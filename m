Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D76121915
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLPRva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfLPRva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF2520700;
        Mon, 16 Dec 2019 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518688;
        bh=EspYBnzyl21o0GLypWlTF/+TqNb05HygIzAfg1k1ilA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZqgEQU4yDw8hbY+Xl5Pe1PiqfiSnOM/v0oehAfaZU/6OdUvIEcvINgrnQ4tEr2Lc+
         UV3DTqPJWqbjOVil0/24hVmmBEGnkU7ItOEQKnugi5HKurtd1NbjgbaSaSKGXJ5y2y
         MNvnFMv/mi7UuBUKf3n6ncvc4cVLp7VV7zOb73iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/267] 4.14.159-stable review
Date:   Mon, 16 Dec 2019 18:45:26 +0100
Message-Id: <20191216174848.701533383@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.159-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.159-rc1
X-KernelTest-Deadline: 2019-12-18T17:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.159 release.
There are 267 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.159-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.159-rc1

Thomas Hellstrom <thellstrom@vmware.com>
    mm/memory.c: fix a huge pud insertion race during faulting

Michal Hocko <mhocko@suse.com>
    mm, thp, proc: report THP eligibility for each vma

Daniel Schultz <d.schultz@phytec.de>
    mfd: rk808: Fix RK818 ID template

yangerkun <yangerkun@huawei.com>
    ext4: fix a bug in ext4_wait_for_tail_page_commit

Chen Jun <chenjun102@huawei.com>
    mm/shmem.c: cast the type of unmap_start to u64

Will Deacon <will@kernel.org>
    firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Theodore Ts'o <tytso@mit.edu>
    ext4: work around deleting a file with i_nlink == 0 safely

Vincenzo Frascino <vincenzo.frascino@arm.com>
    powerpc: Fix vDSO clock_getres()

Nathan Chancellor <natechancellor@gmail.com>
    powerpc: Avoid clang warnings around setjmp and longjmp

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix fw crash by moving chip reset after napi disabled

Helen Koike <helen.koike@collabora.com>
    media: vimc: fix component match compare

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-battery: Fix signed counter sample register

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models

YueHaibing <yuehaibing@huawei.com>
    e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

Nathan Chancellor <natechancellor@gmail.com>
    drbd: Change drbd_request_detach_interruptible's return type to int

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Correct code setting non existent bits in sli4 ABORT WQE

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Cap NPIV vports to 256

H. Nikolaus Schaller <hns@goldelico.com>
    omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Nuno Sá <nuno.sa@analog.com>
    iio: adis16480: Add debugfs_reg_access entry

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure interrupts are restored to correct state

Mika Westerberg <mika.westerberg@linux.intel.com>
    xhci: Fix memory leak in xhci_add_in_port()

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Fix message indicating vectors used by driver

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return value

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix session lookup in qlt_abort_work()

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Fix DMA unmap leak

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: trace channel log even for FCP command responses

Ming Lei <ming.lei@redhat.com>
    block: fix single range discard merge

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix extended attributes on the root directory

Jan Kara <jack@suse.cz>
    ext4: Fix credit estimate for final inode freeing

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: fix livelock in dquot_writeback_dquots

Chengguang Xu <cgxu519@mykernel.net>
    ext2: check err when partial != NULL

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: Check that quota is not dirty before release

Ville Syrjälä <ville.syrjala@linux.intel.com>
    video/hdmi: Fix AVI bar unpack

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Skip ioremap() of ESB pages for LSI interrupts

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow flush_icache_range to work across ranges >4GB

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Prevent page fault issues in the machine crash handler

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges >4GB

Arnd Bergmann <arnd@arndb.de>
    ppdev: fix PPGETTIME/PPSETTIME ioctls

Jarkko Nikula <jarkko.nikula@bitmer.com>
    ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polarity

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup controller init

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in init code

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup controller init

Nishka Dasgupta <nishkadg.linux@gmail.com>
    pinctrl: samsung: Add of_node_put() before return in error path

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Francesco Ruggeri <fruggeri@arista.com>
    ACPI: OSL: only free map once in osl.c

John Hubbard <jhubbard@nvidia.com>
    cpufreq: powernv: fix stack bloat and hard limit on number of CPUs

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Lock devfreq in trans_stat_show

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Tiger Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Ice Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix a double put_device() in error path

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    cpuidle: Do not unset the driver if it is there already

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec.h: CEC_OP_REC_FLAG_ values were swapped

Johan Hovold <johan@kernel.org>
    media: radio: wl1273: fix interrupt masking on release

Johan Hovold <johan@kernel.org>
    media: bdisp: fix memleak on release

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported

Denis Efremov <efremov@linux.com>
    ar5523: check NULL before memcpy() in ar5523_cmd()

