Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1310BF4D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfK0UkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbfK0UkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9749821780;
        Wed, 27 Nov 2019 20:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887217;
        bh=rQ6Kyz5BhPN6jCgRqkQQberjYMlQ6vdF+TlX5WVZXq8=;
        h=From:To:Cc:Subject:Date:From;
        b=Xv6FjqdM7hzOdZvjvzkn8GYCFVsSTstuwltJnfbIWzu/ffs/uS3COyPxLAYT+M8HK
         f2wI+AlFxjt96nRobHqPyoHvh01IPH5Xd03gLSAh6CGomG8xY2z1d9QftSrP8jbgLG
         ckUA7qPvGpfCtsHDJ/3PxnUIDXirwjE9eTI0HPhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/151] 4.9.204-stable review
Date:   Wed, 27 Nov 2019 21:29:43 +0100
Message-Id: <20191127203000.773542911@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.204-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.204-rc1
X-KernelTest-Deadline: 2019-11-29T20:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.204 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.204-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.204-rc1

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/book3s64: Fix link stack flush on context switch

Christopher M. Riedl <cmr@informatik.wtf>
    powerpc/64s: support nospectre_v2 cmdline option

Bernd Porr <mail@berndporr.me.uk>
    staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for Foxconn T77W968 LTE modules

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: add support for DW5821e with eSIM support

Johan Hovold <johan@kernel.org>
    USB: serial: mos7840: fix remote wakeup

Johan Hovold <johan@kernel.org>
    USB: serial: mos7720: fix remote wakeup

Pavel Löbl <pavel@loebl.cz>
    USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Oliver Neukum <oneukum@suse.com>
    appledisplay: fix error handling in the scheduled work

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fix error case of a timeout

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb-serial: cp201x: support Mark-10 digital force gauge

Hewenliang <hewenliang4@huawei.com>
    usbip: tools: fix fd leakage in the function of read_attr_usbip_status

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: move removal code

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: drop custom control queue cleanup

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: fix uninitialized variable use

Halil Pasic <pasic@linux.ibm.com>
    virtio_ring: fix return code on DMA mapping fails

Laurent Vivier <lvivier@redhat.com>
    virtio_console: allocate inbufs in add_port() only if it is needed

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: don't tie bufs to a vq

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: reset on out of memory

Sean Young <sean@mess.org>
    media: imon: invalid dereference in imon_touch_event

Vito Caputo <vcaputo@pengaru.com>
    media: cxusb: detect cxusb_ctrl_msg error in query

Oliver Neukum <oneukum@suse.com>
    media: b2c2-flexcop-usb: add sanity checking

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Fix error path in control parsing failure

Kai Shen <shenkai8@huawei.com>
    cpufreq: Add NULL checks to show() and store() methods of cpufreq

Alan Stern <stern@rowland.harvard.edu>
    media: usbvision: Fix races among open, close, and disconnect

Alexander Popov <alex.popov@linux.com>
    media: vivid: Fix wrong locking that causes race conditions on streaming stop

Vandana BN <bnvandana@gmail.com>
    media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6

Oliver Neukum <oneukum@suse.com>
    nfc: port100: handle command failure cleanly

Waiman Long <longman@redhat.com>
    x86/speculation: Fix redundant MDS mitigation message

Waiman Long <longman@redhat.com>
    x86/speculation: Fix incorrect MDS/TAA mitigation status

Alexander Kapshuk <alexander.kapshuk@gmail.com>
    x86/insn: Fix awk regexp warnings

Alexey Brodkin <Alexey.Brodkin@synopsys.com>
    ARC: perf: Accommodate big-endian CPU

Chester Lin <clin@suse.com>
    ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary

Gang He <ghe@suse.com>
    ocfs2: remove ocfs2_is_o2cb_active()

Bo Yan <byan@nvidia.com>
    cpufreq: Skip cpufreq resume if it's not suspended

Hari Vyas <hari.vyas@broadcom.com>
    arm64: fix for bad_mode() handler to always result in panic

