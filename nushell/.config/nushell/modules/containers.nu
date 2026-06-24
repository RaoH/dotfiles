#!/usr/bin/env nu

# Show all containers grouped by compose project (works with both docker and podman)
def main [] {
    # Detect which container runtime is available
    let runtime = if (which docker | is-not-empty) {
        "docker"
    } else if (which podman | is-not-empty) {
        "podman"
    } else {
        error make { msg: "Neither docker nor podman found in PATH" }
    }
    
    # Use Go template to emit NDJSON with Ports/RunningFor as strings in both Docker and Podman
    let containers = (^$runtime ps -a --format '{{json .}}' | from json --objects)
    
    if ($containers | is-empty) {
        print "No containers found"
        return
    }
    
    let grouped = ($containers | each { |container|
        # Get Labels robustly (string or record or missing)
        let labels_val = (try { $container | get Labels } catch { null })
        let labels_kind = (if $labels_val == null { "nothing" } else { $labels_val | describe })
        let compose_project = if $labels_kind == "string" {
            let labels_str = $labels_val
            if ($labels_str | is-empty) { "" } else { 
                $labels_str | split row "," | where ($it | str starts-with "com.docker.compose.project=") | first | default "" | str replace "com.docker.compose.project=" ""
            }
        } else if ($labels_kind | str starts-with "record") {
            ($labels_val | get "com.docker.compose.project" -i | default "")
        } else { "" }
        let compose_service = if $labels_kind == "string" {
            let labels_str = ($labels_val | default "")
            if ($labels_str | is-empty) { "" } else { 
                $labels_str | split row "," | where ($it | str starts-with "com.docker.compose.service=") | first | default "" | str replace "com.docker.compose.service=" ""
            }
        } else if ($labels_kind | str starts-with "record") {
            ($labels_val | get "com.docker.compose.service" -i | default "")
        } else { "" }
        
        # Choose running time: prefer RunningFor if present; otherwise parse from Status if it starts with "Up"
        let running_for = (try { $container | get RunningFor } catch { "" })
        let running_time = if (not ($running_for | is-empty)) {
            $running_for
        } else {
            let status_str = (try { $container | get Status } catch { "" })
            if ($status_str | str starts-with "Up ") {
                ($status_str | str replace -r "^Up\\s+" "" | str replace " ago" "")
            } else { $status_str }
        }
        
        # Ports: pretty-format when list of records; otherwise stringify safely
        let ports_val = (try { $container | get Ports } catch { "" })
        let ports_kind = ($ports_val | describe)
        let is_listish = (($ports_kind | str starts-with "list") or ($ports_kind | str starts-with "table"))
        let ports_display = if $is_listish {
            if ($ports_val | is-empty) { "" } else {
                let first_kind = ($ports_val.0 | describe)
                if ($first_kind | str starts-with "record") {
                    $ports_val | each {|p|
                        let host_ip = (try { $p | get host_ip } catch { try { $p | get HostIP } catch { try { $p | get IP } catch { "" } } }) | to text | str trim
                        let host_port = (try { $p | get host_port } catch { try { $p | get HostPort } catch { try { $p | get PublicPort } catch { "" } } }) | to text | str trim
                        let cont_port = (try { $p | get container_port } catch { try { $p | get ContainerPort } catch { try { $p | get PrivatePort } catch { "" } } }) | to text | str trim
                        let proto = (try { $p | get protocol } catch { try { $p | get Protocol } catch { try { $p | get Type } catch { "" } } }) | to text | str trim
                        let left = if (($host_ip | is-empty) and ($host_port | is-empty)) { "" } else { if ($host_ip | is-empty) { $host_port } else { if ($host_port | is-empty) { $host_ip } else { $"($host_ip):($host_port)" } } }
                        let right = (if ($cont_port | is-empty) { "" } else { $cont_port })
                        let arrow = (if (($left | is-empty) or ($right | is-empty)) { "" } else { "->" })
                        let proto_str = (if ($proto | is-empty) { "" } else { $"/($proto)" })
                        $"($left)($arrow)($right)($proto_str)" | str trim
                    } | where ($it | str length) > 0 | str join ", "
                } else {
                    $ports_val | each {|x| $x | to text | str trim } | str join ", "
                }
            }
        } else if ($ports_kind | str starts-with "record") {
            # try to pretty print a single-record form; otherwise stringify
            let host_ip = (try { $ports_val | get host_ip } catch { try { $ports_val | get HostIP } catch { try { $ports_val | get IP } catch { "" } } }) | to text | str trim
            let host_port = (try { $ports_val | get host_port } catch { try { $ports_val | get HostPort } catch { try { $ports_val | get PublicPort } catch { "" } } }) | to text | str trim
            let cont_port = (try { $ports_val | get container_port } catch { try { $ports_val | get ContainerPort } catch { try { $ports_val | get PrivatePort } catch { "" } } }) | to text | str trim
            let proto = (try { $ports_val | get protocol } catch { try { $ports_val | get Protocol } catch { try { $ports_val | get Type } catch { "" } } }) | to text | str trim
            let left = if (($host_ip | is-empty) and ($host_port | is-empty)) { "" } else { if ($host_ip | is-empty) { $host_port } else { if ($host_port | is-empty) { $host_ip } else { $"($host_ip):($host_port)" } } }
            let right = (if ($cont_port | is-empty) { "" } else { $cont_port })
            let arrow = (if (($left | is-empty) or ($right | is-empty)) { "" } else { "->" })
            let proto_str = (if ($proto | is-empty) { "" } else { $"/($proto)" })
            let pretty = $"($left)($arrow)($right)($proto_str)" | str trim
            if ($pretty | is-empty) { ($ports_val | to nuon --raw | str replace -a "\n" " " | str trim) } else { $pretty }
        } else if ($ports_kind == "string") {
            ($ports_val | into string)
        } else {
            ($ports_val | to nuon --raw | str replace -a "\n" " " | str trim)
        }
        
        # Names may be string or list - normalize to string (first item)
        let name_val = (try { $container | get Names } catch { "" })
        let name_str = if (($name_val | describe) | str starts-with "list") {
            $name_val | each {|x| $x | into string } | first | default ""
        } else { ($name_val | into string | default "") }
        
        # Normalize fields and build display record with simple keys
        {
            name: $name_str,
            image: (try { $container | get Image } catch { "" }),
            state: ((try { $container | get State } catch { "" }) | default "" | str capitalize),
            running_for: ($running_time | default "-"),
            ports: (let p = ($ports_display | to nuon --raw | str replace -a "\n" " " | str trim); if ($p | is-empty) { "-" } else { $p }),
            service: (let s = ($compose_service | default ""); if ($s | is-empty) { "-" } else { $s }),
            created: ((try { $container | get CreatedAt } catch { try { $container | get Created } catch { "" } }) | to text | str trim),
            compose_project: (if ($compose_project | is-empty) { "standalone" } else { $compose_project }),
            runtime: $runtime
        }
    } | group-by compose_project)
    
    let groups = ($grouped | transpose project containers)
    for row in $groups {
        let project = ($row.project)
        let containers = ($row.containers)
        let runtime_info = (try { $containers | get 0 | get runtime } catch { $runtime })
        print $"=== ($project) [($runtime_info)] ==="
        ($containers | select name image state running_for ports service created | table | to text) | print
        print ""
    }
}