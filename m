Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D789E1673EC
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbgBUIQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:16:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732083AbgBUIQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:16:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B322467B;
        Fri, 21 Feb 2020 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273010;
        bh=Orc8sqEE5gYpOb3lHbtnkPoThY5bgn6YyuBSLOF2qhI=;
        h=From:To:Cc:Subject:Date:From;
        b=tEhrHVuZve3bT3JiXyOz3Frz03rgetAJ0XJql0cRtP/0VtsNl5U2xW1X2uuzB8U1y
         JTUxM5Wlfo8QLKYhupcbZ9p37QVyVTKzdpEiRzTgGDhr2bMqiLjAoaVC8E0ZQ6UNBI
         c5+0ihwz3pzSiM9dnFKM7SYycpuiOG0OhfojWvoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/191] 4.19.106-stable review
Date:   Fri, 21 Feb 2020 08:39:33 +0100
Message-Id: <20200221072250.732482588@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.106-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.106-rc1
X-KernelTest-Deadline: 2020-02-23T07:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.106 release.
There are 191 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.106-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.106-rc1

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (v2)

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_dpipe: Add missing error path

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: prevent pfn array overflow

Steve French <stfrench@microsoft.com>
    cifs: log warning message (once) if out of disk space

Vasily Averin <vvs@virtuozzo.com>
    help_next should increase position index

Wenwen Wang <wenwen@cs.uga.edu>
    NFS: Fix memory leaks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    brd: check and limit max_part par

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    microblaze: Prevent the overflow of the start

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Fix thermal zone registration

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when building INVALL

Coly Li <colyli@suse.de>
    bcache: explicity type cast in bset_bkey_last()

Yunfeng Ye <yeyunfeng@huawei.com>
    reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Nathan Chancellor <natechancellor@gmail.com>
    lib/scatterlist.c: adjust indentation in __sg_alloc_table

wangyan <wangyan122@huawei.com>
    ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fsync_trans()

Daniel Vetter <daniel.vetter@ffwll.ch>
    radeon: insert 10ms sleep in dce5_crtc_load_lut

Vasily Averin <vvs@virtuozzo.com>
    trigger_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    ftrace: fpid_next() should increase position index

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/disp/nv50-: prevent oops when no channel method map provided

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Only provision redistributors that are enabled in ACPI

Arnd Bergmann <arnd@arndb.de>
    rbd: work around -Wuninitialized warning

Xiubo Li <xiubli@redhat.com>
    ceph: check availability of mds cluster on mount after wait timeout

Vasily Averin <vvs@virtuozzo.com>
    bpf: map_seq_next should always increase position index

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix NULL dereference in match_prepath

Colin Ian King <colin.king@canonical.com>
    iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop

Nathan Chancellor <natechancellor@gmail.com>
    hostap: Adjust indentation in prism2_hostapd_add_sta

Vincenzo Frascino <vincenzo.frascino@arm.com>
    ARM: 8951/1: Fix Kexec compilation issue.

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: make sure ESHUTDOWN to be recorded in the journal superblock

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: Reset global state between reuseport test runs

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove unnecessary WARN_ON_ONCE()

Liang Chen <liangchen.linux@gmail.com>
    bcache: cached_dev_free needs to put the sb page

Oliver O'Halloran <oohall@gmail.com>
    powerpc/sriov: Remove VF eeh_dev state when disabling SR-IOV

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/mmu: fix comptag memory leak

Peter Große <pegro@friiks.de>
    ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Colin Ian King <colin.king@canonical.com>
    driver core: platform: fix u32 greater or equal to zero comparison

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: generate traced function stack frame

Vasily Gorbik <gor@linux.ibm.com>
    s390: adjust -mpacked-stack support check for clang 10

Masami Hiramatsu <mhiramat@kernel.org>
    x86/decoder: Add TEST opcode to Group3-2

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: use -S instead of -E for precise cc-option test in Kconfig

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()

John Garry <john.garry@huawei.com>
    irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove problems

