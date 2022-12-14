Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42D64CD58
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbiLNPty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiLNPs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:48:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D023382;
        Wed, 14 Dec 2022 07:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D7961B09;
        Wed, 14 Dec 2022 15:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A65BC433EF;
        Wed, 14 Dec 2022 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032876;
        bh=RuuriLlBrqwRVEHDnnrfeGE0ZdoqGk+2KpBpzVwdnH0=;
        h=From:To:Cc:Subject:Date:From;
        b=bidLZI5Hx2tPEONMpzi7Dwqhtq+8KONJVpRMQi4lFMzizdO/Or+sFakgOrkZQDncZ
         Z5vl4DhpHyU1dQtpMlfhQMj1vwK9Hrg9aU3n0rmBi2GUjO6zN4h4beZdBEmR4oMtsP
         UyOzOykF8sEwze1u6mDDsXpJPTyGFuXE/pjb/Dvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.83
Date:   Wed, 14 Dec 2022 16:47:13 +0100
Message-Id: <16710328334016@kroah.com>
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

I'm announcing the release of the 5.15.83 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                                |    7 
 Makefile                                                   |    6 
 arch/arm/boot/dts/imx7s.dtsi                               |    4 
 arch/arm/boot/dts/rk3036-evb.dts                           |    3 
 arch/arm/boot/dts/rk3188-radxarock.dts                     |    2 
 arch/arm/boot/dts/rk3188.dtsi                              |    3 
 arch/arm/boot/dts/rk3288-evb-act8846.dts                   |    2 
 arch/arm/boot/dts/rk3288-firefly.dtsi                      |    3 
 arch/arm/boot/dts/rk3288-miqi.dts                          |    3 
 arch/arm/boot/dts/rk3288-rock2-square.dts                  |    3 
 arch/arm/boot/dts/rk3288-vmarc-som.dtsi                    |    1 
 arch/arm/boot/dts/rk3xxx.dtsi                              |    7 
 arch/arm/include/asm/perf_event.h                          |    2 
 arch/arm/include/asm/pgtable-nommu.h                       |    6 
 arch/arm/include/asm/pgtable.h                             |   16 
 arch/arm/mm/nommu.c                                        |   19 
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts             |    2 
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi         |    1 
 arch/s390/kvm/vsie.c                                       |    4 
 block/Makefile                                             |    2 
 drivers/bluetooth/btusb.c                                  |    5 
 drivers/clk/clk-devres.c                                   |   91 
 drivers/gpio/gpio-amd8111.c                                |    4 
 drivers/gpio/gpio-rockchip.c                               |    1 
 drivers/gpio/gpiolib.c                                     |   59 
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                     |   24 
 drivers/gpu/drm/bridge/analogix/anx7625.c                  |    4 
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                  |    6 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                      |    4 
 drivers/gpu/drm/drm_gem_shmem_helper.c                     |   18 
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                        |    6 
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c                       |    4 
 drivers/hid/hid-core.c                                     |    3 
 drivers/hid/hid-ids.h                                      |    4 
 drivers/hid/hid-ite.c                                      |    5 
 drivers/hid/hid-lg4ff.c                                    |    6 
 drivers/hid/hid-quirks.c                                   |    3 
 drivers/media/common/videobuf2/videobuf2-core.c            |  102 
 drivers/media/v4l2-core/v4l2-dv-timings.c                  |   20 
 drivers/mmc/host/mtk-sd.c                                  |    6 
 drivers/net/can/usb/esd_usb2.c                             |    6 
 drivers/net/dsa/sja1105/sja1105_devlink.c                  |    2 
 drivers/net/dsa/sja1105/sja1105_main.c                     |    2 
 drivers/net/ethernet/aeroflex/greth.c                      |    1 
 drivers/net/ethernet/broadcom/Kconfig                      |    3 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c           |    4 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c |    4 
 drivers/net/ethernet/hisilicon/hisi_femac.c                |    2 
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c              |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                 |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c             |   12 
 drivers/net/ethernet/intel/i40e/i40e_main.c                |   19 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |    2 
 drivers/net/ethernet/intel/igb/igb_ethtool.c               |    2 
 drivers/net/ethernet/marvell/mvneta.c                      |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       |    7 
 drivers/net/ethernet/microchip/encx24j600-regmap.c         |    4 
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c        |    3 
 drivers/net/ethernet/microsoft/mana/gdma.h                 |    9 
 drivers/net/ethernet/microsoft/mana/mana_en.c              |   16 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c      |    8 
 drivers/net/ieee802154/ca8210.c                            |    2 
 drivers/net/ieee802154/cc2520.c                            |    2 
 drivers/net/macsec.c                                       |    1 
 drivers/net/mdio/fwnode_mdio.c                             |   25 
 drivers/net/mdio/of_mdio.c                                 |    3 
 drivers/net/phy/mdio_device.c                              |    2 
 drivers/net/phy/mxl-gpy.c                                  |   11 
 drivers/net/plip/plip.c                                    |    4 
 drivers/net/thunderbolt.c                                  |    1 
 drivers/net/usb/qmi_wwan.c                                 |    1 
 drivers/net/vmxnet3/vmxnet3_drv.c                          |   27 
 drivers/net/xen-netback/common.h                           |   14 
 drivers/net/xen-netback/interface.c                        |   22 
 drivers/net/xen-netback/netback.c                          |  229 
 drivers/net/xen-netback/rx.c                               |   10 
 drivers/net/xen-netfront.c                                 |    6 
 drivers/nvme/host/core.c                                   |    8 
 drivers/regulator/slg51000-regulator.c                     |    2 
 drivers/regulator/twl6030-regulator.c                      |   15 
 drivers/rtc/rtc-cmos.c                                     |  179 
 drivers/rtc/rtc-mc146818-lib.c                             |   70 
 drivers/s390/net/qeth_l2_main.c                            |   16 
 drivers/soundwire/intel.c                                  |    1 
 drivers/spi/spi-mt65xx.c                                   |    8 
 drivers/usb/dwc3/gadget.c                                  |    3 
 drivers/video/fbdev/core/fbcon.c                           |    2 
 fs/Makefile                                                |    2 
 fs/btrfs/send.c                                            |   24 
 fs/cifs/connect.c                                          |    1 
 fs/file.c                                                  |   11 
 fs/io-wq.c                                                 | 1398 -
 fs/io-wq.h                                                 |  160 
 fs/io_uring.c                                              |11110 ------------
 include/asm-generic/tlb.h                                  |    4 
 include/linux/cgroup.h                                     |    1 
 include/linux/clk.h                                        |  109 
 include/linux/mc146818rtc.h                                |    3 
 io_uring/Makefile                                          |    6 
 io_uring/io-wq.c                                           | 1398 +
 io_uring/io-wq.h                                           |  160 
 io_uring/io_uring.c                                        |11112 +++++++++++++
 kernel/cgroup/cgroup-internal.h                            |    1 
 kernel/sched/core.c                                        |    2 
 mm/gup.c                                                   |    2 
 mm/khugepaged.c                                            |   47 
 mm/memcontrol.c                                            |   15 
 mm/mmu_gather.c                                            |    4 
 net/9p/trans_fd.c                                          |    6 
 net/9p/trans_xen.c                                         |    9 
 net/bluetooth/6lowpan.c                                    |    1 
 net/bluetooth/af_bluetooth.c                               |    4 
 net/bluetooth/hci_core.c                                   |    3 
 net/can/af_can.c                                           |    4 
 net/dsa/tag_hellcreek.c                                    |    3 
 net/dsa/tag_ksz.c                                          |    3 
 net/dsa/tag_sja1105.c                                      |    3 
 net/ipv4/fib_frontend.c                                    |    3 
 net/ipv4/fib_semantics.c                                   |    1 
 net/ipv4/ip_gre.c                                          |   48 
 net/ipv6/ip6_output.c                                      |    5 
 net/mac802154/iface.c                                      |    1 
 net/netfilter/nf_conntrack_netlink.c                       |   19 
 net/netfilter/nft_set_pipapo.c                             |    5 
 net/nfc/nci/ntf.c                                          |    6 
 net/tipc/link.c                                            |    4 
 net/tipc/node.c                                            |   12 
 net/unix/diag.c                                            |   20 
 sound/core/seq/seq_memory.c                                |   11 
 sound/soc/codecs/rt711-sdca-sdw.c                          |    2 
 sound/soc/codecs/wm8962.c                                  |    8 
 sound/soc/soc-pcm.c                                        |    2 
 tools/testing/selftests/net/fcnal-test.sh                  |   11 
 tools/testing/selftests/net/fib_tests.sh                   |   37 
 tools/testing/selftests/net/pmtu.sh                        |   10 
 tools/testing/selftests/net/rtnetlink.sh                   |    2 
 136 files changed, 13901 insertions(+), 13161 deletions(-)

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

