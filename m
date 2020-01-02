Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07C212ED5E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgABW1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729756AbgABW1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:27:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABF420866;
        Thu,  2 Jan 2020 22:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004055;
        bh=EC5Weh2g1vOErZfDAswvL7atDbLCxv31V6PuD8I8WxY=;
        h=From:To:Cc:Subject:Date:From;
        b=g2XR04CGPgmisWX/G8BHi1DV7dgbhQW0mVpICW47ZOnmU3NlYYB+XwKLHfEcLtWZ9
         R1HB+KKxbeOXCmFM2DWUIoxEweqlDRB3JvE7uHUM7mFTmlHnkbUyshZzpdV2iMYS9m
         iLnMWUI7Ec50JK0qBYIEJGM2i4HzJmw84i/UPEV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/171] 4.9.208-stable review
Date:   Thu,  2 Jan 2020 23:05:31 +0100
Message-Id: <20200102220546.960200039@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.208-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.208-rc1
X-KernelTest-Deadline: 2020-01-04T22:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.208 release.
There are 171 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 04 Jan 2020 22:02:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.208-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.208-rc1

Taehee Yoo <ap420073@gmail.com>
    gtp: avoid zero size hashtable

Taehee Yoo <ap420073@gmail.com>
    gtp: fix wrong condition in gtp_genl_dump_pdp()

Eric Dumazet <edumazet@google.com>
    tcp: do not send empty skb from tcp_write_xmit()

Eric Dumazet <edumazet@google.com>
    tcp/dccp: fix possible race __inet_lookup_established()

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: accept only packets with the right dst_cid

Netanel Belgazal <netanel@amazon.com>
    net: ena: fix napi handler misbehavior when the napi budget is zero

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci: Update the tuning failed messages to pr_debug level

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Really serialize all register accesses

David Engraf <david.engraf@sysgo.com>
    tty/serial: atmel: fix out of range clock divider handling

Eric Dumazet <edumazet@google.com>
    hrtimer: Annotate lockless access to timer->state

Eric Dumazet <edumazet@google.com>
    net: icmp: fix data-race in cmp_global_allow()

Eric Dumazet <edumazet@google.com>
    netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()

Eric Dumazet <edumazet@google.com>
    6pack,mkiss: fix possible deadlock

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: compat: reject all padding in matches/watchers

Linus Torvalds <torvalds@linux-foundation.org>
    filldir[64]: remove WARN_ON_ONCE() for bad directory entries

Linus Torvalds <torvalds@linux-foundation.org>
    Make filldir[64]() verify the directory entry filename is valid

Mattias Jacobsson <2pi@mok.nu>
    perf strbuf: Remove redundant va_end() in strbuf_addv()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Downgrade error message for single-cmd fallback

Alexander Lobakin <alobakin@dlink.ru>
    net, sysctl: Fix compiler warning when only cBPF is present

Jan H. Schönherr <jschoenh@amazon.de>
    x86/mce: Fix possibly incorrect severity calculation on AMD

Johannes Weiner <hannes@cmpxchg.org>
    kernel: sysctl: make drop_caches write-only

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ocfs2: fix passing zero to 'PTR_ERR' warning

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Check for SDBT and SDB consistency

Masahiro Yamada <yamada.masahiro@socionext.com>
    libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf regs: Make perf_reg_name() return "unknown" instead of NULL

Diego Elio Pettenò <flameeyes@flameeyes.com>
    cdrom: respect device capabilities during opening action

Masahiro Yamada <yamada.masahiro@socionext.com>
    scripts/kallsyms: fix definitely-lost memory leak

Vladimir Oltean <vladimir.oltean@nxp.com>
    gpio: mpc8xxx: Don't overwrite default irq_set_type callback

Bart Van Assche <bvanassche@acm.org>
    scsi: target: iscsi: Wait for all commands to finish before freeing a session

Maurizio Lombardi <mlombard@redhat.com>
    scsi: scsi_debug: num_tgts must be >= 0

peter chang <dpf@google.com>
    scsi: pm80xx: Fix for SATA device discovery