Brandon Maier <brandon.maier@rockwellcollins.com>
    remoteproc: Initialize rproc_class before use

Jessica Yu <jeyu@kernel.org>
    module: avoid setting info->name early in case we can fall back to info->mod->name

Anand Jain <anand.jain@oracle.com>
    btrfs: device stats, log when stats are zeroed

David Sterba <dsterba@suse.com>
    btrfs: safely advance counter when looking up bio csums

Johannes Thumshirn <jth@kernel.org>
    btrfs: fix possible NULL-pointer dereference in integrity checks

yu kuai <yukuai3@huawei.com>
    pwm: Remove set but not set variable 'pwm'

Dan Carpenter <dan.carpenter@oracle.com>
    ide: serverworks: potential overflow in svwks_set_pio_mode()

Dan Carpenter <dan.carpenter@oracle.com>
    cmd64x: potential buffer overflow in cmd64x_program_timings()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunctional

Ard Biesheuvel <ardb@kernel.org>
    x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd

Chao Yu <yuchao0@huawei.com>
    f2fs: fix memleak of kobject

Hanjun Guo <guohanjun@huawei.com>
    ACPI/IORT: Fix 'Number of IDs' handling in iort_id_map()

Thomas Gleixner <tglx@linutronix.de>
    watchdog/softlockup: Enforce that timestamp is valid on boot

Jun Lei <Jun.Lei@amd.com>
    drm/amd/display: fixup DML dependencies

Sami Tolvanen <samitolvanen@google.com>
    arm64: fix alternatives with LLVM's integrated assembler

Nick Black <nlb@google.com>
    scsi: iscsi: Don't destroy session if there are outstanding connections

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: free sysfs kobject

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: set I_LINKABLE early to avoid wrong access by vfs

Will Deacon <will@kernel.org>
    iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

Tony Lindgren <tony@atomide.com>
    usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fault/gv100-: fix memory leak on module unload

YueHaibing <yuehaibing@huawei.com>
    drm/nouveau/drm/ttm: Remove set but not used variable 'mem'

YueHaibing <yuehaibing@huawei.com>
    drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read from fw

Dan Carpenter <dan.carpenter@oracle.com>
    drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()

Arnd Bergmann <arnd@arndb.de>
    vme: bridges: reduce stack usage

Li RongQing <lirongqing@baidu.com>
    bpf: Return -EBADRQC for invalid map type in __bpf_tx_xdp_map

Geert Uytterhoeven <geert+renesas@glider.be>
    driver core: Print device when resources present in really_probe()

Simon Schwartz <kern.simon@theschwartz.xyz>
    driver core: platform: Prevent resouce overflow from causing infinite loops

Arnd Bergmann <arnd@arndb.de>
    visorbus: fix uninitialized variable access

Nathan Chancellor <natechancellor@gmail.com>
    tty: synclink_gt: Adjust indentation in several functions

Nathan Chancellor <natechancellor@gmail.com>
    tty: synclinkmp: Adjust indentation in several functions

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/uverbs: Remove needs_kfree_rcu from uverbs_obj_type_class

Chen Zhou <chenzhou10@huawei.com>
    ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=m

Arnd Bergmann <arnd@arndb.de>
    wan: ixp4xx_hss: fix compile-testing on 64-bit

Changbin Du <changbin.du@gmail.com>
    x86/nmi: Remove irq_work from the long duration NMI handler

Philipp Zabel <p.zabel@pengutronix.de>
    Input: edt-ft5x06 - work around first register access error

Paul E. McKenney <paulmck@kernel.org>
    rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Don't panic or BUG() on non-critical error conditions

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: fuse: Correct straps' address for older Tegra124 device trees

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Add software counter for ctxt0 seq drop

Arnd Bergmann <arnd@arndb.de>
    staging: rtl8188: avoid excessive stack usage

Jan Kara <jack@suse.cz>
    udf: Fix free space reporting for metadata and virtual partitions

