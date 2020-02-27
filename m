Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C164D172010
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbgB0Nxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgB0Nxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:53:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C67521D7E;
        Thu, 27 Feb 2020 13:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811618;
        bh=0KeJqi+qk4Zomh4B13yns7i/18qxxP2MKiBuSuJdAxU=;
        h=From:To:Cc:Subject:Date:From;
        b=nQx9P0PY5Cpl+FAXHuKQX5XnfZPHPlf7hrvqnNeaELRR2aUj7cLdZ+xm3Ugp8XdKt
         eDEH7kj4UyvqHUu7WJuWCGJ6Qv6lbWOccjNaHURLywQxSTslKpZioKX8euFHcpx+sD
         uGwYbyCH3INSKaW0j6d3QGh0+nIcJMfAQz8BfZ4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/237] 4.14.172-stable review
Date:   Thu, 27 Feb 2020 14:33:34 +0100
Message-Id: <20200227132255.285644406@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.172-rc1
X-KernelTest-Deadline: 2020-02-29T13:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.172 release.
There are 237 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.172-rc1

Nathan Chancellor <natechancellor@gmail.com>
    s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_key_init_range

Thomas Gleixner <tglx@linutronix.de>
    xen: Enable interrupts when calling _cond_resched()

Prabhakar Kushwaha <pkushwaha@marvell.com>
    ata: ahci: Add shutdown to freeze hardware resources of ahci

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: xt_hashlimit: limit the max size of hashtable

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix concurrent access to queue current tick/time

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Avoid concurrent access to queue flags

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Avoid bit fields for state flags

Thomas Gleixner <tglx@linutronix.de>
    genirq/proc: Reject invalid affinity masks (again)

Joerg Roedel <jroedel@suse.de>
    iommu/vt-d: Fix compile warning from intel-svm.h

Aditya Pakki <pakki001@umn.edu>
    ecryptfs: replace BUG_ON with error handling code

Dan Carpenter <dan.carpenter@oracle.com>
    staging: greybus: use after free in gb_audio_manager_remove_all()

Colin Ian King <colin.king@canonical.com>
    staging: rtl8723bs: fix copy of overlapping memory

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "target: iscsi: Wait for all commands to finish before freeing a session"

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordered extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not check delayed items are empty for single transaction cleanup

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix bytes_may_use underflow in prealloc error condtition

Miaohe Lin <linmiaohe@huawei.com>
    KVM: apic: avoid calculating pending eoi from an uninitialized val

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1

Oliver Upton <oupton@google.com>
    KVM: nVMX: Check IO instruction VM-exit conditions

Oliver Upton <oupton@google.com>
    KVM: nVMX: Refactor IO bitmap checks into helper function

Eric Biggers <ebiggers@google.com>
    ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Eric Biggers <ebiggers@google.com>
    ext4: rename s_journal_flag_rwsem to s_writepages_rwsem

Jan Kara <jack@suse.cz>
    ext4: fix mount failure with quota configured as module

Shijie Luo <luoshijie1@huawei.com>
    ext4: add cond_resched() to __ext4_find_entry()

Qian Cai <cai@lca.pw>
    ext4: fix a data race in EXT4_I(inode)->i_disksize

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: Don't emulate instructions in guest mode

Alexander Potapenko <glider@google.com>
    lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Miles Chen <miles.chen@mediatek.com>
    lib/stackdepot: Fix outdated comments

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250: Check UPF_IRQ_SHARED in advance

Gustavo Luiz Duarte <gustavold@linux.ibm.com>
    powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal delivery

Gustavo Romero <gromero@linux.vnet.ibm.com>
    powerpc/tm: Fix endianness flip on trap

Michael Neuling <mikey@neuling.org>
    powerpc/tm: P9 disable transactionally suspended sigcontexts

Eric Dumazet <edumazet@google.com>
    vt: vt_ioctl: fix race in VT_RESIZEX

