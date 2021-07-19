Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6653CED59
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 22:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352160AbhGSSWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 14:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350243AbhGSSF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 14:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD5C61029;
        Mon, 19 Jul 2021 18:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626720319;
        bh=ruXYCQplZLgShOXeIINzAfw6f1Xjaxo3My5HlLq5Q1U=;
        h=From:To:Cc:Subject:Date:From;
        b=St3WuCSfBeYnzIdHS8X0jnU/nrp/Jvn0HXPEuiL+nbQ7Xz+QvclNgRi5v1C6H3Mc1
         ypoFh/a3YY7PImnl6AYpu5nvhcRTO5Apv8G774F94tsKS0AtU4L2BLcw3TyFbXJmwW
         LOjlVE1H08wFdAJJdX5vCqPRQQH37FgNYaugAtWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/148] 5.4.134-rc2 review
Date:   Mon, 19 Jul 2021 20:45:17 +0200
Message-Id: <20210719184316.974243081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.134-rc2
X-KernelTest-Deadline: 2021-07-21T18:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.134 release.
There are 148 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.134-rc2

Tong Zhang <ztong0001@gmail.com>
    misc: alcor_pci: fix inverted branch condition

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: scsi_dh_alua: Fix signedness bug in alua_rtpg()

Martin Fäcknitz <faecknitz@hotsplots.de>
    MIPS: vdso: Invalid GIC access through VDSO

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix --task and --stat with pipe input

Randy Dunlap <rdunlap@infradead.org>
    mips: disable branch profiling in boot/decompress.o

Arnd Bergmann <arnd@arndb.de>
    mips: always link byteswap helpers into decompressor

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()

Pali Rohár <pali@kernel.org>
    firmware: turris-mox-rwtm: fail probing when firmware does not support hwrng

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: report failures better

Marek Behún <kabel@kernel.org>
    firmware: turris-mox-rwtm: fix reply status decoding function

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    thermal/drivers/rcar_gen3_thermal: Fix coefficient calculations

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    ARM: dts: imx6q-dhcom: Add gpios pinctrl for i2c bus recovery

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    ARM: dts: imx6q-dhcom: Fix ethernet plugin detection problems

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    ARM: dts: imx6q-dhcom: Fix ethernet reset time properties

Aswath Govindraju <a-govindraju@ti.com>
    ARM: dts: am437x: align ti,pindir-d0-out-d1-in property with dt-shema

Aswath Govindraju <a-govindraju@ti.com>
    ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: fsl_ifc: fix leak of private memory on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: fsl_ifc: fix leak of IO mapping on probe failure

Philipp Zabel <p.zabel@pengutronix.de>
    reset: bail if try_module_get() fails

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fixup SPI binding

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Reset Rx buffer to max size during async commands

Zhen Lei <thunder.leizhen@huawei.com>
    firmware: tegra: Fix error return code in tegra210_bpmp_init()

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7779, marzen: Fix DU clock names

Valentine Barshak <valentine.barshak@cogentembedded.com>
    arm64: dts: renesas: v3msk: Fix memory size

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: fix snprintf() checking in is_rtc_hctosys()

Zhen Lei <thunder.leizhen@huawei.com>
    memory: pl353: Fix error return code in pl353_smc_probe()

Zou Wei <zou_wei@huawei.com>
    reset: brcmstb: Add missing MODULE_DEVICE_TABLE

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: atmel-ebi: add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid HC1

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: exynos: add missing of_node_put for loop iteration

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    reset: a10sr: add missing of_match_table reference

Corentin Labbe <clabbe@baylibre.com>
    ARM: dts: gemini-rut1xx: remove duplicate ethernet node

Nathan Chancellor <nathan@kernel.org>
    hexagon: use common DISCARDS macro

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Don't call _nfs4_pnfs_v3_ds_connect multiple times

Zhen Lei <thunder.leizhen@huawei.com>
    ALSA: isa: Fix error return code in snd_cmi8330_probe()

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: can't set sk_user_data without write_lock

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: move tx vq operation under tx queue lock

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: imx1: Don't disable clocks at device remove time

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Limit xstate copy size in xstateregs_set()

Sandor Bodo-Merle <sbodomerle@gmail.com>
    PCI: iproc: Support multi-MSI only on uniprocessor kernel

Sandor Bodo-Merle <sbodomerle@gmail.com>
    PCI: iproc: Fix multi-MSI base vector number allocation

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode

