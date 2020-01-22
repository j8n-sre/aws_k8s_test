kubectl delete -f 03.certificates.yaml
kubectl delete -f 01.cluster-issuer.yaml
kubectl delete -f 02.ingress-certmanager.yaml
kubectl delete namespace cert-manager