Al Viro <viro@zeniv.linux.org.uk>
    VT_RESIZEX: get rid of field-by-field copyin

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms

Miaohe Lin <linmiaohe@huawei.com>
    KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt EOI

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc15: fix xclk for raven

Gavin Shan <gshan@redhat.com>
    mm/vmscan.c: don't round up scan size for online memory cgroup

Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
    Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"

Jani Nikula <jani.nikula@intel.com>
    MAINTAINERS: Update drm/i915 bug filing URL

Johan Hovold <johan@kernel.org>
    serdev: ttyport: restore client ops on deregistration

Fugang Duan <fugang.duan@nxp.com>
    tty: serial: imx: setup the correct sg entry for tx dma

Nicolas Ferre <nicolas.ferre@microchip.com>
    tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

Thomas Gleixner <tglx@linutronix.de>
    x86/mce/amd: Fix kobject lifetime

Borislav Petkov <bp@suse.de>
    x86/mce/amd: Publish the bank pointer only after setup has succeeded

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8723bs: Fix potential overuse of kernel memory

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8723bs: Fix potential security hole

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Fix potential overuse of kernel memory

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Fix potential security hole

Hardik Gajjar <hgajjar@de.adit-jv.com>
    USB: hub: Fix the broken detection of USB3 device in SMSC hub

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Don't record a connect-change event during reset-resume

Richard Dodd <richard.o.dodd@gmail.com>
    USB: Fix novation SourceControl XL after suspend

EJ Hsu <ejh@nvidia.com>
    usb: uas: fix a plug & unplug racing

Peter Chen <peter.chen@nxp.com>
    usb: host: xhci: update event ring dequeue pointer on purpose

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix runtime pm enabling for quirky Intel hosts

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Force Maximum Packet size for Full-speed bulk devices to valid range.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Suren Baghdasaryan <surenb@google.com>
    staging: android: ashmem: Disallow ashmem memory from being remapped

Jiri Slaby <jslaby@suse.cz>
    vt: selection, handle pending signals in paste_selection

Linus Torvalds <torvalds@linux-foundation.org>
    floppy: check FDC index for errors before assigning it

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: add support for the 100 device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: add support for the 28 and 28L devices

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: add support for 2 OEMed devices

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Prevent crash if non-active NVMem file is read

Eric Dumazet <edumazet@google.com>
    net/smc: fix leak of kernel memory to user space

Davide Caratti <dcaratti@redhat.com>
    net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Davide Caratti <dcaratti@redhat.com>
    net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS

Per Forlin <per.forlin@axis.com>
    net: dsa: tag_qca: Make sure there is headroom for tag

Firo Yang <firo.yang@suse.com>
    enic: prevent waking up stopped tx queues over watchdog reset

Jaihind Yadav <jaihindyadav@codeaurora.org>
    selinux: ensure we cleanup the internal AVC counters on error in avc_update()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_dpipe: Add missing error path

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: prevent pfn array overflow

Vasily Averin <vvs@virtuozzo.com>
    help_next should increase position index

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

Xiubo Li <xiubli@redhat.com>
    ceph: check availability of mds cluster on mount after wait timeout

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

Oliver O'Halloran <oohall@gmail.com>
    powerpc/sriov: Remove VF eeh_dev state when disabling SR-IOV

Peter Große <pegro@friiks.de>
    ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Colin Ian King <colin.king@canonical.com>
    driver core: platform: fix u32 greater or equal to zero comparison

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: generate traced function stack frame

Masami Hiramatsu <mhiramat@kernel.org>
    x86/decoder: Add TEST opcode to Group3-2

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()

John Garry <john.garry@huawei.com>
    irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove problems

Brandon Maier <brandon.maier@rockwellcollins.com>
    remoteproc: Initialize rproc_class before use

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

Thomas Gleixner <tglx@linutronix.de>
    watchdog/softlockup: Enforce that timestamp is valid on boot