Bart Van Assche <bart.vanassche@sandisk.com>
    dm: use blk_set_queue_dying() in __dm_destroy()

Denis Efremov <efremov@linux.com>
    ath9k_hw: fix uninitialized variable data

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

Tomas Bortoli <tomasbortoli@gmail.com>
    Bluetooth: Fix invalid-free in bcsp_close()

zhong jiang <zhongjiang@huawei.com>
    mm/memory_hotplug: Do not unlock when fails to take the device_hotplug_lock

Vignesh R <vigneshr@ti.com>
    spi: omap2-mcspi: Fix DMA and FIFO event trigger size mismatch

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Use quirk to limit MRRS for K2G

Nathan Chancellor <natechancellor@gmail.com>
    pinctrl: zynq: Use define directive for PIN_CONFIG_IO_STANDARD

Nathan Chancellor <natechancellor@gmail.com>
    pinctrl: lpc18xx: Use define directive for PIN_CONFIG_GPIO_PIN_INT

Brian Masney <masneyb@onstation.org>
    pinctrl: qcom: spmi-gpio: fix gpio-hog related boot issues

David Barmann <david.barmann@stackpath.com>
    sock: Reset dst when changing sk_mark via setsockopt

YueHaibing <yuehaibing@huawei.com>
    net: bcmgenet: return correct value 'ret' from bcmgenet_power_down

Colin Ian King <colin.king@canonical.com>
    ACPICA: Use %d for signed int print formatting instead of %u

Tycho Andersen <tycho@tycho.ws>
    dlm: don't leak kernel pointer to userspace

Tycho Andersen <tycho@tycho.ws>
    dlm: fix invalid free

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: fcoe: Fix link down issue after 1000+ link bounces

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Fix msleep granularity

Suganath Prabu <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing page11

Suganath Prabu <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Fix Sync cache command failure during driver unload

Shaokun Zhang <zhangshaokun@hisilicon.com>
    rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information

Dan Carpenter <dan.carpenter@oracle.com>
    wireless: airo: potential buffer overflow in sprintf()

Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
    brcmsmac: never log "tid x is not agg'able" by default

Gustavo A. R. Silva <gustavo@embeddedor.com>
    rtl8xxxu: Fix missing break in switch

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_smart_config_start()'

Richard Guy Briggs <rgb@redhat.com>
    audit: print empty EXECVE args

Valentin Schneider <valentin.schneider@arm.com>
    sched/fair: Don't increase sd->balance_interval on newidle balance

Eric Dumazet <edumazet@google.com>
    net: do not abort bulk send on BQL status

Larry Chen <lchen@suse.com>
    ocfs2: fix clusters leak in ocfs2_defrag_extent()

Changwei Ge <ge.changwei@h3c.com>
    ocfs2: don't put and assigning null to bh allocated outside

Victor Kamensky <kamensky@cisco.com>
    arm64: makefile fix build of .i file in external module case

Dave Jiang <dave.jiang@intel.com>
    ntb: intel: fix return value for ndev_vec_mask()

Jon Mason <jdmason@kudzu.us>
    ntb_netdev: fix sleep time mismatch

Miroslav Lichvar <mlichvar@redhat.com>
    igb: shorten maximum PHC timecounter update interval

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: make add_memory() take the device_hotplug_lock

Colin Ian King <colin.king@canonical.com>
    fs/hfs/extent.c: fix array out of bounds read of array extent

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfs: update timestamp on truncate()

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfsplus: update timestamps on truncate()

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfs: fix return value of hfs_get_block()

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfsplus: fix return value of hfsplus_get_block()

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfs: prevent btree data loss on ENOSPC

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfsplus: prevent btree data loss on ENOSPC

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfs: fix BUG on bnode parent update

Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
    hfsplus: fix BUG on bnode parent update

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    linux/bitmap.h: fix type of nbits in bitmap_shift_right()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    linux/bitmap.h: handle constant zero-size bitmaps correctly

Anton Ivanov <anton.ivanov@cambridgegreys.com>
    um: Make line/tty semantics use true write IRQ

