Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C0764CD5C
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiLNPux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238508AbiLNPsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:48:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2678F28702;
        Wed, 14 Dec 2022 07:48:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4982618AF;
        Wed, 14 Dec 2022 15:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641EFC433F0;
        Wed, 14 Dec 2022 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032888;
        bh=rEdhf/10DBFJjdSPnUkKFskkw9DHCsMi+64rk+oCx28=;
        h=From:To:Cc:Subject:Date:From;
        b=ZZf0XkwkEvzeq7H6bdxwPB1jRxrOhI9dSLrUeWQpnEALLnt/xTX8nX1iWtW7UE7ay
         vPeOBBpaBVn83TKVhARYOqlW1qS7WJTsQk7pPAKvDHZpC1tO+XDr2AXujfXGFjHRFC
         tgf2UpcUEU8Z7d969dd/0GJtDCi9Gw++8x29gjMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.13
Date:   Wed, 14 Dec 2022 16:47:18 +0100
Message-Id: <167103283885128@kroah.com>
X-Mailer: git-send-email 2.39.0
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

I'm announcing the release of the 6.0.13 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 .clang-format                                                 |    1 
 Makefile                                                      |    2 
 arch/arm/boot/dts/imx7s.dtsi                                  |    4 
 arch/arm/boot/dts/rk3036-evb.dts                              |    3 
 arch/arm/boot/dts/rk3066a-mk808.dts                           |    2 
 arch/arm/boot/dts/rk3188-radxarock.dts                        |    2 
 arch/arm/boot/dts/rk3188.dtsi                                 |    3 
 arch/arm/boot/dts/rk3288-evb-act8846.dts                      |    2 
 arch/arm/boot/dts/rk3288-evb.dtsi                             |    6 
 arch/arm/boot/dts/rk3288-firefly.dtsi                         |    3 
 arch/arm/boot/dts/rk3288-miqi.dts                             |    3 
 arch/arm/boot/dts/rk3288-rock2-square.dts                     |    3 
 arch/arm/boot/dts/rk3288-vmarc-som.dtsi                       |    1 
 arch/arm/boot/dts/rk3xxx.dtsi                                 |    7 
 arch/arm/include/asm/perf_event.h                             |    2 
 arch/arm/include/asm/pgtable-nommu.h                          |    6 
 arch/arm/include/asm/pgtable.h                                |   16 
 arch/arm/mach-at91/sama5.c                                    |    2 
 arch/arm/mm/fault.c                                           |   18 
 arch/arm/mm/fault.h                                           |    9 
 arch/arm/mm/nommu.c                                           |   19 
 arch/arm64/boot/dts/rockchip/px30-evb.dts                     |   10 
 arch/arm64/boot/dts/rockchip/rk3308-evb.dts                   |   12 
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts                |    2 
 arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts               |    2 
 arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts        |    2 
 arch/arm64/boot/dts/rockchip/rk3368-r88.dts                   |    2 
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi          |    2 
 arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts             |    2 
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts            |    2 
 arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts              |    4 
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts           |    2 
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi               |    2 
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi            |    1 
 arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts    |    4 
 arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi         |    2 
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi             |    2 
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts                |    8 
 arch/loongarch/Makefile                                       |    2 
 arch/loongarch/include/asm/pgtable.h                          |    8 
 arch/loongarch/kernel/acpi.c                                  |   31 -
 arch/loongarch/kernel/setup.c                                 |    1 
 arch/loongarch/kernel/unwind_prologue.c                       |    3 
 arch/s390/kvm/vsie.c                                          |    4 
 drivers/bluetooth/btusb.c                                     |    6 
 drivers/crypto/ccp/sev-dev.c                                  |   16 
 drivers/gpio/gpio-amd8111.c                                   |    4 
 drivers/gpio/gpio-rockchip.c                                  |    1 
 drivers/gpio/gpiolib.c                                        |   42 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h                       |    7 
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                        |   24 -
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c                         |    4 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c           |    7 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c          |    3 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c             |    4 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c            |    1 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c          |    2 
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h         |    2 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                     |    6 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                         |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                        |   18 
 drivers/gpu/drm/i915/display/intel_display.c                  |   10 
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                           |    6 
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c                          |    4 
 drivers/hid/hid-core.c                                        |    3 
 drivers/hid/hid-ids.h                                         |    4 
 drivers/hid/hid-ite.c                                         |    5 
 drivers/hid/hid-lg4ff.c                                       |    6 
 drivers/hid/hid-quirks.c                                      |    3 
 drivers/hid/hid-uclogic-core.c                                |    1 
 drivers/hid/hid-uclogic-rdesc.c                               |    2 
 drivers/hid/i2c-hid/Kconfig                                   |    4 
 drivers/media/common/videobuf2/videobuf2-core.c               |  102 +++-
 drivers/media/v4l2-core/v4l2-dv-timings.c                     |   20 
 drivers/net/bonding/bond_main.c                               |    2 
 drivers/net/can/can327.c                                      |   17 
 drivers/net/can/slcan/slcan-core.c                            |   10 
 drivers/net/can/usb/esd_usb.c                                 |    6 
 drivers/net/dsa/mv88e6xxx/chip.c                              |    7 
 drivers/net/dsa/sja1105/sja1105_devlink.c                     |    2 
 drivers/net/dsa/sja1105/sja1105_main.c                        |    2 
 drivers/net/ethernet/aeroflex/greth.c                         |    1 
 drivers/net/ethernet/broadcom/Kconfig                         |    3 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c              |    4 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c    |    4 
 drivers/net/ethernet/hisilicon/hisi_femac.c                   |    2 
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                 |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                    |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                |   12 
 drivers/net/ethernet/intel/i40e/i40e_main.c                   |   19 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c            |    2 
 drivers/net/ethernet/intel/igb/igb_ethtool.c                  |    2 
 drivers/net/ethernet/marvell/mvneta.c                         |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c          |    7 
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c             |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h             |   14 
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c           |  100 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h           |    1 
 drivers/net/ethernet/microchip/encx24j600-regmap.c            |    4 
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c           |    2 
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c           |    3 
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c         |   41 +
 drivers/net/ethernet/microsoft/mana/gdma.h                    |    9 
 drivers/net/ethernet/microsoft/mana/mana_en.c                 |   16 
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c                  |    6 
 drivers/net/ethernet/renesas/ravb_main.c                      |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c         |    8 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                      |    2 
 drivers/net/ieee802154/ca8210.c                               |    2 
 drivers/net/ieee802154/cc2520.c                               |    2 
 drivers/net/macsec.c                                          |    1 
 drivers/net/mdio/fwnode_mdio.c                                |   25 -
 drivers/net/mdio/of_mdio.c                                    |    3 
 drivers/net/phy/mdio_device.c                                 |    2 
 drivers/net/phy/mxl-gpy.c                                     |   85 +++
 drivers/net/plip/plip.c                                       |    4 
 drivers/net/thunderbolt.c                                     |    1 
 drivers/net/usb/qmi_wwan.c                                    |    1 
 drivers/net/vmxnet3/vmxnet3_drv.c                             |   27 +
 drivers/net/wwan/iosm/iosm_ipc_mux.c                          |    1 
 drivers/net/xen-netback/common.h                              |    2 
 drivers/net/xen-netback/interface.c                           |    6 
 drivers/net/xen-netback/netback.c                             |  225 +++++-----
 drivers/net/xen-netback/rx.c                                  |    8 
 drivers/net/xen-netfront.c                                    |    6 
 drivers/nvme/host/core.c                                      |    8 
 drivers/platform/x86/asus-nb-wmi.c                            |   28 -
 drivers/platform/x86/asus-wmi.c                               |   86 +++
 drivers/platform/x86/asus-wmi.h                               |   10 
 drivers/regulator/slg51000-regulator.c                        |    2 
 drivers/regulator/twl6030-regulator.c                         |   15 
 drivers/s390/net/qeth_l2_main.c                               |    2 
 drivers/soundwire/dmi-quirks.c                                |   27 +
 drivers/soundwire/intel.c                                     |    1 
 drivers/spi/spi-mt65xx.c                                      |    8 
 drivers/usb/dwc3/gadget.c                                     |    3 
 drivers/video/fbdev/core/fbcon.c                              |    2 
 fs/btrfs/send.c                                               |   24 +
 fs/file.c                                                     |   11 
 fs/fscache/cookie.c                                           |    8 
 include/asm-generic/tlb.h                                     |    4 
 include/linux/cgroup.h                                        |    1 
 include/linux/mm.h                                            |   29 -
 include/linux/platform_data/x86/asus-wmi.h                    |    1 
 include/net/bluetooth/hci.h                                   |   12 
 include/net/ping.h                                            |    3 
 include/trace/events/fscache.h                                |    2 
 io_uring/io_uring.c                                           |    4 
 kernel/cgroup/cgroup-internal.h                               |    1 
 mm/gup.c                                                      |    2 
 mm/hugetlb.c                                                  |   25 -
 mm/khugepaged.c                                               |   63 ++
 mm/madvise.c                                                  |    6 
 mm/memcontrol.c                                               |   15 
 mm/memory.c                                                   |   25 -
 mm/mmu_gather.c                                               |    4 
 mm/shmem.c                                                    |   11 
 net/9p/trans_fd.c                                             |    6 
 net/9p/trans_xen.c                                            |    9 
 net/bluetooth/6lowpan.c                                       |    1 
 net/bluetooth/af_bluetooth.c                                  |    4 
 net/bluetooth/hci_codec.c                                     |   19 
 net/bluetooth/hci_core.c                                      |    8 
 net/bluetooth/hci_sync.c                                      |   19 
 net/bluetooth/iso.c                                           |    1 
 net/can/af_can.c                                              |    4 
 net/dsa/tag_hellcreek.c                                       |    3 
 net/dsa/tag_ksz.c                                             |    3 
 net/dsa/tag_sja1105.c                                         |    3 
 net/ipv4/fib_frontend.c                                       |    3 
 net/ipv4/fib_semantics.c                                      |    1 
 net/ipv4/ip_gre.c                                             |   48 +-
 net/ipv4/ping.c                                               |    7 
 net/ipv6/ip6_output.c                                         |    5 
 net/mac802154/iface.c                                         |    1 
 net/netfilter/nf_conntrack_core.c                             |    6 
 net/netfilter/nf_conntrack_netlink.c                          |   19 
 net/netfilter/nf_flow_table_offload.c                         |    6 
 net/netfilter/nft_set_pipapo.c                                |    5 
 net/nfc/nci/ntf.c                                             |    6 
 net/tipc/link.c                                               |    4 
 net/tipc/node.c                                               |   12 
 net/unix/diag.c                                               |   20 
 sound/core/seq/seq_memory.c                                   |   11 
 sound/pci/hda/patch_realtek.c                                 |   62 +-
 sound/soc/codecs/rt711-sdca-sdw.c                             |    2 
 sound/soc/codecs/wm8962.c                                     |    8 
 sound/soc/soc-pcm.c                                           |    2 
 tools/testing/selftests/net/config                            |    2 
 tools/testing/selftests/net/fcnal-test.sh                     |   11 
 tools/testing/selftests/net/fib_tests.sh                      |   37 +
 tools/testing/selftests/net/pmtu.sh                           |   10 
 tools/testing/selftests/net/rtnetlink.sh                      |    2 
 195 files changed, 1461 insertions(+), 627 deletions(-)