Aleksa Sarai <cyphar@cyphar.com>
    cgroup: pids: use atomic64_t for pids->limit

Ming Lei <ming.lei@redhat.com>
    blk-mq: avoid sysfs buffer overflow with too many CPU cores

Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
    ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Tejun Heo <tj@kernel.org>
    workqueue: Fix pwq ref leak in rescuer_thread()

Tejun Heo <tj@kernel.org>
    workqueue: Fix spurious sanity check failures in destroy_workqueue()

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: reduce overhead of backing device checks

Sumit Garg <sumit.garg@linaro.org>
    hwrng: omap - Fix RNG wait loop timeout

Joel Stanley <joel@jms.id.au>
    watchdog: aspeed: Fix clock behaviour for ast2600

Dan Carpenter <dan.carpenter@oracle.com>
    md/raid0: Fix an error message in raid0_make_request()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix pending unsol events at shutdown

Amir Goldstein <amir73il@gmail.com>
    ovl: relax WARN_ON() on rename to self

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lib: raid6: fix awk build warnings

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix missing enable interrupt flag

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address

Josef Bacik <josef@toxicpanda.com>
    btrfs: record all roots for rename exchange on a subvol

Filipe Manana <fdmanana@suse.com>
    Btrfs: send, skip backreference walking for extents with many references

Qu Wenruo <wqu@suse.com>
    btrfs: Remove btrfs_bio::flags member

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix negative subv_writers counter and data space leak after buffered write

Josef Bacik <josef@toxicpanda.com>
    btrfs: use refcount_inc_not_zero in kill_all_nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: check page->mapping when loading free space cache

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Clear started flag on completion

David Hildenbrand <david@redhat.com>
    virtio-balloon: fix managed page counts when migrating pages between zones

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spear_smi: Fix Write Burst mode

Tadeusz Struk <tadeusz.struk@intel.com>
    tpm: add check after commands attribs tab allocation

Pete Zaitcev <zaitcev@redhat.com>
    usb: mon: Fix a deadlock in usbmon between mmap and read

Emiliano Ingrassia <ingrassia@epigenesys.com>
    usb: core: urb: fix URB structure initialization function

Johan Hovold <johan@kernel.org>
    USB: adutux: fix interface sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix epic endpoint lookup

Johan Hovold <johan@kernel.org>
    USB: idmouse: fix interface sanity checks

Johan Hovold <johan@kernel.org>
    USB: atm: ueagle-atm: add missing endpoint check

Chris Lesiak <chris.lesiak@licor.com>
    iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: pandora-common: define wl1251 as child node of mmc3

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behaviour.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Increase STS_HALT timeout in xhci_suspend()

Henry Lin <henryl@nvidia.com>
    usb: xhci: only set D3hot for pci device

Johan Hovold <johan@kernel.org>
    staging: gigaset: add endpoint-type sanity check

Johan Hovold <johan@kernel.org>
    staging: gigaset: fix illegal free on probe errors

Johan Hovold <johan@kernel.org>
    staging: gigaset: fix general protection fault on probe

Johan Hovold <johan@kernel.org>
    staging: rtl8712: fix interface sanity check

Johan Hovold <johan@kernel.org>
    staging: rtl8188eu: fix interface sanity check

Kai-Heng Feng <kai.heng.feng@canonical.com>
    usb: Allow USB device to be warm reset in suspended state

Oliver Neukum <oneukum@suse.com>
    USB: documentation: flags on usb-storage versus UAS

Oliver Neukum <oneukum@suse.com>
    USB: uas: heed CAPACITY_HEURISTICS

Oliver Neukum <oneukum@suse.com>
    USB: uas: honor flag to avoid CAPACITY16

Arnd Bergmann <arnd@arndb.de>
    media: venus: remove invalid compat_ioctl32 handler

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix driver unload hang

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: gadget: pch_udc: fix use after free

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: configfs: Fix missing spin_lock_init()

YueHaibing <yuehaibing@huawei.com>
    appletalk: Set error code if register_snap_client failed

YueHaibing <yuehaibing@huawei.com>
    appletalk: Fix potential NULL pointer dereference in unregister_snap_client

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: fixup MIX kctrl registration

Jann Horn <jannh@google.com>
    binder: Handle start==NULL in binder_update_page_range()

Wei Wang <wvw@google.com>
    thermal: Fix deadlock in thermal thermal_zone_device_check

Jan Kara <jack@suse.cz>
    iomap: Fix pipe page leakage during splicing

Viresh Kumar <viresh.kumar@linaro.org>
    RDMA/qib: Validate ->show()/store() callbacks before calling them

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: atmel: Fix CS high support

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: user - fix memory leak in crypto_report

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ecdh - fix big endian bug in ECC library

Mark Salter <msalter@redhat.com>
    crypto: ccp - fix uninitialized list head