Theodore Ts'o <tytso@mit.edu>
    ext4: work around deleting a file with i_nlink == 0 safely

Blaž Hrastnik <blaz@mxxn.io>
    HID: Improve Windows Precision Touchpad detection.

Coly Li <colyli@suse.de>
    bcache: at least try to shrink 1 node in bch_mca_scan()

Robert Jarzmik <robert.jarzmik@free.fr>
    clk: pxa: fix one of the pxa RTC clocks

Finn Thain <fthain@telegraphics.com.au>
    scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE

Gustavo L. F. Walbon <gwalbon@linux.ibm.com>
    powerpc/security: Fix wrong message when RFI Flush is disable

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: Implement release() function for sysfs device

Bean Huo <beanhuo@micron.com>
    scsi: ufs: fix potential bug which ends in system hang

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    fs/quota: handle overflows of sysctl fs.quota.* and report as unsigned long

Lee Jones <lee.jones@linaro.org>
    mfd: mfd-core: Honour Device Tree's request to disable a child-device

Paul Cercueil <paul@crapouillou.net>
    irqchip: ingenic: Error out if IRQ domain creation failed

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    clk: qcom: Allow constant ratio freq tables for rcg

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow

Bart Van Assche <bvanassche@acm.org>
    scsi: tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)

Jan Kara <jack@suse.cz>
    jbd2: Fix statistics for the number of logged blocks

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning

Anthony Steinhauser <asteinhauser@google.com>
    powerpc/security/book3s64: Report L1TF status in sysfs

Chuhong Yuan <hslester96@gmail.com>
    clocksource/drivers/asm9260: Add a check for of_clk_get

Eric Dumazet <edumazet@google.com>
    dma-debug: add a schedule point in debug_dma_dump_mappings()

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Don't fail hash page table insert for bolted mapping

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Mark accumulate_stolen_time() as notrace

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Don't enable IRQs too early

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices

David Disseldorp <ddiss@suse.de>
    scsi: target: compare full CHAP_A Algorithm strings

Thierry Reding <treding@nvidia.com>
    iommu/tegra-smmu: Fix page tables in > 4 GiB memory

Evan Green <evgreen@chromium.org>
    Input: atmel_mxt_ts - disable IRQ across suspend

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix locking on mailbox command completion

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix clear pending bit in ioctl status

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show function entry line as probe-able

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: fix P2020 errata handling

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/irq: fix stack overflow verification

Jan Kara <jack@suse.cz>
    ext4: check for directory entries too close to block end

Jan Kara <jack@suse.cz>
    ext4: fix ext4_empty_dir() for directories with holes

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes

Erkka Talvitie <erkka.talvitie@vincit.fi>
    USB: EHCI: Do not return -EPIPE when hub is disconnected

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Fix error path of vhci_recv_ret_submit()

Geert Uytterhoeven <geert@linux-m68k.org>
    net: dst: Force 4-byte alignment of dst_metrics

Xin Long <lucien.xin@gmail.com>
    sctp: fully initialize v4 addr in some functions

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix suspend/resume PHY register access error

Ben Hutchings <ben@decadent.org.uk>
    net: qlogic: Fix error paths in ql_alloc_large_buffers()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart_tty_receive()

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Russell King <rmk+kernel@armlinux.org.uk>
    mod_devicetable: fix PHY module format

Chuhong Yuan <hslester96@gmail.com>
    fjes: fix missed check in fjes_acpi_add

Mao Wenan <maowenan@huawei.com>
    af_packet: set defaule value for tmo

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix removal logic of the tree mod log that leads to use-after-free issues

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort transaction after failed inode updates in create_subvol

Dan Carpenter <dan.carpenter@oracle.com>
    btrfs: return error pointer from alloc_test_extent_buffer

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not call synchronize_srcu() in inode_tree_del

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't double lock the subvol_sem for rename exchange

Guenter Roeck <linux@roeck-us.net>
    usb: xhci: Fix build warning seen with CONFIG_PM=n

Faiz Abbas <faiz_abbas@ti.com>
    Revert "mmc: sdhci: Fix incorrect switch to HS mode"

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in reada_start_machine_worker()

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: initialise phydev speed and duplex sanely