Bartosz Golaszewski (2):
      gpiolib: improve coding style for local variables
      gpiolib: check the 'ngpios' property in core gpiolib code

Chancel Liu (1):
      ASoC: wm8962: Wait for updated value of WM8962_CLOCKING1 register

Chen Zhongjin (1):
      Bluetooth: Fix not cleanup led when bt_init fails

Dan Carpenter (2):
      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
      net: mvneta: Fix an out of bounds check

Daniel Díaz (1):
      selftests/net: Find nettest in current directory

Davide Tronchin (1):
      net: usb: qmi_wwan: add u-blox 0x1342 composition

Dawei Li (1):
      drm/vmwgfx: Fix race issue calling pin_user_pages

Dominique Martinet (1):
      9p/xen: check logical size for buffer size

Emeel Hakim (1):
      macsec: add missing attribute validation for offload

Eric Dumazet (1):
      ipv6: avoid use-after-free in ip6_fragment()

FUKAUMI Naoki (1):
      arm64: dts: rockchip: keep I2S1 disabled for GPIO function on ROCK Pi 4 series

Filipe Manana (1):
      btrfs: send: avoid unaligned encoded writes when attempting to clone range

Francesco Dolcini (1):
      Revert "ARM: dts: imx7: Fix NAND controller size-cells"

