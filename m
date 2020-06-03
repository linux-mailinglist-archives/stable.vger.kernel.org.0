Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B8D1ECF4E
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 14:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgFCMDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 08:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgFCMCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 08:02:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E79207D0;
        Wed,  3 Jun 2020 12:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591185767;
        bh=5vatPR7dAjq60sO21C2tLG6F04xA6ESseYchDoKt4+w=;
        h=From:To:Cc:Subject:Date:From;
        b=VfSwC46UHSN8pNpeINCCxh3bCYo9PSO5gVJ+KbsZuVIh5r22DmOcZdJcqU4HEBEmh
         fO2F9dNf/k7upoc57zJy4LR2YtK5fxezTk+ff9ZYn7YOCjzomuy/UvADTSTE2A0Bex
         1cy6zy+6SNhM6ESXOoLfVTCCLJr6l45vO9NNvNbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.6.16
Date:   Wed,  3 Jun 2020 14:02:44 +0200
Message-Id: <1591185764117235@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.6.16 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/boot/compressed/vmlinux.lds.S                      |    2 
 arch/arm/boot/dts/bcm-hr2.dtsi                              |    6 
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts                    |    2 
 arch/arm/boot/dts/imx6q-b450v3.dts                          |    7 
 arch/arm/boot/dts/imx6q-b650v3.dts                          |    7 
 arch/arm/boot/dts/imx6q-b850v3.dts                          |   11 
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                         |   15 +
 arch/arm/boot/dts/mmp3-dell-ariel.dts                       |   12 
 arch/arm/boot/dts/mmp3.dtsi                                 |    8 
 arch/arm/boot/dts/motorola-mapphone-common.dtsi             |   43 +++
 arch/arm/boot/dts/rk3036.dtsi                               |    2 
 arch/arm/boot/dts/rk3228-evb.dts                            |    2 
 arch/arm/boot/dts/rk3229-xms6.dts                           |    2 
 arch/arm/boot/dts/rk322x.dtsi                               |    6 
 arch/arm/boot/dts/rk3xxx.dtsi                               |    2 
 arch/arm/include/asm/assembler.h                            |   75 ------
 arch/arm/include/asm/uaccess-asm.h                          |  117 +++++++++
 arch/arm/kernel/entry-armv.S                                |   11 
 arch/arm/kernel/entry-header.S                              |    9 
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                    |    4 
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi                |   19 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi                       |    2 
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts                 |    2 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                    |    8 
 arch/csky/abiv1/inc/abi/entry.h                             |    4 
 arch/csky/abiv2/inc/abi/entry.h                             |    4 
 arch/csky/include/asm/uaccess.h                             |   49 ++-
 arch/csky/kernel/entry.S                                    |    2 
 arch/csky/kernel/perf_callchain.c                           |    9 
 arch/csky/lib/usercopy.c                                    |    8 
 arch/parisc/mm/init.c                                       |    2 
 arch/powerpc/Kconfig                                        |    1 
 arch/riscv/Kconfig.socs                                     |   17 -
 arch/riscv/include/asm/mmio.h                               |    2 
 arch/riscv/include/asm/pgtable.h                            |    3 
 arch/riscv/kernel/stacktrace.c                              |    2 
 arch/x86/include/asm/dma.h                                  |    2 
 arch/x86/include/asm/io_bitmap.h                            |    4 
 arch/x86/kernel/fpu/xstate.c                                |   86 +++---
 arch/x86/kernel/ioport.c                                    |   22 -
 arch/x86/kernel/process.c                                   |    4 
 block/blk-core.c                                            |   11 
 drivers/clk/qcom/gcc-sm8150.c                               |    3 
 drivers/clk/ti/clk-33xx.c                                   |    2 
 drivers/crypto/chelsio/chtls/chtls_io.c                     |    2 
 drivers/gpio/gpio-bcm-kona.c                                |    2 
 drivers/gpio/gpio-exar.c                                    |    7 
 drivers/gpio/gpio-mvebu.c                                   |   15 -
 drivers/gpio/gpio-pxa.c                                     |    4 
 drivers/gpio/gpio-tegra.c                                   |    1 
 drivers/gpio/gpiolib.c                                      |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c            |    5 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                      |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |   12 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c      |   10 
 drivers/gpu/drm/amd/display/dc/core/dc.c                    |  124 +++++++---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c             |   40 ---
 drivers/gpu/drm/amd/display/dc/dc_stream.h                  |    1 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |   30 --
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c   |  148 +++++++++---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h   |   13 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c           |    4 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c            |   15 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h            |   20 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c       |   14 -
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c          |  108 ++++----
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.h          |    7 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c           |    5 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c            |    1 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h            |    3 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c       |    4 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c           |    5 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c       |    4 
 drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h                 |   16 +
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h           |   12 
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c               |    6 
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c                  |    6 
 drivers/gpu/drm/ingenic/ingenic-drm.c                       |    6 
 drivers/gpu/drm/meson/meson_drv.c                           |    4 
 drivers/hwmon/nct7904.c                                     |    4 
 drivers/infiniband/core/rdma_core.c                         |   20 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c                      |    8 
 drivers/infiniband/hw/mlx5/mr.c                             |    1 
 drivers/infiniband/hw/qib/qib_sysfs.c                       |    9 
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c              |    2 
 drivers/infiniband/ulp/ipoib/ipoib.h                        |    4 
 drivers/infiniband/ulp/ipoib/ipoib_cm.c                     |   15 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c                     |    9 
 drivers/infiniband/ulp/ipoib/ipoib_main.c                   |   10 
 drivers/input/evdev.c                                       |   19 -
 drivers/input/joystick/xpad.c                               |   12 
 drivers/input/keyboard/dlink-dir685-touchkeys.c             |    2 
 drivers/input/rmi4/rmi_driver.c                             |    5 
 drivers/input/serio/i8042-x86ia64io.h                       |    7 
 drivers/input/touchscreen/usbtouchscreen.c                  |    1 
 drivers/iommu/iommu.c                                       |    2 
 drivers/mmc/core/block.c                                    |    2 
 drivers/net/bonding/bond_sysfs_slave.c                      |    4 
 drivers/net/dsa/mt7530.c                                    |    9 
 drivers/net/dsa/mt7530.h                                    |    1 
 drivers/net/dsa/ocelot/felix.c                              |   23 -
 drivers/net/dsa/ocelot/felix.h                              |    6 
 drivers/net/dsa/ocelot/felix_vsc9959.c                      |   22 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   16 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                   |    5 
 drivers/net/ethernet/freescale/Kconfig                      |    2 
 drivers/net/ethernet/freescale/dpaa/Kconfig                 |    1 
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c              |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c              |    2 
 drivers/net/ethernet/mellanox/mlx4/fw.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c               |   59 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en.h                |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c           |   12 
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c             |    9 
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                |    3 
 drivers/net/ethernet/mellanox/mlx5/core/events.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c           |   17 -
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c       |    4 
 drivers/net/ethernet/mellanox/mlx5/core/main.c              |    7 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c              |   14 -
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c              |    8 
 drivers/net/ethernet/microchip/encx24j600.c                 |    5 
 drivers/net/ethernet/mscc/ocelot.c                          |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c         |    4 
 drivers/net/ethernet/realtek/r8169_main.c                   |   17 +
 drivers/net/ethernet/sgi/ioc3-eth.c                         |    8 
 drivers/net/ethernet/sun/cassini.c                          |    3 
 drivers/net/ethernet/ti/cpsw.c                              |    4 
 drivers/net/hamradio/bpqether.c                             |    3 
 drivers/net/usb/cdc_ether.c                                 |   11 
 drivers/net/usb/r8152.c                                     |    1 
 drivers/net/wireguard/messages.h                            |    2 
 drivers/net/wireguard/noise.c                               |   22 -
 drivers/net/wireguard/noise.h                               |   14 -
 drivers/net/wireguard/queueing.h                            |   10 
 drivers/net/wireguard/receive.c                             |   44 +--
 drivers/net/wireguard/selftest/counter.c                    |   17 -
 drivers/net/wireguard/send.c                                |   19 -
 drivers/soc/mediatek/mtk-cmdq-helper.c                      |    4 
 drivers/usb/dwc3/dwc3-pci.c                                 |    1 
 drivers/usb/gadget/legacy/inode.c                           |    3 
 drivers/usb/phy/phy-twl6030-usb.c                           |   12 
 drivers/virtio/virtio_balloon.c                             |  107 +++-----
 fs/binfmt_elf.c                                             |    2 
 fs/cachefiles/rdwr.c                                        |    2 
 fs/ceph/caps.c                                              |    2 
 fs/cifs/file.c                                              |    2 
 fs/gfs2/log.c                                               |    6 
 fs/gfs2/quota.c                                             |    3 
 fs/gfs2/quota.h                                             |    3 
 include/asm-generic/topology.h                              |    2 
 include/linux/ieee80211.h                                   |    2 
 include/linux/mlx5/driver.h                                 |   16 +
 include/linux/mm.h                                          |   15 +
 include/linux/netfilter/nf_conntrack_pptp.h                 |    2 
 include/net/act_api.h                                       |    3 
 include/net/espintcp.h                                      |    1 
 include/net/ip_fib.h                                        |   11 
 include/net/nexthop.h                                       |   67 ++++-
 include/net/tls.h                                           |    4 
 include/rdma/uverbs_std_types.h                             |    2 
 include/uapi/linux/xfrm.h                                   |    2 
 mm/khugepaged.c                                             |    1 
 net/ax25/af_ax25.c                                          |    6 
 net/bridge/netfilter/nft_reject_bridge.c                    |    6 
 net/ceph/osd_client.c                                       |    4 
 net/core/dev.c                                              |   20 +
 net/dsa/slave.c                                             |    1 
 net/dsa/tag_mtk.c                                           |   15 +
 net/ethtool/netlink.c                                       |    4 
 net/ethtool/strset.c                                        |    1 
 net/ipv4/esp4_offload.c                                     |    4 
 net/ipv4/fib_frontend.c                                     |   22 -
 net/ipv4/inet_connection_sock.c                             |   43 +--
 net/ipv4/ip_vti.c                                           |   23 +
 net/ipv4/ipip.c                                             |    2 
 net/ipv4/ipmr.c                                             |    2 
 net/ipv4/netfilter/nf_nat_pptp.c                            |    7 
 net/ipv4/nexthop.c                                          |  105 +++++---
 net/ipv4/route.c                                            |   14 -
 net/ipv6/esp6_offload.c                                     |   13 -
 net/ipv6/ip6_fib.c                                          |    2 
 net/ipv6/ip6mr.c                                            |    2 
 net/mac80211/mesh_hwmp.c                                    |    7 
 net/netfilter/ipset/ip_set_list_set.c                       |    2 
 net/netfilter/nf_conntrack_core.c                           |   80 +++++-
 net/netfilter/nf_conntrack_pptp.c                           |   62 ++---
 net/netfilter/nfnetlink_cthelper.c                          |    3 
 net/qrtr/qrtr.c                                             |    2 
 net/sctp/sm_sideeffect.c                                    |   14 -
 net/sctp/sm_statefuns.c                                     |    9 
 net/tipc/udp_media.c                                        |    6 
 net/tls/tls_sw.c                                            |   50 +++-
 net/wireless/core.c                                         |    2 
 net/xdp/xdp_umem.c                                          |    8 
 net/xfrm/espintcp.c                                         |    2 
 net/xfrm/xfrm_device.c                                      |    8 
 net/xfrm/xfrm_input.c                                       |    2 
 net/xfrm/xfrm_interface.c                                   |   21 +
 net/xfrm/xfrm_output.c                                      |   15 -
 net/xfrm/xfrm_policy.c                                      |    7 
 samples/bpf/lwt_len_hist_user.c                             |    2 
 security/commoncap.c                                        |    1 
 sound/core/hwdep.c                                          |    4 
 sound/pci/hda/patch_realtek.c                               |   39 ++-
 sound/usb/mixer.c                                           |    8 
 sound/usb/mixer_maps.c                                      |   24 +
 sound/usb/quirks-table.h                                    |   26 ++
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c          |    1 
 213 files changed, 1809 insertions(+), 1016 deletions(-)