Ayush Sawal <ayush.sawal@chelsio.com>
    crypto: af_alg - cast ki_complete ternary op to int

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not modify masked bits of shared MSRs

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i810: Prevent underflow in ioctl

Jan Kara <jack@suse.cz>
    jbd2: Fix possible overflow in jbd2_log_space_left()

Tejun Heo <tj@kernel.org>
    kernfs: fix ino wrap-around detection

Jouni Hogander <jouni.hogander@unikie.com>
    can: slcan: Fix use-after-free Read in slcan_open

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    tty: vt: keyboard: reject invalid keycodes

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix SMB2 oplock break processing

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Navid Emamdoost <navid.emamdoost@gmail.com>
    Input: Fix memory leak in psxpad_spi_probe

Mike Leach <mike.leach@linaro.org>
    coresight: etm4x: Fix input validation for sysfs.

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add upside-down quirk for Teclast X89 tablet

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda - Add mute led support for HP ProBook 645 G4

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid potential buffer overflows

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify attributes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify nlink

Xuewei Zhang <xueweiz@google.com>
    sched/fair: Scale bandwidth quota and period without losing quota/period ratio precision

Eric Dumazet <edumazet@google.com>
    tcp: exit if nothing to retransmit on RTO timeout

Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
    net: aquantia: fix RSS table and key sizes

Helen Fornazier <helen.koike@collabora.com>
    media: vimc: fix start stream when link is disabled

Rob Herring <robh@kernel.org>
    ARM: dts: sunxi: Fix PMU compatible strings

YueHaibing <yuehaibing@huawei.com>
    usb: mtu3: fix dbginfo in qmu_tx_zlp_error_handler

Qian Cai <cai@gmx.us>
    mlx4: Use snprintf instead of complicated strcpy

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close VNIC sdma_progress sleep window

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Ignore LNI errors before DC8051 transitions to Polling state

Nir Dotan <nird@mellanox.com>
    mlxsw: spectrum_router: Relax GRE decap matching check

Jonathan Marek <jonathan@marek.ca>
    firmware: qcom: scm: fix compilation error when disabled

Andreas Pape <ap@ca-pape.de>
    media: stkwebcam: Bugfix for wrong return values

Dmitry Safonov <dima@arista.com>
    tty: Don't block on IO when ldisc change is pending

zhengbin <zhengbin13@huawei.com>
    nfsd: Return EPERM, not EACCES, in some SETATTR cases

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible definition

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a77995: Correct parent clock of DU

Joel Stanley <joel@jms.id.au>
    powerpc/math-emu: Update macros from GCC

Kees Cook <keescook@chromium.org>
    pstore/ram: Avoid NULL deref in ftrace merging failure path

Erez Alfasi <ereza@mellanox.com>
    net/mlx4_core: Fix return codes of unsupported operations

David Teigland <teigland@redhat.com>
    dlm: fix invalid cluster name warning

Rob Herring <robh@kernel.org>
    ARM: dts: realview: Fix some more duplicate regulator nodes

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent

Daniel Mack <daniel@zonque.org>
    ARM: dts: pxa: clean up USB controller nodes

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: fix mtd_oobavail() incoherent returned value

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: fix single target build for external module

Paul Walmsley <paul.walmsley@sifive.com>
    modpost: skip ELF local symbols during section mismatch check

Yuchung Cheng <ycheng@google.com>
    tcp: fix SNMP TCP timeout under-estimation

Yuchung Cheng <ycheng@google.com>
    tcp: fix SNMP under-estimation on failed retransmission

Yuchung Cheng <ycheng@google.com>
    tcp: fix off-by-one bug on aborting window-probing socket

Rob Herring <robh@kernel.org>
    ARM: dts: realview-pbx: Fix duplicate regulator nodes

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp2: fix the gpio interrupt cell number

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix null_x25_address handling

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix called/calling length calculation in x25_parse_address_block

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxl-khadas-vim: fix GPIO lines names

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxbb-odroidc2: fix GPIO lines names

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxbb-nanopi-k2: fix GPIO lines names

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxl-libretech-cc: fix GPIO lines names

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1/2: fix SoC name printing

Young_X <YangX92@hotmail.com>
    ASoC: au8540: use 64-bit arithmetic instead of 32-bit

Scott Mayhew <smayhew@redhat.com>
    nfsd: fix a warning in __cld_pipe_upcall()

Clément Péron <peron.clem@gmail.com>
    ARM: debug: enable UART1 for socfpga Cyclone5

Wen Yang <wen.yang99@zte.com.cn>
    dlm: NULL check before kmem_cache_destroy is not needed

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun8i: v3s: Change pinctrl nodes to avoid warning

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun5i: a10s: Fix HDMI output DTC warning

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()

J. Bruce Fields <bfields@redhat.com>
    lockd: fix decoding of TEST results

