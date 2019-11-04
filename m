Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC6EEFF9
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfKDVwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbfKDVwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:17 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D330F2184C;
        Mon,  4 Nov 2019 21:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904336;
        bh=YHKFDJ05IoqcfJ98B3LPS/7pSJydcSY5/SM6/5BKDdE=;
        h=From:To:Cc:Subject:Date:From;
        b=AofODcxqXTVMePbkV8gRLD9rw2dCQKs6e8P089m7kJ2eYhXpcajRYm0G/P2Ps67Ee
         9gGuPT9QNUQsgdC13DpsJWxaQE9bhny6PaBtJnh8PHIxWSYxCUSIjYJFudHSXNKrbc
         rioWRZg0i2FXT+jnpBFvpFfuvWjYGVHnGks8ou/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/95] 4.14.152-stable review
Date:   Mon,  4 Nov 2019 22:43:58 +0100
Message-Id: <20191104212038.056365853@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.152-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.152-rc1
X-KernelTest-Deadline: 2019-11-06T21:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.152 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.152-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.152-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix mutex deadlock at releasing card

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Simplify error path in snd_timer_open()

Vratislav Bendel <vbendel@redhat.com>
    xfs: Correctly invert xfs_buftarg LRU isolation logic

Xin Long <lucien.xin@gmail.com>
    sctp: not bind the socket in sctp_connect

Xin Long <lucien.xin@gmail.com>
    sctp: fix the issue that flags are ignored when using kernel_connect

Eric Dumazet <edumazet@google.com>
    sch_netem: fix rcu splat in netem_enqueue()

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: usb: sr9800: fix uninitialized local variable

Eric Dumazet <edumazet@google.com>
    bonding: fix potential NULL deref in bond_update_slave_arr

Johan Hovold <johan@kernel.org>
    NFC: pn533: fix use-after-free and memleaks

David Howells <dhowells@redhat.com>
    rxrpc: Fix call ref leak

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff leak in llc_conn_service()

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff leak in llc_sap_state_process()

Tony Lindgren <tony@atomide.com>
    dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Laura Abbott <labbott@redhat.com>
    rtlwifi: Fix potential overflow on P2P code

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/idle: fix cpu idle time calculation

Yihui ZENG <yzeng56@asu.edu>
    s390/cmm: fix information leak in cmm_timeout_handler()

Markus Theil <markus.theil@tu-ilmenau.de>
    nl80211: fix validation of mesh path nexthop

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    HID: fix error message in hid_open_report()

Alan Stern <stern@rowland.harvard.edu>
    HID: Fix assumption that devices have inputs

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Bart Van Assche <bvanassche@acm.org>
    scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Johan Hovold <johan@kernel.org>
    USB: serial: whiteheat: fix line-speed endianness

Johan Hovold <johan@kernel.org>
    USB: serial: whiteheat: fix potential slab corruption

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix control-message timeout

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix ring-buffer locking

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_boundary_mask to avoid SG overflows")

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: Reject endpoints with 0 maxpacket value

Alan Stern <stern@rowland.harvard.edu>
    UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments")

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support for ALC623

Aaron Ma <aaron.ma@canonical.com>
    ALSA: hda/realtek - Fix 2 front mics of codec 0x623

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: Fix prototype of helper function to return negative value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: truncate pending writes on O_TRUNC

Miklos Szeredi <mszeredi@redhat.com>
    fuse: flush dirty data/metadata before non-truncate setattr

Hui Peng <benquike@gmail.com>
    ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use 32-bit writes when writing ring producer/consumer

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: check cops->tcf_block in tc_bind_tclass()

Dan Carpenter <dan.carpenter@oracle.com>
    USB: legousbtower: fix a signedness bug in tower_probe()

Mike Christie <mchristi@redhat.com>
    nbd: verify socket is supported during setup

Petr Mladek <pmladek@suse.com>
    tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/uaccess: avoid (false positive) compiler warnings

Chuck Lever <chuck.lever@oracle.com>
    NFSv4: Fix leak of clp->cl_acceptor string

Xiubo Li <xiubli@redhat.com>
    nbd: fix possible sysfs duplicate warning

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: fw: sni: Fix out of bounds init of o32 stack

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: include: Mark __xchg as __always_inline

Tom Lendacky <thomas.lendacky@amd.com>
    perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp

Frederic Weisbecker <frederic@kernel.org>
    sched/vtime: Fix guest/system mis-accounting on task switch

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan_inode_alloc()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end_nolock()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()

Jia Guo <guojia12@huawei.com>
    ocfs2: clear zero in unaligned direct IO

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/xen: Return from panic notifier

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: include: Mark __cmpxchg as __always_inline

Dave Young <dyoung@redhat.com>
    efi/x86: Do not clean dummy variable in kexec path

Lukas Wunner <lukas@wunner.de>
    efi/cper: Fix endianness of PCIe class code

Adam Ford <aford173@gmail.com>
    serial: mctrl_gpio: Check for NULL pointer

Austin Kim <austindh.kim@gmail.com>
    fs: cifs: mute -Wunused-const-variable message