Gao Xiang <hsiangkao@linux.alibaba.com>
    nfs: fix acl memory leak of posix_acl_create()

Tao Ren <rentao.bupt@gmail.com>
    watchdog: aspeed: fix hardware timeout calculation

Zhen Lei <thunder.leizhen@huawei.com>
    um: fix error return code in winch_tramp()

Zhen Lei <thunder.leizhen@huawei.com>
    um: fix error return code in slip_open()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Initialise connection to the server in nfs4_alloc_client()

Stephan Gerhold <stephan@gerhold.net>
    power: supply: rt5033_battery: Fix device tree enumeration

Krzysztof Wilczyński <kw@linux.com>
    PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun

Chao Yu <chao@kernel.org>
    f2fs: add MODULE_SOFTDEP to ensure crc32 is included in the initramfs

Chang S. Bae <chang.seok.bae@intel.com>
    x86/signal: Detect and prevent an alternate signal stack overflow

Xie Yongji <xieyongji@bytedance.com>
    virtio_console: Assure used length from device is limited

Xie Yongji <xieyongji@bytedance.com>
    virtio_net: Fix error handling in virtnet_restore()

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Fix memory leak among suspend/resume procedure

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add quirk for the Dell Vostro 3350

Liguang Zhang <zhangliguang@linux.alibaba.com>
    ACPI: AMBA: Fix resource name in /proc/iomem

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: tegra: Don't modify HW state in .remove callback

Zou Wei <zou_wei@huawei.com>
    pwm: img: Fix PM reference leak in img_pwm_enable()

Zou Wei <zou_wei@huawei.com>
    power: supply: ab8500: add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    power: supply: charger-manager: add missing MODULE_DEVICE_TABLE

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_find_open_context() may only select open files

Jeff Layton <jlayton@kernel.org>
    ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix orangefs df output.

Zou Wei <zou_wei@huawei.com>
    PCI: tegra: Add missing MODULE_DEVICE_TABLE

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Return proper error codes from user access functions

Jan Kiszka <jan.kiszka@siemens.com>
    watchdog: iTCO_wdt: Account for rebooting on second timeout

Stefan Eichenberger <eichest@gmail.com>
    watchdog: imx_sc_wdt: fix pretimeout

Zou Wei <zou_wei@huawei.com>
    watchdog: Fix possible use-after-free by calling del_timer_sync()

Zou Wei <zou_wei@huawei.com>
    watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()

Zou Wei <zou_wei@huawei.com>
    watchdog: Fix possible use-after-free in wdt_startup()

Logan Gunthorpe <logang@deltatee.com>
    PCI/P2PDMA: Avoid pci_get_slot(), which may sleep

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9087/1: kprobes: test-thumb: fix for LLVM_IAS=1

Bixuan Cui <cuibixuan@huawei.com>
    power: reset: gpio-poweroff: add missing MODULE_DEVICE_TABLE

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: max17042: Do not enforce (incorrect) interrupt trigger type

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Avoid NULL pointers

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: spear: Don't modify HW state in .remove callback

Zou Wei <zou_wei@huawei.com>
    power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE

Zou Wei <zou_wei@huawei.com>
    power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE

Dimitri John Ledkov <dimitri.ledkov@canonical.com>
    lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    i2c: core: Disable client irq on reboot/shutdown

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Wait until port is in reset before programming it

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: fix macro value for 2.4Ghz only device

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions

Jiajun Cao <jjcao20@fudan.edu.cn>
    ALSA: hda: Add IRQ check for platform_get_irq()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    backlight: lm3630a: Fix return code of .update_status() callback

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/boot: Fixup device-tree on little endian

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: hid: fix error return code in hid_bind()

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_hid: fix endianness issue with descriptors

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix scarlett2_*_ctl_put() return values

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix data_mutex lock

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: add support for ToneWeal FW66

Yizhuo Zhai <yzhai003@ucr.edu>
    Input: hideep - fix the uninitialized use in hideep_nvm_unlock()

Heiko Carstens <hca@linux.ibm.com>
    s390/mem_detect: fix tprot() program check new psw handling

Heiko Carstens <hca@linux.ibm.com>
    s390/mem_detect: fix diag260() program check new psw handling

Heiko Carstens <hca@linux.ibm.com>
    s390/ipl_parm: fix program check new psw handling

