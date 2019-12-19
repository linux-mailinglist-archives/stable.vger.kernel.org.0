Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC8126A0B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbfLSSnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfLSSna (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1DA24680;
        Thu, 19 Dec 2019 18:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781009;
        bh=jSnsSYGTer6Oe+Wea3Mf2Dwxw3TPuWrH4pJlIgJdueQ=;
        h=From:To:Cc:Subject:Date:From;
        b=eH0faWQxE2LgTl6vDYProF7O5ZMLExTxO/Y3lKckKSshibBKLDqbTDEhNVFQ/hBTe
         heKJZkplYnkdVYwLNeiLsRSXQyvEG3gXZxwUqUdDWu3PtTRt2n3wrt3hUp/iK7tfIq
         pFs2hB+4a/fQv09FZStzvg+jk5RjjnjVzpZzPQlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/199] 4.9.207-stable review
Date:   Thu, 19 Dec 2019 19:31:22 +0100
Message-Id: <20191219183214.629503389@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.207-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.207-rc1
X-KernelTest-Deadline: 2019-12-21T18:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.207 release.
There are 199 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.207-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.207-rc1

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't stop NAPI processing when dropping a packet

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: use correct DMA buffer size in the RX descriptor

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix USB3 device initiated resume race with roothub autosuspend

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix r1xx/r2xx register checker for POT textures

Bart Van Assche <bvanassche@acm.org>
    scsi: iscsi: Fix a potential deadlock in the timeout handler

Hou Tao <houtao1@huawei.com>
    dm btree: increase rebalance threshold in __rebalance2()

Navid Emamdoost <navid.emamdoost@gmail.com>
    dma-buf: Fix memory leak in sync_file_merge()

Jiang Yi <giangyi@amazon.com>
    vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Lihua Yao <ylhuajnu@outlook.com>
    ARM: dts: s3c64xx: Fix init order of clock providers

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix TLB sanity checker

Jian-Hong Pan <jian-hong@endlessm.com>
    PCI/MSI: Fix incorrect MSI-X masking on resume

Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
    PCI: Fix Intel ACS quirk UPDCR register address

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "regulator: Defer init completion for a while after late_initcall"

Guillaume Nault <gnault@redhat.com>
    tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Guillaume Nault <gnault@redhat.com>
    tcp: tighten acceptance of ACKs not matching a child socket

Guillaume Nault <gnault@redhat.com>
    tcp: fix rejected syncookies due to stale timestamps

Eric Dumazet <edumazet@google.com>
    inet: protect against too small mtu values.

Taehee Yoo <ap420073@gmail.com>
    tipc: fix ordering of tipc module init and exit routine

Eric Dumazet <edumazet@google.com>
    tcp: md5: fix potential overestimation of TCP option space

Aaron Conole <aconole@redhat.com>
    openvswitch: support asymmetric conntrack

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix extra rx interrupt

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: deny dev_set_mac_address() when unregistering

Ivan Bornyakov <brnkv.i1@gmail.com>
    nvme: host: core: fix precedence of ternary operator

Konstantin Khorenko <khorenko@virtuozzo.com>
    kernel/module.c: wakeup processes in module_wq on module unload

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5e: Fix SFF 8472 eeprom length

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    sunrpc: fix crash when cache_head become valid before update

Tejun Heo <tj@kernel.org>
    workqueue: Fix missing kfree(rescuer) in destroy_workqueue()

Ming Lei <ming.lei@redhat.com>
    blk-mq: make sure that line break can be printed

yangerkun <yangerkun@huawei.com>
    ext4: fix a bug in ext4_wait_for_tail_page_commit

Chen Jun <chenjun102@huawei.com>
    mm/shmem.c: cast the type of unmap_start to u64

Will Deacon <will@kernel.org>
    firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix extended attributes on the root directory

Vincenzo Frascino <vincenzo.frascino@arm.com>
    powerpc: Fix vDSO clock_getres()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return value

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix session lookup in qlt_abort_work()

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Fix DMA unmap leak

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup controller init

Jarkko Nikula <jarkko.nikula@bitmer.com>
    ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polarity

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix fw crash by moving chip reset after napi disabled

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models

YueHaibing <yuehaibing@huawei.com>
    e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Cap NPIV vports to 256