Al Viro (2):
      csky: Fixup raw_copy_from_user()
      copy_xstate_to_kernel(): don't leave parts of destination uninitialized

Alexander Dahl (1):
      x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Alexander Potapenko (1):
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Amy Shih (1):
      hwmon: (nct7904) Fix incorrect range of temperature limit registers

Andreas Gruenbacher (1):
      gfs2: Grab glock reference sooner in gfs2_add_revoke

Andrew Oakley (1):
      ALSA: usb-audio: add mapping for ASRock TRX40 Creator

Andy Shevchenko (1):
      usb: dwc3: pci: Enable extcon driver for Intel Merrifield

Anthony Koo (3):
      drm/amd/display: Split program front end part that occur outside lock
      drm/amd/display: Indicate dsc updates explicitly
      drm/amd/display: Added locking for atomic update stream and update planes

Antony Antony (1):
      xfrm: fix error in comment

Aric Cyr (2):
      drm/amd/display: Use cursor locking to prevent flip delays
      drm/amd/display: Fix potential integer wraparound resulting in a hang

Arnd Bergmann (2):
      net: freescale: select CONFIG_FIXED_PHY where needed
      include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Bernard Zhao (1):
      drm/meson: pm resume add return errno branch

Björn Töpel (1):
      xsk: Add overflow check for u64 division, stored into u32

