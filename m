Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6099EE5389
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbfJYSGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46608 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731356AbfJYSFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OB-Jx; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xu-0001hW-OQ; Fri, 25 Oct 2019 19:05:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 25 Oct 2019 19:03:01 +0100
Message-ID: <lsq.1572026581.992411028@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/47] 3.16.76-rc1 review
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.76 release.
There are 47 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Oct 29 18:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Andreas Fritiofson (1):
      USB: serial: ftdi_sio: add ID for isodebug v1
         [f8377eff548170e8ea8022c067a1fbdf9e1c46a8]

Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation
         [b38ff4075a80b4da5cb2202d7965332ca0efb213]

Arnd Bergmann (1):
      ARC: hide unused function unw_hdr_alloc
         [fd5de2721ea7d16e2b16c4049ac49f229551b290]

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()
         [07d89227a983df957a6a7c56f7c040cde9ac571f]

Brian Norris (2):
      mwifiex: Don't abort on small, spec-compliant vendor IEs
         [63d7ef36103d26f20325a921ecc96a3288560146]
      mwifiex: fix 802.11n/WPA detection
         [df612421fe2566654047769c6852ffae1a31df16]

Christian Lamparter (1):
      carl9170: fix misuse of device driver API
         [feb09b2933275a70917a869989ea2823e7356be8]

Christophe Leroy (4):
      crypto: talitos - check AES key size
         [1ba34e71e9e56ac29a52e0d42b6290f3dc5bfd90]
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than PAGE_SIZE
         [aeb87246537a83c2aff482f3f34a2e0991e02cbc]
      powerpc/32s: fix suspend/resume when IBATs 4-7 are used
         [6ecb78ef56e08d2119d337ae23cb951a640dc52d]
      tty: serial: cpm_uart - fix init when SMC is relocated
         [06aaa3d066db87e8478522d910285141d44b1e58]

Cong Wang (1):
      bonding: validate ip header before check IPPROTO_IGMP
         [9d1bc24b52fb8c5d859f9a47084bf1179470e04c]

Dan Carpenter (1):
      eCryptfs: fix a couple type promotion bugs
         [0bdf8a8245fdea6f075a5fede833a5fcf1b3466c]

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs
         [cf144f81a99d1a3928f90b0936accfd3f45c9a0a]

Dianzhang Chen (2):
      x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
         [31a2fbb390fee4231281b939e1979e810f945415]
      x86/tls: Fix possible spectre-v1 in do_get_thread_area()
         [993773d11d45c90cb1c6481c2638c3d9f092ea5b]

Eiichi Tsukata (1):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec
         [d8655e7630dafa88bc37f101640e39c736399771]

Eric Biggers (1):
      crypto: ghash - fix unaligned memory access in ghash_setkey()
         [5c6bc4dfa515738149998bb0db2481a4fdead979]

Eric Dumazet (1):
      igmp: fix memory leak in igmpv3_del_delrec()
         [e5b1c6c6277d5a283290a8c033c72544746f9b5b]

Eric W. Biederman (1):
      signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig
         [f9070dc94542093fd516ae4ccea17ef46a4362c5]

Heiko Carstens (1):
      s390: fix stfle zero padding
         [4f18d869ffd056c7858f3d617c71345cf19be008]

Helge Deller (1):
      parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1
         [10835c854685393a921b68f529bf740fa7c9984d]

Jan Harkes (1):
      coda: pass the host file in vma->vm_file on mmap
         [7fa0a1da3dadfd9216df7745a1331fdaa0940d1c]

Jean-Philippe Brucker (1):
      mm/mmu_notifier: use hlist_add_head_rcu()
         [543bdb2d825fe2400d6e951f1786d92139a16931]

Jeremy Sowden (1):
      af_key: fix leaks in key_pol_get_resp and dump_sp.
         [7c80eb1c7e2b8420477fbc998971d62a648035d9]

Julian Wiedmann (3):
      s390/qdio: (re-)initialize tiqdio list entries
         [e54e4785cb5cb4896cf4285964aeef2125612fb2]
      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()
         [ac6639cd3db607d386616487902b4cc1850a7be5]
      s390/qdio: handle PENDING state for QEBSM devices
         [04310324c6f482921c071444833e70fe861b73d9]

Jörgen Storvist (2):
      USB: serial: option: add GosunCn ZTE WeLink ME3630
         [70a7444c550a75584ffcfae95267058817eff6a7]
      USB: serial: option: add support for GosunCn ME3630 RNDIS mode
         [aed2a26283528fb69c38e414f649411aa48fb391]

Kiruthika Varadarajan (1):
      usb: gadget: ether: Fix race between gether_disconnect and rx_submit
         [d29fcf7078bc8be2b6366cbd4418265b53c94fac]

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
         [6fc3977ccc5d3c22e851f2dce2d3ce2a0a843842]

Lorenzo Bianconi (1):
      net: neigh: fix multiple neigh timer scheduling
         [071c37983d99da07797294ea78e9da1a6e287144]

Mika Westerberg (1):
      PCI: Do not poll for PME if the device is in D3cold
         [000dd5316e1c756a1c028f22e01d06a38249dd4d]

Nicolas Dichtel (1):
      xfrm: fix sa selector validation
         [b8d6d0079757cbd1b69724cfd1c08e2171c68cee]

Nikolay Aleksandrov (1):
      net: bridge: stp: don't cache eth dest pointer before skb pull
         [2446a68ae6a8cee6d480e2f5b52f5007c7c41312]