Shuah Khan <skhan@linuxfoundation.org>
    usbip: Fix unsafe unaligned pointer usage

Benjamin Gaignard <benjamin.gaignard@st.com>
    ARM: dts: stm32: Add power-supply for DSI panel on stm32f469-disco

Dingchen Zhang <dingchen.zhang@amd.com>
    drm: remove the newline for CRC source name.

Arnd Bergmann <arnd@arndb.de>
    mlx5: work around high stack usage with gcc

Jason Ekstrand <jason@jlekstrand.net>
    ACPI: button: Add DMI quirk for Razer Blade Stealth 13 late 2019 lid switch

Shile Zhang <shile.zhang@linux.alibaba.com>
    x86/unwind/orc: Fix !CONFIG_MODULES build warning

Andrey Zhizhikin <andrey.z@gmail.com>
    tools lib api fs: Fix gcc9 stringop-truncation compilation error

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix compile warning wrt const

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    clk: uniphier: Add SCSSI clock gate for each channel

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix unused variable warnings

Icenowy Zheng <icenowy@aosc.io>
    clk: sunxi-ng: add mux and pll notifiers for A64 CPU clock

Jiewei Ke <kejiewei.cn@gmail.com>
    RDMA/rxe: Fix error type of mmap_offset

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    reset: uniphier: Add SCSSI reset control for each channel

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC dependency

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    x86/vdso: Provide missing include file

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    crypto: chtls - Fixed memory leak

Sascha Hauer <s.hauer@pengutronix.de>
    dmaengine: imx-sdma: Fix memory leak

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: Store module owner in dma_device struct

Jaihind Yadav <jaihindyadav@codeaurora.org>
    selinux: ensure we cleanup the internal AVC counters on error in avc_update()

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7779: Add device node for ARM global timer

Bibby Hsieh <bibby.hsieh@mediatek.com>
    drm/mediatek: handle events when enabling/disabling crtc

Nathan Chancellor <natechancellor@gmail.com>
    scsi: aic7xxx: Adjust indentation in ahc_find_syncrate

Can Guo <cang@codeaurora.org>
    scsi: ufs: Complete pending requests in host reset and restore path

Erik Kaneda <erik.kaneda@intel.com>
    ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1

Aditya Pakki <pakki001@umn.edu>
    orinoco: avoid assertion in case of NULL pointer

Phong Tran <tranmanphong@gmail.com>
    rtlwifi: rtl_pci: Fix -Wcast-function-type

Phong Tran <tranmanphong@gmail.com>
    iwlegacy: Fix -Wcast-function-type

Phong Tran <tranmanphong@gmail.com>
    ipw2x00: Fix -Wcast-function-type

Phong Tran <tranmanphong@gmail.com>
    b43legacy: Fix -Wcast-function-type

Nathan Chancellor <natechancellor@gmail.com>
    ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status

Xin Long <lucien.xin@gmail.com>
    netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy

Arnd Bergmann <arnd@arndb.de>
    isdn: don't mark kcapi_proc_exit as __exit

Aditya Pakki <pakki001@umn.edu>
    fore200e: Fix incorrect checks of NULL pointer dereference

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: check that Realtek PHY driver module is loaded

Jan Kara <jack@suse.cz>
    reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling

Nathan Chancellor <natechancellor@gmail.com>
    media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2_device macros

Daniel Drake <drake@endlessm.com>
    PCI: Increase D3 delay for AMD Ryzen5/7 XHCI controllers

Daniel Drake <drake@endlessm.com>
    PCI: Add generic quirk for increasing D3hot delay

Forest Crossman <cyrozap@gmail.com>
    media: cx23885: Add support for AVerMedia CE310B

Wei Liu <wei.liu@kernel.org>
    PCI: iproc: Apply quirk_paxc_bridge() for module as well as built-in

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6: rdu2: Limit USBH1 to Full Speed

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6: rdu2: Disable WP for USDHC2 and USDHC3

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Manu Gautam <mgautam@codeaurora.org>
    arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core