H. Nikolaus Schaller <hns@goldelico.com>
    omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix negative subv_writers counter and data space leak after buffered write

Nuno Sá <nuno.sa@analog.com>
    iio: adis16480: Add debugfs_reg_access entry

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure interrupts are restored to correct state

Mika Westerberg <mika.westerberg@linux.intel.com>
    xhci: Fix memory leak in xhci_add_in_port()

Henry Lin <henryl@nvidia.com>
    usb: xhci: only set D3hot for pci device

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: trace channel log even for FCP command responses

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: fix livelock in dquot_writeback_dquots

Chengguang Xu <cgxu519@mykernel.net>
    ext2: check err when partial != NULL

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: Check that quota is not dirty before release

Ville Syrjälä <ville.syrjala@linux.intel.com>
    video/hdmi: Fix AVI bar unpack

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges >4GB

Arnd Bergmann <arnd@arndb.de>
    ppdev: fix PPGETTIME/PPSETTIME ioctls

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in init code

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup controller init

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Francesco Ruggeri <fruggeri@arista.com>
    ACPI: OSL: only free map once in osl.c

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Lock devfreq in trans_stat_show

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    cpuidle: Do not unset the driver if it is there already

Johan Hovold <johan@kernel.org>
    media: radio: wl1273: fix interrupt masking on release

Johan Hovold <johan@kernel.org>
    media: bdisp: fix memleak on release

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix pending unsol events at shutdown

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

Josef Bacik <josef@toxicpanda.com>
    btrfs: check page->mapping when loading free space cache

David Hildenbrand <david@redhat.com>
    virtio-balloon: fix managed page counts when migrating pages between zones

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spear_smi: Fix Write Burst mode

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

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Increase STS_HALT timeout in xhci_suspend()

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
    USB: uas: heed CAPACITY_HEURISTICS

Oliver Neukum <oneukum@suse.com>
    USB: uas: honor flag to avoid CAPACITY16

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: configfs: Fix missing spin_lock_init()

YueHaibing <yuehaibing@huawei.com>
    appletalk: Set error code if register_snap_client failed

YueHaibing <yuehaibing@huawei.com>
    appletalk: Fix potential NULL pointer dereference in unregister_snap_client

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)

Wei Wang <wvw@google.com>
    thermal: Fix deadlock in thermal thermal_zone_device_check

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

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not modify masked bits of shared MSRs

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i810: Prevent underflow in ioctl

Jan Kara <jack@suse.cz>
    jbd2: Fix possible overflow in jbd2_log_space_left()

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

Mike Leach <mike.leach@linaro.org>
    coresight: etm4x: Fix input validation for sysfs.

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add upside-down quirk for Teclast X89 tablet

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid potential buffer overflows

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify attributes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify nlink

Xuewei Zhang <xueweiz@google.com>
    sched/fair: Scale bandwidth quota and period without losing quota/period ratio precision

Rob Herring <robh@kernel.org>
    ARM: dts: sunxi: Fix PMU compatible strings

Qian Cai <cai@gmx.us>
    mlx4: Use snprintf instead of complicated strcpy

Andreas Pape <ap@ca-pape.de>
    media: stkwebcam: Bugfix for wrong return values

Dmitry Safonov <dima@arista.com>
    tty: Don't block on IO when ldisc change is pending

zhengbin <zhengbin13@huawei.com>
    nfsd: Return EPERM, not EACCES, in some SETATTR cases

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible definition

Joel Stanley <joel@jms.id.au>
    powerpc/math-emu: Update macros from GCC

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
    tcp: fix off-by-one bug on aborting window-probing socket

Rob Herring <robh@kernel.org>
    ARM: dts: realview-pbx: Fix duplicate regulator nodes

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp2: fix the gpio interrupt cell number

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix null_x25_address handling

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix called/calling length calculation in x25_parse_address_block

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1/2: fix SoC name printing

Scott Mayhew <smayhew@redhat.com>
    nfsd: fix a warning in __cld_pipe_upcall()

Clément Péron <peron.clem@gmail.com>
    ARM: debug: enable UART1 for socfpga Cyclone5

Wen Yang <wen.yang99@zte.com.cn>
    dlm: NULL check before kmem_cache_destroy is not needed

Lucas Stach <l.stach@pengutronix.de>
    i2c: imx: don't print error message on probe defer