Hewenliang <hewenliang4@huawei.com>
    libtraceevent: Fix memory leakage in copy_filter_type

Michael Ellerman <mpe@ellerman.id.au>
    crypto: vmx - Avoid weird build failures

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbtft: Make sure string is NULL terminated

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: check kasprintf() return value

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Add some Intel instructions to the opcode map

Chuhong Yuan <hslester96@gmail.com>
    spi: st-ssc4: add missed pm_runtime_disable

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in run_ordered_work()

Omar Sandoval <osandov@fb.com>
    btrfs: don't prematurely free work in end_workqueue_fn()

Eugeniu Rosca <erosca@de.adit-jv.com>
    mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests

Chuhong Yuan <hslester96@gmail.com>
    spi: tegra20-slink: add missed clk_unprepare

Wang Xuerui <wangxuerui@qiniu.com>
    iwlwifi: mvm: fix unaligned read of rx_pkt_status

Lianbo Jiang <lijiang@redhat.com>
    x86/crash: Add a forward declaration of struct kimage

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Register drivers only after CPU devices have been registered

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    parport: load lowlevel driver if ports not found

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/disassembler: don't hide instruction addresses

Ben Zhang <benzh@chromium.org>
    ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile

Chuhong Yuan <hslester96@gmail.com>
    spi: pxa2xx: Add missed security checks

Robert Richter <rrichter@marvell.com>
    EDAC/ghes: Fix grain calculation

Chuhong Yuan <hslester96@gmail.com>
    media: si470x-i2c: add missed operations in remove

Mike Isely <isely@pobox.com>
    media: pvrusb2: Fix oops on tear-down when radio support is not present

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix get invalid tx rate for Mesh metric

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Filter out instances except for inlined subroutine and subprogram

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Skip end-of-sequence and non statement lines

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show calling lines of inlined functions

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Return a better scope DIE if there is no best scope

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Skip overlapped location on searching variables

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to probe a function which has no entry pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show inlined function callsite without entry_pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to show ranges of variables in functions without entry_pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to probe an inline function which has no entry pc

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Walk function lines in lexical blocks

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to list probe event with correct line number

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to find range-only function instance

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Limit max amount of slave instances

Pan Bian <bianpan2016@163.com>
    spi: img-spfi: fix potential double release

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix PF-VF communication over multi-cos queues.

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix advertising duplicated flags

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B

John Garry <john.garry@huawei.com>
    libata: Ensure ata_port probe has completed before detach

Yunfeng Ye <yeyunfeng@huawei.com>
    arm64: psci: Reduce the waiting time for cpu_psci_cpu_kill()

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Prevent inconsistent state when moving an interrupt

Chris Chiu <chiu@endlessm.com>
    rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

Kangjie Lu <kjlu@umn.edu>
    drm/gma500: fix memory disclosures due to uninitialized bytes

Benjamin Berg <bberg@redhat.com>
    x86/mce: Lower throttling MCE messages' priority to warning

Mattijs Korpershoek <mkorpershoek@baylibre.com>
    Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Reset the device at probe time

Ingo Rohloff <ingo.rohloff@lauterbach.com>
    usb: usbfs: Suppress problematic bind and unbind uevents.

Jin Yao <yao.jin@linux.intel.com>
    perf report: Add warning when libunwind not compiled in

Leo Yan <leo.yan@linaro.org>
    perf test: Report failure for mmap events

Sami Tolvanen <samitolvanen@google.com>
    x86/mm: Use the correct function type for native_set_fixmap()

Stephan Gerhold <stephan@gerhold.net>
    extcon: sm5502: Reset registers during initialization

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: Make sure YUYV is set as default format

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequence number

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel format

Navid Emamdoost <navid.emamdoost@gmail.com>
    mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Daniel T. Lee <danieltimlee@gmail.com>
    samples: pktgen: fix proc_cmd command result check logic

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-funcs.h: add status_req checks

Yang Yingliang <yangyingliang@huawei.com>
    media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()

