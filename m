Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7FB51F5F8
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 09:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiEIHm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 03:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiEIHme (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 03:42:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D72A1A359C;
        Mon,  9 May 2022 00:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0290EB80FD4;
        Mon,  9 May 2022 07:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2954AC385A8;
        Mon,  9 May 2022 07:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652081890;
        bh=WIadj8VNW//uGl1JKYJlAAyIGr9iOoR5iCoaPDXCub8=;
        h=From:To:Cc:Subject:Date:From;
        b=HxHnAJsBFA90zdp56ttglT68z3V6CELqln3aKdQ/NnpzHol31kQ/MxBs35lJ3pM86
         aZ7HFQk6YeLNtkg1syLpYIZKbSwspMJ4+x/m9Elllbb8kUeDYjwtKpqv5lhaYuQK6K
         dQxYfHzoj063y67mP///8ym8A7CdH2qGFsCMfd2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.38
Date:   Mon,  9 May 2022 09:37:57 +0200
Message-Id: <1652081878161118@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.38 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/am3517-evm.dts                        |   45 +++
 arch/arm/boot/dts/am3517-som.dtsi                       |    9 
 arch/arm/boot/dts/at91-sama5d3_xplained.dts             |    8 
 arch/arm/boot/dts/at91-sama5d4_xplained.dts             |    6 
 arch/arm/boot/dts/at91-sama7g5ek.dts                    |    2 
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi             |    6 
 arch/arm/boot/dts/dra7-l4.dtsi                          |    4 
 arch/arm/boot/dts/imx6qdl-apalis.dtsi                   |   10 
 arch/arm/boot/dts/imx6ull-colibri.dtsi                  |    2 
 arch/arm/boot/dts/logicpd-som-lv-35xx-devkit.dts        |   15 +
 arch/arm/boot/dts/logicpd-som-lv-37xx-devkit.dts        |   15 +
 arch/arm/boot/dts/logicpd-som-lv.dtsi                   |   15 -
 arch/arm/boot/dts/omap3-gta04.dtsi                      |    2 
 arch/arm/mach-exynos/Kconfig                            |    1 
 arch/arm/mach-omap2/omap4-common.c                      |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-a311d.dtsi       |   40 ---
 arch/arm64/boot/dts/amlogic/meson-g12b-s922x.dtsi       |   40 ---
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts   |    1 
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi              |   20 -
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi |    4 
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi |    4 
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi |    4 
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts       |    4 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi               |   10 
 arch/arm64/boot/dts/freescale/imx8qm.dtsi               |    2 
 arch/powerpc/kernel/reloc_64.S                          |   67 +++--
 arch/powerpc/kernel/vmlinux.lds.S                       |    2 
 arch/powerpc/perf/Makefile                              |    4 
 arch/powerpc/tools/relocs_check.sh                      |    7 
 arch/riscv/kernel/patch.c                               |    2 
 arch/x86/include/asm/microcode.h                        |    2 
 arch/x86/kernel/cpu/microcode/core.c                    |    6 
 arch/x86/lib/usercopy_64.c                              |    2 
 arch/x86/pci/xen.c                                      |    6 
 arch/x86/power/cpu.c                                    |   10 
 arch/xtensa/platforms/iss/console.c                     |    8 
 block/blk-iocost.c                                      |   12 
 drivers/acpi/processor_idle.c                           |    8 
 drivers/base/arch_topology.c                            |    2 
 drivers/bus/mhi/pci_generic.c                           |    2 
 drivers/bus/sunxi-rsb.c                                 |    2 
 drivers/bus/ti-sysc.c                                   |   16 +
 drivers/clk/sunxi/clk-sun9i-mmc.c                       |    2 
 drivers/cpufreq/qcom-cpufreq-hw.c                       |   27 +-
 drivers/cpufreq/sun50i-cpufreq-nvmem.c                  |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c   |   83 ++----
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c   |    1 
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c   |   34 +-
 drivers/gpu/drm/i915/i915_reg.h                         |    2 
 drivers/gpu/drm/sun4i/sun4i_frontend.c                  |    3 
 drivers/iio/dac/ad5446.c                                |    2 
 drivers/iio/dac/ad5592r-base.c                          |    2 
 drivers/iio/imu/bmi160/bmi160_core.c                    |   20 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c         |   15 -
 drivers/iio/magnetometer/ak8975.c                       |    1 
 drivers/interconnect/qcom/sdx55.c                       |   21 -
 drivers/memory/renesas-rpc-if.c                         |   60 +++-
 drivers/misc/eeprom/at25.c                              |   19 -
 drivers/mtd/nand/raw/mtk_ecc.c                          |   12 
 drivers/mtd/nand/raw/qcom_nandc.c                       |   24 -
 drivers/mtd/nand/raw/sh_flctl.c                         |   14 -
 drivers/net/bonding/bond_main.c                         |   13 
 drivers/net/dsa/lantiq_gswip.c                          |    3 
 drivers/net/dsa/mv88e6xxx/port_hidden.c                 |    5 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c        |    9 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c          |    7 
 drivers/net/ethernet/freescale/fec_main.c               |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c         |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  |   31 +-
 drivers/net/ethernet/ibm/ibmvnic.c                      |  129 ++-------
 drivers/net/ethernet/ibm/ibmvnic.h                      |    6 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c          |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c     |   12 
 drivers/net/hippi/rrunner.c                             |    2 
 drivers/net/phy/marvell10g.c                            |    2 
 drivers/net/virtio_net.c                                |   20 +
 drivers/net/wireguard/device.c                          |    3 
 drivers/phy/amlogic/phy-meson-g12a-usb3-pcie.c          |   20 -
 drivers/phy/motorola/phy-mapphone-mdm6600.c             |    3 
 drivers/phy/samsung/phy-exynos5250-sata.c               |   21 +
 drivers/phy/ti/phy-am654-serdes.c                       |    2 
 drivers/phy/ti/phy-omap-usb2.c                          |    2 
 drivers/pinctrl/mediatek/Kconfig                        |    1 
 drivers/pinctrl/pinctrl-pistachio.c                     |    6 
 drivers/pinctrl/pinctrl-rockchip.c                      |   45 ++-
 drivers/pinctrl/samsung/Kconfig                         |   11 
 drivers/pinctrl/stm32/pinctrl-stm32.c                   |   23 +
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    4 
 drivers/tty/n_gsm.c                                     |  209 ++++++++--------
 drivers/tty/serial/8250/8250_pci.c                      |    8 
 drivers/tty/serial/8250/8250_port.c                     |    2 
 drivers/tty/serial/amba-pl011.c                         |    9 
 drivers/tty/serial/imx.c                                |    2 
 drivers/usb/cdns3/cdns3-gadget.c                        |    7 
 drivers/usb/core/devio.c                                |   14 -
 drivers/usb/core/quirks.c                               |    6 
 drivers/usb/dwc3/core.c                                 |   11 
 drivers/usb/dwc3/drd.c                                  |   11 
 drivers/usb/dwc3/dwc3-pci.c                             |    8 
 drivers/usb/dwc3/gadget.c                               |   31 ++
 drivers/usb/gadget/configfs.c                           |    2 
 drivers/usb/gadget/function/uvc_queue.c                 |    2 
 drivers/usb/host/xhci-hub.c                             |    2 
 drivers/usb/host/xhci-pci.c                             |    4 
 drivers/usb/host/xhci-ring.c                            |    1 
 drivers/usb/host/xhci-tegra.c                           |    4 
 drivers/usb/host/xhci.c                                 |   11 
 drivers/usb/misc/uss720.c                               |    3 
 drivers/usb/mtu3/mtu3_dr.c                              |    6 
 drivers/usb/phy/phy-generic.c                           |    7 
 drivers/usb/serial/cp210x.c                             |    2 
 drivers/usb/serial/option.c                             |   12 
 drivers/usb/serial/whiteheat.c                          |    5 
 drivers/usb/typec/ucsi/ucsi.c                           |   24 +
 drivers/video/fbdev/udlfb.c                             |   14 -
 fs/btrfs/tree-log.c                                     |    1 
 fs/ceph/caps.c                                          |    4 
 fs/cifs/smb2ops.c                                       |    8 
 fs/ext4/super.c                                         |   19 -
 fs/gfs2/file.c                                          |   33 +-
 fs/io_uring.c                                           |    4 
 fs/ksmbd/smb2pdu.c                                      |   13 
 fs/ksmbd/vfs_cache.c                                    |    1 
 fs/zonefs/super.c                                       |   46 +++
 include/linux/kernel.h                                  |    2 
 include/linux/mtd/mtd.h                                 |    6 
 include/memory/renesas-rpc-if.h                         |    1 
 include/net/ip6_tunnel.h                                |    2 
 include/net/ip_tunnels.h                                |    2 
 include/net/tcp.h                                       |    8 
 lib/hexdump.c                                           |   41 ++-
 mm/kasan/quarantine.c                                   |    7 
 net/core/lwt_bpf.c                                      |    7 
 net/dsa/port.c                                          |    2 
 net/ipv4/ip_gre.c                                       |   12 
 net/ipv4/syncookies.c                                   |    8 
 net/ipv4/tcp_input.c                                    |   15 -
 net/ipv4/tcp_minisocks.c                                |    2 
 net/ipv4/tcp_output.c                                   |    1 
 net/ipv4/tcp_rate.c                                     |   11 
 net/ipv6/ip6_gre.c                                      |   16 -
 net/ipv6/netfilter.c                                    |   10 
 net/ipv6/syncookies.c                                   |    3 
 net/netfilter/ipvs/ip_vs_conn.c                         |    2 
 net/netfilter/nf_conntrack_standalone.c                 |    2 
 net/netfilter/nft_set_rbtree.c                          |    6 
 net/netfilter/nft_socket.c                              |   52 ++-
 net/sctp/sm_sideeffect.c                                |    4 
 net/smc/af_smc.c                                        |    2 
 net/tls/tls_device.c                                    |   12 
 net/xdp/xsk.c                                           |    2 
 sound/soc/codecs/wm8731.c                               |   19 -
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c       |    4 
 tools/objtool/check.c                                   |    8 
 tools/objtool/elf.c                                     |  189 ++++++++++++--
 tools/objtool/include/objtool/elf.h                     |    4 
 tools/perf/arch/arm64/util/Build                        |    1 
 tools/perf/arch/arm64/util/machine.c                    |   28 --
 tools/perf/arch/powerpc/util/Build                      |    1 
 tools/perf/arch/powerpc/util/machine.c                  |   25 -
 tools/perf/arch/s390/util/machine.c                     |   16 -
 tools/perf/util/arm-spe.c                               |    3 
 tools/perf/util/symbol-elf.c                            |    2 
 tools/perf/util/symbol.c                                |   37 ++
 tools/perf/util/symbol.h                                |    3 
 tools/testing/selftests/vm/mremap_test.c                |   83 ++++++
 167 files changed, 1476 insertions(+), 902 deletions(-)

Adam Ford (2):
      ARM: dts: am3517-evm: Fix misc pinmuxing
      ARM: dts: logicpd-som-lv: Fix wrong pinmuxing on OMAP35

Alexey Kardashevskiy (2):
      powerpc/perf: Fix 32bit compile
      powerpc/64: Add UADDR64 relocation support

Andreas Gruenbacher (4):
      gfs2: Prevent endless loops in gfs2_file_buffered_write
      gfs2: Minor retry logic cleanup
      gfs2: Make sure not to return short direct writes
      gfs2: No short reads or writes upon glock contention

Baruch Siach (1):
      net: phy: marvell10g: fix return value on error

Borislav Petkov (1):
      x86/cpu: Load microcode during restore_processor_state()

Bruno Thomsen (1):
      USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader

Chao Song (1):
      ASoC: Intel: soc-acpi: correct device endpoints for max98373

Christian Hewitt (2):
      arm64: dts: meson: remove CPU opps below 1GHz for G12B boards
      arm64: dts: meson: remove CPU opps below 1GHz for SM1 boards

Christophe JAILLET (1):
      bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Christophe Leroy (1):
      eeprom: at25: Use DMA safe buffers

Chuanhong Guo (1):
      mtd: rawnand: fix ecc parameters for mt7622

Claudiu Beznea (2):
      ARM: dts: at91: sama5d4_xplained: fix pinctrl phandle name
      ARM: dts: at91: fix pinctrl phandles

Damien Le Moal (2):
      zonefs: Fix management of open zones
      zonefs: Clear inode information flags on inode creation

Dan Vacura (1):
      usb: gadget: uvc: Fix crash when encoding data for usb request

Daniel Starke (15):
      tty: n_gsm: fix restart handling via CLD command
      tty: n_gsm: fix decoupled mux resource
      tty: n_gsm: fix mux cleanup after unregister tty device
      tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2
      tty: n_gsm: fix malformed counter for out of frame data
      tty: n_gsm: fix insufficient txframe size
      tty: n_gsm: fix wrong DLCI release order
      tty: n_gsm: fix missing explicit ldisc flush
      tty: n_gsm: fix wrong command retry handling
      tty: n_gsm: fix wrong command frame length field encoding
      tty: n_gsm: fix wrong signal octets encoding in MSC
      tty: n_gsm: fix missing tty wakeup in convergence layer type 2
      tty: n_gsm: fix reset fifo race condition
      tty: n_gsm: fix incorrect UA handling
      tty: n_gsm: fix software flow control handling

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Dany Madden (1):
      Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"

David Yat Sin (1):
      drm/amdkfd: Fix GWS queue count

Dinh Nguyen (1):
      net: ethernet: stmmac: fix write to sgmii_adapter_base

Dmitry Baryshkov (1):
      cpufreq: qcom-hw: fix the race between LMH worker and cpuhp

Duoming Zhou (2):
      arch: xtensa: platforms: Fix deadlock in rs_close()
      drivers: net: hippi: Fix deadlock in rr_close()

Eric Dumazet (2):
      tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
      tcp: make sure treq->af_specific is initialized

Eugen Hristev (1):
      ARM: dts: at91: sama7g5ek: enable pull-up on flexcom3 console lines

Evan Green (1):
      xhci: Enable runtime PM on second Alderlake controller

Eyal Birger (1):
      bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Fabio Estevam (2):
      ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue
      arm64: dts: imx8mn-ddr4-evk: Describe the 32.768 kHz PMIC clock

Fawzi Khaber (1):
      iio: imu: inv_icm42600: Fix I2C init possible nack

Filipe Manana (1):
      btrfs: fix leaked plug after failure syncing log on zoned filesystems

Florian Westphal (1):
      netfilter: nft_socket: only do sk lookups when indev is available

Francesco Ruggeri (1):
      tcp: md5: incorrect tcp_header_len for incoming connections

Geert Uytterhoeven (1):
      memory: renesas-rpc-if: Fix HF/OSPI data transfer in Manual Mode

Greg Kroah-Hartman (1):
      Linux 5.15.38

Guillaume Giraudon (1):
      arm64: dts: meson-sm1-bananapi-m5: fix wrong GPIO pin labeling for CON1

Guo Ren (1):
      riscv: patch_text: Fixup last cpu should be master

H. Nikolaus Schaller (1):
      ARM: dts: Fix mmc order for omap3-gta04

Hangyu Hua (1):
      usb: misc: fix improper handling of refcount in uss720_probe()

Heikki Krogerus (3):
      usb: typec: ucsi: Fix reuse of completion structure
      usb: typec: ucsi: Fix role swapping
      usb: dwc3: pci: add support for the Intel Meteor Lake-P

Heiner Kallweit (1):
      phy: amlogic: fix error path in phy_g12a_usb3_pcie_probe()

Henry Lin (1):
      xhci: stop polling roothubs after shutdown

Imre Deak (1):
      drm/i915: Fix SEL_FETCH_PLANE_*(PIPE_B+) register addresses

Jens Axboe (2):
      io_uring: check reserved fields for send/sendmsg
      io_uring: check reserved fields for recv/recvmsg

Jian Shen (3):
      net: hns3: clear inited state and stop client after failed to register netdev
      net: hns3: add validity check for message data length
      net: hns3: add return value for mailbox handling in PF

Jie Wang (1):
      net: hns3: modify the return code of hclge_get_ring_chain_from_mbx

Johan Hovold (2):
      serial: imx: fix overrun interrupts in DMA mode
      arm64: dts: imx8mm-venice: fix spi2 pin configuration

Jonathan Lemon (1):
      net: bcmgenet: hide status block before TX timestamping

Jouni Högander (1):
      drm/i915: Check EDID for HDR static metadata when choosing blc

Kees Cook (2):
      USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS
      thermal: int340x: Fix attr.show callback prototype

Krzysztof Kozlowski (2):
      pinctrl: samsung: fix missing GPIOLIB on ARM64 Exynos config
      phy: samsung: exynos5250-sata: fix missing device put in probe error paths

Leon Romanovsky (1):
      ixgbe: ensure IPsec VF<->PF compatibility

Lino Sanfilippo (1):
      serial: amba-pl011: do not time out prematurely when draining tx fifo

Liu Ying (1):
      arm64: dts: imx8qm: Correct SCU clock controller's compatible property

Luca Ceresoli (1):
      pinctrl: rockchip: fix RK3308 pinmux bits

Lv Ruyi (1):
      pinctrl: pistachio: fix use of irq_of_parse_and_map()

Maciej Fijalkowski (1):
      xsk: Fix l2fwd for copy mode + busy poll combo

Maciej W. Rozycki (2):
      serial: 8250: Also set sticky MCR bits in console restoration
      serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device

Macpaul Lin (1):
      usb: mtu3: fix USB 3.0 dual-role-switch from device to host

Manish Chopra (1):
      bnx2x: fix napi API usage sequence

Manivannan Sadhasivam (2):
      bus: mhi: host: pci_generic: Add missing poweroff() PM callback
      bus: mhi: host: pci_generic: Flush recovery worker during freeze

Marek Vasut (3):
      arm64: dts: imx8mn: Fix SAI nodes
      pinctrl: stm32: Do not call stm32_gpio_get() for edge triggered IRQs in EOI
      pinctrl: stm32: Keep pinctrl block clock enabled when LEVEL IRQ requested

Mark Brown (1):
      ARM: dts: at91: Map MCLK for wm8731 on at91sam9g20ek

Martin Blumenstingl (1):
      net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK

Martin Willi (1):
      netfilter: Update ip6_route_me_harder to consider L3 domain

Mathias Nyman (1):
      xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms

Max Krummenacher (1):
      ARM: dts: imx6ull-colibri: fix vqmmc regulator

Maxim Mikityanskiy (1):
      tls: Skip tls_append_frag on zero copy size

Md Sadre Alam (1):
      mtd: rawnand: qcom: fix memory corruption that causes panic

Miaoqian Lin (8):
      phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe
      ARM: OMAP2+: Fix refcount leak in omap_gic_of_init
      phy: ti: omap-usb2: Fix error handling in omap_usb2_enable_clocks
      phy: mapphone-mdm6600: Fix PM error handling in phy_mdm6600_probe
      phy: ti: Add missing pm_runtime_disable() in serdes_am654_probe
      mtd: rawnand: Fix return value check of wait_for_completion_timeout
      net: dsa: Add missing of_node_put() in dsa_port_link_register_of
      drm/amd/display: Fix memory leak in dcn21_clock_source_create

Michael Hennerich (1):
      iio: dac: ad5446: Fix read_raw not returning set value

Mikulas Patocka (3):
      hex2bin: make the function hex_to_bin constant-time
      hex2bin: fix access beyond string end
      x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

Namhyung Kim (3):
      perf symbol: Pass is_kallsyms to symbols__fixup_end()
      perf symbol: Update symbols__fixup_end()
      perf symbol: Remove arch__symbols__fixup_end()

Namjae Jeon (2):
      ksmbd: increment reference count of parent fp
      ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION

Nathan Rossi (1):
      net: dsa: mv88e6xxx: Fix port_hidden_wait to account for port_base_addr

Nikolay Aleksandrov (2):
      virtio_net: fix wrong buf address calculation when using xdp
      wireguard: device: check for metadata_dst with skb_valid_dst()

Oleksandr Ocheretnyi (1):
      mtd: fix 'part' field data corruption in mtd_info

Oliver Neukum (2):
      USB: quirks: add a Realtek card reader
      USB: quirks: add STRING quirk for VCOM device

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion

Pavel Skripkin (1):
      video: fbdev: udlfb: properly check endpoint type

Pawel Laszczak (1):
      usb: cdns3: Fix issue for clear halt endpoint

Peilin Ye (3):
      ip_gre: Make o_seqno start from 0 in native mode
      ip6_gre: Make o_seqno start from 0 in native mode
      ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode

Pengcheng Yang (3):
      ipvs: correctly print the memory size of ip_vs_conn_tab
      tcp: ensure to use the most recently sent skb when filling the rate sample
      tcp: fix F-RTO may not work correctly when receiving DSACK

Peter Zijlstra (2):
      objtool: Fix code relocs vs weak symbols
      objtool: Fix type of reloc::addend

Ronnie Sahlberg (1):
      cifs: destage any unwritten data to the server before calling copychunk_write

Samuel Holland (1):
      drm/sun4i: Remove obsolete references to PHYS_OFFSET

Sean Anderson (1):
      usb: phy: generic: Get the vbus supply

Sidhartha Kumar (2):
      selftest/vm: verify mmap addr in mremap_test
      selftest/vm: verify remap destination address in mremap_test

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/MV32-WB

Stephen Boyd (1):
      interconnect: qcom: sdx55: Drop IP0 interconnects

Sven Peter (1):
      usb: dwc3: Try usb-role-switch first in dwc3_drd_init

Tasos Sahanidis (1):
      usb: core: Don't hold the device lock while sleeping in do_proc_control()

Tejun Heo (1):
      iocost: don't reset the inuse weight of under-weighted debtors

Thinh Nguyen (3):
      usb: dwc3: core: Fix tx/rx threshold settings
      usb: dwc3: core: Only handle soft-reset in DCTL
      usb: dwc3: gadget: Return proper request status

Thomas Gleixner (1):
      x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

Tim Harvey (1):
      ARM: dts: imx8mm-venice-gw{71xx,72xx,73xx}: fix OTG controller OC mode

Timothy Hayes (1):
      perf arm-spe: Fix addresses of synthesized SPE events

Tong Zhang (1):
      iio:imu:bmi160: disable regulator in error path

Tony Lindgren (2):
      bus: ti-sysc: Make omap3 gpt12 quirk handling SoC specific
      ARM: dts: dra7: Fix suspend warning for vpe powerdomain

Vijayavardhan Vennapusa (1):
      usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Ville Syrjälä (2):
      Revert "ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40"
      ACPI: processor: idle: Avoid falling back to C3 type C-states

Vladimir Zapolskiy (2):
      cpufreq: qcom-cpufreq-hw: Fix throttle frequency value on EPSS platforms
      cpufreq: qcom-cpufreq-hw: Clear dcvs interrupts

Volodymyr Mytnyk (1):
      netfilter: conntrack: fix udp offload timeout sysctl

Wang Qing (1):
      arch_topology: Do not set llc_sibling if llc_id is invalid

Weitao Wang (1):
      USB: Fix xhci event ring dequeue pointer ERDP update issue

Xiaobing Luo (1):
      cpufreq: fix memory leak in sun50i_cpufreq_nvmem_probe

Xin Long (1):
      sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Xiubo Li (1):
      ceph: fix possible NULL pointer dereference for req->r_session

Yang Yingliang (2):
      clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()
      net: fec: add missing of_node_put() in fec_enet_init_stop_mode()

Ye Bin (1):
      ext4: fix bug_on in start_this_handle during umount filesystem

YueHaibing (1):
      pinctrl: mediatek: moore: Fix build error

Zheyu Ma (2):
      iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()
      ASoC: wm8731: Disable the regulator when probing fails

Zizhuang Deng (1):
      iio: dac: ad5592r: Fix the missing return value.

Zqiang (1):
      kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

liuyacan (1):
      net/smc: sync err code when tcp connection was refused

suresh kumar (1):
      bonding: do not discard lowest hash bit for non layer3+4 hashing

zhangqilong (1):
      usb: xhci: tegra:Fix PM usage reference leak of tegra_xusb_unpowergate_partitions