Heiko Carstens <hca@linux.ibm.com>
    s390/processor: always inline stap() and __load_psw_mask()

Zhen Lei <thunder.leizhen@huawei.com>
    ASoC: soc-core: Fix the error return code in snd_soc_of_parse_audio_routing()

Peter Robinson <pbrobinson@gmail.com>
    gpio: pca953x: Add support for the On Semi pca9655

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    selftests/powerpc: Fix "no_handler" EBB selftest

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ppc: fix error return code in snd_pmac_probe()

Srinivas Neeli <srinivas.neeli@xilinx.com>
    gpio: zynq: Check return value of pm_runtime_get_sync

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails

Geoff Levand <geoff@infradead.org>
    powerpc/ps3: Add dma_mask to ps3_dma_region

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Fix potential double-free of CSP mixer elements

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: timers: rtcpie: skip test if default RTC device does not exist

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    s390/sclp_vt220: fix console name to match device

Daniel Mack <daniel@zonque.org>
    serial: tty: uartlite: fix console setup

Yufen Yu <yuyufen@huawei.com>
    ASoC: img: Fix PM reference leak in img_i2s_in_probe()

Tony Lindgren <tony@atomide.com>
    mfd: cpcap: Fix cpcap dmamask not set warnings

Zou Wei <zou_wei@huawei.com>
    mfd: da9052/stmpe: Add and modify MODULE_DEVICE_TABLE

Mike Christie <michael.christie@oracle.com>
    scsi: qedi: Fix null ref during abort handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix shost->max_id use

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix conn use after free during resets

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Add iscsi_cls_conn refcount helpers

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs

Kashyap Desai <kashyap.desai@broadcom.com>
    scsi: megaraid_sas: Early detection of VD deletion through RaidMap update

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Fix resource leak in case of probe failure

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    fs/jfs: Fix missing error code in lmLogInit()

Hannes Reinecke <hare@suse.de>
    scsi: scsi_dh_alua: Check for negative result value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: 8250: serial_cs: Fix a memory leak in error handling path

Yufen Yu <yuyufen@huawei.com>
    ALSA: ac97: fix PM reference leak in ac97_bus_remove()

John Garry <john.garry@huawei.com>
    scsi: core: Cap scsi_host cmd_per_lun at can_queue

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology

Sergey Shtylyov <s.shtylyov@omp.ru>
    scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()

Luiz Sampaio <sampaio.ime@gmail.com>
    w1: ds2438: fixing bug that would always get page0

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    Revert "ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro"

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Don't call free_pages_exact() with NULL address

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: magn: bmc150: Balance runtime pm + use pm_runtime_resume_and_get()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: gyro: fxa21002c: Balance runtime pm + use pm_runtime_resume_and_get().

Tong Zhang <ztong0001@gmail.com>
    misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    misc/libmasm/module: Fix two use after free in ibmasm_init_one

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero

Frederic Weisbecker <frederic@kernel.org>
    srcu: Fix broken node geometry after early ssp init

Robin Gong <yibin.gong@nxp.com>
    dmaengine: fsl-qdma: check dma_set_mask return value

Yang Yingliang <yangyingliang@huawei.com>
    net: moxa: Use devm_platform_get_and_ioremap_resource()

Zhen Lei <thunder.leizhen@huawei.com>
    fbmem: Do not delete the mode that is still in use

Christian Brauner <christian.brauner@ubuntu.com>
    cgroup: verify that source is a string

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not reference char * as a string in histograms

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: core: Fix bad pointer dereference when ehandler kthread is invalid

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is enabled