Sabrina Dubroca <sd@queasysnail.net>
    macsec: let the administrator set UP state even if lowerdev is down

Sabrina Dubroca <sd@queasysnail.net>
    macsec: update operstate when lower device changes

Dave Chinner <dchinner@redhat.com>
    mm/page-writeback.c: fix range_cyclic writeback vs writepages deadlock

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs/ocfs2/dlm/dlmdebug.c: fix a sleep-in-atomic-context bug in dlm_print_one_mle()

David S. Miller <davem@davemloft.net>
    sparc64: Rework xchg() definition to avoid warnings.

Felipe Rechia <felipe.rechia@datacom.com.br>
    powerpc/process: Fix flush_all_to_thread for SPE

Geert Uytterhoeven <geert+renesas@glider.be>
    thermal: rcar_thermal: Prevent hardware access during system suspend

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Fix to test kprobe $comm arg only if available

Marek Szyprowski <m.szyprowski@samsung.com>
    mfd: max8997: Enale irq-wakeup unconditionally

Fabio Estevam <fabio.estevam@nxp.com>
    mfd: mc13xxx-core: Fix PMIC shutdown when reading ADC values

Sapthagiri Baratam <sapthagiri.baratam@cirrus.com>
    mfd: arizona: Correct calling of runtime_put_sync

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    net: ethernet: ti: cpsw: unsync mcast entries while switch promisc mode

Dan Carpenter <dan.carpenter@oracle.com>
    qlcnic: fix a return in qlcnic_dcb_get_capability()

Nathan Chancellor <natechancellor@gmail.com>
    mISDN: Fix type of switch control variable in ctrl_teimanager

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to spread clear_cold_data()

Nathan Chancellor <natechancellor@gmail.com>
    rtc: s35390a: Change buf's type to u8 in s35390a_init

Yan, Zheng <zyan@redhat.com>
    ceph: fix dentry leak in ceph_readdir_prepopulate

David S. Miller <davem@davemloft.net>
    sparc: Fix parport build warnings.

Vignesh R <vigneshr@ti.com>
    spi: omap2-mcspi: Set FIFO DMA trigger level to word length

Thomas Richter <tmricht@linux.ibm.com>
    s390/perf: Return error when debug_register fails

Nathan Chancellor <natechancellor@gmail.com>
    atm: zatm: Fix empty body Clang warnings

J. Bruce Fields <bfields@redhat.com>
    sunrpc: safely reallow resvport min/max inversion

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix a compile warning for cmpxchg64()

Colin Ian King <colin.king@canonical.com>
    usbip: tools: fix atoi() on non-null terminated string

Mattias Jacobsson <2pi@mok.nu>
    USB: misc: appledisplay: fix backlight update_status return code

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    macintosh/windfarm_smu_sat: Fix debug output

Philipp Klocke <philipp97kl@gmail.com>
    ALSA: i2c/cs8427: Fix int to char conversion

Steven Rostedt (VMware) <rostedt@goodmis.org>
    kprobes, x86/ptrace.h: Make regs_get_kernel_stack_nth() not fault on bad stack

Dave Chinner <dchinner@redhat.com>
    xfs: fix use-after-free race in xfs_buf_rele

Netanel Belgazal <netanel@amazon.com>
    net: ena: Fix Kconfig dependency on X86

Kyeongdon Kim <kyeongdon.kim@lge.com>
    net: fix warning in af_unix

Christoph Hellwig <hch@lst.de>
    scsi: dc395x: fix DMA API usage in sg_update_list

Christoph Hellwig <hch@lst.de>
    scsi: dc395x: fix dma API usage in srb_done

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ASoC: tegra_sgtl5000: fix device_node refcounting

Lubomir Rintel <lkundrak@v3.sk>
    clk: mmp2: fix the clock id for sdh2_clk and sdh3_clk

Nathan Chancellor <natechancellor@gmail.com>
    scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param

Nathan Chancellor <natechancellor@gmail.com>
    scsi: isci: Change sci_controller_start_task's return type to sci_status