Yizhuo <yzhai003@ucr.edu>
    regulator: max8907: Fix the usage of uninitialized variable in max8907_regulator_probe()

Tony Lindgren <tony@atomide.com>
    hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not idled

Veeraiyan Chidambaram <veeraiyan.chidambaram@in.bosch.com>
    usb: renesas_usbhs: add suspend event support in gadget mode

Nathan Chancellor <natechancellor@gmail.com>
    tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix stored frame format not in sync with hardware

Benoit Parrot <bparrot@ti.com>
    media: i2c: ov2659: Fix missing 720p register config

Benoit Parrot <bparrot@ti.com>
    media: i2c: ov2659: fix s_stream return value

Benoit Parrot <bparrot@ti.com>
    media: am437x-vpfe: Setting STD to current value is not an error

Max Gurtovoy <maxg@mellanox.com>
    IB/iser: bound protection_sg size by data_sg size

Allen Pais <allen.pais@oracle.com>
    libertas: fix a potential NULL pointer dereference

Navid Emamdoost <navid.emamdoost@gmail.com>
    rtlwifi: prevent memory leak in rtl_usb_probe

Connor Kuehl <connor.kuehl@canonical.com>
    staging: rtl8188eu: fix possible null dereference

Navid Emamdoost <navid.emamdoost@gmail.com>
    staging: rtl8192u: fix multiple memory leaks on error path

Lukasz Majewski <lukma@denx.de>
    spi: Add call to spi_slave_abort() function when spidev driver is released

Krzysztof Wilczynski <kw@linux.com>
    iio: light: bh1750: Resolve compiler warning and make code more readable

Brian Masney <masneyb@onstation.org>
    drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings

Sean Paul <seanpaul@chromium.org>
    drm: mst: Fix query_payload ack reply struct

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Avoid endless loop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Keep power on during processing DSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Avoid possible info leaks from PCM stream buffers

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle ENOENT in btrfs_uuid_tree_iterate

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not leak reloc root if we fail to read the fs root

