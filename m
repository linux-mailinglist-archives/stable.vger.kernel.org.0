Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EC7696CC8
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbjBNSZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjBNSZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:25:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7BC2BF38;
        Tue, 14 Feb 2023 10:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B577B81DE8;
        Tue, 14 Feb 2023 18:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF76EC433D2;
        Tue, 14 Feb 2023 18:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676399118;
        bh=GbRx4A9jojGNM22itTHjKqu6qBv//L34j0efP8SLZ3k=;
        h=From:To:Cc:Subject:Date:From;
        b=lFa1JVJinSPuvEcfDd8iLcJFkbAM7HcTyaU0LjOKgmqYtpgScC0pKwEvT1LanAncM
         bLlsxPDUsjcaSBqV6DF25BFc6frPfR8YBHS1jwpvYuCRH8WxQU+IuQDEbF5A355Loo
         9pyQnFaor37waA0fsWiny+AyQET0kVjnOOpHJN6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.94
Date:   Tue, 14 Feb 2023 19:25:09 +0100
Message-Id: <1676399110121196@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.94 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst   |   92 ++++++++++++++
 Documentation/admin-guide/hw-vuln/index.rst              |    1 
 Makefile                                                 |    2 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi               |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi        |    6 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                |    6 
 arch/powerpc/kernel/interrupt.c                          |    6 
 arch/riscv/kernel/stacktrace.c                           |    3 
 arch/riscv/mm/cacheflush.c                               |    4 
 arch/x86/include/asm/cpufeatures.h                       |    1 
 arch/x86/kernel/cpu/common.c                             |    9 +
 arch/x86/kvm/x86.c                                       |   43 ++++--
 drivers/clk/ingenic/jz4760-cgu.c                         |   18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                |    8 +
 drivers/gpu/drm/i915/display/intel_bios.c                |   33 +++--
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c                |    2 
 drivers/infiniband/hw/hfi1/file_ops.c                    |    7 -
 drivers/infiniband/hw/irdma/cm.c                         |    3 
 drivers/infiniband/hw/usnic/usnic_uiom.c                 |    8 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c                |    8 +
 drivers/net/bonding/bond_debugfs.c                       |    2 
 drivers/net/dsa/mt7530.c                                 |   26 ++-
 drivers/net/ethernet/intel/ice/ice_main.c                |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                |   25 +++
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c |   30 ----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |   98 +++++----------
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c  |   13 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c           |   14 +-
 drivers/net/ethernet/mscc/ocelot_flower.c                |   24 +--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c          |   15 +-
 drivers/net/phy/meson-gxl.c                              |    2 
 drivers/net/phy/phylink.c                                |    5 
 drivers/net/usb/plusb.c                                  |    4 
 drivers/of/address.c                                     |   21 ++-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                  |    2 
 drivers/pinctrl/intel/pinctrl-intel.c                    |   16 +-
 drivers/pinctrl/mediatek/pinctrl-mt8195.c                |    4 
 drivers/pinctrl/pinctrl-single.c                         |    2 
 drivers/spi/spi-dw-core.c                                |    2 
 drivers/usb/core/quirks.c                                |    3 
 drivers/usb/typec/altmodes/displayport.c                 |    8 -
 fs/btrfs/volumes.c                                       |   22 +++
 fs/btrfs/zlib.c                                          |    2 
 fs/ceph/mds_client.c                                     |    6 
 fs/cifs/file.c                                           |    4 
 include/linux/hugetlb.h                                  |    6 
 include/uapi/linux/ip.h                                  |    1 
 include/uapi/linux/ipv6.h                                |    1 
 kernel/locking/rtmutex.c                                 |    5 
 kernel/trace/trace.c                                     |    3 
 mm/gup.c                                                 |    2 
 mm/hugetlb.c                                             |   11 -
 mm/memory-failure.c                                      |    2 
 mm/memory_hotplug.c                                      |    2 
 mm/mempolicy.c                                           |    5 
 mm/migrate.c                                             |    7 -
 mm/page_alloc.c                                          |    5 
 net/can/j1939/address-claim.c                            |   40 ++++++
 net/mptcp/subflow.c                                      |   10 +
 net/rds/message.c                                        |    6 
 net/xfrm/xfrm_compat.c                                   |    4 
 net/xfrm/xfrm_input.c                                    |    3 
 sound/pci/hda/patch_realtek.c                            |    3 
 sound/pci/lx6464es/lx_core.c                             |   11 -
 sound/soc/soc-topology.c                                 |    8 -
 sound/synth/emux/emux_nrpn.c                             |    3 
 tools/testing/selftests/net/forwarding/lib.sh            |    4 
 71 files changed, 508 insertions(+), 261 deletions(-)

Adham Faris (1):
      net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change

Alan Stern (1):
      net: USB: Fix wrong-direction WARNING in plusb.c