Sami Tolvanen <samitolvanen@google.com>
    arm64: fix alternatives with LLVM's integrated assembler

Nick Black <nlb@google.com>
    scsi: iscsi: Don't destroy session if there are outstanding connections

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: free sysfs kobject

Will Deacon <will@kernel.org>
    iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

Tony Lindgren <tony@atomide.com>
    usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

YueHaibing <yuehaibing@huawei.com>
    drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read from fw

Dan Carpenter <dan.carpenter@oracle.com>
    drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()

Arnd Bergmann <arnd@arndb.de>
    vme: bridges: reduce stack usage

Geert Uytterhoeven <geert+renesas@glider.be>
    driver core: Print device when resources present in really_probe()

Simon Schwartz <kern.simon@theschwartz.xyz>
    driver core: platform: Prevent resouce overflow from causing infinite loops

Nathan Chancellor <natechancellor@gmail.com>
    tty: synclink_gt: Adjust indentation in several functions

Nathan Chancellor <natechancellor@gmail.com>
    tty: synclinkmp: Adjust indentation in several functions

Chen Zhou <chenzhou10@huawei.com>
    ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=m

Arnd Bergmann <arnd@arndb.de>
    wan: ixp4xx_hss: fix compile-testing on 64-bit

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

Jan Kara <jack@suse.cz>
    udf: Fix free space reporting for metadata and virtual partitions

Shuah Khan <skhan@linuxfoundation.org>
    usbip: Fix unsafe unaligned pointer usage

Dingchen Zhang <dingchen.zhang@amd.com>
    drm: remove the newline for CRC source name.

Andrey Zhizhikin <andrey.z@gmail.com>
    tools lib api fs: Fix gcc9 stringop-truncation compilation error

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix compile warning wrt const

Takashi Iwai <tiwai@suse.de>
    ALSA: sh: Fix unused variable warnings

Icenowy Zheng <icenowy@aosc.io>
    clk: sunxi-ng: add mux and pll notifiers for A64 CPU clock

Jiewei Ke <kejiewei.cn@gmail.com>
    RDMA/rxe: Fix error type of mmap_offset

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC dependency

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    x86/vdso: Provide missing include file

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: Store module owner in dma_device struct

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

Aditya Pakki <pakki001@umn.edu>
    fore200e: Fix incorrect checks of NULL pointer dereference

Jan Kara <jack@suse.cz>
    reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling

Nathan Chancellor <natechancellor@gmail.com>
    media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2_device macros

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6: rdu2: Disable WP for USDHC2 and USDHC3

Manu Gautam <mgautam@codeaurora.org>
    arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core

Mao Wenan <maowenan@huawei.com>
    NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Navid Emamdoost <navid.emamdoost@gmail.com>
    PCI/IOV: Fix memory leak in pci_iov_add_virtfn()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net/wan/fsl_ucc_hdlc: reject muram offsets above 64K

Miquel Raynal <miquel.raynal@bootlin.com>
    regulator: rk808: Lower log level on optional GPIOs being not available

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

zhangyi (F) <yi.zhang@huawei.com>
    ext4, jbd2: ensure panic when aborting with zero errno

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix very unlikely race of registering two stat tracers

Luis Henriques <luis.henriques@canonical.com>
    tracing: Fix tracing_stat return values in error handling paths

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

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    drm/gma500: Fixup fbdev stolen size usage evaluation

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Use correct root level for nested EPT shadow page tables - again

Sasha Levin <sashal@kernel.org>
    Revert "KVM: VMX: Add non-canonical check on writes to RTIT address MSRs"

Sasha Levin <sashal@kernel.org>
    Revert "KVM: nVMX: Use correct root level for nested EPT shadow page tables"

Allen Pais <allen.pais@oracle.com>
    scsi: qla2xxx: fix a potential NULL pointer dereference

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()

Mike Jones <michael-a1.jones@analog.com>
    hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix inaccurate period in context switch for auto-reload

