Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E24C4DB03A
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 13:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355975AbiCPNBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355977AbiCPNBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:01:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367F365D38;
        Wed, 16 Mar 2022 05:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C769D617A6;
        Wed, 16 Mar 2022 12:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BF0C340E9;
        Wed, 16 Mar 2022 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647435591;
        bh=D5djTTr29IPHfjG2Gm+rbphyRilYjl2QNHwiZ4OY69I=;
        h=From:To:Cc:Subject:Date:From;
        b=DQ0vESjvPFl+wgmpvIRylUoDV5ijigrUg6Ki/3FLii9NyQojl38lJnQ+SC4Eookdd
         jEeeB4zVzg0odVh7J0BIkxvxWT8Brwm+NEg3x+W8su0LgECmENbgsbxlk9r8ojeZsZ
         fWHcrHBwAJiXiJsvXwQJ1vD3eoQlODEb3eXagns0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.185
Date:   Wed, 16 Mar 2022 13:59:43 +0100
Message-Id: <1647435583127@kroah.com>
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

I'm announcing the release of the 5.4.185 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi               |    2 
 arch/arm/include/asm/spectre.h                         |    6 +
 arch/arm/kernel/entry-armv.S                           |    4 -
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts |    8 ++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           |    2 
 arch/riscv/kernel/module.c                             |   21 +++++-
 arch/x86/include/asm/cpufeatures.h                     |    2 
 arch/x86/kernel/cpu/scattered.c                        |    1 
 arch/x86/kvm/svm.c                                     |    3 
 arch/x86/mm/pageattr.c                                 |    2 
 drivers/block/virtio_blk.c                             |   10 ++-
 drivers/clk/qcom/gdsc.c                                |   26 ++++++--
 drivers/clk/qcom/gdsc.h                                |    8 ++
 drivers/gpio/gpio-ts4900.c                             |   24 +++++--
 drivers/gpu/drm/sun4i/sun8i_mixer.h                    |    8 +-
 drivers/mmc/host/meson-gx-mmc.c                        |   15 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c     |    7 ++
 drivers/net/ethernet/cadence/macb_main.c               |   25 +++++++
 drivers/net/ethernet/freescale/gianfar_ethtool.c       |    1 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c          |   15 ++--
 drivers/net/ethernet/nxp/lpc_eth.c                     |    5 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c            |   18 +++--
 drivers/net/ethernet/qlogic/qed/qed_vf.c               |    7 ++
 drivers/net/ethernet/ti/cpts.c                         |    4 -
 drivers/net/ethernet/xilinx/xilinx_emaclite.c          |    4 -
 drivers/net/phy/dp83822.c                              |    2 
 drivers/net/xen-netback/xenbus.c                       |   13 +---
 drivers/nfc/port100.c                                  |    2 
 drivers/staging/gdm724x/gdm_lte.c                      |    5 -
 drivers/virtio/virtio.c                                |   39 ++++++------
 fs/ext4/resize.c                                       |    5 +
 fs/fuse/dev.c                                          |   12 +++
 fs/fuse/file.c                                         |    1 
 fs/fuse/fuse_i.h                                       |    1 
 include/linux/mlx5/mlx5_ifc.h                          |    4 -
 include/linux/virtio.h                                 |    1 
 include/linux/virtio_config.h                          |    3 
 kernel/trace/trace.c                                   |   10 +--
 net/ax25/af_ax25.c                                     |    7 ++
 net/core/net-sysfs.c                                   |    2 
 net/ipv6/addrconf.c                                    |    2 
 net/sctp/diag.c                                        |    9 --
 tools/testing/selftests/bpf/prog_tests/timer_crash.c   |   32 ++++++++++
 tools/testing/selftests/bpf/progs/timer_crash.c        |   54 +++++++++++++++++
 tools/testing/selftests/memfd/memfd_test.c             |    1 
 tools/testing/selftests/net/pmtu.sh                    |    7 +-
 tools/testing/selftests/vm/map_fixed_noreplace.c       |   49 +++++++++++----
 48 files changed, 377 insertions(+), 114 deletions(-)

Aneesh Kumar K.V (1):
      selftest/vm: fix map_fixed_noreplace test failure

Borislav Petkov (1):
      x86/cpufeatures: Mark two free bits in word 3

Clément Léger (1):
      net: phy: DP83822: clear MISR2 register to disable interrupts

Dan Carpenter (1):
      staging: gdm724x: fix use after free in gdm_lte_rx()

Duoming Zhou (1):
      ax25: Fix NULL pointer dereference in ax25_kill_by_device

Emil Renner Berthing (1):
      riscv: Fix auipc+jalr relocation range checks

Eric Dumazet (1):
      sctp: fix kernel-infoleak for SCTP sockets

Greg Kroah-Hartman (1):
      Linux 5.4.185

Guillaume Nault (1):
      selftests: pmtu.sh: Kill tcpdump processes launched by subshell.

Jeremy Linton (1):
      net: bcmgenet: Don't claim WOL when its not available

Jernej Skrabec (1):
      drm/sun4i: mixer: Fix P010 and P210 format numbers

Jia-Ju Bai (1):
      net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jiasheng Jiang (2):
      net: ethernet: ti: cpts: Handle error for clk_enable
      net: ethernet: lpc_eth: Handle error for clk_enable

Joel Stanley (1):
      ARM: dts: aspeed: Fix AST2600 quad spi group

Josh Triplett (1):
      ext4: add check to prevent attempting to resize an fs with sparse_super2

Krish Sadhukhan (3):
      x86/cpu: Add hardware-enforced cache coherency as a CPUID feature
      x86/mm/pat: Don't flush cache if hardware enforces cache coherency across encryption domnains
      KVM: SVM: Don't flush cache if hardware enforces cache coherency across encryption domains

Kumar Kartikeya Dwivedi (1):
      selftests/bpf: Add test for bpf_timer overwriting crash

Marek Marczykowski-Górecki (2):
      Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
      Revert "xen-netback: Check for hotplug-status existence before watching"

Mark Featherston (1):
      gpio: ts4900: Do not set DAT and OE together

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

Rong Chen (1):
      mmc: meson: Fix usage of meson_mmc_post_req()

Russell King (Oracle) (1):
      ARM: fix Thumb2 regression with Spectre BHB

Sven Schnelle (1):
      tracing: Ensure trace buffer is at least 4096 bytes large

Taniya Das (1):
      clk: qcom: gdsc: Add support to update GDSC transition delay

Tom Rix (1):
      qed: return status of qed_iov_get_link

Xie Yongji (1):
      virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero

suresh kumar (1):
      net-sysfs: add check for netdevice being present to speed_show