Thierry Reding <treding@nvidia.com>
    gpio: max77620: Use correct unit for debounce times

Randy Dunlap <rdunlap@infradead.org>
    tty: n_hdlc: fix build on SPARC

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'

James Morse <james.morse@arm.com>
    arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1542419

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request

Dexuan Cui <decui@microsoft.com>
    HID: hyperv: Use in-place iterator API in the channel callback

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a lock inversion issue

Navid Emamdoost <navid.emamdoost@gmail.com>
    RDMA/hfi1: Prevent memory leak in sdma_init

Connor Kuehl <connor.kuehl@canonical.com>
    staging: rtl8188eu: fix null dereference when kzalloc fails

Andi Kleen <ak@linux.intel.com>
    perf jevents: Fix period for Intel fixed counters

Steve MacLean <Steve.MacLean@microsoft.com>
    perf map: Fix overlapped map handling

Ian Rogers <irogers@google.com>
    perf tests: Avoid raising SEGV using an obvious NULL dereference

Ian Rogers <irogers@google.com>
    libsubcmd: Make _FORTIFY_SOURCE defines dependent on the feature

Pascal Bouwmann <bouwmann@tau-tec.de>
    iio: fix center temperature of bmc150-accel-core

Remi Pommarel <repk@triplefau.lt>
    iio: adc: meson_saradc: Fix memory allocation order

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: max14656: fix potential use-after-free

Sven Van Asbroeck <thesven73@gmail.com>
    PCI/PME: Fix possible use-after-free on remove

Kees Cook <keescook@chromium.org>
    exec: load_script: Do not exec truncated interpreter path

Lucas A. M. Magalhães <lucmaga@gmail.com>
    media: vimc: Remove unused but set variables

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume

Nir Dotan <nird@mellanox.com>
    mlxsw: spectrum: Set LAG port collector only when active

Sam Ravnborg <sam@ravnborg.org>
    rtc: pcf8523: set xtal load capacitance from DT

Jan-Marek Glogowski <glogow@fbihome.de>
    usb: handle warm-reset port requests on hub resume

NOGUCHI Hiroshi <drvlabo@gmail.com>
    HID: Add ASUS T100CHI keyboard dock battery quirks

Brian Norris <briannorris@chromium.org>
    scripts/setlocalversion: Improve -dirty check with git-status --no-optional-locks

Yi Wang <wang.yi59@zte.com.cn>
    clk: boston: unregister clks on failure in clk_boston_setup()

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Add Odys Winbook 13 to descriptor override

Kan Liang <kan.liang@linux.intel.com>
    x86/cpu: Add Atom Tremont (Jacobsville)

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override

David Hildenbrand <david@redhat.com>
    powerpc/powernv: hold device_hotplug_lock when calling memtrace_offline_pages()

Phil Elwell <phil@raspberrypi.org>
    sc16is7xx: Fix for "Unexpected interrupt: 8"

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix a duplicate 0711 log message number.

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: flush quota blocks after turnning it off

Kent Overstreet <kent.overstreet@gmail.com>
    dm: Use kzalloc for all structs with embedded biosets/mempools

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: rework COW throttling to fix deadlock

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: introduce account_start_copy() and account_end_copy()

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: use mutex instead of rw_semaphore