Kefeng Wang <wangkefeng.wang@huawei.com>
    KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-cm-t335.dts               |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   4 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |  18 +--
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         |   2 +-
 arch/arm/boot/dts/exynos5422-odroidxu4.dts         |   2 +-
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi    |   4 +-
 arch/arm/boot/dts/gemini-rut1xx.dts                |  12 --
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |  41 ++++++-
 arch/arm/boot/dts/r8a7779-marzen.dts               |   2 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |   1 +
 arch/arm/mach-exynos/exynos.c                      |   2 +
 arch/arm/probes/kprobes/test-thumb.c               |  10 +-
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts     |   2 +-
 arch/hexagon/kernel/vmlinux.lds.S                  |   7 +-
 arch/mips/boot/compressed/Makefile                 |   4 +-
 arch/mips/boot/compressed/decompress.c             |   2 +
 arch/mips/include/asm/vdso/vdso.h                  |   2 +-
 arch/powerpc/boot/devtree.c                        |  59 +++++-----
 arch/powerpc/boot/ns16550.c                        |   9 +-
 arch/powerpc/include/asm/ps3.h                     |   2 +
 arch/powerpc/platforms/ps3/mm.c                    |  12 ++
 arch/s390/boot/ipl_parm.c                          |  19 ++--
 arch/s390/boot/mem_detect.c                        |  47 ++++----
 arch/s390/include/asm/processor.h                  |   4 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/um/drivers/chan_user.c                        |   3 +-
 arch/um/drivers/slip_user.c                        |   3 +-
 arch/x86/include/asm/fpu/internal.h                |  19 ++--
 arch/x86/kernel/fpu/regset.c                       |   2 +-
 arch/x86/kernel/signal.c                           |  24 +++-
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/x86.c                                 |   2 +
 drivers/acpi/acpi_amba.c                           |   1 +
 drivers/acpi/acpi_video.c                          |   9 ++
 drivers/block/virtio_blk.c                         |   2 +
 drivers/char/virtio_console.c                      |   4 +-
 drivers/dma/fsl-qdma.c                             |   6 +-
 drivers/firmware/arm_scmi/driver.c                 |   4 +
 drivers/firmware/tegra/bpmp-tegra210.c             |   2 +-
 drivers/firmware/turris-mox-rwtm.c                 |  53 +++++++--
 drivers/gpio/gpio-pca953x.c                        |   1 +
 drivers/gpio/gpio-zynq.c                           |   5 +-
 drivers/hwtracing/intel_th/core.c                  |  17 +++
 drivers/hwtracing/intel_th/gth.c                   |  16 +++
 drivers/hwtracing/intel_th/intel_th.h              |   3 +
 drivers/i2c/i2c-core-base.c                        |   3 +
 drivers/iio/gyro/fxas21002c_core.c                 |  11 +-
 drivers/iio/magnetometer/bmc150_magn.c             |  10 +-
 drivers/input/touchscreen/hideep.c                 |  13 ++-
 drivers/iommu/arm-smmu.c                           |  10 +-
 drivers/memory/atmel-ebi.c                         |   4 +-
 drivers/memory/fsl_ifc.c                           |   8 +-
 drivers/memory/pl353-smc.c                         |   1 +
 drivers/mfd/da9052-i2c.c                           |   1 +
 drivers/mfd/motorola-cpcap.c                       |   4 +
 drivers/mfd/stmpe-i2c.c                            |   2 +-
 drivers/misc/cardreader/alcor_pci.c                |   8 +-
 drivers/misc/ibmasm/module.c                       |   5 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |   4 +
 drivers/net/virtio_net.c                           |  27 ++++-
 drivers/nvme/target/tcp.c                          |   1 -
 drivers/pci/controller/pci-tegra.c                 |   1 +
 drivers/pci/controller/pcie-iproc-msi.c            |  29 +++--
 drivers/pci/p2pdma.c                               |  34 +++++-
 drivers/pci/pci-label.c                            |   2 +-
 drivers/power/reset/gpio-poweroff.c                |   1 +
 drivers/power/supply/Kconfig                       |   3 +-
 drivers/power/supply/ab8500_btemp.c                |   1 +
 drivers/power/supply/ab8500_charger.c              |  19 +++-
 drivers/power/supply/ab8500_fg.c                   |   1 +
 drivers/power/supply/charger-manager.c             |   1 +
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/power/supply/rt5033_battery.c              |   7 ++
 drivers/power/supply/sc2731_charger.c              |   1 +
 drivers/power/supply/sc27xx_fuel_gauge.c           |   1 +
 drivers/pwm/pwm-img.c                              |   2 +-
 drivers/pwm/pwm-imx1.c                             |   2 -
 drivers/pwm/pwm-spear.c                            |   4 -
 drivers/pwm/pwm-tegra.c                            |  13 ---
 drivers/reset/core.c                               |   5 +-
 drivers/reset/reset-a10sr.c                        |   1 +
 drivers/reset/reset-brcmstb.c                      |   1 +
 drivers/rtc/proc.c                                 |   4 +-
 drivers/s390/char/sclp_vt220.c                     |   4 +-
 drivers/scsi/be2iscsi/be_main.c                    |   5 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |  11 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  12 +-
 drivers/scsi/hosts.c                               |   4 +
 drivers/scsi/libiscsi.c                            | 122 ++++++++++-----------
 drivers/scsi/lpfc/lpfc_els.c                       |   9 ++
 drivers/scsi/lpfc/lpfc_sli.c                       |   5 +-
 drivers/scsi/megaraid/megaraid_sas.h               |  12 ++
 drivers/scsi/megaraid/megaraid_sas_base.c          |  96 ++++++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  10 +-
 drivers/scsi/qedi/qedi_fw.c                        |   2 +-
 drivers/scsi/qedi/qedi_main.c                      |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  12 ++
 drivers/staging/rtl8723bs/hal/odm.h                |   5 +-
 drivers/thermal/rcar_gen3_thermal.c                |   2 +-
 drivers/tty/serial/8250/serial_cs.c                |  11 +-
 drivers/tty/serial/fsl_lpuart.c                    |   3 +
 drivers/tty/serial/uartlite.c                      |  27 +----
 drivers/usb/gadget/function/f_hid.c                |   2 +-
 drivers/usb/gadget/legacy/hid.c                    |   4 +-
 drivers/video/backlight/lm3630a_bl.c               |  12 +-
 drivers/video/fbdev/core/fbmem.c                   |  12 +-
 drivers/w1/slaves/w1_ds2438.c                      |   4 +-
 drivers/watchdog/aspeed_wdt.c                      |   2 +-
 drivers/watchdog/iTCO_wdt.c                        |  12 +-
 drivers/watchdog/imx_sc_wdt.c                      |  11 +-
 drivers/watchdog/lpc18xx_wdt.c                     |   2 +-
 drivers/watchdog/sbc60xxwdt.c                      |   2 +-
 drivers/watchdog/sc520_wdt.c                       |   2 +-
 drivers/watchdog/w83877f_wdt.c                     |   2 +-
 fs/ceph/addr.c                                     |  10 +-
 fs/f2fs/super.c                                    |   1 +
 fs/jfs/jfs_logmgr.c                                |   1 +
 fs/nfs/inode.c                                     |   4 +
 fs/nfs/nfs3proc.c                                  |   4 +-
 fs/nfs/nfs4client.c                                |  82 +++++++-------
 fs/nfs/pnfs_nfs.c                                  |  52 ++++-----
 fs/orangefs/super.c                                |   2 +-
 fs/ubifs/dir.c                                     |   7 ++
 include/linux/nfs_fs.h                             |   1 +
 include/linux/sched/signal.h                       |  19 ++--
 include/scsi/libiscsi.h                            |  11 +-
 include/scsi/scsi_transport_iscsi.h                |   2 +
 kernel/cgroup/cgroup-v1.c                          |   2 +
 kernel/rcu/rcu.h                                   |   2 +
 kernel/rcu/srcutree.c                              |   3 +
 kernel/rcu/tree.c                                  |  16 ++-
 kernel/trace/trace_events_hist.c                   |   6 +-
 lib/decompress_unlz4.c                             |   8 ++
 sound/ac97/bus.c                                   |   2 +-
 sound/firewire/Kconfig                             |   5 +-
 sound/firewire/bebob/bebob.c                       |   5 +-
 sound/firewire/oxfw/oxfw.c                         |   2 +-
 sound/isa/cmi8330.c                                |   2 +-
 sound/isa/sb/sb16_csp.c                            |   8 +-
 sound/pci/hda/hda_tegra.c                          |   3 +
 sound/ppc/powermac.c                               |   6 +-
 sound/soc/img/img-i2s-in.c                         |   2 +-
 sound/soc/intel/boards/kbl_da7219_max98357a.c      |   4 +-
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c  |   2 +-
 sound/soc/soc-core.c                               |   2 +-
 sound/usb/mixer_scarlett_gen2.c                    |  39 ++++---
 sound/usb/usx2y/usb_stream.c                       |   7 +-
 tools/perf/builtin-report.c                        |   6 +
 .../selftests/powerpc/pmu/ebb/no_handler_test.c    |   2 -
 tools/testing/selftests/timers/rtcpie.c            |  10 +-
 virt/kvm/coalesced_mmio.c                          |   2 +-
 155 files changed, 982 insertions(+), 499 deletions(-)