Josef Bacik <josef@toxicpanda.com>
    btrfs: skip log replay on orphaned roots


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/compressed/libfdt_env.h              |  4 +-
 arch/arm64/kernel/psci.c                           | 15 ++--
 arch/powerpc/boot/libfdt_env.h                     |  2 +
 arch/powerpc/kernel/irq.c                          |  4 +-
 arch/powerpc/kernel/security.c                     | 21 +++---
 arch/powerpc/kernel/time.c                         |  2 +-
 arch/powerpc/mm/hash_utils_64.c                    | 10 ++-
 arch/powerpc/platforms/pseries/cmm.c               |  5 ++
 arch/s390/kernel/dis.c                             | 13 ++--
 arch/s390/kernel/perf_cpum_sf.c                    | 17 ++++-
 arch/sh/include/cpu-sh4/cpu/sh7734.h               |  2 +-
 arch/x86/include/asm/crash.h                       |  2 +
 arch/x86/include/asm/fixmap.h                      |  2 +-
 arch/x86/kernel/apic/io_apic.c                     |  9 ++-
 arch/x86/kernel/cpu/mcheck/mce.c                   |  2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |  2 +-
 arch/x86/lib/x86-opcode-map.txt                    | 18 +++--
 arch/x86/mm/pgtable.c                              |  4 +-
 drivers/ata/libata-core.c                          |  3 +
 drivers/cdrom/cdrom.c                              | 12 +++-
 drivers/char/hw_random/omap3-rom-rng.c             |  3 +-
 drivers/clk/pxa/clk-pxa27x.c                       |  1 +
 drivers/clk/qcom/clk-rcg2.c                        |  2 +
 drivers/clk/qcom/common.c                          |  3 +
 drivers/clocksource/asm9260_timer.c                |  4 ++
 drivers/cpufreq/cpufreq.c                          |  7 ++
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            | 12 ++--
 drivers/crypto/vmx/Makefile                        |  6 +-
 drivers/edac/ghes_edac.c                           | 10 ++-
 drivers/extcon/extcon-sm5502.c                     |  4 ++
 drivers/extcon/extcon-sm5502.h                     |  2 +
 drivers/gpio/gpio-mpc8xxx.c                        |  3 +-
 drivers/gpu/drm/bridge/analogix-anx78xx.c          |  8 ++-
 drivers/gpu/drm/gma500/oaktrail_crtc.c             |  2 +
 drivers/hid/hid-core.c                             |  4 ++
 drivers/iio/adc/max1027.c                          |  8 +++
 drivers/iio/light/bh1750.c                         |  4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |  4 ++
 drivers/iommu/tegra-smmu.c                         | 11 +--
 drivers/irqchip/irq-bcm7038-l1.c                   |  4 ++
 drivers/irqchip/irq-ingenic.c                      | 15 ++--
 drivers/md/bcache/btree.c                          |  2 +
 drivers/media/i2c/ov2659.c                         | 18 +++--
 drivers/media/i2c/soc_camera/ov6650.c              |  9 ++-
 drivers/media/platform/am437x/am437x-vpfe.c        |  4 ++
 drivers/media/platform/ti-vpe/vpe.c                | 16 +++--
 drivers/media/radio/si470x/radio-si470x-i2c.c      |  2 +
 drivers/media/usb/b2c2/flexcop-usb.c               |  8 ++-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  9 ++-
 drivers/mfd/mfd-core.c                             |  5 ++
 drivers/mmc/host/sdhci-of-esdhc.c                  |  4 +-
 drivers/mmc/host/sdhci.c                           |  6 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 10 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  | 16 +++--
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |  8 +--
 drivers/net/fjes/fjes_main.c                       |  3 +
 drivers/net/gtp.c                                  | 43 +++++++-----
 drivers/net/hamradio/6pack.c                       |  4 +-
 drivers/net/hamradio/mkiss.c                       |  4 +-
 drivers/net/phy/phy_device.c                       |  4 +-
 drivers/net/usb/lan78xx.c                          |  1 +
 drivers/net/wireless/ath/ath10k/txrx.c             |  2 +
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  3 +-
 drivers/net/wireless/marvell/libertas/if_sdio.c    |  5 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  5 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  3 +
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  2 +
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  5 +-
 drivers/parport/share.c                            | 21 ++++++
 drivers/pinctrl/intel/pinctrl-baytrail.c           | 81 ++++++++++++----------
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |  4 +-
 drivers/platform/x86/hp-wmi.c                      |  2 +-
 drivers/regulator/max8907-regulator.c              | 15 +++-
 drivers/scsi/atari_scsi.c                          |  6 +-
 drivers/scsi/csiostor/csio_lnode.c                 | 15 ++--
 drivers/scsi/lpfc/lpfc_els.c                       |  2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  4 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 15 +++-
 drivers/scsi/mac_scsi.c                            |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  2 +
 drivers/scsi/scsi_debug.c                          |  5 ++
 drivers/scsi/scsi_trace.c                          | 11 +--
 drivers/scsi/sun3_scsi.c                           |  4 +-
 drivers/scsi/ufs/ufshcd.c                          |  2 +-
 drivers/spi/spi-img-spfi.c                         |  2 +
 drivers/spi/spi-pxa2xx.c                           |  6 ++
 drivers/spi/spi-st-ssc4.c                          |  3 +
 drivers/spi/spi-tegra20-slink.c                    |  5 +-
 drivers/spi/spidev.c                               |  3 +
 drivers/staging/comedi/drivers/gsc_hpdi.c          | 10 +++
 drivers/staging/fbtft/fbtft-core.c                 |  2 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |  4 +-
 drivers/staging/rtl8192u/r8192U_core.c             | 17 +++--
 drivers/target/iscsi/iscsi_target.c                | 10 ++-
 drivers/target/iscsi/iscsi_target_auth.c           |  2 +-
 drivers/tty/serial/atmel_serial.c                  | 43 ++++++------
 drivers/usb/core/devio.c                           | 15 +++-
 drivers/usb/host/ehci-q.c                          | 13 +++-
 drivers/usb/host/xhci-pci.c                        |  2 +-
 drivers/usb/renesas_usbhs/common.h                 |  3 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             | 12 +++-
 drivers/usb/usbip/vhci_rx.c                        | 13 ++--
 drivers/vhost/vsock.c                              |  4 +-
 fs/btrfs/async-thread.c                            | 56 +++++++++++----
 fs/btrfs/ctree.c                                   |  2 +-
 fs/btrfs/disk-io.c                                 |  2 +-
 fs/btrfs/extent_io.c                               |  6 +-
 fs/btrfs/inode.c                                   | 11 ++-
 fs/btrfs/ioctl.c                                   | 10 ++-
 fs/btrfs/reada.c                                   | 10 ++-
 fs/btrfs/relocation.c                              |  1 +
 fs/btrfs/tests/free-space-tree-tests.c             |  6 +-
 fs/btrfs/tests/qgroup-tests.c                      |  4 +-
 fs/btrfs/tree-log.c                                | 23 +++++-
 fs/btrfs/uuid-tree.c                               |  2 +
 fs/ext4/dir.c                                      |  5 ++
 fs/ext4/namei.c                                    | 43 ++++++------
 fs/jbd2/commit.c                                   |  4 +-
 fs/ocfs2/acl.c                                     |  4 +-
 fs/quota/dquot.c                                   | 29 ++++----
 fs/readdir.c                                       | 40 +++++++++++
 include/drm/drm_dp_mst_helper.h                    |  2 +-
 include/linux/cec-funcs.h                          |  6 +-
 include/linux/hrtimer.h                            | 14 ++--
 include/linux/libfdt_env.h                         |  3 +
 include/linux/mod_devicetable.h                    |  4 +-
 include/linux/quota.h                              |  2 +-
 include/linux/rculist_nulls.h                      | 37 ++++++++++
 include/net/dst.h                                  |  2 +-
 include/net/inet_hashtables.h                      | 12 +++-
 include/net/sock.h                                 |  5 ++
 include/scsi/iscsi_proto.h                         |  1 +
 kernel/sysctl.c                                    |  2 +-
 kernel/time/hrtimer.c                              | 11 +--
 lib/dma-debug.c                                    |  1 +
 net/bluetooth/hci_core.c                           |  9 ++-
 net/bluetooth/hci_request.c                        |  9 +++
 net/bridge/br_netfilter_hooks.c                    |  3 +
 net/bridge/netfilter/ebtables.c                    | 33 +++++----
 net/core/sysctl_net_core.c                         |  2 +
 net/ipv4/icmp.c                                    | 11 +--
 net/ipv4/inet_diag.c                               |  3 +-
 net/ipv4/inet_hashtables.c                         | 18 ++---
 net/ipv4/tcp_ipv4.c                                |  7 +-
 net/ipv4/tcp_output.c                              |  8 +++
 net/ipv6/inet6_hashtables.c                        |  3 +-
 net/nfc/nci/uart.c                                 |  2 +-
 net/packet/af_packet.c                             |  3 +-
 net/sctp/protocol.c                                |  4 ++
 samples/pktgen/functions.sh                        | 17 +++--
 scripts/kallsyms.c                                 |  2 +
 sound/core/pcm_native.c                            |  4 ++
 sound/core/timer.c                                 | 10 +++
 sound/pci/hda/hda_controller.c                     |  2 +-
 sound/pci/hda/patch_ca0132.c                       |  7 +-
 sound/soc/codecs/rt5677.c                          |  1 +
 tools/lib/traceevent/parse-filter.c                |  9 ++-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt      | 18 +++--
 tools/perf/builtin-report.c                        |  7 ++
 tools/perf/tests/task-exit.c                       |  1 +
 tools/perf/util/dwarf-aux.c                        | 80 +++++++++++++++++----
 tools/perf/util/dwarf-aux.h                        |  3 +
 tools/perf/util/perf_regs.h                        |  2 +-
 tools/perf/util/probe-finder.c                     | 45 ++++++++++--
 tools/perf/util/strbuf.c                           |  1 -
 .../cpupower/utils/idle_monitor/hsw_ext_idle.c     |  1 -
 175 files changed, 1115 insertions(+), 417 deletions(-)


