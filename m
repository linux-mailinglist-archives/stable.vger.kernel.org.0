Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228072B9269
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 13:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgKSMOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 07:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgKSMOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 07:14:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99D8246F1;
        Thu, 19 Nov 2020 12:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605788062;
        bh=O/4nQq6gvTzuwfybq00T25Y4qJbRtQrhCpos5Jg9mhM=;
        h=From:To:Cc:Subject:Date:From;
        b=B5rQ19Ty0V5CIO7wLEjIxpz9nKZqv8yJqaCH/oesW2SRxN+1Ci9mqboOsE2TL12up
         qp8poxqiVjQAq96zqGtM0rtMWMuHZFB+zkLYqtvQFJav8mf20rlKiz4mVZJrjOq2Pz
         eIIkq87tUJ2FDEdhSYnI5K1nXXwpnoIDCvyfZ3m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.158
Date:   Thu, 19 Nov 2020 13:14:51 +0100
Message-Id: <160578809133210@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.158 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm/include/asm/kprobes.h                         |   22 
 arch/arm/probes/kprobes/opt-arm.c                      |   18 
 arch/arm64/crypto/aes-modes.S                          |   16 
 arch/s390/kernel/smp.c                                 |    3 
 arch/x86/kernel/cpu/bugs.c                             |   52 +
 drivers/block/nbd.c                                    |   10 
 drivers/char/random.c                                  |    1 
 drivers/char/tpm/eventlog/efi.c                        |    5 
 drivers/char/tpm/tpm_tis.c                             |   29 -
 drivers/gpio/gpio-pcie-idio-24.c                       |   62 ++
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c                  |   27 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c       |    4 
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h              |    1 
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h             |    2 
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c       |   29 -
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c          |    8 
 drivers/gpu/drm/gma500/psb_irq.c                       |   34 -
 drivers/hv/hv_balloon.c                                |    2 
 drivers/iommu/amd_iommu_types.h                        |    6 
 drivers/mfd/sprd-sc27xx-spi.c                          |   28 -
 drivers/misc/mei/client.h                              |    4 
 drivers/mmc/host/renesas_sdhi_core.c                   |    1 
 drivers/net/can/dev.c                                  |   14 
 drivers/net/can/flexcan.c                              |    3 
 drivers/net/can/peak_canfd/peak_canfd.c                |   11 
 drivers/net/can/rx-offload.c                           |    4 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c           |   51 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c             |   48 +
 drivers/net/ethernet/microchip/lan743x_main.c          |   12 
 drivers/net/ethernet/microchip/lan743x_main.h          |    3 
 drivers/net/ethernet/realtek/r8169.c                   |    3 
 drivers/net/vrf.c                                      |   92 ++-
 drivers/net/wan/cosa.c                                 |    1 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c          |    2 
 drivers/of/address.c                                   |    4 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                |    7 
 drivers/pinctrl/intel/pinctrl-intel.c                  |    8 
 drivers/pinctrl/pinctrl-amd.c                          |    6 
 drivers/regulator/core.c                               |    2 
 drivers/scsi/device_handler/scsi_dh_alua.c             |    9 
 drivers/scsi/hpsa.c                                    |    4 
 drivers/staging/erofs/inode.c                          |   21 
 drivers/thunderbolt/nhi.c                              |   19 
 drivers/thunderbolt/xdomain.c                          |    1 
 drivers/uio/uio.c                                      |   10 
 drivers/usb/class/cdc-acm.c                            |    9 
 drivers/usb/dwc3/gadget.c                              |   32 -
 drivers/usb/gadget/udc/goku_udc.c                      |    2 
 drivers/usb/host/xhci-histb.c                          |    2 
 drivers/vfio/platform/vfio_platform_common.c           |    3 
 fs/btrfs/dev-replace.c                                 |   26 
 fs/btrfs/extent_io.c                                   |    4 
 fs/btrfs/ioctl.c                                       |   12 
 fs/btrfs/ref-verify.c                                  |    1 
 fs/btrfs/volumes.c                                     |   33 -
 fs/cifs/cifs_unicode.c                                 |    8 
 fs/ext4/inline.c                                       |    1 
 fs/ext4/super.c                                        |    4 
 fs/gfs2/rgrp.c                                         |    5 
 fs/gfs2/super.c                                        |    1 
 fs/ocfs2/super.c                                       |    1 
 fs/xfs/libxfs/xfs_alloc.c                              |    1 
 fs/xfs/libxfs/xfs_bmap.h                               |    2 
 fs/xfs/libxfs/xfs_rmap.c                               |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c                         |   16 
 fs/xfs/scrub/bmap.c                                    |    2 
 fs/xfs/scrub/inode.c                                   |    3 
 fs/xfs/scrub/refcount.c                                |    8 
 fs/xfs/xfs_iops.c                                      |   10 
 fs/xfs/xfs_pnfs.c                                      |    2 
 include/linux/can/skb.h                                |   20 
 include/linux/netfilter_ipv4.h                         |    2 
 include/linux/netfilter_ipv6.h                         |    2 
 include/linux/prandom.h                                |   36 +
 include/linux/time64.h                                 |    4 
 kernel/dma/swiotlb.c                                   |    6 
 kernel/events/core.c                                   |    7 
 kernel/events/internal.h                               |    2 
 kernel/exit.c                                          |    5 
 kernel/futex.c                                         |    5 
 kernel/irq/Kconfig                                     |    1 
 kernel/reboot.c                                        |   28 -
 kernel/time/itimer.c                                   |    4 
 kernel/time/tick-common.c                              |    2 
 kernel/time/timer.c                                    |    7 
 lib/random32.c                                         |  462 ++++++++++-------
 net/ipv4/netfilter.c                                   |   12 
 net/ipv4/netfilter/ipt_SYNPROXY.c                      |    2 
 net/ipv4/netfilter/iptable_mangle.c                    |    2 
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c               |    2 
 net/ipv4/netfilter/nf_reject_ipv4.c                    |    2 
 net/ipv4/netfilter/nft_chain_route_ipv4.c              |    2 
 net/ipv4/syncookies.c                                  |    9 
 net/ipv6/netfilter.c                                   |    6 
 net/ipv6/netfilter/ip6table_mangle.c                   |    2 
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c               |    2 
 net/ipv6/netfilter/nft_chain_route_ipv6.c              |    2 
 net/ipv6/sit.c                                         |    2 
 net/ipv6/syncookies.c                                  |   10 
 net/iucv/af_iucv.c                                     |    3 
 net/mac80211/tx.c                                      |   37 -
 net/netfilter/ipset/ip_set_core.c                      |    3 
 net/netfilter/ipvs/ip_vs_core.c                        |    4 
 net/sched/sch_generic.c                                |    3 
 net/tipc/topsrv.c                                      |   10 
 net/wireless/reg.c                                     |    2 
 net/x25/af_x25.c                                       |    2 
 net/xfrm/xfrm_state.c                                  |    8 
 security/selinux/ibpkey.c                              |    4 
 sound/hda/ext/hdac_ext_controller.c                    |    2 
 tools/perf/util/scripting-engines/trace-event-python.c |    7 
 tools/perf/util/session.c                              |    1 
 tools/testing/selftests/proc/proc-loadavg-001.c        |    1 
 tools/testing/selftests/proc/proc-self-syscall.c       |    1 
 tools/testing/selftests/proc/proc-uptime-002.c         |    1 
 116 files changed, 1082 insertions(+), 546 deletions(-)