Ravi Bangoria (1):
      powerpc/watchpoint: Restore NV GPRs while returning from exception
         [f474c28fbcbe42faca4eb415172c07d76adcb819]

Russell King (2):
      ARM: riscpc: fix DMA
         [ffd9a1ba9fdb7f2bd1d1ad9b9243d34e96756ba2]
      gpio: omap: fix lack of irqstatus_raw0 for OMAP4
         [64ea3e9094a1f13b96c33244a3fb3a0f45690bd2]

Steven J. Magnani (1):
      udf: Fix incorrect final NOT_ALLOCATED (hole) extent length
         [fa33cdbf3eceb0206a4f844fe91aeebcf6ff2b7a]

Taehee Yoo (1):
      caif-hsi: fix possible deadlock in cfhsi_exit_module()
         [fdd258d49e88a9e0b49ef04a506a796f1c768a8e]

Takashi Iwai (1):
      ALSA: seq: Break too long mutex context in the write loop
         [ede34f397ddb063b145b9e7d79c6026f819ded13]

Trond Myklebust (1):
      NFSv4: Handle the special Linux file open access mode
         [44942b4e457beda00981f616402a1a791e8c616e]

Vishnu DASA (1):
      VMCI: Fix integer overflow in VMCI handle arrays
         [1c2eb5b2853c9f513690ba6b71072d8eb65da16a]

Wang Hai (1):
      memstick: Fix error cleanup path of memstick_init
         [65f1a0d39c289bb6fc85635528cd36c4b07f560e]

YueHaibing (2):
      9p/virtio: Add cleanup path in p9_virtio_init
         [d4548543fc4ece56c6f04b8586f435fb4fd84c20]
      Input: psmouse - fix build error of multiple definition
         [49e6979e7e92cf496105b5636f1df0ac17c159c0]

 Makefile                                    |  4 +-
 arch/arc/kernel/unwind.c                    |  9 ++-
 arch/arm/mach-rpc/dma.c                     |  5 +-
 arch/parisc/kernel/ptrace.c                 | 28 +++++----
 arch/powerpc/kernel/exceptions-64s.S        |  9 ++-
 arch/powerpc/kernel/swsusp_32.S             | 73 +++++++++++++++++++---
 arch/powerpc/platforms/powermac/sleep.S     | 68 +++++++++++++++++++--
 arch/s390/include/asm/facility.h            | 21 ++++---
 arch/x86/kernel/ptrace.c                    |  4 +-
 arch/x86/kernel/tls.c                       |  9 ++-
 arch/x86/kvm/pmu.c                          |  4 +-
 crypto/ghash-generic.c                      |  8 ++-
 drivers/crypto/talitos.c                    | 13 ++++
 drivers/edac/edac_mc_sysfs.c                | 16 ++---
 drivers/edac/edac_module.h                  |  2 +-
 drivers/gpio/gpio-omap.c                    |  2 +
 drivers/input/mouse/trackpoint.h            |  3 +-
 drivers/media/v4l2-core/v4l2-ctrls.c        |  9 ++-
 drivers/memstick/core/memstick.c            | 13 ++--
 drivers/misc/vmw_vmci/vmci_context.c        | 80 ++++++++++++++-----------
 drivers/misc/vmw_vmci/vmci_handle_array.c   | 38 ++++++++----
 drivers/misc/vmw_vmci/vmci_handle_array.h   | 29 +++++----
 drivers/net/bonding/bond_main.c             | 37 +++++++-----
 drivers/net/caif/caif_hsi.c                 |  2 +-
 drivers/net/wireless/ath/carl9170/usb.c     | 39 ++++++------
 drivers/net/wireless/mwifiex/fw.h           | 12 +++-
 drivers/net/wireless/mwifiex/main.h         |  1 +
 drivers/net/wireless/mwifiex/scan.c         | 21 ++++---
 drivers/net/wireless/mwifiex/sta_ioctl.c    |  4 +-
 drivers/net/wireless/mwifiex/wmm.c          |  2 +-
 drivers/pci/pci.c                           |  7 +++
 drivers/s390/cio/qdio_main.c                |  1 +
 drivers/s390/cio/qdio_setup.c               |  2 +
 drivers/s390/cio/qdio_thinint.c             |  5 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 17 ++++--
 drivers/usb/gadget/u_ether.c                |  6 +-
 drivers/usb/serial/ftdi_sio.c               |  1 +
 drivers/usb/serial/ftdi_sio_ids.h           |  6 ++
 drivers/usb/serial/option.c                 |  3 +
 fs/coda/file.c                              | 70 +++++++++++++++++++++-
 fs/ecryptfs/crypto.c                        | 12 ++--
 fs/nfs/inode.c                              |  1 +
 fs/nfs/nfs4file.c                           |  2 +-
 fs/udf/inode.c                              | 93 +++++++++++++++++++----------
 include/linux/vmw_vmci_defs.h               | 11 +++-
 kernel/padata.c                             | 12 ++++
 kernel/pid_namespace.c                      |  2 +-
 lib/scatterlist.c                           |  9 +--
 mm/mmu_notifier.c                           |  2 +-
 net/9p/trans_virtio.c                       |  8 ++-
 net/bridge/br_stp_bpdu.c                    |  3 +-
 net/core/neighbour.c                        |  2 +
 net/ipv4/igmp.c                             |  8 +--
 net/key/af_key.c                            |  8 ++-
 net/xfrm/xfrm_user.c                        | 19 ++++++
 sound/core/seq/seq_clientmgr.c              | 11 +++-
 56 files changed, 642 insertions(+), 244 deletions(-)

-- 
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