Stefan Agner <stefan@agner.ch>
    serial: imx: fix error handling in console_setup

Colin Ian King <colin.king@canonical.com>
    altera-stapl: check for a null key before strcasecmp'ing it

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    dma-mapping: fix return type of dma_set_max_seg_size()

Alexey Dobriyan <adobriyan@gmail.com>
    ACPI: fix acpi_find_child_device() invocation in acpi_preset_companion()

Brian Norris <briannorris@chromium.org>
    usb: dwc3: don't log probe deferrals; but do log other error codes

Vinod Koul <vkoul@kernel.org>
    dmaengine: coh901318: Remove unused variable

Jia-Ju Bai <baijiaju1990@gmail.com>
    dmaengine: coh901318: Fix a double-lock bug

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

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: OCTEON: octeon-platform: fix typing

Mark Brown <broonie@kernel.org>
    regulator: Fix return value of _set_load() stub

Shreeya Patel <shreeya.patel23498@gmail.com>
    Staging: iio: adt7316: Fix i2c data reading, set the data field

Brian Masney <masneyb@onstation.org>
    pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: drop default switch case which might paper over missing case

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

Marek Szyprowski <m.szyprowski@samsung.com>
    extcon: max8997: Fix lack of path setting in USB device mode

Moni Shoua <monis@mellanox.com>
    net/mlx5: Release resource on error flow

Vincent Whitchurch <vincent.whitchurch@axis.com>
    ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Send non offchannel traffic via AP sta

Arjun Vynipadath <arjun@chelsio.com>
    cxgb4vf: fix memleak in mac_hlist initialization

Douglas Anderson <dianders@chromium.org>
    serial: core: Allow processing sysrq at port unlock time

Chuhong Yuan <hslester96@gmail.com>
    net: ep93xx_eth: fix mismatch of request_mem_region in remove

Chuhong Yuan <hslester96@gmail.com>
    rsxx: add missed destroy_workqueue calls in remove

paulhsia <paulhsia@chromium.org>
    ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

Pan Bian <bianpan2016@163.com>
    Input: cyttsp4_core - fix use after free bug

Stephan Gerhold <stephan@gerhold.net>
    NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error

Al Viro <viro@zeniv.linux.org.uk>
    audit_get_nd(): don't unlock parent too early

Al Viro <viro@zeniv.linux.org.uk>
    exportfs_decode_fh(): negative pinned may become positive without the parent locked

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


-------------