Frank Jungclaus (1):
      can: esd_usb: Allow REC and TEC to return to zero

GUO Zihua (1):
      9p/fd: Use P9_HDRSZ for header size

Gaosheng Cui (1):
      mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()

Giulio Benetti (1):
      ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation

Greg Kroah-Hartman (1):
      Linux 5.15.83

Guillaume BRUN (1):
      drm: bridge: dw_hdmi: fix preference of RGB modes over YUV420

Haiyang Zhang (1):
      net: mana: Fix race on per-CQ variable napi work_done

Hangbin Liu (1):
      ip_gre: do not report erspan version on GRE interface

Hans Verkuil (2):
      media: videobuf2-core: take mmap_lock in vb2_get_unmapped_area()
      media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Hans de Goede (1):
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10

Harshit Mogalapalli (1):
      io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()

Hauke Mehrtens (1):
      ca8210: Fix crash by zero initializing data

Heiko Carstens (1):
      s390/qeth: fix various format strings

Hsin-Yi Wang (1):
      drm/bridge: anx7625: Fix edid_read break case in sp_tx_edid_read()

Ido Schimmel (2):
      ipv4: Fix incorrect route flushing when source address is deleted
      ipv4: Fix incorrect route flushing when table ID 0 is used

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Add debug message for CSR controllers

Jann Horn (4):
      fs: use acquire ordering in __fget_light()
      mm/khugepaged: take the right locks for page table retraction
      mm/khugepaged: fix GUP-fast interaction by sending IPI
      mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths

Jens Axboe (1):
      io_uring: move to separate directory

Jisheng Zhang (1):
      net: stmmac: fix "snps,axi-config" node property parsing

Johan Jonker (4):
      ARM: dts: rockchip: fix ir-receiver node names
      arm64: dts: rockchip: fix ir-receiver node names
      ARM: dts: rockchip: rk3188: fix lcdc1-rgb24 node name
      ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188

