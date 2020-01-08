Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38235134C2C
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgAHTuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:50:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43396 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730175AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-0006nh-CN; Wed, 08 Jan 2020 19:45:57 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHA-007dkT-RY; Wed, 08 Jan 2020 19:45:56 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 08 Jan 2020 19:42:58 +0000
Message-ID: <lsq.1578512578.117275639@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/63] 3.16.81-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.81 release.
There are 63 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 10 20:00:00 UTC 2020.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Adrian Bunk (1):
      mwifiex: Fix NL80211_TX_POWER_LIMITED
         [65a576e27309120e0621f54d5c81eb9128bd56be]

Amitkumar Karwar (1):
      mwifiex: don't follow AP if country code received from EEPROM
         [947d315257f9b25b0e24f5706f8184b3b00774d4]

Andreas Ziegler (1):
      tracing/uprobes: Fix output for multiple string arguments
         [0722069a5374b904ec1a67f91249f90e1cfae259]

Ard Biesheuvel (1):
      arm64/kernel: fix incorrect EL0 check in inv_entry macro
         [b660950c60a7278f9d8deb7c32a162031207c758]

Arnd Bergmann (1):
      ARM: 8458/1: bL_switcher: add GIC dependency
         [6c044fecdf78be3fda159a5036bb33700cdd5e59]

Baolin Wang (1):
      usb: gadget: Add the gserial port checking in gs_start_tx()
         [511a36d2f357724312bb3776d2f6eed3890928b2]

Ben Hutchings (3):
      Revert "sched/fair: Fix bandwidth timer clock drift condition"
         [not upstream; upstream fix is unsuitable for stable]
      ext4: Introduce ext4_clamp_want_extra_isize()
         [7bc04c5c2cc467c5b40f2b03ba08da174a0d5fa7]
      net: qlogic: Fix error paths in ql_alloc_large_buffers()
         [cad46039e4c99812db067c8ac22a864960e7acc4]

Bhadram Varka (1):
      stmmac: copy unicast mac address to MAC registers
         [a830405ee452ddc4101c3c9334e6fedd42c6b357]

Chaotian Jing (1):
      mmc: mmc: fix switch timeout issue caused by jiffies precision
         [987aa5f8059613bf85cbb6f64ffbd34f5cb7a9d1]

Christoffer Dall (1):
      video: fbdev: Set pixclock = 0 in goldfishfb
         [ace6033ec5c356615eaa3582fb1946e9eaff6662]

Christoph Hellwig (1):
      suspend: simplify block I/O handling
         [343df3c79c62b644ce6ff5dff96c9e0be1ecb242]

Chuanxiao Dong (1):
      mmc: debugfs: Add a restriction to mmc debugfs clock setting
         [e5905ff1281f0a0f5c9863c430ac1ed5faaf5707]

Colin Cross (1):
      mmc: block: Allow more than 8 partitions per card
         [382c55f88ffeb218c446bf0c46d0fc25d2795fe2]

Dmitry Vyukov (1):
      locking/x86: Remove the unused atomic_inc_short() methd
         [31b35f6b4d5285a311e10753f4eb17304326b211]

Dong Aisheng (1):
      mmc: core: fix using wrong io voltage if mmc_select_hs200 fails
         [e51534c806609c806d81bfb034f02737461f855c]

Eric Biggers (2):
      arm64: support keyctl() system call in 32-bit mode
         [5c2a625937ba49bc691089370638223d310cda9a]
      crypto: cts - fix crash on short inputs
         [not upstream; issue was fixed by large refactoring]

Eric Dumazet (2):
      net: diag: support v4mapped sockets in inet_diag_find_one_icsk()
         [7c1306723ee916ea9f1fa7d9e4c7a6d029ca7aaf]
      tcp/dccp: drop SYN packets if accept queue is full
         [5ea8ea2cb7f1d0db15762c9b0bb9e7330425a071]

Ezequiel Garcia (1):
      arm64: kconfig: drop CONFIG_RTC_LIB dependency
         [99a507771fa57238dc7ffe674ae06090333d02c9]

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()
         [3d94a4a8373bf5f45cf5f939e88b8354dbf2311b]

Greg Hackmann (1):
      staging: goldfish: audio: fix compiliation on arm
         [4532150762ceb0d6fd765ebcb3ba6966fbb8faab]

Ilya Dryomov (1):
      libceph: handle an empty authorize reply
         [0fd3fd0a9bb0b02b6435bb7070e9f7b82a23f068]

James Morse (3):
      PM / Hibernate: Call flush_icache_range() on pages restored in-place
         [f6cf0545ec697ddc278b7457b7d0c0d86a2ea88e]
      arm64: kernel: Include _AC definition in page.h
         [812264550dcba6cdbe84bfac2f27e7d23b5b8733]
      arm64: mm: Add trace_irqflags annotations to do_debug_exception()
         [6afedcd23cfd7ac56c011069e4a8db37b46e4623]

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected
         [f70267f379b5e5e11bdc5d72a56bf17e5feed01f]