Bob Peterson (1):
      gfs2: move privileged user check to gfs2_quota_lock_check

Boris Sukholitko (1):
      __netif_receive_skb_core: pass skb by reference

Brendan Shanks (1):
      Input: evdev - call input_flush_device() on release(), not flush()

Changming Liu (1):
      ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Chris Chiu (1):
      ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Christophe JAILLET (2):
      usb: phy: twl6030-usb: Fix a resource leak in an error handling path in 'twl6030_usb_probe()'
      Input: dlink-dir685-touchkeys - fix a typo in driver name

Chuhong Yuan (1):
      net: microchip: encx24j600: add missed kthread_stop

Claudiu Manoil (1):
      felix: Fix initialization of ioremap resources

DENG Qingfang (1):
      net: dsa: mt7530: fix roaming from DSA user ports

David Ahern (4):
      nexthop: Fix attribute checking for groups
      nexthops: Move code from remove_nexthop_from_groups to remove_nh_grp_entry
      nexthop: Expand nexthop_is_multipath in a few places
      ipv4: nexthop version of fib_info_nh_uses_dev

Denis V. Lunev (1):
      IB/i40iw: Remove bogus call to netdev_master_upper_dev_get()

Dennis YC Hsieh (1):
      soc: mediatek: cmdq: return send msg error code