John Starks (1):
      mm/gup: fix gup_pud_range() for dax

Juergen Gross (3):
      xen/netback: do some code cleanup
      xen/netback: don't call kfree_skb() with interrupts disabled
      xen/netback: fix build warning

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

Masahiro Yamada (1):
      block: move CONFIG_BLOCK guard to top Makefile

Mateusz Jończyk (3):
      rtc: mc146818-lib: extract mc146818_avoid_UIP
      rtc: cmos: avoid UIP when writing alarm time
      rtc: cmos: avoid UIP when reading alarm time

Michael Walle (1):
      net: phy: mxl-gpy: fix version reporting

Michal Jaron (1):
      i40e: Fix not setting default xps_cpus after reset

Oleksij Rempel (1):
      net: mdiobus: fwnode_mdiobus_register_phy() rework error handling

Oliver Hartkopp (1):
      can: af_can: fix NULL pointer dereference in can_rcv_filter

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark

Pankaj Raghav (1):
      nvme initialize core quirks before calling nvme_init_subsystem

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

Sebastian Reichel (2):
      arm: dts: rockchip: fix node name for hym8563 rtc
      arm: dts: rockchip: remove clock-frequency from rtc

Shuming Fan (1):
      ASoC: rt711-sdca: fix the latency time of clock stop prepare state machine transitions

Sjoerd Simons (1):
      soundwire: intel: Initialize clock stop timeout

Srinivasa Rao Mandadapu (1):
      ASoC: soc-pcm: Add NULL check in BE reparenting

Stefano Brivio (1):
      netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one

Sylwester Dziedziuch (1):
      i40e: Fix for VF MAC address 0

Tejun Heo (1):
      memcg: fix possible use-after-free in memcg_write_event_control()

Tetsuo Handa (1):
      fbcon: Use kzalloc() in fbcon_prepare_logo()

Thinh Nguyen (1):
      usb: dwc3: gadget: Disable GUSB2PHYCFG.SUSPHY for End Transfer

Thomas Huth (1):
      KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

Tomislav Novak (1):
      ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels

Uwe Kleine-König (3):
      clk: generalize devm_clk_get() a bit
      clk: Provide new devm_clk helpers for prepared and enabled clocks
      clk: Fix pointer casting to prevent oops in devm_clk_release()

Valentina Goncharenko (2):
      net: encx24j600: Add parentheses to fix precedence
      net: encx24j600: Fix invalid logic in reading of MISTAT register

Wang ShaoBo (1):
      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()

Wang Yufen (1):
      gpio/rockchip: fix refcount leak in rockchip_gpiolib_register()

Wei Yongjun (1):
      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Xin Long (1):
      tipc: call tipc_lxc_xmit without holding node_read_lock

Xiongfeng Wang (1):
      gpio: amd8111: Fix PCI device reference count leak

Yang Yingliang (2):
      net: mdiobus: fix double put fwnode in the error path
      net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()

Yongqiang Liu (1):
      net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq

Yuan Can (1):
      dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()

YueHaibing (2):
      net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
      tipc: Fix potential OOB in tipc_link_proto_rcv()

Zack Rusin (1):
      drm/vmwgfx: Don't use screen objects when SEV is active

Zeng Heng (3):
      cifs: fix use-after-free caused by invalid pointer `hostname`
      gpiolib: fix memory leak in gpiochip_setup_dev()
      net: mdio: fix unbalanced fwnode reference count in mdio_device_release()

Zhang Changzhong (1):
      ethernet: aeroflex: fix potential skb leak in greth_init_rings()

ZhangPeng (1):
      HID: core: fix shift-out-of-bounds in hid_report_raw_event

Zhengchao Shao (3):
      selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload
      net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
      net: thunderbolt: fix memory leak in tbnet_open()

Zhichao Liu (1):
      spi: mediatek: Fix DEVAPC Violation at KO Remove

Ziyang Xuan (2):
      ieee802154: cc2520: Fix error return code in cc2520_hw_init()
      octeontx2-pf: Fix potential memory leak in otx2_init_tc()

