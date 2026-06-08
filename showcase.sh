#!/usr/bin/env bash
# ENux Proje Vitrini — Bilim Şenliği 2027

set -euo pipefail

TITLE="ENux Proje Vitrini — Bilim Şenliği 2026"
BACKTITLE="ENux-Distro | github.com/ENux-Distro"

# Proje isimleri (anahtar)
PROJECTS=(
    "ENux"
    "EPM"
    "E-Libc"
    "init.c"
    "EPkgOS"
    "Mini-Linux"
    "ShellOS"
    "E-Kernel"
)

# VM disk görüntüsü dosya adları (./vms/ altında, uzantı dahil)
declare -A VM_IMAGE=(
    ["ENux"]="ENux.iso"
    ["EPM"]="EPM.img"
    ["E-Libc"]="E-Libc.img"
    ["init.c"]="init.c.img"
    ["EPkgOS"]="EPkgOS.iso"
    ["Mini-Linux"]="Mini-Linux.iso"
    ["ShellOS"]="ShellOS.iso"
    ["E-Kernel"]="E-Kernel.iso"
)

# Listede görünen kısa açıklamalar
declare -A SHORT_DESC=(
    ["ENux"]="15 Farklı Linux ekosistem desteğine sahip işletim sistemidir"
    ["EPM"]="ENux'un kendi minimal C paket yöneticisi (.epm formatı)"
    ["E-Libc"]="Ergonomik başlıklı musl tabanlı özel C kütüphanesi"
    ["init.c"]="C+ASM ile Bedrock init — ~%10 daha hızlı önyükleme"
    ["EPkgOS"]="ENux ekibinin epkg paket yöneticili Linux dağıtımı"
    ["Mini-Linux"]="Sadelik ve kolaylık için inşa edilmiş ultra-minimal Linux"
    ["ShellOS"]="Sıfırdan inşa: özel kabuk, init ve araçlar"
    ["E-Kernel"]="POSIX uyumlu sistem çağrılı minimalist i386 çekirdeği"
)

