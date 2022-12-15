[webapps]
%{ for host in webapps ~}
${host}
%{ endfor ~}

[webappspriv]
%{ for host in webappspriv ~}
${host}
%{ endfor ~}

[nodebalancer]
${nodebalancer}

[nodebalancerhost]
${nodebalancerhost}

[redis]
${redis}

[redispriv]
${redispriv}

[workers]
%{ for host in workers ~}
${host}
%{ endfor ~}

[workerspriv]
%{ for host in workerspriv ~}
${host}
%{ endfor ~}