Nathan Chancellor <natechancellor@gmail.com>
    s390/time: Fix clk type in get_tod_clock

Leon Romanovsky <leonro@mellanox.com>
    RDMA/core: Fix protection fault in get_pkey_idx_qp_list

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Close window for pq and request coliding

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: Only handle irqs that are actually enabled

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: ensure that RX irqs are off if RX is off

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove broken queue flushing

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Use correct root level for nested EPT shadow page tables

Will Deacon <will@kernel.org>
    arm64: ssbs: Fix context-switch when SSBS is present on all CPUs

David Sterba <dsterba@suse.com>
    btrfs: log message when rw remount is attempted with unclean tree-log

David Sterba <dsterba@suse.com>
    btrfs: print message when tree-log replay starts

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between using extent maps and merging them

Theodore Ts'o <tytso@mit.edu>
    ext4: improve explanation of a mount failure caused by a misconfigured kernel

Jan Kara <jack@suse.cz>
    ext4: fix checksum errors with indexed dirs

Theodore Ts'o <tytso@mit.edu>
    ext4: fix support for inode sizes > 1024 bytes

Andreas Dilger <adilger@dilger.ca>
    ext4: don't assume that mmp_nodename/bdevname have NUL

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 8723/2: always assume the "unified" syntax for assembly code

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: nofpsimd: Handle TIF_FOREIGN_FPSTATE flag cleanly

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly

Arvind Sankar <nivedita@alum.mit.edu>
    ALSA: usb-audio: Apply sample rate quirk for Audioengine D1

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: synaptics - remove the LEN0049 dmi id from topbuttonpad list

Gaurav Agrawal <agrawalgaurav@gnome.org>
    Input: synaptics - enable SMBus on ThinkPad L470

Lyude Paul <lyude@redhat.com>
    Input: synaptics - switch T470s to RMI4 by default

Wenwen Wang <wenwen@cs.uga.edu>
    ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()

Wenwen Wang <wenwen@cs.uga.edu>
    ecryptfs: fix a memory leak bug in parse_tag_1_packet()

Samuel Holland <samuel@sholland.org>
    ASoC: sun8i-codec: Fix setting DAI data format

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs

Robin Murphy <robin.murphy@arm.com>
    iommu/qcom: Fix bogus detach logic

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: emulate RDPID


-------------