Sasha Levin <sashal@kernel.org>
    zram: fix race between backing_dev_show and backing_dev_store


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt  |   4 +
 Makefile                                         |   4 +-
 arch/arm64/include/asm/pgtable-prot.h            |  15 +-
 arch/arm64/kernel/ftrace.c                       |   8 +-
 arch/mips/fw/sni/sniprom.c                       |   2 +-
 arch/mips/include/asm/cmpxchg.h                  |   9 +-
 arch/powerpc/platforms/powernv/memtrace.c        |   4 +-
 arch/s390/include/asm/uaccess.h                  |   4 +-
 arch/s390/kernel/idle.c                          |  29 +++-
 arch/s390/mm/cmm.c                               |  12 +-
 arch/x86/events/amd/core.c                       |  30 ++--
 arch/x86/include/asm/intel-family.h              |   3 +-
 arch/x86/platform/efi/efi.c                      |   3 -
 arch/x86/xen/enlighten.c                         |  28 +++-
 drivers/block/nbd.c                              |  25 +++-
 drivers/block/zram/zram_drv.c                    |   5 +-
 drivers/clk/imgtec/clk-boston.c                  |  18 ++-
 drivers/dma/cppi41.c                             |  21 ++-
 drivers/firmware/efi/cper.c                      |   2 +-
 drivers/gpio/gpio-max77620.c                     |   6 +-
 drivers/hid/hid-axff.c                           |  11 +-
 drivers/hid/hid-core.c                           |   7 +-
 drivers/hid/hid-dr.c                             |  12 +-
 drivers/hid/hid-emsff.c                          |  12 +-
 drivers/hid/hid-gaff.c                           |  12 +-
 drivers/hid/hid-holtekff.c                       |  12 +-
 drivers/hid/hid-hyperv.c                         |  56 ++-----
 drivers/hid/hid-input.c                          |   3 +
 drivers/hid/hid-lg2ff.c                          |  12 +-
 drivers/hid/hid-lg3ff.c                          |  11 +-
 drivers/hid/hid-lg4ff.c                          |  11 +-
 drivers/hid/hid-lgff.c                           |  11 +-
 drivers/hid/hid-logitech-hidpp.c                 |  11 +-
 drivers/hid/hid-sony.c                           |  12 +-
 drivers/hid/hid-tmff.c                           |  12 +-
 drivers/hid/hid-zpff.c                           |  12 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c         |  35 +++++
 drivers/iio/accel/bmc150-accel-core.c            |   2 +-
 drivers/iio/adc/meson_saradc.c                   |  10 +-
 drivers/infiniband/core/cma.c                    |   3 +-
 drivers/infiniband/hw/hfi1/sdma.c                |   5 +-
 drivers/md/dm-bio-prison-v1.c                    |   2 +-
 drivers/md/dm-bio-prison-v2.c                    |   2 +-
 drivers/md/dm-io.c                               |   2 +-
 drivers/md/dm-kcopyd.c                           |   2 +-
 drivers/md/dm-region-hash.c                      |   2 +-
 drivers/md/dm-snap.c                             | 178 +++++++++++++++--------
 drivers/md/dm-thin.c                             |   2 +-
 drivers/media/platform/vimc/vimc-sensor.c        |   7 -
 drivers/net/bonding/bond_main.c                  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c   |  62 +++++---
 drivers/net/usb/sr9800.c                         |   2 +-
 drivers/net/wireless/ath/ath6kl/usb.c            |   8 +
 drivers/net/wireless/realtek/rtlwifi/ps.c        |   6 +
 drivers/nfc/pn533/usb.c                          |   9 +-
 drivers/pci/pcie/pme.c                           |   1 +
 drivers/power/supply/max14656_charger_detector.c |  17 ++-
 drivers/rtc/rtc-pcf8523.c                        |  28 +++-
 drivers/scsi/lpfc/lpfc_scsi.c                    |   2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |   6 +-
 drivers/target/iscsi/cxgbit/cxgbit_cm.c          |   3 +-
 drivers/thunderbolt/nhi.c                        |  22 ++-
 drivers/tty/n_hdlc.c                             |   5 +
 drivers/tty/serial/owl-uart.c                    |   2 +-
 drivers/tty/serial/sc16is7xx.c                   |  28 ++++
 drivers/tty/serial/serial_mctrl_gpio.c           |   3 +
 drivers/usb/core/hub.c                           |   7 +
 drivers/usb/gadget/udc/core.c                    |  11 ++
 drivers/usb/misc/ldusb.c                         |   6 +-
 drivers/usb/misc/legousbtower.c                  |   2 +-
 drivers/usb/serial/whiteheat.c                   |  13 +-
 drivers/usb/serial/whiteheat.h                   |   2 +-
 drivers/usb/storage/scsiglue.c                   |  10 --
 drivers/usb/storage/uas.c                        |  20 ---
 fs/binfmt_script.c                               |  57 ++++++--
 fs/cifs/netmisc.c                                |   4 -
 fs/f2fs/super.c                                  |   6 +
 fs/fuse/dir.c                                    |  13 ++
 fs/fuse/file.c                                   |  10 +-
 fs/nfs/nfs4proc.c                                |   1 +
 fs/nfs/write.c                                   |   5 +-
 fs/ocfs2/aops.c                                  |  25 +++-
 fs/ocfs2/ioctl.c                                 |   2 +-
 fs/ocfs2/xattr.c                                 |  56 +++----
 fs/xfs/xfs_buf.c                                 |   2 +-
 include/net/llc_conn.h                           |   2 +-
 include/net/sch_generic.h                        |   5 +
 include/net/sctp/sctp.h                          |   2 +
 kernel/sched/cputime.c                           |   6 +-
 kernel/trace/trace.c                             |   1 +
 net/llc/llc_c_ac.c                               |   8 +-
 net/llc/llc_conn.c                               |  32 ++--
 net/llc/llc_s_ac.c                               |  12 +-
 net/llc/llc_sap.c                                |  23 +--
 net/rxrpc/sendmsg.c                              |   1 +
 net/sched/sch_api.c                              |   2 +
 net/sched/sch_netem.c                            |   2 +-
 net/sctp/ipv6.c                                  |   2 +-
 net/sctp/protocol.c                              |   2 +-
 net/sctp/socket.c                                |  55 +++----
 net/wireless/nl80211.c                           |   3 +-
 scripts/setlocalversion                          |  12 +-
 sound/core/timer.c                               |  63 ++++----
 sound/firewire/bebob/bebob_stream.c              |   3 +-
 sound/pci/hda/patch_realtek.c                    |  15 +-
 tools/lib/subcmd/Makefile                        |   8 +-
 tools/perf/pmu-events/jevents.c                  |  12 +-
 tools/perf/tests/perf-hooks.c                    |   3 +-
 tools/perf/util/map.c                            |   3 +
 109 files changed, 959 insertions(+), 477 deletions(-)