Lucas Stach <l.stach@pengutronix.de>
    i2c: imx: don't print error message on probe defer

Stefan Agner <stefan@agner.ch>
    serial: imx: fix error handling in console_setup

Colin Ian King <colin.king@canonical.com>
    altera-stapl: check for a null key before strcasecmp'ing it

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    dma-mapping: fix return type of dma_set_max_seg_size()

David Miller <davem@davemloft.net>
    sparc: Correct ctx->saw_frame_pointer logic.

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: fix to allow node segment for GC by ioctl path

Otavio Salvador <otavio@ossystems.com.br>
    ARM: dts: rockchip: Assign the proper GPIO clocks for rv1108

Otavio Salvador <otavio@ossystems.com.br>
    ARM: dts: rockchip: Fix the PMU interrupt number for rv1108

Yunlong Song <yunlong.song@huawei.com>
    f2fs: change segment to section in f2fs_ioc_gc_range

Yunlong Song <yunlong.song@huawei.com>
    f2fs: fix count of seg_freed to make sec_freed correct

Alexey Dobriyan <adobriyan@gmail.com>
    ACPI: fix acpi_find_child_device() invocation in acpi_preset_companion()

Brian Norris <briannorris@chromium.org>
    usb: dwc3: don't log probe deferrals; but do log other error codes

Thinh Nguyen <thinh.nguyen@synopsys.com>
    usb: dwc3: debugfs: Properly print/set link state for HS

Christian Lamparter <chunkeey@gmail.com>
    dmaengine: dw-dmac: implement dma protection control setting

Vinod Koul <vkoul@kernel.org>
    dmaengine: coh901318: Remove unused variable

Jia-Ju Bai <baijiaju1990@gmail.com>
    dmaengine: coh901318: Fix a double-lock bug

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: report Vendor ID after initialization

Hans Verkuil <hverkuil@xs4all.nl>
    media: pulse8-cec: return 0 when invalidating the logical address

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module

Baruch Siach <baruch@tkos.co.il>
    rtc: dt-binding: abx80x: fix resistance scale

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    rtc: max8997: Fix the returned value in case of error in 'max8997_rtc_read_alarm()'

Vincent Chen <vincentc@andestech.com>
    math-emu/soft-fp.h: (_FP_ROUND_ZERO) cast 0 to void to fix warning

Ursula Braun <ursula.braun@linux.ibm.com>
    net/smc: use after free fix in smc_wr_tx_put_slot()

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: OCTEON: octeon-platform: fix typing

Dave Chinner <dchinner@redhat.com>
    iomap: sub-block dio needs to zeroout beyond EOF

Xue Chaojing <xuechaojing@huawei.com>
    net-next/hinic:fix a bug in set mac address

Mark Brown <broonie@kernel.org>
    regulator: Fix return value of _set_load() stub

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    clk: rockchip: fix ID of 8ch clock of I2S1 for rk3328

Katsuhiro Suzuki <katsuhiro@katsuster.net>
    clk: rockchip: fix I2S1 clock gate register for rk3328

Janne Huttunen <janne.huttunen@nokia.com>
    mm/vmstat.c: fix NUMA statistics updates

Shreeya Patel <shreeya.patel23498@gmail.com>
    Staging: iio: adt7316: Fix i2c data reading, set the data field

Brian Masney <masneyb@onstation.org>
    pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
    crypto: bcm - fix normal/non key hash algorithm failure

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecc - check for invalid values in the key verification test

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: drop default switch case which might paper over missing case

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Work around mv886e6161 SERDES missing MII_PHYSID2

Maciej W. Rozycki <macro@linux-mips.org>
    MIPS: SiByte: Enable ZONE_DMA32 for LittleSur

David Teigland <teigland@redhat.com>
    dlm: fix missing idr_destroy for recover_idr

John Keeping <john@metanate.com>
    ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name

Heiko Stuebner <heiko@sntech.de>
    clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering

Finley Xiao <finley.xiao@rock-chips.com>
    clk: rockchip: fix rk3188 sclk_smc gate data

Mitch Williams <mitch.a.williams@intel.com>
    i40e: don't restart nway if autoneg not supported

Marek Szyprowski <m.szyprowski@samsung.com>
    rtc: s3c-rtc: Avoid using broken ALMYEAR register

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    net: ethernet: ti: cpts: correct debug for expired txq skb

Marek Szyprowski <m.szyprowski@samsung.com>
    extcon: max8997: Fix lack of path setting in USB device mode

Denis V. Lunev <den@openvz.org>
    dlm: fix possible call to kfree() for non-initialized pointer

Jagan Teki <jagan@amarulasolutions.com>
    clk: sunxi-ng: a64: Fix gate bit of DSI DPHY

Moni Shoua <monis@mellanox.com>
    net/mlx5: Release resource on error flow