Jeffrey Hugo (1):
      dmaengine: qcom: bam_dma: Fix resource leak
         [7667819385457b4aeb5fac94f67f52ab52cc10d5]

Johannes Berg (1):
      cfg80211: size various nl80211 messages correctly
         [4ef8c1c93f848e360754f10eb2e7134c872b6597]

Konstantin Khlebnikov (1):
      mm/rmap: replace BUG_ON(anon_vma->degree) with VM_WARN_ON
         [e4c5800a3991f0c6a766983535dfc10d51802cf6]

Laura Abbott (1):
      staging: ashmem: Avoid deadlock with mmap/shrink
         [18e77054de741ef3ed2a2489bc9bf82a318b2d5e]

Linus Torvalds (2):
      Make filldir[64]() verify the directory entry filename is valid
         [8a23eb804ca4f2be909e372cf5a9e7b30ae476cd]
      filldir[64]: remove WARN_ON_ONCE() for bad directory entries
         [b9959c7a347d6adbb558fba7e36e9fef3cba3b07]

Lorenzo Pieralisi (1):
      ARM: 8510/1: rework ARM_CPU_SUSPEND dependencies
         [1b9bdf5c1661873a10e193b8cbb803a87fe5c4a1]

Mark Rutland (1):
      asm-generic: Fix local variable shadow in __set_fixmap_offset
         [3694bd76781b76c4f8d2ecd85018feeb1609f0e5]

Mathias Nyman (2):
      xhci: Fix port resume done detection for SS ports with LPM enabled
         [6cbcf596934c8e16d6288c7cc62dfb7ad8eadf15]
      xhci: fix USB3 device initiated resume race with roothub autosuspend
         [057d476fff778f1d3b9f861fdb5437ea1a3cfc99]

Navid Emamdoost (1):
      net: qlogic: Fix memory leak in ql_alloc_large_buffers
         [1acb8f2a7a9f10543868ddd737e37424d5c36cf4]

Peter Chen (1):
      usb: gadget: composite: fix dereference after null check coverify warning
         [c526c62d565ea5a5bba9433f28756079734f430d]

Peter Zijlstra (2):
      locking,x86: Kill atomic_or_long()
         [f6b4ecee0eb7bfa66ae8d5652105ed4da53209a3]
      x86/atomic: Fix smp_mb__{before,after}_atomic()
         [69d927bba39517d0980462efc051875b7f4db185]

Philip Oberstaller (1):
      usb: gadget: serial: fix re-ordering of tx data
         [3e9d3d2efc677b501b12512cab5adb4f32a0673a]

Qiao Zhou (1):
      arm64: traps: disable irq in die()
         [6f44a0bacb79a03972c83759711832b382b1b8ac]

Rajmal Menariya (1):
      staging: ion: Set minimum carveout heap allocation order to PAGE_SHIFT
         [1328d8efef17d5e16bd6e9cfe59130a833674534]

Ravindra Lokhande (1):
      ALSA: compress: add support for 32bit calls in a 64bit kernel
         [c10368897e104c008c610915a218f0fe5fa4ec96]

Roderick Colenbrander (2):
      HID: sony: Support DS4 dongle
         [de66a1a04c25f2560a8dca7a95e2a150b0d5e17e]
      HID: sony: Update device ids
         [cf1015d65d7c8a5504a4c03afb60fb86bff0f032]

Roger Quadros (1):
      usb: dwc3: gadget: Fix suspend/resume during device mode
         [9772b47a4c2916d645c551228b6085ea24acbe5d]

Rom Lemarchand (1):
      staging: ashmem: Add missing include
         [90a2f171383b5ae43b33ab4d9d566b9765622ac7]

Russell King (1):
      mmc: core: shut up "voltage-ranges unspecified" pr_info()
         [10a16a01d8f72e80f4780e40cf3122f4caffa411]

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling
         [4ea99936a1630f51fc3a2d61a58ec4a1c4b7d55a]

Will Deacon (2):
      arm64: debug: Don't propagate UNKNOWN FAR into si_code for debug signals
         [b9a4b9d084d978f80eb9210727c81804588b42ff]
      arm64: debug: Ensure debug handlers check triggering exception level
         [6bd288569b50bc89fa5513031086746968f585cb]

Winter Wang (1):
      usb: gadget: configfs: add mutex lock before unregister gadget
         [cee51c33f52ebf673a088a428ac0fecc33ab77fa]

Wolfram Sang (2):
      kbuild: setlocalversion: print error to STDERR
         [78283edf2c01c38eb840a3de5ffd18fe2992ab64]
      mmc: sanitize 'bus width' in debug output
         [ed9feec72fc1fa194ebfdb79e14561b35decce63]