Akihiko Odaki (2):
      e1000e: Fix TX dispatch condition
      igb: Allocate MSI-X vector when testing

Alexandra Winter (1):
      s390/qeth: fix use-after-free in hsci

Anastasia Belova (1):
      HID: hid-lg4ff: Add check for empty lbuf

Andreas Kemnade (1):
      regulator: twl6030: fix get status of twl6032 regulators

Ankit Patel (1):
      HID: usbhid: Add ALWAYS_POLL quirk for some mice

Artem Chernyshev (3):
      net: dsa: ksz: Check return value
      net: dsa: hellcreek: Check return value
      net: dsa: sja1105: Check return value

Aurabindo Pillai (1):
      drm/amd/display: fix array index out of bound error in DCN32 DML

Benjamin Tissoires (1):
      HID: fix I2C_HID not selected when I2C_HID_OF_ELAN is

Casper Andersson (1):
      net: microchip: sparx5: correctly free skb in xmit

Chancel Liu (1):
      ASoC: wm8962: Wait for updated value of WM8962_CLOCKING1 register

Chen Zhongjin (1):
      Bluetooth: Fix not cleanup led when bt_init fails

Chethan T N (2):
      Bluetooth: Remove codec id field in vendor codec definition
      Bluetooth: Fix support for Read Local Supported Codecs V2