Vincent Whitchurch <vincent.whitchurch@axis.com>
    ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Send non offchannel traffic via AP sta

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: synchronize TID queue removal

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4vf: fix memleak in mac_hlist initialization

Douglas Anderson <dianders@chromium.org>
    serial: core: Allow processing sysrq at port unlock time

Wen Yang <wenyang@linux.alibaba.com>
    i2c: core: fix use after free in of_i2c_notify

Chuhong Yuan <hslester96@gmail.com>
    net: ep93xx_eth: fix mismatch of request_mem_region in remove

Chuhong Yuan <hslester96@gmail.com>
    rsxx: add missed destroy_workqueue calls in remove

paulhsia <paulhsia@chromium.org>
    ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

Peter Zijlstra <peterz@infradead.org>
    sched/core: Avoid spurious lock dependencies

Pan Bian <bianpan2016@163.com>
    Input: cyttsp4_core - fix use after free bug

Xiaodong Xu <stid.smth@gmail.com>
    xfrm: release device reference for invalid state

Stephan Gerhold <stephan@gerhold.net>
    NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error

Al Viro <viro@zeniv.linux.org.uk>
    audit_get_nd(): don't unlock parent too early

Al Viro <viro@zeniv.linux.org.uk>
    exportfs_decode_fh(): negative pinned may become positive without the parent locked

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: pcie: don't consider IV len in A-MSDU

Sirong Wang <wangsirong@huawei.com>
    RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Al Viro <viro@zeniv.linux.org.uk>
    autofs: fix a leak in autofs_expire_indirect()

Chuhong Yuan <hslester96@gmail.com>
    serial: ifx6x60: add missed pm_runtime_disable

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    serial: serial_core: Perform NULL checks for break_ctl ops