Diffstat:

 .../devicetree/bindings/rtc/abracon,abx80x.txt     |  2 +-
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
 arch/arm/boot/dts/s3c6410-mini6410.dts             |  4 +
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |  4 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  2 +-
 arch/arm/include/asm/uaccess.h                     | 18 +++++
 arch/arm/lib/getuser.S                             | 11 +++
 arch/arm/lib/putuser.S                             | 20 ++---
 arch/arm/mach-omap1/id.c                           |  6 +-
 arch/arm/mach-omap2/id.c                           |  4 +-
 arch/arm/mach-omap2/pdata-quirks.c                 | 93 ----------------------
 arch/arm/mach-tegra/reset-handler.S                |  6 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |  2 +-
 arch/mips/Kconfig                                  |  1 +
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c |  2 +-
 arch/mips/cavium-octeon/octeon-platform.c          |  2 +-
 arch/mips/include/asm/octeon/cvmx-pko.h            |  2 +-
 arch/powerpc/include/asm/sfp-machine.h             | 92 +++++++--------------
 arch/powerpc/include/asm/vdso_datapage.h           |  2 +
 arch/powerpc/kernel/asm-offsets.c                  |  2 +-
 arch/powerpc/kernel/time.c                         |  1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |  7 +-
 arch/powerpc/kernel/vdso64/cacheflush.S            |  4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S          |  7 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   | 30 -------
 arch/x86/kernel/cpu/mcheck/mce_amd.c               | 36 +++++++++
 arch/x86/kvm/cpuid.c                               |  5 +-
 arch/x86/kvm/x86.c                                 | 14 +++-
 arch/x86/pci/fixup.c                               | 11 +++
 arch/xtensa/mm/tlb.c                               |  4 +-
 block/blk-mq-sysfs.c                               | 15 ++--
 crypto/crypto_user.c                               |  4 +-
 crypto/ecc.c                                       |  3 +-
 drivers/acpi/bus.c                                 |  2 +-
 drivers/acpi/device_pm.c                           | 12 ++-
 drivers/acpi/osl.c                                 | 28 ++++---
 drivers/block/rsxx/core.c                          |  2 +
 drivers/char/ppdev.c                               | 16 +++-
 drivers/clk/rockchip/clk-rk3188.c                  |  8 +-
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                |  2 +-
 drivers/cpuidle/driver.c                           | 15 ++--
 drivers/crypto/amcc/crypto4xx_core.c               |  6 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  1 +
 drivers/devfreq/devfreq.c                          | 12 ++-
 drivers/dma-buf/sync_file.c                        |  2 +-
 drivers/dma/coh901318.c                            |  5 --
 drivers/extcon/extcon-max8997.c                    | 10 +--
 drivers/firmware/qcom_scm-64.c                     |  2 +-
 drivers/gpu/drm/i810/i810_dma.c                    |  4 +-
 drivers/gpu/drm/radeon/r100.c                      |  4 +-
 drivers/gpu/drm/radeon/r200.c                      |  4 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    | 21 +++--
 drivers/i2c/busses/i2c-imx.c                       |  3 +-
 drivers/iio/humidity/hdc100x.c                     |  2 +-
 drivers/iio/imu/adis16480.c                        |  1 +
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  2 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 | 12 +--
 drivers/infiniband/hw/qib/qib_sysfs.c              |  6 ++
 drivers/input/touchscreen/cyttsp4_core.c           |  7 --
 drivers/input/touchscreen/goodix.c                 |  9 +++
 drivers/isdn/gigaset/usb-gigaset.c                 | 23 ++++--
 drivers/md/persistent-data/dm-btree-remove.c       |  8 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  3 +-
 drivers/media/radio/radio-wl1273.c                 |  3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |  6 +-
 drivers/misc/altera-stapl/altera.c                 |  3 +-
 drivers/mmc/host/omap_hsmmc.c                      | 30 +++++++
 drivers/mtd/devices/spear_smi.c                    | 38 ++++++++-
 drivers/net/can/slcan.c                            |  1 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  6 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |  5 +-
 drivers/net/ethernet/intel/e100.c                  |  4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          | 11 ++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  4 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |  2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    | 23 ++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     | 10 ++-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    | 10 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 20 ++---
 drivers/net/ethernet/ti/cpsw.c                     |  2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  3 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 15 ++++
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  9 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   | 25 +++++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  2 +
 drivers/nfc/nxp-nci/i2c.c                          |  6 +-
 drivers/nvme/host/core.c                           |  4 +-
 drivers/pci/msi.c                                  |  2 +-
 drivers/pci/quirks.c                               |  2 +-
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c           | 23 ++++--
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c          |  6 +-
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c          |  3 +
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 10 ++-
 drivers/regulator/core.c                           | 42 +++-------
 drivers/rtc/rtc-max8997.c                          |  2 +-
 drivers/s390/scsi/zfcp_dbf.c                       |  8 +-
 drivers/s390/scsi/zfcp_erp.c                       |  3 -
 drivers/scsi/libiscsi.c                            |  4 +-
 drivers/scsi/lpfc/lpfc.h                           |  3 +-
 drivers/scsi/lpfc/lpfc_attr.c                      | 12 ++-
 drivers/scsi/lpfc/lpfc_init.c                      |  3 +
 drivers/scsi/qla2xxx/qla_attr.c                    |  3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     | 15 ++--
 drivers/scsi/qla2xxx/qla_target.c                  | 11 +--
 drivers/spi/spi-atmel.c                            |  6 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |  2 +
 drivers/staging/media/pulse8-cec/pulse8-cec.c      |  2 +-
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
 drivers/usb/gadget/configfs.c                      |  1 +
 drivers/usb/gadget/function/u_serial.c             |  2 +
 drivers/usb/host/xhci-hub.c                        | 16 +++-
 drivers/usb/host/xhci-mem.c                        |  4 +
 drivers/usb/host/xhci-pci.c                        | 13 +++
 drivers/usb/host/xhci-ring.c                       |  6 +-
 drivers/usb/host/xhci.c                            |  7 +-
 drivers/usb/host/xhci.h                            |  2 +
 drivers/usb/misc/adutux.c                          |  2 +-
 drivers/usb/misc/idmouse.c                         |  2 +-
 drivers/usb/mon/mon_bin.c                          | 32 +++++---
 drivers/usb/serial/io_edgeport.c                   | 10 ++-
 drivers/usb/storage/uas.c                          | 10 +++
 drivers/vfio/pci/vfio_pci_intrs.c                  |  2 +-
 drivers/video/hdmi.c                               |  8 +-
 drivers/virtio/virtio_balloon.c                    | 11 +++
 fs/autofs4/expire.c                                |  5 +-
 fs/btrfs/file.c                                    |  2 +-
 fs/btrfs/free-space-cache.c                        |  6 ++
 fs/btrfs/inode.c                                   |  3 +
 fs/btrfs/send.c                                    | 25 +++++-
 fs/btrfs/volumes.h                                 |  1 -
 fs/cifs/file.c                                     | 14 +++-
 fs/cifs/smb2misc.c                                 |  7 +-
 fs/dlm/lockspace.c                                 |  1 +
 fs/dlm/memory.c                                    |  9 +--
 fs/dlm/user.c                                      |  3 +-
 fs/exportfs/expfs.c                                | 31 +++++---
 fs/ext2/inode.c                                    |  7 +-
 fs/ext4/inode.c                                    | 12 ++-
 fs/fuse/dir.c                                      | 27 +++++--
 fs/fuse/fuse_i.h                                   |  2 +
 fs/nfsd/nfs4recover.c                              | 17 ++--
 fs/nfsd/vfs.c                                      | 17 +++-
 fs/ocfs2/quota_global.c                            |  2 +-
 fs/quota/dquot.c                                   | 11 +--
 fs/reiserfs/inode.c                                | 12 ++-
 fs/reiserfs/namei.c                                |  7 +-
 fs/reiserfs/reiserfs.h                             |  2 +
 fs/reiserfs/super.c                                |  2 +
 fs/reiserfs/xattr.c                                | 19 +++--
 fs/reiserfs/xattr_acl.c                            |  4 +-
 include/linux/acpi.h                               |  2 +-
 include/linux/atalk.h                              |  2 +-
 include/linux/dma-mapping.h                        |  3 +-
 include/linux/jbd2.h                               |  4 +-
 include/linux/mtd/mtd.h                            |  2 +-
 include/linux/netdevice.h                          |  5 ++
 include/linux/quotaops.h                           | 10 +++
 include/linux/regulator/consumer.h                 |  2 +-
 include/linux/serial_core.h                        | 37 ++++++++-
 include/linux/time.h                               | 12 +++
 include/linux/tty.h                                |  7 ++
 include/math-emu/soft-fp.h                         |  2 +-
 include/net/ip.h                                   |  5 ++
 include/net/tcp.h                                  | 18 +++--
 kernel/audit_watch.c                               |  2 +-
 kernel/cgroup_pids.c                               | 11 +--
 kernel/module.c                                    |  2 +
 kernel/sched/fair.c                                | 36 +++++----
 kernel/workqueue.c                                 | 38 +++++++--
 lib/raid6/unroll.awk                               |  2 +-
 mm/shmem.c                                         |  2 +-
 net/appletalk/aarp.c                               | 15 +++-
 net/appletalk/ddp.c                                | 21 +++--
 net/bridge/br_device.c                             |  6 ++
 net/core/dev.c                                     |  3 +-
 net/ipv4/devinet.c                                 |  5 --
 net/ipv4/ip_output.c                               | 14 ++--
 net/ipv4/tcp_output.c                              |  5 +-
 net/ipv4/tcp_timer.c                               | 10 +--
 net/openvswitch/conntrack.c                        | 11 +++
 net/sunrpc/cache.c                                 |  6 --
 net/tipc/core.c                                    | 29 +++----
 net/x25/af_x25.c                                   | 18 +++--
 scripts/mod/modpost.c                              | 12 +++
 sound/core/oss/linear.c                            |  2 +
 sound/core/oss/mulaw.c                             |  2 +
 sound/core/oss/route.c                             |  2 +
 sound/core/pcm_lib.c                               |  8 +-
 sound/pci/hda/hda_bind.c                           |  4 +
 sound/pci/hda/hda_intel.c                          |  3 +
 sound/soc/soc-jack.c                               |  3 +-
 225 files changed, 1265 insertions(+), 749 deletions(-)