Xerox Lin (1):
      usb: gadget: rndis: free response queue during REMOTE_NDIS_RESET_MSG
         [207707d8fd48ebc977fb2b2794004a020e1ee08e]

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices
         [da2311a6385c3b499da2ed5d9be59ce331fa93e9]

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: gadget: fix unused-but-set-variable warning
         [b7d44c36a6f6d956e1539e0dd42f98b26e5a4684]

YueHaibing (1):
      media: cpia2: Fix use-after-free in cpia2_exit
         [dea37a97265588da604c6ba80160a287b72c7bfd]

Yury Norov (1):
      arm64: fix COMPAT_SHMLBA definition for large pages
         [b9b7aebb42d1b1392f3111de61136bb6cf3aae3f]

 Makefile                                          |   4 +-
 arch/arm/Kconfig                                  |   6 +-
 arch/arm64/Kconfig                                |   5 +-
 arch/arm64/include/asm/page.h                     |   2 +
 arch/arm64/include/asm/shmparam.h                 |   2 +-
 arch/arm64/kernel/entry.S                         |   2 +-
 arch/arm64/kernel/kgdb.c                          |  15 +-
 arch/arm64/kernel/traps.c                         |   8 +-
 arch/arm64/mm/fault.c                             |  36 +++--
 arch/tile/lib/atomic_asm_32.S                     |   3 +-
 arch/x86/include/asm/atomic.h                     |  36 +----
 arch/x86/include/asm/atomic64_64.h                |   8 +-
 arch/x86/include/asm/barrier.h                    |   4 +-
 crypto/cts.c                                      |   8 +-
 drivers/dma/qcom_bam_dma.c                        |  14 ++
 drivers/hid/hid-core.c                            |   3 +
 drivers/hid/hid-ids.h                             |   2 +
 drivers/hid/hid-sony.c                            |   6 +
 drivers/media/usb/cpia2/cpia2_v4l.c               |   3 +-
 drivers/mmc/card/block.c                          |   7 +-
 drivers/mmc/core/core.c                           |  10 +-
 drivers/mmc/core/debugfs.c                        |   2 +-
 drivers/mmc/core/mmc.c                            |  13 +-
 drivers/mmc/core/mmc_ops.c                        |   2 +-
 drivers/net/can/usb/kvaser_usb.c                  |   6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c             |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  16 +-
 drivers/net/wireless/mwifiex/cfg80211.c           |  17 ++-
 drivers/net/wireless/mwifiex/ioctl.h              |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c          |  23 ++-
 drivers/scsi/libsas/sas_discover.c                |  11 +-
 drivers/staging/android/ashmem.c                  |   4 +-
 drivers/staging/android/ion/ion_carveout_heap.c   |   2 +-
 drivers/staging/android/uapi/ashmem.h             |   1 +
 drivers/staging/goldfish/goldfish_audio.c         |   1 +
 drivers/usb/dwc3/gadget.c                         |   6 +
 drivers/usb/gadget/composite.c                    |   2 +
 drivers/usb/gadget/configfs.c                     |   2 +
 drivers/usb/gadget/rndis.c                        |   6 +
 drivers/usb/gadget/u_serial.c                     |  12 +-
 drivers/usb/host/xhci-hub.c                       |   8 +
 drivers/usb/host/xhci-ring.c                      |  15 +-
 drivers/usb/host/xhci.h                           |   2 +
 drivers/usb/renesas_usbhs/mod_gadget.c            |   5 +-
 drivers/video/fbdev/goldfishfb.c                  |   2 +-
 fs/ext4/inode.c                                   |  15 ++
 fs/ext4/super.c                                   |  59 +++++---
 fs/readdir.c                                      |  40 +++++
 include/asm-generic/fixmap.h                      |  12 +-
 include/linux/swap.h                              |   1 -
 include/net/inet_connection_sock.h                |   5 -
 kernel/power/Makefile                             |   3 +-
 kernel/power/block_io.c                           | 103 -------------
 kernel/power/power.h                              |   9 --
 kernel/power/swap.c                               | 177 +++++++++++++++++-----
 kernel/sched/fair.c                               |  14 +-
 kernel/sched/sched.h                              |   2 -
 kernel/trace/trace_uprobe.c                       |   9 +-
 mm/page_io.c                                      |   2 +-
 mm/rmap.c                                         |   2 +-
 net/ceph/messenger.c                              |  12 +-
 net/dccp/ipv4.c                                   |   8 +-
 net/dccp/ipv6.c                                   |   2 +-
 net/ipv4/inet_diag.c                              |  18 ++-
 net/ipv4/tcp_ipv4.c                               |   7 +-
 net/ipv6/tcp_ipv6.c                               |   2 +-
 net/wireless/nl80211.c                            |  16 +-
 scripts/setlocalversion                           |   2 +-
 sound/core/compress_offload.c                     |  13 ++
 69 files changed, 533 insertions(+), 352 deletions(-)

-- 
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