Dan Carpenter (2):
      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
      net: mvneta: Fix an out of bounds check

Daniel Díaz (1):
      selftests/net: Find nettest in current directory

Dave Wysochanski (1):
      fscache: Fix oops due to race with cookie_lru and use_cookie

Davide Tronchin (1):
      net: usb: qmi_wwan: add u-blox 0x1342 composition

Dawei Li (1):
      drm/vmwgfx: Fix race issue calling pin_user_pages

Dillon Varone (2):
      drm/amd/display: Use viewport height for subvp mall allocation size
      drm/amd/display: Use new num clk levels struct for max mclk index

Dominique Martinet (1):
      9p/xen: check logical size for buffer size

Eli Cohen (1):
      net/mlx5: Lag, avoid lockdep warnings

Emeel Hakim (1):
      macsec: add missing attribute validation for offload

Eric Dumazet (1):
      ipv6: avoid use-after-free in ip6_fragment()

FUKAUMI Naoki (1):
      arm64: dts: rockchip: keep I2S1 disabled for GPIO function on ROCK Pi 4 series

Filipe Manana (1):
      btrfs: send: avoid unaligned encoded writes when attempting to clone range

Florian Westphal (1):
      inet: ping: use hlist_nulls rcu iterator during lookup

Francesco Dolcini (1):
      Revert "ARM: dts: imx7: Fix NAND controller size-cells"

