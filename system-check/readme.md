# Linux System Check

Egyszerű Bash script Linux rendszerek alapvető állapotának ellenőrzésére.

## Funkciók

A script megjeleníti:

- az operációs rendszer nevét
- a gépnevet
- az aktuális felhasználót
- a dátumot
- a kernel verzióját
- a rendszer futási idejét
- a memóriahasználatot
- a gyökérpartíció lemezhasználatát
- az elsődleges IP-címet
- az SSH és a firewalld szolgáltatás állapotát

A script figyelmeztetést jelenít meg, ha a gyökérpartíció
lemezhasználata eléri vagy meghaladja a 80 százalékot.

## Használat

A repository klónozása:

```bash
git clone https://github.com/redhat707/system-check.git