Paul Moore <paul@paul-moore.com>
    selinux: ensure we cleanup the internal AVC counters on error in avc_insert()

Andre Przywara <andre.przywara@arm.com>
    arm: dts: allwinner: H3: Add PMU node

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H6: Add PMU mode

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: fall back to ref-walk if audit is required

Mao Wenan <maowenan@huawei.com>
    NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net/wan/fsl_ucc_hdlc: reject muram offsets above 64K

Miquel Raynal <miquel.raynal@bootlin.com>
    regulator: rk808: Lower log level on optional GPIOs being not available

Nathan Chancellor <natechancellor@gmail.com>
    drm/amdgpu: Ensure ret is always initialized when using SOC15_WAIT_ON_RREG

yu kuai <yukuai3@huawei.com>
    drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get_connector_info_from_object_table

Douglas Anderson <dianders@chromium.org>
    clk: qcom: rcg2: Don't crash if our parent can't be found; return an error

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix broken dependency in randconfig-generated .config

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups

Sun Ke <sunke32@huawei.com>
    nbd: add a flush_workqueue in nbd_start_device

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Retrain dongles when SINK_COUNT becomes non-zero

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Correct the DMA direction for management tx buffers

zhangyi (F) <yi.zhang@huawei.com>
    ext4, jbd2: ensure panic when aborting with zero errno

Vincenzo Frascino <vincenzo.frascino@arm.com>
    ARM: 8952/1: Disable kmemleak on XIP kernels

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix very unlikely race of registering two stat tracers

Luis Henriques <luis.henriques@canonical.com>
    tracing: Fix tracing_stat return values in error handling paths

Oliver O'Halloran <oohall@gmail.com>
    powerpc/iov: Move VF pdev fixup into pcibios_fixup_iov()

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix possible deadlock in recover_store()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: omap-dmtimer: Simplify error handling

Arvind Sankar <nivedita@alum.mit.edu>
    x86/sysfb: Fix check for bad VRAM size

Kai Li <li.kai4@h3c.com>
    jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal

Siddhesh Poyarekar <siddhesh@gotplt.org>
    kselftest: Minimise dependency of get_size on C library interfaces

Colin Ian King <colin.king@canonical.com>
    clocksource/drivers/bcm2835_timer: Fix memory leak of timer

John Keeping <john@metanate.com>
    usb: dwc2: Fix IN FIFO allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_probe()

Jia-Ju Bai <baijiaju1990@gmail.com>
    uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()

David S. Miller <davem@davemloft.net>
    sparc: Add .exit.data section.

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_init()

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Map the entire EFI vendor string before copying it

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins

Jia-Ju Bai <baijiaju1990@gmail.com>
    media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdisp_device_run()

Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
    char/random: silence a lockdep splat with printk()

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix off-by-one in PASID allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpio_irq_map/unmap()

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid PE number

Eugen Hristev <eugen.hristev@microchip.com>
    media: i2c: mt9v032: fix enum mbus codes and frame sizes

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pxa168fb: Fix the function used to release some memory in an error handling path

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs

Vladimir Oltean <olteanv@gmail.com>
    gianfar: Fix TX timestamping with a stacked DSA driver

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: ctl: allow TLV read operation for callback type of element in locked case

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix ext4_dax_read/write inode locking sequence for IOCB_NOWAIT

Zahari Petkov <zahari@balena.io>
    leds: pca963x: Fix open-drain initialization

Dan Carpenter <dan.carpenter@oracle.com>
    brcmfmac: Fix use after free in brcmf_sdio_readframes()

Peter Zijlstra <peterz@infradead.org>
    cpu/hotplug, stop_machine: Fix stop_machine vs hotplug order

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    soc: fsl: qe: change return type of cpm_muram_alloc() to s32

J. Bruce Fields <bfields@redhat.com>
    nfsd4: avoid NULL deference on strange COPY compounds

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/gma500: Fixup fbdev stolen size usage evaluation

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Use correct root level for nested EPT shadow page tables