Frank Jungclaus (1):
      can: esd_usb: Allow REC and TEC to return to zero

Furkan Kardame (3):
      arm64: dts: rockchip: Fix gmac failure of rgmii-id from rk3566-roc-pc
      arm64: dts: rockchip: Fix i2c3 pinctrl on rk3566-roc-pc
      arm64: dts: rockchip: remove i2c5 from rk3566-roc-pc

GUO Zihua (1):
      9p/fd: Use P9_HDRSZ for header size

Giulio Benetti (1):
      ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation

Greg Kroah-Hartman (1):
      Linux 6.0.13

Guillaume BRUN (1):
      drm: bridge: dw_hdmi: fix preference of RGB modes over YUV420

Haiyang Zhang (1):
      net: mana: Fix race on per-CQ variable napi work_done

Hangbin Liu (2):
      ip_gre: do not report erspan version on GRE interface
      bonding: get correct NA dest address

Hans Verkuil (2):
      media: videobuf2-core: take mmap_lock in vb2_get_unmapped_area()
      media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Hans de Goede (1):
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10

Harshit Mogalapalli (1):
      io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()

Hauke Mehrtens (1):
      ca8210: Fix crash by zero initializing data

Huacai Chen (2):
      LoongArch: Combine acpi_boot_table_init() and acpi_boot_init()
      LoongArch: Set _PAGE_DIRTY only if _PAGE_MODIFIED is set in {pmd,pte}_mkwrite()

Hugh Dickins (1):
      tmpfs: fix data loss from failed fallocate

Ido Schimmel (2):
      ipv4: Fix incorrect route flushing when source address is deleted
      ipv4: Fix incorrect route flushing when table ID 0 is used