Al Viro (1):
      don't dump the threads that had been already exiting when zapped.

Alexander Usyskin (1):
      mei: protect mei_cl_mtu from null dereference

Anand Jain (1):
      btrfs: dev-replace: fail mount if we don't have replace item with target device

Anand K Mistry (1):
      x86/speculation: Allow IBPB to be conditionally enabled on CPUs with always-on STIBP

Andrew Jeffery (1):
      ARM: 9019/1: kprobes: Avoid fortify_panic() when copying optprobe template

Andy Shevchenko (1):
      pinctrl: intel: Set default bias in case no particular value given

Ard Biesheuvel (1):
      crypto: arm64/aes-modes - get rid of literal load of addend vector

Arnaldo Carvalho de Melo (1):
      perf scripting python: Avoid declaring function pointers with a visibility attribute

Arnaud de Turckheim (3):
      gpio: pcie-idio-24: Fix irq mask when masking
      gpio: pcie-idio-24: Fix IRQ Enable Register value
      gpio: pcie-idio-24: Enable PEX8311 interrupts

Baolin Wang (1):
      mfd: sprd: Add wakeup capability for PMIC IRQ

Billy Tsai (1):
      pinctrl: aspeed: Fix GPI only function problem.

Bob Peterson (3):
      gfs2: Free rd_bits later in gfs2_clear_rgrpd to fix use-after-free
      gfs2: Add missing truncate_inode_pages_final for sd_aspace
      gfs2: check for live vs. read-only file system in gfs2_fitrim