Nathan Chancellor <natechancellor@gmail.com>
    scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler

Uros Bizjak <ubizjak@gmail.com>
    KVM/x86: Fix invvpid and invept register operand size in 64-bit mode

Gustavo A. R. Silva <gustavo@embeddedor.com>
    scsi: ips: fix missing break in switch

Omar Sandoval <osandov@fb.com>
    amiflop: clean up on errors during setup

Angelo Dureghello <angelo@sysam.it>
    m68k: fix command-line parsing when passed from u-boot

Wenwen Wang <wang6495@umn.edu>
    misc: mic: fix a DMA pool free failure

Duncan Laurie <dlaurie@chromium.org>
    gsmi: Fix bug in append_to_eventlog sysfs handler

Nikolay Borisov <nborisov@suse.com>
    btrfs: handle error of get_old_root

Chaotian Jing <chaotian.jing@mediatek.com>
    mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready fail

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    spi: sh-msiof: fix deferred probing

Carl Huang <cjhuang@codeaurora.org>
    ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem

Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
    brcmsmac: AP mode: update beacon when TIM changes

Sam Bobroff <sbobroff@linux.ibm.com>
    powerpc/eeh: Fix use of EEH_PE_KEEP on wrong field

Dan Carpenter <dan.carpenter@oracle.com>
    powerpc: Fix signedness bug in update_flash_db()

Al Viro <viro@zeniv.linux.org.uk>
    synclink_gt(): fix compat_ioctl()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix marking bitmaps non-full

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    printk: fix integer overflow in setup_log_buf()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: isight: fix leak of reference to firewire unit in error path of .probe callback

Adrian Bunk <bunk@kernel.org>
    mwifiex: Fix NL80211_TX_POWER_LIMITED

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-wmi: Only Tell EC the OS will handle display hotkeys from asus_nb_wmi

Kiernan Hager <kah.listaddress@gmail.com>
    platform/x86: asus-nb-wmi: Support ALS on the Zenbook UX430UQ

Andrey Ryabinin <aryabinin@virtuozzo.com>
    mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()

Joseph Qi <joseph.qi@linux.alibaba.com>
    Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()"

Laura Abbott <labbott@redhat.com>
    tools: gpio: Correctly add make dependencies for gpio_utils

Thierry Reding <treding@nvidia.com>
    gpio: max77620: Fixup debounce delays

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_pedit: fix WARN() in the traffic path

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Fix set vf link state error flow

Martin Habets <mhabets@solarflare.com>
    sfc: Only cancel the PPS workqueue if it exists

Dan Carpenter <dan.carpenter@oracle.com>
    net: rtnetlink: prevent underflows in do_setvfinfo()

Luigi Rizzo <lrizzo@google.com>
    net/mlx4_en: fix mlx4 ethtool -N insertion


-------------