Vincent Whitchurch <vincent.whitchurch@axis.com>
    serial: pl011: Fix DMA ->flush_buffer()

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    tty: serial: msm_serial: Fix flow control

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    usb: gadget: u_serial: add missing port entry locking

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Navid Emamdoost <navid.emamdoost@gmail.com>
    rsi: release skb if rsi_prepare_beacon fails


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    | 22 ++---
 .../devicetree/bindings/rtc/abracon,abx80x.txt     |  2 +-
 Documentation/filesystems/proc.txt                 |  3 +
 Makefile                                           | 15 ++--
 arch/arm/Kconfig.debug                             | 23 ++++--
 arch/arm/boot/dts/arm-realview-pb1176.dts          |  4 +-
 arch/arm/boot/dts/arm-realview-pb11mp.dts          |  4 +-
 arch/arm/boot/dts/arm-realview-pbx.dtsi            |  5 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |  2 +-
 arch/arm/boot/dts/mmp2.dtsi                        |  2 +-
 arch/arm/boot/dts/omap3-pandora-common.dtsi        | 36 ++++++++-
 arch/arm/boot/dts/omap3-tao3530.dtsi               |  2 +-
 arch/arm/boot/dts/pxa27x.dtsi                      |  2 +-
 arch/arm/boot/dts/pxa2xx.dtsi                      |  7 --
 arch/arm/boot/dts/pxa3xx.dtsi                      |  2 +-
 arch/arm/boot/dts/rk3288-rock2-som.dtsi            |  2 +-
 arch/arm/boot/dts/rv1108.dtsi                      | 10 +--
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |  2 -
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  2 +-
 arch/arm/boot/dts/sun8i-v3s-licheepi-zero.dts      |  4 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi                   | 10 +--
 arch/arm/include/asm/uaccess.h                     | 18 +++++
 arch/arm/lib/getuser.S                             | 11 +++
 arch/arm/lib/putuser.S                             | 20 ++---
 arch/arm/mach-omap1/id.c                           |  6 +-
 arch/arm/mach-omap2/id.c                           |  4 +-
 arch/arm/mach-omap2/pdata-quirks.c                 | 93 ----------------------
 .../boot/dts/amlogic/meson-gxbb-nanopi-k2.dts      |  4 +-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |  4 +-
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |  4 +-
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |  4 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |  2 +-
 arch/mips/Kconfig                                  |  1 +
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c |  2 +-
 arch/mips/cavium-octeon/octeon-platform.c          |  2 +-
 arch/mips/include/asm/octeon/cvmx-pko.h            |  2 +-
 arch/powerpc/include/asm/sfp-machine.h             | 92 +++++++--------------
 arch/powerpc/include/asm/vdso_datapage.h           |  2 +
 arch/powerpc/kernel/Makefile                       |  4 +-
 arch/powerpc/kernel/asm-offsets.c                  |  2 +-
 arch/powerpc/kernel/misc_64.S                      |  4 +-
 arch/powerpc/kernel/time.c                         |  1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |  7 +-
 arch/powerpc/kernel/vdso64/cacheflush.S            |  4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S          |  7 +-
 arch/powerpc/sysdev/xive/common.c                  |  9 +++
 arch/powerpc/sysdev/xive/spapr.c                   | 12 ++-
 arch/powerpc/xmon/Makefile                         |  4 +-
 arch/s390/include/asm/pgtable.h                    |  4 +-
 arch/sparc/net/bpf_jit_comp_64.c                   | 12 +++
 arch/x86/kernel/cpu/mcheck/mce.c                   | 30 -------
 arch/x86/kernel/cpu/mcheck/mce_amd.c               | 36 +++++++++
 arch/x86/kvm/cpuid.c                               |  5 +-
 arch/x86/kvm/x86.c                                 | 14 +++-
 arch/x86/pci/fixup.c                               | 11 +++
 block/blk-merge.c                                  |  2 +-
 block/blk-mq-sysfs.c                               | 15 ++--
 crypto/af_alg.c                                    |  2 +-
 crypto/crypto_user.c                               |  4 +-
 crypto/ecc.c                                       | 45 +++++++----
 drivers/acpi/bus.c                                 |  2 +-
 drivers/acpi/device_pm.c                           | 12 ++-
 drivers/acpi/osl.c                                 | 28 ++++---
 drivers/android/binder_alloc.c                     |  8 +-
 drivers/block/drbd/drbd_state.c                    |  6 +-
 drivers/block/drbd/drbd_state.h                    |  3 +-
 drivers/block/rsxx/core.c                          |  2 +
 drivers/char/hw_random/omap-rng.c                  |  9 ++-
 drivers/char/ppdev.c                               | 16 +++-
 drivers/char/tpm/tpm2-cmd.c                        |  4 +
 drivers/clk/renesas/r8a77995-cpg-mssr.c            |  4 +-
 drivers/clk/rockchip/clk-rk3188.c                  |  8 +-
 drivers/clk/rockchip/clk-rk3328.c                  |  2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |  2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                |  2 +-
 drivers/cpufreq/powernv-cpufreq.c                  | 17 +++-
 drivers/cpuidle/driver.c                           | 15 ++--
 drivers/crypto/amcc/crypto4xx_core.c               |  6 +-
 drivers/crypto/bcm/cipher.c                        |  6 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  1 +
 drivers/devfreq/devfreq.c                          | 12 ++-
 drivers/dma/coh901318.c                            |  5 --
 drivers/dma/dw/core.c                              |  2 +
 drivers/dma/dw/platform.c                          |  6 ++
 drivers/dma/dw/regs.h                              |  4 +
 drivers/extcon/extcon-max8997.c                    | 10 +--
 drivers/firmware/qcom_scm-64.c                     |  2 +-
 drivers/gpu/drm/i810/i810_dma.c                    |  4 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    | 21 +++--
 drivers/hwtracing/intel_th/core.c                  |  8 +-
 drivers/hwtracing/intel_th/pci.c                   | 10 +++
 drivers/i2c/busses/i2c-imx.c                       |  3 +-
 drivers/i2c/i2c-core-of.c                          |  4 +-
 drivers/iio/humidity/hdc100x.c                     |  2 +-
 drivers/iio/imu/adis16480.c                        |  1 +
 drivers/infiniband/hw/hfi1/chip.c                  | 47 ++++++++++-
 drivers/infiniband/hw/hfi1/vnic_sdma.c             | 15 ++--
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  2 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 | 12 +--
 drivers/infiniband/hw/qib/qib_sysfs.c              |  6 ++
 drivers/input/joystick/psxpad-spi.c                |  2 +-
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/input/rmi4/rmi_f34v7.c                     |  3 +
 drivers/input/rmi4/rmi_smbus.c                     |  2 -
 drivers/input/touchscreen/cyttsp4_core.c           |  7 --
 drivers/input/touchscreen/goodix.c                 |  9 +++
 drivers/isdn/gigaset/usb-gigaset.c                 | 23 ++++--
 drivers/md/dm-zoned-metadata.c                     | 29 ++++---
 drivers/md/dm-zoned-reclaim.c                      |  8 +-
 drivers/md/dm-zoned-target.c                       | 54 +++++++++----
 drivers/md/dm-zoned.h                              |  2 +
 drivers/md/raid0.c                                 |  2 +-
 drivers/media/cec/cec-adap.c                       |  7 ++
 drivers/media/platform/qcom/venus/vdec.c           |  3 -
 drivers/media/platform/qcom/venus/venc.c           |  3 -
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  3 +-
 drivers/media/platform/vimc/vimc-common.c          |  2 +
 drivers/media/platform/vimc/vimc-core.c            |  7 +-
 drivers/media/radio/radio-wl1273.c                 |  3 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |  2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |  6 +-
 drivers/misc/altera-stapl/altera.c                 |  3 +-
 drivers/mmc/host/omap_hsmmc.c                      | 30 +++++++
 drivers/mtd/devices/spear_smi.c                    | 38 ++++++++-
 drivers/net/can/slcan.c                            |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   | 21 +++--
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h    |  4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  6 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |  5 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  7 +-
 drivers/net/ethernet/intel/e100.c                  |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 10 +--
 drivers/net/ethernet/mellanox/mlx4/main.c          | 11 ++-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 78 ++++++++++++++++--
 drivers/net/ethernet/ti/cpts.c                     |  4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  3 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 15 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 10 +++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 20 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  9 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   | 25 +++++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  2 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |  1 +
 drivers/nfc/nxp-nci/i2c.c                          |  6 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  5 +-
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c           | 23 ++++--
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  4 +-
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c          |  6 +-
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c          |  6 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 10 ++-
 drivers/power/supply/cpcap-battery.c               | 11 +--
 drivers/rtc/rtc-max8997.c                          |  2 +-
 drivers/rtc/rtc-s3c.c                              |  6 --
 drivers/s390/scsi/zfcp_dbf.c                       |  8 +-
 drivers/s390/scsi/zfcp_erp.c                       |  3 -
 drivers/scsi/lpfc/lpfc.h                           |  3 +-
 drivers/scsi/lpfc/lpfc_attr.c                      | 12 ++-
 drivers/scsi/lpfc/lpfc_init.c                      |  3 +
 drivers/scsi/lpfc/lpfc_nvme.c                      |  2 -
 drivers/scsi/lpfc/lpfc_sli.c                       | 14 +---
 drivers/scsi/qla2xxx/qla_attr.c                    |  3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     | 15 ++--
 drivers/scsi/qla2xxx/qla_init.c                    |  2 -
 drivers/scsi/qla2xxx/qla_isr.c                     |  6 +-
 drivers/scsi/qla2xxx/qla_target.c                  | 11 +--
 drivers/spi/spi-atmel.c                            |  6 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |  2 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  2 +-
 drivers/staging/rtl8712/usb_intf.c                 |  2 +-
 drivers/thermal/thermal_core.c                     |  4 +-
 drivers/tty/n_hdlc.c                               |  4 +-
 drivers/tty/n_r3964.c                              |  2 +-
 drivers/tty/n_tty.c                                |  8 +-
 drivers/tty/serial/amba-pl011.c                    |  6 +-
 drivers/tty/serial/fsl_lpuart.c                    |  4 +-
 drivers/tty/serial/ifx6x60.c                       |  3 +
 drivers/tty/serial/imx.c                           |  2 +-
 drivers/tty/serial/msm_serial.c                    |  6 +-
 drivers/tty/serial/serial_core.c                   |  2 +-
 drivers/tty/tty_ldisc.c                            |  7 ++
 drivers/tty/vt/keyboard.c                          |  2 +-
 drivers/usb/atm/ueagle-atm.c                       | 18 +++--
 drivers/usb/core/hub.c                             |  5 +-
 drivers/usb/core/urb.c                             |  1 +
 drivers/usb/dwc3/core.c                            |  3 +-
 drivers/usb/dwc3/debug.h                           | 29 +++++++
 drivers/usb/dwc3/debugfs.c                         | 19 ++++-
 drivers/usb/dwc3/ep0.c                             |  8 ++
 drivers/usb/gadget/configfs.c                      |  1 +
 drivers/usb/gadget/function/u_serial.c             |  2 +
 drivers/usb/gadget/udc/pch_udc.c                   |  1 -
 drivers/usb/host/xhci-hub.c                        |  8 +-
 drivers/usb/host/xhci-mem.c                        |  4 +
 drivers/usb/host/xhci-pci.c                        | 13 +++
 drivers/usb/host/xhci-ring.c                       |  3 +-
 drivers/usb/host/xhci.c                            |  9 +--
 drivers/usb/host/xhci.h                            |  1 +
 drivers/usb/misc/adutux.c                          |  2 +-
 drivers/usb/misc/idmouse.c                         |  2 +-
 drivers/usb/mon/mon_bin.c                          | 32 +++++---
 drivers/usb/mtu3/mtu3_qmu.c                        |  2 +-
 drivers/usb/serial/io_edgeport.c                   | 10 ++-
 drivers/usb/storage/uas.c                          | 10 +++
 drivers/video/hdmi.c                               |  8 +-
 drivers/virtio/virtio_balloon.c                    | 11 +++
 drivers/watchdog/aspeed_wdt.c                      | 16 ++--
 fs/autofs4/expire.c                                |  5 +-
 fs/btrfs/delayed-inode.c                           | 13 ++-
 fs/btrfs/file.c                                    |  2 +-
 fs/btrfs/free-space-cache.c                        |  6 ++
 fs/btrfs/inode.c                                   |  3 +
 fs/btrfs/send.c                                    | 25 +++++-
 fs/btrfs/volumes.h                                 |  1 -
 fs/cifs/file.c                                     |  7 +-
 fs/cifs/smb2misc.c                                 |  7 +-
 fs/dlm/lockspace.c                                 |  1 +
 fs/dlm/member.c                                    |  2 +-
 fs/dlm/memory.c                                    |  9 +--
 fs/dlm/user.c                                      |  3 +-
 fs/exportfs/expfs.c                                | 31 +++++---
 fs/ext2/inode.c                                    |  7 +-
 fs/ext4/inode.c                                    | 25 ++++--
 fs/ext4/namei.c                                    | 11 ++-
 fs/f2fs/file.c                                     |  2 +-
 fs/f2fs/gc.c                                       | 10 +--
 fs/fuse/dir.c                                      | 27 +++++--
 fs/fuse/fuse_i.h                                   |  2 +
 fs/iomap.c                                         | 18 ++++-
 fs/kernfs/dir.c                                    |  5 +-
 fs/lockd/clnt4xdr.c                                | 22 ++---
 fs/lockd/clntxdr.c                                 | 22 ++---
 fs/nfsd/nfs4recover.c                              | 17 ++--
 fs/nfsd/vfs.c                                      | 17 +++-
 fs/ocfs2/quota_global.c                            |  2 +-
 fs/overlayfs/dir.c                                 |  2 +-
 fs/proc/task_mmu.c                                 |  3 +
 fs/pstore/ram.c                                    |  2 +-
 fs/quota/dquot.c                                   | 11 +--
 fs/reiserfs/inode.c                                | 12 ++-
 fs/reiserfs/namei.c                                |  7 +-
 fs/reiserfs/reiserfs.h                             |  2 +
 fs/reiserfs/super.c                                |  2 +
 fs/reiserfs/xattr.c                                | 19 +++--
 fs/reiserfs/xattr_acl.c                            |  4 +-
 include/asm-generic/pgtable.h                      | 25 ++++++
 include/dt-bindings/clock/rk3328-cru.h             |  2 +-
 include/linux/acpi.h                               |  2 +-
 include/linux/atalk.h                              |  2 +-
 include/linux/dma-mapping.h                        |  3 +-
 include/linux/huge_mm.h                            | 13 ++-
 include/linux/jbd2.h                               |  4 +-
 include/linux/kernfs.h                             |  1 +
 include/linux/mfd/rk808.h                          |  2 +-
 include/linux/mtd/mtd.h                            |  2 +-
 include/linux/platform_data/dma-dw.h               |  6 ++
 include/linux/qcom_scm.h                           |  3 +
 include/linux/quotaops.h                           | 10 +++
 include/linux/regulator/consumer.h                 |  2 +-
 include/linux/serial_core.h                        | 37 ++++++++-
 include/linux/tty.h                                |  7 ++
 include/math-emu/soft-fp.h                         |  2 +-
 include/uapi/linux/cec.h                           |  4 +-
 kernel/audit_watch.c                               |  2 +-
 kernel/cgroup/pids.c                               | 11 +--
 kernel/sched/core.c                                |  3 +-
 kernel/sched/fair.c                                | 36 +++++----
 kernel/workqueue.c                                 | 37 +++++++--
 lib/raid6/unroll.awk                               |  2 +-
 mm/huge_memory.c                                   | 12 ++-
 mm/memory.c                                        | 10 ++-
 mm/shmem.c                                         |  2 +-
 mm/vmstat.c                                        |  7 +-
 net/appletalk/aarp.c                               | 15 +++-
 net/appletalk/ddp.c                                | 21 +++--
 net/ipv4/tcp_output.c                              |  2 +-
 net/ipv4/tcp_timer.c                               | 20 +++--
 net/smc/smc_wr.c                                   |  4 +-
 net/x25/af_x25.c                                   | 18 +++--
 net/xfrm/xfrm_input.c                              |  3 +
 scripts/mod/modpost.c                              | 12 +++
 sound/core/oss/linear.c                            |  2 +
 sound/core/oss/mulaw.c                             |  2 +
 sound/core/oss/route.c                             |  2 +
 sound/core/pcm_lib.c                               |  8 +-
 sound/pci/hda/hda_bind.c                           |  4 +
 sound/pci/hda/hda_intel.c                          |  3 +
 sound/pci/hda/patch_conexant.c                     |  1 +
 sound/pci/hda/patch_realtek.c                      |  7 +-
 sound/soc/codecs/nau8540.c                         |  2 +-
 sound/soc/sh/rcar/core.c                           | 12 +++
 sound/soc/soc-jack.c                               |  3 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |  6 +-
 297 files changed, 1762 insertions(+), 939 deletions(-)