Boris Protopopov (1):
      Convert trailing spaces and periods in path components

Brian Foster (1):
      xfs: flush new eof page on truncate to avoid post-eof corruption

Chen Zhou (1):
      selinux: Fix error return code in sel_ib_pkey_sid_slow()

Chris Brandt (1):
      usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode

Christoph Hellwig (2):
      nbd: fix a block_device refcount leak in nbd_release
      xfs: fix a missing unlock on error in xfs_fs_map_blocks

Chunyan Zhang (1):
      tick/common: Touch watchdog in tick_unfreeze() on all CPUs

Coiby Xu (2):
      pinctrl: amd: use higher precision for 512 RtcClk
      pinctrl: amd: fix incorrect way to disable debounce filter

Dan Carpenter (3):
      ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()
      can: peak_usb: add range checking in decode operations
      futex: Don't enable IRQs unconditionally in put_pi_state()

Darrick J. Wong (6):
      xfs: set xefi_discard when creating a deferred agfl free log intent item
      xfs: fix scrub flagging rtinherit even if there is no rt device
      xfs: fix flags argument to rmap lookup when converting shared file rmaps
      xfs: set the unwritten bit in rmap lookup flags in xchk_bmap_get_rmapextents
      xfs: fix rmap key and record comparison functions
      xfs: fix brainos in the refcount scrubber's rmap fragment processor

Dinghao Liu (1):
      btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod

Evan Nimmo (1):
      of/address: Fix of_node memory leak in of_dma_is_coherent

Evan Quan (3):
      drm/amdgpu: perform srbm soft reset always on SDMA resume
      drm/amd/pm: perform SMC reset on suspend/hibernation
      drm/amd/pm: do not use ixFEATURE_STATUS for checking smc running

Evgeny Novikov (1):
      usb: gadget: goku_udc: fix potential crashes in probe

Filipe Manana (1):
      Btrfs: fix missing error return if writeback for extent buffer never started

Gao Xiang (1):
      erofs: derive atime instead of leaving it empty

George Spelvin (1):
      random32: make prandom_u32() output unpredictable

Greg Kroah-Hartman (1):
      Linux 4.19.158

Hannes Reinecke (1):
      scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()

Heiner Kallweit (1):
      r8169: fix potential skb double free in an error path

Jason A. Donenfeld (1):
      netfilter: use actual socket sk rather than skb sk when routing harder

Jerry Snitselaar (1):
      tpm_tis: Disable interrupts on ThinkPad T490s

Jing Xiangfeng (1):
      thunderbolt: Add the missed ida_simple_remove() in ring_request_msix()

Jiri Olsa (2):
      perf tools: Add missing swap for ino_generation
      perf/core: Fix race in the perf_mmap_close() function