Ismael Ferreras Morezuelas (2):
      Bluetooth: btusb: Fix CSR clones again by re-adding ERR_DATA_REPORTING quirk
      Bluetooth: btusb: Add debug message for CSR controllers

Jann Horn (4):
      fs: use acquire ordering in __fget_light()
      mm/khugepaged: take the right locks for page table retraction
      mm/khugepaged: fix GUP-fast interaction by sending IPI
      mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths

Jarkko Sakkinen (1):
      crypto: ccp - Add a quirk to firmware update

Jiri Slaby (SUSE) (1):
      can: slcan: fix freed work crash

Jisheng Zhang (1):
      net: stmmac: fix "snps,axi-config" node property parsing

Johan Jonker (6):
      ARM: dts: rockchip: fix adc-keys sub node names
      arm64: dts: rockchip: fix adc-keys sub node names
      ARM: dts: rockchip: fix ir-receiver node names
      arm64: dts: rockchip: fix ir-receiver node names
      ARM: dts: rockchip: rk3188: fix lcdc1-rgb24 node name
      ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188

John Starks (1):
      mm/gup: fix gup_pud_range() for dax

José Expósito (2):
      HID: uclogic: Fix frame templates for big endian architectures
      HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk

Juergen Gross (2):
      xen/netback: don't call kfree_skb() with interrupts disabled
      xen/netback: fix build warning

KaiLong Wang (1):
      LoongArch: Fix unsigned comparison with less than zero

Kees Cook (2):
      ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event
      NFC: nci: Bounds check struct nfc_target arrays

Konrad Dybcio (1):
      regulator: slg51000: Wait after asserting CS pin

Kuniyuki Iwashima (1):
      af_unix: Get user_ns from in_skb in unix_diag_get_exact().

Lin Liu (1):
      xen-netfront: Fix NULL sring after live migration

Liu Jian (2):
      net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
      net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Luiz Augusto von Dentz (1):
      Bluetooth: Fix crash when replugging CSR fake controllers

Luke D. Jones (2):
      platform/x86: asus-wmi: Adjust tablet/lidflip handling to use enum
      platform/x86: asus-wmi: Add support for ROG X13 tablet mode

Max Staudt (1):
      can: can327: flush TX_work on ldisc .close()

Michael Walle (1):
      net: phy: mxl-gpy: add MDINT workaround

Michal Jaron (1):
      i40e: Fix not setting default xps_cpus after reset

Mike Kravetz (2):
      madvise: use zap_page_range_single for madvise dontneed
      hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing

Oleksij Rempel (1):
      net: mdiobus: fwnode_mdiobus_register_phy() rework error handling

Oliver Hartkopp (1):
      can: af_can: fix NULL pointer dereference in can_rcv_filter

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark

Pankaj Raghav (1):
      nvme initialize core quirks before calling nvme_init_subsystem

Peter Rosin (1):
      ARM: at91: fix build for SAMA5D3 w/o L2 cache

Pierre-Louis Bossart (1):
      soundwire: dmi-quirks: add remapping for HP Omen 16-k0005TX

Prike Liang (1):
      drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend

Przemyslaw Patynowski (1):
      i40e: Disallow ip4 and ip6 l4_4_bytes

Qiheng Lin (1):
      net: microchip: sparx5: Fix missing destroy_workqueue of mact_queue

Qiqi Zhang (1):
      drm/bridge: ti-sn65dsi86: Fix output polarity setting bug

Radu Nicolae Pirea (OSS) (1):
      net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing()

Rob Clark (2):
      drm/shmem-helper: Remove errant put in error path
      drm/shmem-helper: Avoid vm_open error paths

Ronak Doshi (2):
      vmxnet3: correctly report encapsulated LRO packet
      vmxnet3: use correct intrConf reference when using extended queues

Ross Lagerwall (1):
      xen/netback: Ensure protocol headers don't fall in the non-linear area

Ruijing Dong (1):
      drm/amdgpu/vcn: update vcn4 fw shared data structure