Diffstat:

 Documentation/hw-vuln/mds.rst                      |   7 +-
 Documentation/hw-vuln/tsx_async_abort.rst          |   5 +-
 Documentation/kernel-parameters.txt                |  11 ++
 Makefile                                           |   4 +-
 arch/arc/kernel/perf_event.c                       |   4 +-
 arch/arm/mm/mmu.c                                  |   3 +
 arch/arm64/Makefile                                |   2 +
 arch/arm64/kernel/traps.c                          |   1 -
 arch/m68k/kernel/uboot.c                           |   2 +-
 arch/powerpc/include/asm/asm-prototypes.h          |   3 +
 arch/powerpc/include/asm/security_features.h       |   3 +
 arch/powerpc/kernel/eeh_pe.c                       |   2 +-
 arch/powerpc/kernel/entry_64.S                     |   6 +
 arch/powerpc/kernel/process.c                      |   3 +-
 arch/powerpc/kernel/security.c                     |  74 ++++++++++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  27 ++++
 arch/powerpc/platforms/ps3/os-area.c               |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   6 +-
 arch/sparc/include/asm/cmpxchg_64.h                |   7 +-
 arch/sparc/include/asm/parport.h                   |   2 +
 arch/um/drivers/line.c                             |   2 +-
 arch/x86/include/asm/ptrace.h                      |  42 +++++--
 arch/x86/kernel/cpu/bugs.c                         |  30 ++++-
 arch/x86/kvm/mmu.c                                 |   8 +-
 arch/x86/kvm/vmx.c                                 |   4 +-
 arch/x86/tools/gen-insn-attr-x86.awk               |   4 +-
 drivers/acpi/acpi_memhotplug.c                     |   2 +-
 drivers/atm/zatm.c                                 |  42 +++----
 drivers/base/memory.c                              |   9 +-
 drivers/block/amiflop.c                            |  84 ++++++-------
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/char/virtio_console.c                      | 140 ++++++++++-----------
 drivers/clk/mmp/clk-of-mmp2.c                      |   4 +-
 drivers/cpufreq/cpufreq.c                          |   9 ++
 drivers/firmware/google/gsmi.c                     |   5 +-
 drivers/gpio/gpio-max77620.c                       |   6 +-
 drivers/isdn/mISDN/tei.c                           |   7 +-
 drivers/macintosh/windfarm_smu_sat.c               |  25 ++--
 drivers/md/dm.c                                    |   4 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   8 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   8 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   8 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   3 -
 drivers/media/platform/vivid/vivid-vid-out.c       |   3 -
 drivers/media/rc/imon.c                            |   3 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   3 +
 drivers/media/usb/dvb-usb/cxusb.c                  |   3 +-
 drivers/media/usb/usbvision/usbvision-video.c      |  21 +++-
 drivers/media/usb/uvc/uvc_driver.c                 |  30 ++---
 drivers/mfd/arizona-core.c                         |   8 +-
 drivers/mfd/max8997.c                              |   8 +-
 drivers/mfd/mc13xxx-core.c                         |   3 +-
 drivers/misc/mic/scif/scif_fence.c                 |   2 +-
 drivers/mmc/host/mtk-sd.c                          |   2 +-
 drivers/net/ethernet/amazon/Kconfig                |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   2 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |   8 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c    |   2 +-
 drivers/net/ethernet/sfc/ptp.c                     |   3 +-
 drivers/net/ethernet/ti/cpsw.c                     |   1 +
 drivers/net/macsec.c                               |  20 ++-
 drivers/net/ntb_netdev.c                           |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  23 ++--
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |  30 ++++-
 .../wireless/broadcom/brcm80211/brcmsmac/main.h    |   1 +
 drivers/net/wireless/cisco/airo.c                  |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  13 +-
 drivers/net/wireless/marvell/mwifiex/ioctl.h       |   1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    |   2 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c        |   2 +-
 drivers/nfc/port100.c                              |   2 +-
 drivers/ntb/hw/intel/ntb_hw_intel.c                |   2 +-
 drivers/pci/host/pci-keystone.c                    |   3 +
 drivers/pinctrl/pinctrl-lpc18xx.c                  |  10 +-
 drivers/pinctrl/pinctrl-zynq.c                     |   9 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  21 +++-
 drivers/platform/x86/asus-nb-wmi.c                 |  21 +++-
 drivers/platform/x86/asus-wmi.c                    |   2 +-
 drivers/platform/x86/asus-wmi.h                    |   1 +
 drivers/rtc/rtc-s35390a.c                          |   2 +-
 drivers/scsi/dc395x.c                              |  12 +-
 drivers/scsi/ips.c                                 |   1 +
 drivers/scsi/isci/host.c                           |   8 +-
 drivers/scsi/isci/host.h                           |   2 +-
 drivers/scsi/isci/request.c                        |   4 +-
 drivers/scsi/isci/task.c                           |   4 +-
 drivers/scsi/iscsi_tcp.c                           |   3 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   2 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  20 +++
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  11 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   4 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  36 +++++-
 drivers/spi/spi-omap2-mcspi.c                      |  26 ++--
 drivers/spi/spi-sh-msiof.c                         |   4 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |  21 ++--
 drivers/thermal/rcar_thermal.c                     |   4 +-
 drivers/tty/synclink_gt.c                          |  16 +--
 drivers/usb/misc/appledisplay.c                    |  15 ++-
 drivers/usb/misc/chaoskey.c                        |  24 +++-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/mos7720.c                       |   4 -
 drivers/usb/serial/mos7840.c                       |  16 ++-
 drivers/usb/serial/option.c                        |   7 ++
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/xen/balloon.c                              |   3 +
 fs/btrfs/ctree.c                                   |   4 +
 fs/ceph/inode.c                                    |   1 -
 fs/dlm/member.c                                    |   5 +-
 fs/dlm/user.c                                      |   2 +-
 fs/f2fs/data.c                                     |   8 +-
 fs/f2fs/dir.c                                      |   1 +
 fs/f2fs/segment.c                                  |   4 +-
 fs/gfs2/rgrp.c                                     |  13 +-
 fs/hfs/brec.c                                      |   1 +
 fs/hfs/btree.c                                     |  41 +++---
 fs/hfs/btree.h                                     |   1 +
 fs/hfs/catalog.c                                   |  16 +++
 fs/hfs/extent.c                                    |  10 +-
 fs/hfs/inode.c                                     |   2 +
 fs/hfsplus/attributes.c                            |  10 ++
 fs/hfsplus/brec.c                                  |   1 +
 fs/hfsplus/btree.c                                 |  44 ++++---
 fs/hfsplus/catalog.c                               |  24 ++++
 fs/hfsplus/extents.c                               |   8 +-
 fs/hfsplus/hfsplus_fs.h                            |   2 +
 fs/hfsplus/inode.c                                 |   1 +
 fs/ocfs2/buffer_head_io.c                          |  77 +++++++++---
 fs/ocfs2/dlm/dlmdebug.c                            |   2 +-
 fs/ocfs2/dlmglue.c                                 |   2 +-
 fs/ocfs2/move_extents.c                            |  17 +++
 fs/ocfs2/stackglue.c                               |   6 -
 fs/ocfs2/stackglue.h                               |   3 -
 fs/ocfs2/xattr.c                                   |  56 +++++----
 fs/xfs/xfs_buf.c                                   |  38 +++++-
 include/linux/bitmap.h                             |   9 +-
 include/linux/kvm_host.h                           |   1 +
 include/linux/memory_hotplug.h                     |   1 +
 include/linux/mfd/max8997.h                        |   1 -
 include/linux/mfd/mc13xxx.h                        |   1 +
 kernel/auditsc.c                                   |   2 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/fair.c                                |  13 +-
 mm/ksm.c                                           |  14 +--
 mm/memory_hotplug.c                                |  22 +++-
 mm/page-writeback.c                                |  33 +++--
 net/core/dev.c                                     |   2 +-
 net/core/rtnetlink.c                               |  23 +++-
 net/core/sock.c                                    |   6 +-
 net/l2tp/l2tp_ip.c                                 |  24 ++--
 net/l2tp/l2tp_ip6.c                                |  24 ++--
 net/sched/act_pedit.c                              |   5 +-
 net/sunrpc/auth_gss/gss_krb5_seal.c                |   1 +
 net/sunrpc/xprtsock.c                              |  34 ++---
 net/unix/af_unix.c                                 |   2 +
 sound/firewire/isight.c                            |  10 +-
 sound/i2c/cs8427.c                                 |   2 +-
 sound/soc/tegra/tegra_sgtl5000.c                   |  17 ++-
 tools/gpio/Build                                   |   1 +
 tools/gpio/Makefile                                |  10 +-
 tools/objtool/arch/x86/tools/gen-insn-attr-x86.awk |   4 +-
 tools/power/acpi/tools/acpidump/apmain.c           |   2 +-
 .../ftrace/test.d/kprobe/kprobe_args_syntax.tc     |   3 +
 tools/usb/usbip/libsrc/usbip_host_common.c         |   8 +-
 virt/kvm/kvm_main.c                                |  26 +++-
 173 files changed, 1264 insertions(+), 619 deletions(-)