Joakim Zhang (1):
      can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A

Johannes Berg (1):
      mac80211: fix use of skb payload instead of header

Johannes Thumshirn (1):
      btrfs: reschedule when cloning lots of extents

Josef Bacik (1):
      btrfs: sysfs: init devices outside of the chunk_mutex

Joseph Qi (1):
      ext4: unlock xattr_sem properly in ext4_inline_data_truncate()

Kaixu Xia (1):
      ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA

Keita Suzuki (1):
      scsi: hpsa: Fix memory leak in hpsa_init_one()

Mao Wenan (1):
      net: Update window_clamp if SOCK_RCVBUF is set

Marc Kleine-Budde (1):
      can: rx-offload: don't call kfree_skb() from IRQ context

Marc Zyngier (1):
      genirq: Let GENERIC_IRQ_IPI select IRQ_DOMAIN_HIERARCHY

Martin Schiller (1):
      net/x25: Fix null-ptr-deref in x25_connect

Martin Willi (1):
      vrf: Fix fast path output packet handling with async Netfilter rules

Masashi Honma (1):
      ath9k_htc: Use appropriate rs_datalen type

Matteo Croce (2):
      Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
      reboot: fix overflow parsing reboot cpu number

Matthew Wilcox (Oracle) (1):
      btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch

Michał Mirosław (1):
      regulator: defer probe when trying to get voltage from unresolved supply

Mika Westerberg (1):
      thunderbolt: Fix memory leak if ida_simple_get() fails in enumerate_services()

Ming Lei (1):
      nbd: don't update block size after device is started

Olaf Hering (1):
      hv_balloon: disable warning when floor reached

Oleksij Rempel (1):
      can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp (1):
      can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames

Oliver Herms (1):
      IPv6: Set SIT tunnel hard_header_len to zero

Peter Zijlstra (1):
      perf: Fix get_recursion_context()

Qian Cai (1):
      s390/smp: move rcu_cpu_starting() earlier

Shin'ichiro Kawasaki (1):
      uio: Fix use-after-free in uio_unregister_device()

Stefano Brivio (1):
      netfilter: ipset: Update byte and packet counters regardless of whether they match

Stefano Stabellini (1):
      swiotlb: fix "x86: Don't panic if can not alloc buffer for swiotlb"

Stephane Grosjean (2):
      can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
      can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Suravee Suthikulpanit (1):
      iommu/amd: Increase interrupt remapping table limit to 512 entries

Sven Van Asbroeck (1):
      lan743x: fix "BUG: invalid wait context" when setting rx mode

Thinh Nguyen (2):
      usb: dwc3: gadget: Continue to process pending requests
      usb: dwc3: gadget: Reclaim extra TRBs after request completion

Thomas Zimmermann (1):
      drm/gma500: Fix out-of-bounds access to struct drm_device.vblank[]

Tommi Rantala (1):
      selftests: proc: fix warning: _GNU_SOURCE redefined

Tyler Hicks (1):
      tpm: efi: Don't create binary_bios_measurements file for an empty log

Ursula Braun (1):
      net/af_iucv: fix null pointer dereference on shutdown

Vincent Mailhol (1):
      can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Wang Hai (2):
      cosa: Add missing kfree in error path of cosa_write
      tipc: fix memory leak in tipc_topsrv_start()

Wengang Wang (1):
      ocfs2: initialize ip_next_orphan

Ye Bin (1):
      cfg80211: regulatory: Fix inconsistent format argument

Yoshihiro Shimoda (1):
      mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at remove

Yunsheng Lin (1):
      net: sch_generic: fix the missing new qdisc assignment bug

Zeng Tao (1):
      time: Prevent undefined behaviour in timespec64_to_ns()

Zhang Qilong (2):
      vfio: platform: fix reference leak in vfio_platform_open
      xhci: hisilicon: fix refercence leak in xhci_histb_probe

zhuoliang zhang (1):
      net: xfrm: fix a race condition during allocing spi