Edwin Peer (1):
      bnxt_en: fix firmware message length endianness

Eran Ben Elisha (2):
      net/mlx5: Fix a race when moving command interface to events mode
      net/mlx5: Avoid processing commands before cmdif is ready

Eric Dumazet (3):
      ax25: fix setsockopt(SO_BINDTODEVICE)
      tipc: block BH before using dst_cache
      crypto: chelsio/chtls: properly set tp->lsndtime

Eric W. Biederman (1):
      exec: Always set cap_ambient in cap_bprm_set_creds

Evan Green (1):
      Input: synaptics-rmi4 - really fix attn_data use-after-free

Evan Quan (2):
      drm/amdgpu: drop unnecessary cancel_delayed_work_sync on PG ungate
      drm/amd/powerplay: perform PG ungate prior to CG ungate

Felix Kuehling (1):
      drm/amdgpu: Use GEM obj reference for KFD BOs

Greg Kroah-Hartman (2):
      Revert "virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM""
      Linux 5.6.16

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during suspend

Hamish Martin (1):
      ARM: dts: bcm: HR2: Fix PPI interrupt types

Heiner Kallweit (1):
      r8169: fix OCP access on RTL8117

Helge Deller (1):
      parisc: Fix kernel panic in mem_init()

Hsin-Yi Wang (1):
      arm64: dts: mt8173: fix vcodec-enc clock

Hugh Dickins (1):
      mm,thp: stop leaking unreleased file pages

James Hilliard (1):
      Input: usbtouchscreen - add support for BonXeon TP

Jason A. Donenfeld (3):
      wireguard: noise: read preshared key while taking lock
      wireguard: queueing: preserve flow hash across packet scrubbing
      wireguard: noise: separate receive counter from send counter

Jason Gunthorpe (1):
      RDMA/core: Fix double destruction of uobject

Jay Lang (1):
      x86/ioperm: Prevent a memory leak when fork fails

Jeff Layton (1):
      ceph: flush release queue when handling caps for unknown inode

Jens Axboe (1):
      Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"

Jere Leppänen (1):
      sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Jerry Lee (1):
      libceph: ignore pool overlay and cache logic on redirects

Jiri Pirko (1):
      mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case reload fails

