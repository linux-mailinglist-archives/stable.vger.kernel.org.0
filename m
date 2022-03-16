Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFF4DB19A
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbiCPNh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiCPNh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06094707C;
        Wed, 16 Mar 2022 06:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EB6D60C7E;
        Wed, 16 Mar 2022 13:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E9CC340E9;
        Wed, 16 Mar 2022 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647437800;
        bh=quH8zwSVKyG0VADcpnj2NLd0KWU7tiOuZWkKkmJCLVw=;
        h=From:To:Cc:Subject:Date:From;
        b=Rhok7x7X3PvCxIlpm0MUgYzd5JIEcw0muESvUjhueGWDDsc7GVlZCOlqzII6ei776
         mcrFvcSjIorPFi87+CYe+9OA27jcBYo53Dj2Z8/pU8d7dvNPqYOkkUoVnJUgteXvLf
         lB8ES2f99Kr2H6jeyiVFLwnbU2zzyvmxxllv8aZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.106
Date:   Wed, 16 Mar 2022 14:36:36 +0100
Message-Id: <1647437796207155@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.106 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi               |    2 
 arch/arm/boot/dts/bcm2711.dtsi                         |    1 
 arch/arm/include/asm/spectre.h                         |    6 +
 arch/arm/kernel/entry-armv.S                           |    4 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts |    8 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           |    2 
 arch/riscv/kernel/module.c                             |   21 +++-
 arch/x86/kernel/e820.c                                 |   41 ++++++---
 arch/x86/kernel/kdebugfs.c                             |   37 ++++++--
 arch/x86/kernel/ksysfs.c                               |   77 +++++++++++++----
 arch/x86/kernel/setup.c                                |   34 +++++--
 arch/x86/kernel/traps.c                                |    1 
 arch/x86/mm/ioremap.c                                  |   57 +++++++++++-
 drivers/block/virtio_blk.c                             |   10 +-
 drivers/clk/qcom/gdsc.c                                |   26 ++++-
 drivers/clk/qcom/gdsc.h                                |    8 +
 drivers/gpio/gpio-ts4900.c                             |   24 ++++-
 drivers/gpio/gpiolib.c                                 |   10 ++
 drivers/gpu/drm/sun4i/sun8i_mixer.h                    |    8 -
 drivers/hid/hid-vivaldi.c                              |    2 
 drivers/hwmon/pmbus/pmbus_core.c                       |    5 +
 drivers/isdn/hardware/mISDN/hfcpci.c                   |    6 +
 drivers/isdn/mISDN/dsp_pipeline.c                      |   52 +----------
 drivers/mmc/host/meson-gx-mmc.c                        |   15 +--
 drivers/net/dsa/mt7530.c                               |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c     |    7 +
 drivers/net/ethernet/cadence/macb_main.c               |   25 +++++
 drivers/net/ethernet/freescale/gianfar_ethtool.c       |    1 
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c         |    6 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c     |   57 +-----------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h     |    5 -
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h        |   10 +-
 drivers/net/ethernet/intel/ice/ice_common.c            |   13 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c           |   70 ++++++---------
 drivers/net/ethernet/intel/ice/ice_main.c              |   12 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c       |   18 ---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c          |   15 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c       |   11 +-
 drivers/net/ethernet/nxp/lpc_eth.c                     |    5 -
 drivers/net/ethernet/qlogic/qed/qed_sriov.c            |   18 ++-
 drivers/net/ethernet/qlogic/qed/qed_vf.c               |    7 +
 drivers/net/ethernet/ti/cpts.c                         |    4 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c          |    4 
 drivers/net/phy/dp83822.c                              |    2 
 drivers/net/xen-netback/xenbus.c                       |   14 +--
 drivers/nfc/port100.c                                  |    2 
 drivers/spi/spi-rockchip.c                             |   13 ++
 drivers/staging/gdm724x/gdm_lte.c                      |    5 -
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c          |    7 +
 drivers/staging/rtl8723bs/core/rtw_recv.c              |   10 +-
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c           |   22 ++--
 drivers/staging/rtl8723bs/core/rtw_xmit.c              |   16 +--
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c         |    2 
 drivers/virtio/virtio.c                                |   40 ++++----
 fs/ext4/resize.c                                       |    5 +
 fs/fuse/dev.c                                          |   12 ++
 fs/fuse/file.c                                         |    1 
 fs/fuse/fuse_i.h                                       |    1 
 fs/pipe.c                                              |   11 +-
 include/linux/mlx5/mlx5_ifc.h                          |    4 
 include/linux/virtio.h                                 |    1 
 include/linux/virtio_config.h                          |    3 
 include/linux/watch_queue.h                            |    3 
 kernel/trace/trace.c                                   |   10 +-
 kernel/watch_queue.c                                   |   15 +--
 net/ax25/af_ax25.c                                     |    7 +
 net/core/net-sysfs.c                                   |    2 
 net/ipv4/esp4_offload.c                                |    3 
 net/ipv6/addrconf.c                                    |    2 
 net/ipv6/esp6_offload.c                                |    3 
 net/sctp/diag.c                                        |    9 -
 net/tipc/bearer.c                                      |   12 +-
 net/tipc/link.c                                        |    9 +
 tools/testing/selftests/bpf/prog_tests/timer_crash.c   |   32 +++++++
 tools/testing/selftests/bpf/progs/timer_crash.c        |   54 +++++++++++
 tools/testing/selftests/memfd/memfd_test.c             |    1 
 tools/testing/selftests/net/pmtu.sh                    |    7 +
 tools/testing/selftests/vm/map_fixed_noreplace.c       |   49 ++++++++--
 80 files changed, 743 insertions(+), 398 deletions(-)