Diffstat:

 MAINTAINERS                                        |    2 +-
 Makefile                                           |    4 +-
 arch/arm/Kconfig                                   |    9 +-
 arch/arm/Makefile                                  |    6 +-
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi            |    6 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |    8 +
 arch/arm/include/asm/unified.h                     |   77 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |    4 +
 arch/arm64/include/asm/alternative.h               |   32 +-
 arch/arm64/kernel/cpufeature.c                     |   52 +-
 arch/arm64/kernel/fpsimd.c                         |   15 +-
 arch/arm64/kernel/process.c                        |    7 +
 arch/arm64/kernel/ptrace.c                         |   21 +
 arch/microblaze/kernel/cpu/cache.c                 |    3 +-
 arch/mips/loongson64/loongson-3/platform.c         |    3 +
 arch/powerpc/kernel/eeh_driver.c                   |    6 -
 arch/powerpc/kernel/pci_dn.c                       |   15 +-
 arch/powerpc/kernel/process.c                      |    2 +
 arch/powerpc/kernel/signal.c                       |   17 +-
 arch/powerpc/kernel/signal_32.c                    |   30 +-
 arch/powerpc/kernel/signal_64.c                    |   29 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   19 +-
 arch/powerpc/platforms/powernv/pci.c               |    4 -
 arch/s390/include/asm/page.h                       |    2 +-
 arch/s390/include/asm/timex.h                      |    2 +-
 arch/s390/kernel/mcount.S                          |   15 +-
 arch/s390/kvm/interrupt.c                          |    6 +-
 arch/sh/include/cpu-sh2a/cpu/sh7269.h              |   11 +-
 arch/sparc/kernel/vmlinux.lds.S                    |    6 +-
 arch/x86/entry/vdso/vdso32-setup.c                 |    1 +
 arch/x86/events/amd/core.c                         |    1 +
 arch/x86/events/intel/ds.c                         |    2 +
 arch/x86/include/asm/kvm_host.h                    |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c               |   50 +-
 arch/x86/kernel/sysfb_simplefb.c                   |    2 +-
 arch/x86/kvm/cpuid.c                               |    7 +-
 arch/x86/kvm/emulate.c                             |   22 +-
 arch/x86/kvm/irq_comm.c                            |    2 +-
 arch/x86/kvm/lapic.c                               |    9 +-
 arch/x86/kvm/svm.c                                 |    7 +-
 arch/x86/kvm/vmx.c                                 |  118 +-
 arch/x86/kvm/vmx/vmx.c                             | 8033 --------------------
 arch/x86/lib/x86-opcode-map.txt                    |    2 +-
 arch/x86/mm/pageattr.c                             |    8 +-
 arch/x86/platform/efi/efi.c                        |   41 +-
 arch/x86/platform/efi/efi_64.c                     |    9 +-
 drivers/acpi/acpica/dsfield.c                      |    2 +-
 drivers/acpi/acpica/dswload.c                      |   21 +
 drivers/ata/ahci.c                                 |    7 +
 drivers/ata/libata-core.c                          |   21 +
 drivers/atm/fore200e.c                             |   25 +-
 drivers/base/dd.c                                  |    5 +-
 drivers/base/platform.c                            |   12 +-
 drivers/block/brd.c                                |   22 +-
 drivers/block/floppy.c                             |    7 +-
 drivers/block/nbd.c                                |   10 +
 drivers/char/random.c                              |    5 +-
 drivers/clk/qcom/clk-rcg2.c                        |    3 +
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |   28 +-
 drivers/clocksource/bcm2835_timer.c                |    5 +-
 drivers/devfreq/Kconfig                            |    3 +-
 drivers/devfreq/event/Kconfig                      |    2 +-
 drivers/dma/dmaengine.c                            |    4 +-
 drivers/gpio/gpio-grgpio.c                         |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   19 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |    7 +-
 drivers/gpu/drm/drm_debugfs_crc.c                  |    4 +-
 drivers/gpu/drm/gma500/framebuffer.c               |    8 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |    8 +
 drivers/gpu/drm/nouveau/nouveau_fence.c            |    2 +-
 .../gpu/drm/nouveau/nvkm/engine/disp/channv50.c    |    2 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c     |   21 +-
 .../gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c    |    5 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c         |    4 +-
 drivers/hwmon/pmbus/ltc2978.c                      |    4 +-
 drivers/ide/cmd64x.c                               |    3 +
 drivers/ide/serverworks.c                          |    6 +
 drivers/infiniband/core/security.c                 |   24 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   10 +
 drivers/infiniband/hw/hfi1/chip.h                  |    1 +
 drivers/infiniband/hw/hfi1/driver.c                |    1 +
 drivers/infiniband/hw/hfi1/file_ops.c              |   52 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |    7 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |    3 -
 drivers/infiniband/hw/hfi1/user_sdma.c             |   17 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   12 +
 drivers/input/mouse/synaptics.c                    |    4 +-
 drivers/input/touchscreen/edt-ft5x06.c             |    7 +
 drivers/iommu/arm-smmu-v3.c                        |    3 +-
 drivers/iommu/qcom_iommu.c                         |   28 +-
 drivers/irqchip/irq-gic-v3-its.c                   |    2 +-
 drivers/irqchip/irq-gic-v3.c                       |    9 +-
 drivers/irqchip/irq-mbigen.c                       |    1 +
 drivers/leds/leds-pca963x.c                        |    8 +-
 drivers/md/bcache/bset.h                           |    3 +-
 drivers/media/i2c/mt9v032.c                        |   10 +-
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |    6 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |    2 +-
 drivers/net/ethernet/freescale/gianfar.c           |   10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |    3 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |    5 +
 drivers/net/wan/ixp4xx_hss.c                       |    4 +-
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
 drivers/pci/iov.c                                  |    1 +
 drivers/pinctrl/intel/pinctrl-baytrail.c           |    8 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |    9 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |   39 +-
 drivers/pwm/pwm-omap-dmtimer.c                     |    7 +-
 drivers/pwm/pwm-pca9685.c                          |    4 -
 drivers/regulator/rk808-regulator.c                |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/iscsi_tcp.c                           |    4 +
 drivers/scsi/qla2xxx/qla_os.c                      |    4 +
 drivers/scsi/scsi_transport_iscsi.c                |   26 +-
 drivers/scsi/ufs/ufshcd.c                          |   24 +-
 drivers/scsi/ufs/ufshcd.h                          |    2 +
 drivers/soc/tegra/fuse/tegra-apbmisc.c             |    2 +-
 drivers/staging/android/ashmem.c                   |   28 +
 drivers/staging/greybus/audio_manager.c            |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |    4 +-
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |    5 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |    4 +-
 drivers/staging/vt6656/dpc.c                       |    2 +-
 drivers/target/iscsi/iscsi_target.c                |   16 +-
 drivers/thunderbolt/switch.c                       |    7 +
 drivers/tty/serdev/serdev-ttyport.c                |    6 +-
 drivers/tty/serial/8250/8250_aspeed_vuart.c        |    1 -
 drivers/tty/serial/8250/8250_core.c                |    5 +-
 drivers/tty/serial/8250/8250_port.c                |    4 +
 drivers/tty/serial/atmel_serial.c                  |    3 +-
 drivers/tty/serial/imx.c                           |  171 +-
 drivers/tty/synclink_gt.c                          |   18 +-
 drivers/tty/synclinkmp.c                           |   24 +-
 drivers/tty/tty_port.c                             |    5 +-
 drivers/tty/vt/selection.c                         |    9 +-
 drivers/tty/vt/vt_ioctl.c                          |   75 +-
 drivers/uio/uio_dmem_genirq.c                      |    6 +-
 drivers/usb/core/hub.c                             |   20 +-
 drivers/usb/core/hub.h                             |    1 +
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc2/gadget.c                          |    3 +-
 drivers/usb/gadget/composite.c                     |    8 +-
 drivers/usb/gadget/udc/gr_udc.c                    |   16 +-
 drivers/usb/host/xhci-mem.c                        |   12 +-
 drivers/usb/host/xhci-pci.c                        |   10 +-
 drivers/usb/host/xhci-ring.c                       |   60 +-
 drivers/usb/misc/iowarrior.c                       |   31 +-
 drivers/usb/musb/omap2430.c                        |    2 -
 drivers/usb/storage/uas.c                          |   23 +-
 drivers/video/fbdev/pxa168fb.c                     |    6 +-
 drivers/virtio/virtio_balloon.c                    |    2 +
 drivers/vme/bridges/vme_fake.c                     |   30 +-
 drivers/xen/preempt.c                              |    4 +-
 fs/btrfs/check-integrity.c                         |    3 +-
 fs/btrfs/disk-io.c                                 |    2 +-
 fs/btrfs/extent_map.c                              |   11 +
 fs/btrfs/file-item.c                               |    3 +-
 fs/btrfs/inode.c                                   |   16 +-
 fs/btrfs/ordered-data.c                            |    7 +-
 fs/btrfs/super.c                                   |    2 +
 fs/btrfs/volumes.c                                 |    2 +
 fs/ceph/mds_client.c                               |    3 +-
 fs/ceph/super.c                                    |    5 +
 fs/cifs/connect.c                                  |    6 +-
 fs/ecryptfs/crypto.c                               |    6 +-
 fs/ecryptfs/keystore.c                             |    2 +-
 fs/ecryptfs/messaging.c                            |    1 +
 fs/ext4/dir.c                                      |   14 +-
 fs/ext4/ext4.h                                     |   14 +-
 fs/ext4/file.c                                     |   10 +-
 fs/ext4/inode.c                                    |   24 +-
 fs/ext4/migrate.c                                  |   27 +-
 fs/ext4/mmp.c                                      |   12 +-
 fs/ext4/namei.c                                    |    8 +
 fs/ext4/super.c                                    |   38 +-
 fs/f2fs/sysfs.c                                    |   12 +-
 fs/jbd2/checkpoint.c                               |    2 +-
 fs/jbd2/commit.c                                   |   50 +-
 fs/jbd2/journal.c                                  |   24 +-
 fs/jbd2/transaction.c                              |   10 +-
 fs/ocfs2/journal.h                                 |    8 +-
 fs/orangefs/orangefs-debugfs.c                     |    1 +
 fs/reiserfs/stree.c                                |    3 +-
 fs/reiserfs/super.c                                |    2 +-
 fs/udf/super.c                                     |   22 +-
 include/linux/dmaengine.h                          |    2 +
 include/linux/intel-svm.h                          |    2 +-
 include/linux/libata.h                             |    1 +
 include/linux/list_nulls.h                         |    8 +-
 include/linux/rculist_nulls.h                      |    8 +-
 include/linux/tty.h                                |    2 +
 include/media/v4l2-device.h                        |   12 +-
 include/scsi/iscsi_proto.h                         |    1 -
 include/sound/rawmidi.h                            |    6 +-
 ipc/sem.c                                          |    6 +-
 kernel/cpu.c                                       |   13 +-
 kernel/irq/internals.h                             |    2 -
 kernel/irq/manage.c                                |   18 +-
 kernel/irq/proc.c                                  |   22 +
 kernel/padata.c                                    |   45 +-
 kernel/trace/ftrace.c                              |    5 +-
 kernel/trace/trace_events_trigger.c                |    5 +-
 kernel/trace/trace_stat.c                          |   31 +-
 kernel/watchdog.c                                  |   10 +-
 lib/scatterlist.c                                  |    2 +-
 lib/stackdepot.c                                   |   12 +-
 mm/vmscan.c                                        |    9 +-
 net/dsa/tag_qca.c                                  |    2 +-
 net/netfilter/xt_hashlimit.c                       |   10 +
 net/sched/cls_flower.c                             |    1 +
 net/sched/cls_matchall.c                           |    1 +
 net/smc/smc_diag.c                                 |    5 +-
 scripts/kconfig/confdata.c                         |    2 +-
 security/selinux/avc.c                             |    2 +-
 sound/core/control.c                               |    5 +-
 sound/core/seq/seq_clientmgr.c                     |    4 +-
 sound/core/seq/seq_queue.c                         |   29 +-
 sound/core/seq/seq_timer.c                         |   13 +-
 sound/core/seq/seq_timer.h                         |    3 +-
 sound/hda/hdmi_chmap.c                             |    2 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/hda_eld.c                            |    2 +-
 sound/pci/hda/hda_sysfs.c                          |    4 +-
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_hdmi.c                         |    7 +-
 sound/sh/aica.c                                    |    4 +-
 sound/sh/sh_dac_audio.c                            |    3 -
 sound/soc/atmel/Kconfig                            |    2 +
 sound/soc/sunxi/sun8i-codec.c                      |    3 +-
 sound/usb/quirks.c                                 |    1 +
 sound/usb/usx2y/usX2Yhwdep.c                       |    2 +-
 tools/lib/api/fs/fs.c                              |    4 +-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt      |    2 +-
 tools/testing/selftests/size/get_size.c            |   24 +-
 tools/usb/usbip/src/usbip_network.c                |   40 +-
 tools/usb/usbip/src/usbip_network.h                |   12 +-
 250 files changed, 1822 insertions(+), 9005 deletions(-)