Johan Jonker (6):
      ARM: dts: rockchip: fix phy nodename for rk3228-evb
      ARM: dts: rockchip: fix phy nodename for rk3229-xms6
      arm64: dts: rockchip: fix status for &gmac2phy in rk3328-evb.dts
      arm64: dts: rockchip: swap interrupts interrupt-names rk3399 gpu node
      ARM: dts: rockchip: swap clock-names of gpu nodes
      ARM: dts: rockchip: fix pinctrl sub nodename for spi in rk322x.dtsi

Johannes Berg (1):
      cfg80211: fix debugfs rename crash

John Stultz (1):
      kselftests: dmabuf-heaps: Fix confused return value on expected error testing

Kaike Wan (1):
      IB/qib: Call kobject_put() when kobject_init_and_add() fails

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC287

Kefeng Wang (4):
      riscv: Fix unmet direct dependencies built based on SOC_VIRT
      riscv: stacktrace: Fix undefined reference to `walk_stackframe'
      riscv: Add pgprot_writecombine/device and PAGE_SHARED defination if NOMMU
      riscv: pgtable: Fix __kernel_map_pages build error if NOMMU

Kevin Locke (1):
      Input: i8042 - add ThinkPad S230u to i8042 reset list

Konstantin Khlebnikov (1):
      mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Lei Xue (1):
      cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Leo (Hanghong) Ma (1):
      drm/amd/amdgpu: Update update_config() logic

Linus Lüssing (1):
      mac80211: mesh: fix discovery timer re-arming issue / crash

Linus Walleij (1):
      gpio: fix locking open drain IRQ lines

Liu Yibin (2):
      csky: Fixup msa highest 3 bits mask
      csky: Fixup remove duplicate irq_disable

Lubomir Rintel (3):
      ARM: dts: mmp3: Use the MMP3 compatible string for /clocks
      ARM: dts: mmp3-dell-ariel: Fix the SPI devices
      ARM: dts: mmp3: Drop usb-nop-xceiv from HSIC phy

Madhuparna Bhowmik (1):
      drivers: net: hamradio: Fix suspicious RCU usage warning in bpqether.c

Manivannan Sadhasivam (1):
      net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Mao Han (1):
      csky: Fixup perf callchain unwind

Maor Gottlieb (1):
      RDMA/mlx5: Fix NULL pointer dereference in destroy_prefetch_work

Marc Payne (1):
      r8152: support additional Microsoft Surface Ethernet Adapter variant

Martin KaFai Lau (1):
      net: inet_csk: Fix so_reuseport bind-address cache in tb->fast*

Masahiro Yamada (1):
      usb: gadget: legacy: fix redundant initialization warnings

Matteo Croce (1):
      samples: bpf: Fix build error

Michael Braun (1):
      netfilter: nft_reject_bridge: enable reject with bridge vlan

Michael Chan (1):
      bnxt_en: Fix accumulation of bp->net_stats_prev.

Michal Kubecek (1):
      ethtool: count header size in reply size estimate

Moshe Shemesh (3):
      net/mlx5: Add command entry handling completion
      net/mlx5: Fix memory leak in mlx5_events_init
      net/mlx5e: Update netdev txq on completions during closure

Nathan Chancellor (1):
      netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update

Neil Horman (1):
      sctp: Don't add the shutdown timer if its already been added

Nicholas Kazlauskas (1):
      drm/amd/display: Defer cursor lock until after VUPDATE

Nicolas Dichtel (1):
      xfrm interface: fix oops when deleting a x-netns interface

Nikolay Aleksandrov (1):
      nexthops: don't modify published nexthop groups

Pablo Neira Ayuso (5):
      netfilter: conntrack: make conntrack userspace helpers work again
      netfilter: nfnetlink_cthelper: unbreak userspace helper support
      netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
      netfilter: conntrack: comparison of unsigned in cthelper confirmation
      netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Paul Cercueil (2):
      gpu/drm: ingenic: Fix bogus crtc_atomic_check callback
      gpu/drm: Ingenic: Fix opaque pointer casted to wrong type

Peng Hao (1):
      mmc: block: Fix use-after-free issue for rpmb

Petr Mladek (1):
      powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again

Phil Sutter (1):
      netfilter: ipset: Fix subcounter update skip

Pradeep Kumar Chitrapu (1):
      ieee80211: Fix incorrect mask for default PE duration

Qiushi Wu (6):
      net: sun: fix missing release regions in cas_init_one().
      net/mlx4_core: fix a memory leak bug.
      RDMA/pvrdma: Fix missing pci disable in pvrdma_pci_probe()
      iommu: Fix reference count leak in iommu_group_alloc.
      qlcnic: fix missing release in qlcnic_83xx_interrupt_test.
      bonding: Fix reference count leak in bond_sysfs_slave_add.

Robert Beckett (1):
      ARM: dts/imx6q-bx50v3: Set display interface clock parents

Roi Dayan (3):
      net/mlx5e: Fix inner tirs handling
      net/mlx5: Fix cleaning unmanaged flow tables
      net/mlx5: Annotate mutex destroy for root ns

Roman Mashak (1):
      net sched: fix reporting the first-time use timestamp

Russell King (4):
      net: mvpp2: fix RX hashing for non-10G ports
      ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h
      ARM: uaccess: integrate uaccess_save and uaccess_restore
      ARM: uaccess: fix DACR mismatch with nested exceptions

Sabrina Dubroca (2):
      net: don't return invalid table id error when we fall back to PF_UNSPEC
      xfrm: espintcp: save and call old ->sk_destruct

Sascha Hauer (1):
      gpio: mvebu: Fix probing for chips without PWM

Shay Drory (1):
      net/mlx5: Fix error flow in case of function_setup failure

Simon Ser (1):
      drm/amd/display: drop cursor position check in atomic test

Srinivas Kandagatla (1):
      arm64: dts: qcom: db820c: fix audio configuration

Stephen Warren (1):
      gpio: tegra: mask GPIO IRQs during IRQ shutdown

Stephen Worley (1):
      net: nlmsg_cancel() if put fails for nhmsg

Steve French (1):
      cifs: Fix null pointer check in cifs_read

Takashi Iwai (3):
      gpio: exar: Fix bad handling for ida_simple_get error path
      ALSA: hda/realtek - Add a model for Thinkpad T570 without DAC workaround
      ALSA: usb-audio: Quirks for Gigabyte TRX40 Aorus Master onboard audio

Tang Bin (1):
      net: sgi: ioc3-eth: Fix return value check in ioc3eth_probe()

Tariq Toukan (1):
      net/mlx5e: kTLS, Destroy key object after destroying the TIS

Tero Kristo (1):
      clk: ti: am33xx: fix RTC clock parent

Tiezhu Yang (2):
      gpio: pxa: Fix return value of pxa_gpio_probe()
      gpio: bcm-kona: Fix return value of bcm_kona_gpio_probe()

Tony Lindgren (2):
      ARM: dts: omap4-droid4: Fix flakey wlan by disabling internal pull for gpio
      ARM: dts: omap4-droid4: Fix occasional lost wakeirq for uart1

Vadim Fedorenko (3):
      net: ipip: fix wrong address family in init error path
      net/tls: fix encryption error checking
      net/tls: free record only on encryption error

Valentine Fatiev (1):
      IB/ipoib: Fix double free of skb in case of multicast traffic in CM mode

Vinay Kumar Yadav (1):
      net/tls: fix race condition causing kernel panic

Vincent Stehlé (1):
      ARM: dts: bcm2835-rpi-zero-w: Fix led polarity

Vinod Koul (1):
      clk: qcom: gcc: Fix parent for gpll0_out_even

Vladimir Oltean (3):
      dpaa_eth: fix usage as DSA master, try 3
      net: mscc: ocelot: fix address ageing time (again)
      net: dsa: declare lockless TX feature for slave ports

Wei Yongjun (1):
      Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()

Xin Long (8):
      xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
      xfrm: do pskb_pull properly in __xfrm_transport_prep
      xfrm: remove the xfrm_state_put call becofe going to out_reset
      xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
      xfrm: fix a warning in xfrm_policy_insert_list
      xfrm: fix a NULL-ptr deref in xfrm_local_error
      ip_vti: receive ipip packet by calling ip_tunnel_rcv
      esp6: get the right proto for transport mode in esp6_gso_encap

Yuqi Jin (1):
      net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Łukasz Patron (1):
      Input: xpad - add custom init packet for Xbox One S controllers

Łukasz Stelmach (1):
      ARM: 8970/1: decompressor: increase tag size