Sebastian Reichel (3):
      arm64: dts: rockchip: fix node name for hym8563 rtc
      arm: dts: rockchip: fix node name for hym8563 rtc
      arm: dts: rockchip: remove clock-frequency from rtc

Shuming Fan (1):
      ASoC: rt711-sdca: fix the latency time of clock stop prepare state machine transitions

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix RGMII configuration at SPEED_10

Sjoerd Simons (1):
      soundwire: intel: Initialize clock stop timeout

Srinivasa Rao Mandadapu (1):
      ASoC: soc-pcm: Add NULL check in BE reparenting

Stanley.Yang (1):
      drm/amdgpu: fix use-after-free during gpu recovery

Stefano Brivio (1):
      netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one

Sylwester Dziedziuch (1):
      i40e: Fix for VF MAC address 0

Taimur Hassan (1):
      drm/amd/display: Avoid setting pixel rate divider to N/A

Takashi Iwai (1):
      ALSA: hda/realtek: More robust component matching for CS35L41

Tejun Heo (1):
      memcg: fix possible use-after-free in memcg_write_event_control()

Tetsuo Handa (1):
      fbcon: Use kzalloc() in fbcon_prepare_logo()

Thinh Nguyen (1):
      usb: dwc3: gadget: Disable GUSB2PHYCFG.SUSPHY for End Transfer

Thomas Huth (1):
      KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

Tianjia Zhang (1):
      selftests/tls: Fix tls selftests dependency to correct algorithm

Tiezhu Yang (1):
      LoongArch: Makefile: Use "grep -E" instead of "egrep"

Tomislav Novak (1):
      ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels

Valentina Goncharenko (2):
      net: encx24j600: Add parentheses to fix precedence
      net: encx24j600: Fix invalid logic in reading of MISTAT register

Ville Syrjälä (1):
      drm/i915: Remove non-existent pipes from bigjoiner pipe mask

Vladimir Oltean (1):
      net: dsa: mv88e6xxx: accept phy-mode = "internal" for internal PHY ports

Wang Kefeng (1):
      ARM: 9278/1: kfence: only handle translation faults

Wang ShaoBo (2):
      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
      Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()

Wang Yufen (1):
      gpio/rockchip: fix refcount leak in rockchip_gpiolib_register()

Wei Yongjun (1):
      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Xin Long (3):
      netfilter: flowtable_offload: fix using __this_cpu_add in preemptible
      netfilter: conntrack: fix using __this_cpu_add in preemptible
      tipc: call tipc_lxc_xmit without holding node_read_lock

Xiongfeng Wang (1):
      gpio: amd8111: Fix PCI device reference count leak

Yang Yingliang (2):
      net: mdiobus: fix double put fwnode in the error path
      net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()

Yinjun Zhang (1):
      nfp: correct desc type when header dma len is 4096

Yongqiang Liu (1):
      net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq

Yuan Can (1):
      dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()

YueHaibing (3):
      net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
      ravb: Fix potential use-after-free in ravb_rx_gbeth()
      tipc: Fix potential OOB in tipc_link_proto_rcv()

Zack Rusin (1):
      drm/vmwgfx: Don't use screen objects when SEV is active

Zeng Heng (2):
      gpiolib: fix memory leak in gpiochip_setup_dev()
      net: mdio: fix unbalanced fwnode reference count in mdio_device_release()

Zhang Changzhong (1):
      ethernet: aeroflex: fix potential skb leak in greth_init_rings()

ZhangPeng (1):
      HID: core: fix shift-out-of-bounds in hid_report_raw_event

Zhengchao Shao (4):
      selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload
      net: wwan: iosm: fix memory leak in ipc_mux_init()
      net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
      net: thunderbolt: fix memory leak in tbnet_open()

Zhichao Liu (1):
      spi: mediatek: Fix DEVAPC Violation at KO Remove

Ziyang Xuan (2):
      ieee802154: cc2520: Fix error return code in cc2520_hw_init()
      octeontx2-pf: Fix potential memory leak in otx2_init_tc()