Alexey Khoroshilov (1):
      mISDN: Fix memory leak in dsp_pipeline_build()

Aneesh Kumar K.V (1):
      selftest/vm: fix map_fixed_noreplace test failure

Anirudh Venkataramanan (3):
      ice: Align macro names to the specification
      ice: Remove unnecessary checker loop
      ice: Rename a couple of variables

Clément Léger (1):
      net: phy: DP83822: clear MISR2 register to disable interrupts

Dan Carpenter (1):
      staging: gdm724x: fix use after free in gdm_lte_rx()

David Howells (8):
      watch_queue, pipe: Free watchqueue state after clearing pipe ring
      watch_queue: Fix to release page in ->release()
      watch_queue: Fix to always request a pow-of-2 pipe ring size
      watch_queue: Fix the alloc bitmap size to reflect notes allocated
      watch_queue: Free the alloc bitmap when the watch_queue is torn down
      watch_queue: Fix lack of barrier/sync/lock between post and read
      watch_queue: Make comment about setting ->defunct more accurate
      watch_queue: Fix filter limit check

Dmitry Torokhov (1):
      HID: vivaldi: fix sysfs attributes leak

Duoming Zhou (1):
      ax25: Fix NULL pointer dereference in ax25_kill_by_device

Emil Renner Berthing (1):
      riscv: Fix auipc+jalr relocation range checks

Eric Dumazet (1):
      sctp: fix kernel-infoleak for SCTP sockets

Greg Kroah-Hartman (1):
      Linux 5.10.106

Guillaume Nault (1):
      selftests: pmtu.sh: Kill tcpdump processes launched by subshell.

Hans de Goede (1):
      staging: rtl8723bs: Fix access-point mode deadlock

Jacob Keller (2):
      i40e: stop disabling VFs due to PF error responses
      ice: stop disabling VFs due to PF error responses

Jedrzej Jagielski (1):
      ice: Fix curr_link_speed advertised speed

Jeremy Linton (1):
      net: bcmgenet: Don't claim WOL when its not available

Jernej Skrabec (1):
      drm/sun4i: mixer: Fix P010 and P210 format numbers

Jia-Ju Bai (2):
      isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()
      net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jiasheng Jiang (2):
      net: ethernet: ti: cpts: Handle error for clk_enable
      net: ethernet: lpc_eth: Handle error for clk_enable

Joel Stanley (1):
      ARM: dts: aspeed: Fix AST2600 quad spi group

Jon Lin (2):
      spi: rockchip: Fix error in getting num-cs property
      spi: rockchip: terminate dma transmission when slave abort

Josh Triplett (1):
      ext4: add check to prevent attempting to resize an fs with sparse_super2

Kumar Kartikeya Dwivedi (1):
      selftests/bpf: Add test for bpf_timer overwriting crash

Li Huafei (1):
      x86/traps: Mark do_int3() NOKPROBE_SYMBOL

Marek Marczykowski-Górecki (2):
      Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
      Revert "xen-netback: Check for hotplug-status existence before watching"

Mark Featherston (1):
      gpio: ts4900: Do not set DAT and OE together

Maxime Ripard (1):
      ARM: boot: dts: bcm2711: Fix HVS register range

Miaoqian Lin (2):
      ethernet: Fix error handling in xemaclite_of_probe
      gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Michael S. Tsirkin (2):
      virtio: unexport virtio_finalize_features
      virtio: acknowledge all features before access

Mike Kravetz (1):
      selftests/memfd: clean up mapping in mfd_fail_write

Miklos Szeredi (1):
      fuse: fix pipe buffer lifetime for direct_io

Mohammad Kabat (1):
      net/mlx5: Fix size field in bufferx_reg struct

Moshe Shemesh (1):
      net/mlx5: Fix a race on command flush flow

Niels Dossche (1):
      ipv6: prevent a possible race condition with lifetimes

Pali Rohár (2):
      arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias
      arm64: dts: marvell: armada-37xx: Remap IO space to bus address 0x0

Pavel Skripkin (1):
      NFC: port100: fix use-after-free in port100_send_complete

Randy Dunlap (1):
      ARM: Spectre-BHB: provide empty stub for non-config

Robert Hancock (1):
      net: macb: Fix lost RX packet wakeup race in NAPI receive

Roi Dayan (1):
      net/mlx5e: Lag, Only handle events from highest priority multipath entry

Rong Chen (1):
      mmc: meson: Fix usage of meson_mmc_post_req()

Ross Philipson (2):
      x86/boot: Fix memremap of setup_indirect structures
      x86/boot: Add setup_indirect support in early_memremap_is_setup_data()

Russell King (Oracle) (2):
      net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()
      ARM: fix Thumb2 regression with Spectre BHB

Shreeya Patel (1):
      gpio: Return EPROBE_DEFER if gc->to_irq is NULL

Steffen Klassert (1):
      esp: Fix BEET mode inter address family tunneling on GSO

Sven Schnelle (1):
      tracing: Ensure trace buffer is at least 4096 bytes large

Taniya Das (1):
      clk: qcom: gdsc: Add support to update GDSC transition delay

Tom Rix (1):
      qed: return status of qed_iov_get_link

Tung Nguyen (2):
      tipc: fix kernel panic when enabling bearer
      tipc: fix incorrect order of state message data sanity check

Vikash Chandola (1):
      hwmon: (pmbus) Clear pmbus fault/warning bits after read

Xie Yongji (1):
      virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero

Zhen Lei (1):
      mISDN: Remove obsolete PIPELINE_DEBUG debugging information

suresh kumar (1):
      net-sysfs: add check for netdevice being present to speed_show