# Msgbox'ta gösterilen tam açıklamalar
declare -A FULL_DESC=(
["ENux"]="ENux - 15 Farklı Linux Ekosistem Desteğine Sahip İşletim Sistemidir

ENux, çoklu Linux paket yöneticilerine sahip bir işletim sistemidir.

Mesela Android'de PlayStore, iOS'de Apple Store, Windows'da
Microsoft Store vardır. Linux'da ise bunlar gibi uygulamalar,
yani paket yöneticileri vardır.

ENux'un felsefesi ise tüm bu paket yöneticilerini bir araya
getirmek, ve kullancıların kullandığı işletim sistemini
silip farklı birini yükleme alışkanlığı, yani
distro hopping'i durdurmaktır.

Belki Ubuntu veya Fedora Linux işletim sistemlerini duymuşsunuzdur.
İkisi farklı paket yöneticilerine sahip. ENux Fedora, Ubuntu ve
daha fazla paket yöneticilerini tek bir sistemde sahip olmanızı
sağlıyor.

Minimum donanım: x86_64, 550 MB RAM, 25 GB disk.
Önerilen:        çift çekirdek, 800 MB RAM, 35 GB disk."

["EPM"]="EPM & ENUX — ENux Paket Yöneticileri

EPM, kendi hafif .epm paket formatını (tar arşivi) kullanan,
C ile yazılmış minimal bir paket yöneticisidir.

.epm paket yapısı:
  • control  — çalıştırılabilir betik: kurulum yolları, kurulum
               sonrası işlemler ve uyarılar
  • dosyalar — gerçek ikili dosyalar (ör. /usr/bin/), şuraya
               kaydedilir: /var/epm/installed/<paket>

EPM komutları:
  install   Paketi indir ve kur
  purge     Paketi kaldır
  sync      /etc/epm/mirror.list'teki yansıları sorgula
  clean     Günlükleri ve önbelleği temizle

ENUX (sarmalayıcı):
    Birleşik yönetim sağlayan, paket yöneticisi yöneticisi
    olan bir sarmalayıcıdır

Hangisini kullanmalı?
  → ENUX  birleşik yönetim ve otomatik bağımlılık istiyorsanız
  → EPM   mevcut paket yöneticinizin yanında ENux'a özgü
           paketler için hafif bir araç istiyorsanız"

["E-Libc"]="E-Libc — Geliştirilmiş musl C Kütüphanesi

E-Libc, günlük sistem programlama için ergonomik özel başlıklar
ekleyen, musl libc'nin değiştirilmiş bir çatalıdır.

Şimdiye kadar eklenen özel başlıklar:
  elibc.h  — ENux geliştiricisinin en çok kullandığı sistem
              çağrılarına uygun sarmalayıcılar, örn read, write, system
  format.h — %lld gibi format kodlarını ezberlemekten kurtaran
              sezgisel printf belirteçleri:
                %int       tam sayı
                %char      karakter
                %longlong  long long

Derleme ve kurulum:
  git clone → ./configure → make → make install
  ardından  elibc-install  ile özel başlıkları dağıtın.

Kod dili dağılımı:
  C %93,7  |  Assembly %4,4  |  C++ %1,2  |  Awk %0,4"

["init.c"]="init.c — Yüksek Performanslı Bedrock Linux Init'i

init.c, Bedrock Linux'un kabuk tabanlı init sistemini; ham sistem
çağrıları ve performans kritik yollar için x86_64 assembly yardımcıları
kullanan, statik bağlı bir C ikili dosyasıyla (~850 KB) değiştirir.

Sonuç: tüm strataları sıralı yerine paralel olarak etkinleştirerek
        ~%10 daha hızlı önyükleme (fork + waitpid).

system() veya popen() yok — her işlem doğrudan syscall üzerinden:
  mount(2)  pivot_root(2)  open(2)/read(2)  fork(2)

Önyükleme sırası:
  1. PID 1 doğrulaması
  2. Temel dosya sistemlerini bağla
  3. Bedrock yapılandırmasını ayrıştır
  4. Mevcut strataları tara
  5. Etkileşimli strata seçim menüsünü göster
  6. Dosya sistemlerini doğrudan syscall ile bağla
  7. pivot_root işlemi
  8. Tüm strataları eş zamanlı brl-enable et (fork)
  9. Gerçek init'e devret

Derleme: gcc  nasm  binutils ld  x86_64-linux hedef
Çalışma: Bedrock Linux + pivot_root destekli çekirdek
Test:    ENux 5.3.3, i5-12400F, Gen 4 NVMe, 7 strata
Lisans:  GPL-3.0"

["EPkgOS"]="EPkgOS — Özel Paket Yöneticili Linux Dağıtımı

EPkgOS, Benim hobi amaçlı yaptığım ve paket
yöneticisi epkg ile birlikte gelen bir Linux dağıtımıdır.

Teknik yığın:
  Init:         systemd
  Önyükleyici: GRUB (BIOS/UEFI — GPT ve DOS bölümleme)
  Dosya sistemi: ext4 (kök), FAT32 (EFI)
  Paket yönt.:  epkg (özel)
  Mimari:       x86_64

Manuel kurulum akışı:
  bölümle → formatla → bağla → sistemi kur →
  GRUB'ı yapılandır → yeniden başlat

Hem UEFI (GPT + EFI Sistem Bölümü) hem de eski BIOS
(DOS bölüm tablosu) makinelerini destekler.

Son sürüm: EPkgOS Latest (24 Ocak 2026)"

["Mini-Linux"]="Mini-Linux — Ultra-Minimal Linux Dağıtımı

Mini-Linux mümkün olduğunca küçüktür: Gerçek
donanıma kurulumu kolay ve sade bir Linux dağıtımıdır.

Varsayılan kabuk: bash
Yerleşik araçlar: mount  mkdir  grub-install

Kurulum aşamaları:
  1. cfdisk ile bölümlendirme
       UEFI → GPT, 300 MB EFI bölümü
       BIOS → DOS bölüm tablosu
  2. /bin /sbin /etc /lib /usr /var dizinlerini hedefe kopyala
  3. GRUB'ı yükle
       BIOS → grub-install --target=i386-pc
       UEFI → grub-install --target=x86_64-efi
  4. İlk açılışta özel init devralır

Felsefe: gereksiz olan her şeyi çıkar, sistemin açılmasını
ve kullanılmasını sağlayanı koru.

Son sürüm: 24 Ocak 2026"

["ShellOS"]="ShellOS — Sıfırdan İnşa Edilmiş Deneysel İşletim Sistemi

ShellOS, her temel bileşeninin C ile sıfırdan yazıldığı tamamen
özel bir Linux dağıtımıdır, her şey sıfırdan yazılmıştır

Özel bileşenler:
  • Shell        — elle yazılmış komut yorumlayıcısı
  • Init sistemi — özel PID-1 başlatma süreci
  • Araçlar      — C ile yazılmış temel yardımcı programlar:
      cd  ls  rm  rmdir  cat  mkdir
      clear  echo  reboot  poweroff  minifetch

ShellOS, VM testi için bir ISO olarak dağıtılır
(EFI desteği yok — VM'de eski BIOS modunu kullanın).

Kod dağılımı: C %37,5  |  HTML %62,5 (belgeler/site)
Sürüm:        v1.0 — 28 Ocak 2026

Durum: deneysel — amaç, çalışan bir kullanıcı alanının tamamen
sıfırdan inşa edilebileceğini kanıtlamak."

["E-Kernel"]="E-Kernel v1.1.1 — POSIX Uyumlu Minimalist İşletim Sistemi Çekirdeği

E-Kernel, temel UNIX benzeri işlevsellik sağlamak amacıyla POSIX
uyumlu sistem çağrıları ve yerleşik bir komut kabuğu içeren,
sıfırdan yazılmış minimalist bir işletim sistemi çekirdeğidir.

Yerleşik kabuk komutları (15 adet):
  Dosya işlemleri: ls  mkdir  rmdir  rm  touch  mv  cp
  Gezinme:         cd
  Sistem:          whoami  mount  echo  cat  clear  help  reboot  exit

Proje yapısı:
  boot/    — önyükleme ve başlatma kodu
  kernel/  — çekirdek işlevselliği
  fs/      — dosya sistemi uygulaması
  vfs/     — sanal dosya sistemi katmanı

Teknik detaylar:
  Birincil dil:  C (%97,8)
  Mimari kodu:   Assembly (%2,2)
  Hedef mimari:  i386
  Toplam commit: 50

Çalıştırma: qemu-system-i386 -cdrom E-Kernel.iso
RAM:        Yalnızca 1 MB ile çalışır — gerçek minimalcilik bu!

Sürüm: v1.1.1 — 29 Ocak 2026"
)

# ─── yardımcılar ──────────────────────────────────────────────────────────────

die() { clear; echo "Çıkılıyor..."; exit 0; }

launch_vm() {
    local project="$1"
    local img="./vms/${VM_IMAGE[$project]}"
    clear

    # E-Kernel: i386, cdrom, 1 MB — kasıtlı flex
    if [[ "$project" == "E-Kernel" ]]; then
        echo "Başlatılıyor: qemu-system-i386 -cdrom \"$img\" -m 1"
        echo ""
        if [[ ! -f "$img" ]]; then
            echo "Görüntü bulunamadı: $img"
            echo "Disk görüntüsünü yukarıdaki yola yerleştirip tekrar deneyin."
            echo ""
            read -r -p "Menüye dönmek için Enter'a basın..."
            return
        fi
        qemu-system-i386 -cdrom "$img" -m 1 -vga std
        return
    fi

    # Diğer tüm projeler: x86_64, KVM, 3096 MB
    if [[ "$img" == *.iso ]]; then
        echo "Başlatılıyor: qemu-system-x86_64 -cdrom \"$img\" -m 3096 -enable-kvm"
    else
        echo "Başlatılıyor: qemu-system-x86_64 -hda \"$img\" -m 3096 -enable-kvm"
    fi
    echo ""
    if [[ ! -f "$img" ]]; then
        echo "Görüntü bulunamadı: $img"
        echo "Disk görüntüsünü yukarıdaki yola yerleştirip tekrar deneyin."
        echo ""
        read -r -p "Menüye dönmek için Enter'a basın..."
        return
    fi
    if [[ "$img" == *.iso ]]; then
        qemu-system-x86_64 -cdrom "$img" -m 3096 -enable-kvm -vga std
    else
        qemu-system-x86_64 -hda "$img" -m 3096 -enable-kvm -vga std
    fi
}

show_project() {
    local project="$1"

    # msgbox — ayrıntılı açıklama
    whiptail \
        --title "$project" \
        --backtitle "$BACKTITLE" \
        --scrolltext \
        --msgbox "${FULL_DESC[$project]}" \
        30 72 \
        3>&1 1>&2 2>&3

    # evet/hayır — VM başlatılsın mı?
    if whiptail \
        --title "VM Başlatılsın mı?" \
        --backtitle "$BACKTITLE" \
        --yesno "\"$project\" bir QEMU sanal makinesinde başlatılsın mı?\n\nGörüntü: ./vms/${VM_IMAGE[$project]}" \
        10 60 \
        3>&1 1>&2 2>&3; then
        launch_vm "$project"
    fi
}

# ─── ana menü ─────────────────────────────────────────────────────────────────

main_menu() {
    while true; do
        # Radiolist öğelerini oluştur: ETİKET ÖĞE DURUM
        local items=()
        local first=1
        for p in "${PROJECTS[@]}"; do
            if [[ $first -eq 1 ]]; then
                items+=("$p" "${SHORT_DESC[$p]}" "ON")
                first=0
            else
                items+=("$p" "${SHORT_DESC[$p]}" "OFF")
            fi
        done

        local choice
        choice=$(
            whiptail \
                --title "$TITLE" \
                --backtitle "$BACKTITLE" \
                --ok-button "Görüntüle" \
                --cancel-button "Çıkış" \
                --radiolist \
                "Ok: gezin   Boşluk: seç   Enter: görüntüle" \
                15 80 8 \
                "${items[@]}" \
                3>&1 1>&2 2>&3
        ) || die

        [[ -z "$choice" ]] && die
        show_project "$choice"
    done
}

# ─── giriş noktası ────────────────────────────────────────────────────────────

if ! command -v whiptail &>/dev/null; then
    echo "Hata: whiptail kurulu değil. Şu komutla kurun: sudo apt install whiptail"
    exit 1
fi

main_menu