Alexander Potapenko (1):
      btrfs: zlib: zero-initialize zlib workspace

Amadeusz Sławiński (1):
      ASoC: topology: Return -ENOMEM on memory allocation failure

Anand Jain (1):
      btrfs: free device in btrfs_close_devices for a single device filesystem

Anastasia Belova (1):
      xfrm: compat: change expression for switch in xfrm_xlate64

Andy Shevchenko (1):
      pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Anirudh Venkataramanan (1):
      ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Aravind Iddamsetty (1):
      drm/i915: Initialize the obj flags for shmem objects

Artemii Karasev (1):
      ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Christian Hopps (1):
      xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Clément Léger (1):
      net: phylink: move phy_device_free() to correctly release phy device

Dan Carpenter (1):
      ALSA: pci: lx6464es: fix a debug loop

David Chen (1):
      Fix page corruption caused by racy check in __free_pages

Dean Luick (1):
      IB/hfi1: Restore allocated resources on failed copyout

Devid Antonio Filoni (1):
      can: j1939: do not wait 250 ms if the same addr was already claimed

Dragos Tatulea (2):
      IB/IPoIB: Fix legacy IPoIB due to wrong number of queues
      net/mlx5e: IPoIB, Show unknown speed instead of error

Edson Juliano Drosdeck (1):
      ALSA: hda/realtek: Add Positivo N14KP6-TG

Elvis Angelaccio (1):
      ALSA: hda/realtek: Enable mute/micmute LEDs on HP Elitebook, 645 G9

Eric Dumazet (1):
      xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()

Greg Kroah-Hartman (1):
      Linux 5.15.94

Guilherme G. Piccoli (1):
      drm/amdgpu/fence: Fix oops due to non-matching drm_sched init/fini

Guillaume Pinot (1):
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360

Guo Ren (1):
      riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Guodong Liu (1):
      pinctrl: mediatek: Fix the drive register definition of some Pins

Hangbin Liu (1):
      selftests: forwarding: lib: quote the sysctl values

Heiner Kallweit (4):
      net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
      arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Herton R. Krzesinski (1):
      uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Joel Stanley (1):
      pinctrl: aspeed: Fix confusing types in return value

Josef Bacik (1):
      btrfs: limit device extents to the device size

Liu Shixin (1):
      riscv: stacktrace: Fix missing the first frame

Mark Brown (1):
      of/address: Return an error when no valid dma-ranges are found

Mark Pearson (1):
      usb: core: add quirk for Alcor Link AK9563 smartcard reader

Maxim Korotkov (1):
      pinctrl: single: fix potential NULL dereference

Maxim Mikityanskiy (2):
      net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover
      net/mlx5e: Introduce the mlx5e_flush_rq function

Miaohe Lin (1):
      mm/migration: return errno when isolate_huge_page failed

Mike Kravetz (1):
      migrate: hugetlb: check for hugetlb shared PMD in node migration

Neel Patel (1):
      ionic: clean interrupt before enabling queue to avoid credit race

Nicholas Piggin (1):
      powerpc/64s/interrupt: Fix interrupt exit race with security mitigation switch

Nikita Zhandarovich (1):
      RDMA/irdma: Fix potential NULL-ptr-dereference

Paolo Abeni (1):
      mptcp: be careful on subflow status propagation on errors

Paul Cercueil (1):
      clk: ingenic: jz4760: Update M/N/OD calculation algorithm

Pietro Borrello (1):
      rds: rds_rm_zerocopy_callback() use list_first_entry()

Prashant Malani (1):
      usb: typec: altmodes/displayport: Fix probe pin assign check

Qi Zheng (1):
      bonding: fix error checking in bond_debug_reregister()

Sasha Neftin (1):
      igc: Add ndo_tx_timeout support

Serge Semin (1):
      spi: dw: Fix wrong FIFO level setting for long xfers

Shay Drory (3):
      net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
      net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
      net/mlx5: Serialize module cleanup with reload and remove

Shiju Jose (1):
      tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Tom Lendacky (3):
      x86/speculation: Identify processors vulnerable to SMT RSB predictions
      KVM: x86: Mitigate the cross-thread return address predictions bug
      Documentation/hw-vuln: Add documentation for Cross-Thread Return Predictions

Ville Syrjälä (1):
      drm/i915: Fix VBT DSI DVO port handling

Vlad Buslov (1):
      net/mlx5: Bridge, fix ageing of peer FDB entries

Vladimir Oltean (2):
      net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware
      net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"

Wander Lairson Costa (1):
      rtmutex: Ensure that the top waiter is always woken up

Xiubo Li (1):
      ceph: flush cap releases when the session is flushed

Yang Yingliang (1):
      RDMA/usnic: use iommu_map_atomic() under spin_lock()

ZhaoLong Wang (1):
      cifs: Fix use-after-free in rdata->read_into_pages()