Sasha Levin <sashal@kernel.org>
    Revert "KVM: VMX: Add non-canonical check on writes to RTIT address MSRs"

Sasha Levin <sashal@kernel.org>
    Revert "KVM: nVMX: Use correct root level for nested EPT shadow page tables"

Davide Caratti <dcaratti@redhat.com>
    net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Davide Caratti <dcaratti@redhat.com>
    net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS

Per Forlin <per.forlin@axis.com>
    net: dsa: tag_qca: Make sure there is headroom for tag

Eric Dumazet <edumazet@google.com>
    net/smc: fix leak of kernel memory to user space

Firo Yang <firo.yang@suse.com>
    enic: prevent waking up stopped tx queues over watchdog reset

Toke Høiland-Jørgensen <toke@redhat.com>
    core: Don't skip generic XDP program execution for cloned SKBs


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm/Kconfig                                   |    4 +-
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi            |    7 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |    8 +
 arch/arm/boot/dts/stm32f469-disco.dts              |    8 +
 arch/arm/boot/dts/sun8i-h3.dtsi                    |   15 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |   10 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |    4 +
 arch/arm64/include/asm/alternative.h               |   32 +-
 arch/microblaze/kernel/cpu/cache.c                 |    3 +-
 arch/mips/loongson64/loongson-3/platform.c         |    3 +
 arch/powerpc/kernel/eeh_driver.c                   |    6 -
 arch/powerpc/kernel/pci_dn.c                       |   15 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   48 +-
 arch/powerpc/platforms/powernv/pci.c               |   18 -
 arch/s390/Makefile                                 |    2 +-
 arch/s390/kernel/mcount.S                          |   15 +-
 arch/s390/kvm/interrupt.c                          |    6 +-
 arch/s390/pci/pci_sysfs.c                          |   63 +-
 arch/sh/include/cpu-sh2a/cpu/sh7269.h              |   11 +-
 arch/sparc/kernel/vmlinux.lds.S                    |    6 +-
 arch/x86/entry/vdso/vdso32-setup.c                 |    1 +
 arch/x86/include/asm/nmi.h                         |    1 -
 arch/x86/kernel/nmi.c                              |   20 +-
 arch/x86/kernel/sysfb_simplefb.c                   |    2 +-
 arch/x86/kernel/unwind_orc.c                       |    3 +-
 arch/x86/kvm/vmx.c                                 |    3 +
 arch/x86/kvm/vmx/vmx.c                             | 8036 --------------------
 arch/x86/lib/x86-opcode-map.txt                    |    2 +-
 arch/x86/mm/pageattr.c                             |    8 +-
 arch/x86/platform/efi/efi.c                        |   41 +-
 arch/x86/platform/efi/efi_64.c                     |    9 +-
 drivers/acpi/acpica/dsfield.c                      |    2 +-
 drivers/acpi/acpica/dswload.c                      |   21 +
 drivers/acpi/arm64/iort.c                          |   57 +-
 drivers/acpi/button.c                              |   11 +
 drivers/atm/fore200e.c                             |   25 +-
 drivers/base/dd.c                                  |    5 +-
 drivers/base/platform.c                            |   12 +-
 drivers/block/brd.c                                |   22 +-
 drivers/block/nbd.c                                |   10 +
 drivers/block/rbd.c                                |    2 +-
 drivers/char/random.c                              |    5 +-
 drivers/clk/qcom/clk-rcg2.c                        |    3 +
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |   28 +-
 drivers/clk/uniphier/clk-uniphier-peri.c           |   13 +-
 drivers/clocksource/bcm2835_timer.c                |    5 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   27 +-
 drivers/crypto/chelsio/chtls/chtls_cm.h            |   21 +
 drivers/crypto/chelsio/chtls/chtls_hw.c            |    3 +
 drivers/devfreq/Kconfig                            |    3 +-
 drivers/devfreq/event/Kconfig                      |    2 +-
 drivers/dma/dmaengine.c                            |    4 +-
 drivers/dma/imx-sdma.c                             |   19 +-
 drivers/gpio/gpio-grgpio.c                         |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   19 +-
 drivers/gpu/drm/amd/amdgpu/soc15_common.h          |    1 +
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c   |   34 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |    3 +-
 .../gpu/drm/amd/display/dc/dml/dml_common_defs.c   |    2 +-
 .../gpu/drm/amd/display/dc/dml/dml_inline_defs.h   |    2 +-
 .../amd/display/dc/{calcs => inc}/dcn_calc_math.h  |    0
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c  |   23 +-
 drivers/gpu/drm/drm_debugfs_crc.c                  |    4 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    8 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |    8 +
 drivers/gpu/drm/nouveau/nouveau_fence.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |    4 -
 drivers/gpu/drm/nouveau/nvkm/core/memory.c         |    2 +-
 .../gpu/drm/nouveau/nvkm/engine/disp/channv50.c    |    2 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c     |   21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c   |    1 +
 .../gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c    |    5 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c         |    4 +-
 drivers/ide/cmd64x.c                               |    3 +
 drivers/ide/serverworks.c                          |    6 +
 drivers/infiniband/core/rdma_core.c                |   23 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   10 +
 drivers/infiniband/hw/hfi1/chip.h                  |    1 +
 drivers/infiniband/hw/hfi1/driver.c                |    1 +
 drivers/infiniband/hw/hfi1/hfi.h                   |    2 +
 drivers/infiniband/sw/rxe/rxe_verbs.h              |    2 +-
 drivers/input/touchscreen/edt-ft5x06.c             |    7 +
 drivers/iommu/arm-smmu-v3.c                        |    3 +-
 drivers/iommu/dmar.c                               |    1 -
 drivers/iommu/intel-svm.c                          |    2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |    2 +-
 drivers/irqchip/irq-gic-v3.c                       |    9 +-
 drivers/irqchip/irq-mbigen.c                       |    1 +
 drivers/isdn/capi/kcapi_proc.c                     |    2 +-
 drivers/leds/leds-pca963x.c                        |    8 +-
 drivers/md/bcache/bset.h                           |    3 +-
 drivers/md/bcache/super.c                          |    3 +
 drivers/media/i2c/mt9v032.c                        |   10 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   24 +
 drivers/media/pci/cx23885/cx23885-video.c          |    3 +-
 drivers/media/pci/cx23885/cx23885.h                |    1 +
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |    6 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |    2 +-
 drivers/net/ethernet/freescale/gianfar.c           |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    3 +
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |    3 +-
 drivers/net/ethernet/realtek/r8169.c               |    9 +
 drivers/net/wan/fsl_ucc_hdlc.c                     |    5 +
 drivers/net/wan/ixp4xx_hss.c                       |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    1 +
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    7 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    5 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    5 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    5 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |    4 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |    2 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |    3 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   10 +-
 drivers/nfc/port100.c                              |    2 +-
 drivers/pci/controller/pcie-iproc.c                |   24 +
 drivers/pci/quirks.c                               |   61 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |    8 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |    9 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |   39 +-
 drivers/pwm/pwm-omap-dmtimer.c                     |   35 +-
 drivers/pwm/pwm-pca9685.c                          |    4 -
 drivers/regulator/rk808-regulator.c                |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    2 +-
 drivers/reset/reset-uniphier.c                     |   13 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/iscsi_tcp.c                           |    4 +
 drivers/scsi/scsi_transport_iscsi.c                |   26 +-
 drivers/scsi/ufs/ufshcd.c                          |   24 +-
 drivers/scsi/ufs/ufshcd.h                          |    2 +
 drivers/soc/fsl/qe/qe_common.c                     |   29 +-
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |    9 +-
 drivers/tty/synclink_gt.c                          |   18 +-
 drivers/tty/synclinkmp.c                           |   24 +-
 drivers/uio/uio_dmem_genirq.c                      |    6 +-
 drivers/usb/dwc2/gadget.c                          |    3 +-
 drivers/usb/gadget/udc/gr_udc.c                    |   16 +-
 drivers/usb/musb/omap2430.c                        |    2 -
 drivers/video/fbdev/pxa168fb.c                     |    6 +-
 drivers/virtio/virtio_balloon.c                    |    2 +
 drivers/visorbus/visorchipset.c                    |   11 +-
 drivers/vme/bridges/vme_fake.c                     |   30 +-
 fs/btrfs/check-integrity.c                         |    3 +-
 fs/btrfs/file-item.c                               |    3 +-
 fs/btrfs/volumes.c                                 |    2 +
 fs/ceph/mds_client.c                               |    3 +-
 fs/ceph/super.c                                    |    5 +
 fs/cifs/connect.c                                  |    6 +-
 fs/cifs/smb2pdu.c                                  |    3 +
 fs/ext4/file.c                                     |   10 +-
 fs/f2fs/namei.c                                    |   27 +-
 fs/f2fs/sysfs.c                                    |   12 +-
 fs/jbd2/checkpoint.c                               |    2 +-
 fs/jbd2/commit.c                                   |    4 +-
 fs/jbd2/journal.c                                  |   24 +-
 fs/nfs/nfs42proc.c                                 |    4 +-
 fs/nfsd/nfs4proc.c                                 |    3 +-
 fs/ocfs2/journal.h                                 |    8 +-
 fs/orangefs/orangefs-debugfs.c                     |    1 +
 fs/reiserfs/stree.c                                |    3 +-
 fs/reiserfs/super.c                                |    2 +-
 fs/udf/super.c                                     |   22 +-
 include/linux/dmaengine.h                          |    2 +
 include/linux/list_nulls.h                         |    8 +-
 include/linux/rculist_nulls.h                      |    8 +-
 include/media/v4l2-device.h                        |   12 +-
 include/rdma/uverbs_types.h                        |    1 -
 include/soc/fsl/qe/qe.h                            |   16 +-
 kernel/bpf/inode.c                                 |    3 +-
 kernel/cpu.c                                       |   13 +-
 kernel/module.c                                    |    9 +-
 kernel/padata.c                                    |    4 +-
 kernel/trace/ftrace.c                              |    5 +-
 kernel/trace/trace_events_trigger.c                |    5 +-
 kernel/trace/trace_stat.c                          |   31 +-
 kernel/watchdog.c                                  |   10 +-
 lib/scatterlist.c                                  |    2 +-
 net/core/dev.c                                     |    4 +-
 net/core/filter.c                                  |    2 +-
 net/dsa/tag_qca.c                                  |    2 +-
 net/netfilter/nft_tunnel.c                         |    3 +-
 net/sched/cls_flower.c                             |    1 +
 net/sched/cls_matchall.c                           |    1 +
 net/smc/smc_diag.c                                 |    5 +-
 scripts/Kconfig.include                            |    2 +-
 scripts/kconfig/confdata.c                         |    2 +-
 security/selinux/avc.c                             |   77 +-
 security/selinux/hooks.c                           |   11 +-
 security/selinux/include/avc.h                     |    8 +-
 sound/core/control.c                               |    5 +-
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_hdmi.c                         |    7 +-
 sound/sh/aica.c                                    |    4 +-
 sound/sh/sh_dac_audio.c                            |    3 -
 sound/soc/atmel/Kconfig                            |    2 +
 sound/usb/usx2y/usX2Yhwdep.c                       |    2 +-
 tools/lib/api/fs/fs.c                              |    4 +-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt      |    2 +-
 .../testing/selftests/bpf/test_select_reuseport.c  |   16 +-
 tools/testing/selftests/size/get_size.c            |   24 +-
 tools/usb/usbip/src/usbip_network.c                |   40 +-
 tools/usb/usbip/src/usbip_network.h                |   12 +-
 207 files changed, 1280 insertions(+), 8742 deletions(-)


