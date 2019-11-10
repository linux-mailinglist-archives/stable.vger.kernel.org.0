Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1CBF6A58
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfKJQvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJQvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 11:51:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7802B2080F;
        Sun, 10 Nov 2019 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573404696;
        bh=cnFNC5cLWLVDFONtGnW7YZgpxVUvYpwtQN3BoiyahEY=;
        h=Date:From:To:Cc:Subject:From;
        b=QEI1AbJFNqQNyzFKVaYw0iq0D4SvknftZAtxM73z5wl37bCUKpDMxBDo6Fnlsv4fD
         Ypd8sX/55IZ2QOtH6HuZGIRR7rGIz82aMeIm9AvTX3iY7uK6PvmeeaW1sINr0li8tC
         SnY1diqnVwwHCvTNNcUlBWPj+ZCntkP4RIE3gCUU=
Date:   Sun, 10 Nov 2019 17:51:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.10
Message-ID: <20191110165133.GA2873346@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.10 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                           |    2=
=20
 arch/arm/boot/dts/am3874-iceboard.dts                              |    9=
=20
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi                             |    8=
=20
 arch/arm/boot/dts/imx6-logicpd-som.dtsi                            |    4=
=20
 arch/arm/boot/dts/imx7s.dtsi                                       |    8=
=20
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi                         |    4=
=20
 arch/arm/boot/dts/omap4-droid4-xt894.dts                           |    2=
=20
 arch/arm/boot/dts/omap4-panda-common.dtsi                          |    2=
=20
 arch/arm/boot/dts/omap4-sdp.dts                                    |    2=
=20
 arch/arm/boot/dts/omap4-var-som-om44-wlan.dtsi                     |    2=
=20
 arch/arm/boot/dts/omap5-board-common.dtsi                          |    2=
=20
 arch/arm/boot/dts/vf610-zii-scu4-aib.dts                           |    2=
=20
 arch/arm/include/asm/domain.h                                      |    8=
=20
 arch/arm/include/asm/uaccess.h                                     |    4=
=20
 arch/arm/kernel/head-common.S                                      |    5=
=20
 arch/arm/kernel/head-nommu.S                                       |    2=
=20
 arch/arm/mach-davinci/dm365.c                                      |    4=
=20
 arch/arm/mm/alignment.c                                            |   44=
=20
 arch/arm/mm/proc-v7m.S                                             |    6=
=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts           |    9=
=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts      |    6=
=20
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                      |    9=
=20
 arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi        |    5=
=20
 arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi                |    3=
=20
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi                     |   36=
=20
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                          |    6=
=20
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi                |    4=
=20
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                          |    4=
=20
 arch/arm64/boot/dts/rockchip/rk3399-hugsun-x99.dts                 |    4=
=20
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts                  |   12=
=20
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                           |    2=
=20
 arch/mips/bcm63xx/prom.c                                           |    2=
=20
 arch/mips/include/asm/bmips.h                                      |   10=
=20
 arch/mips/kernel/smp-bmips.c                                       |    8=
=20
 drivers/block/nbd.c                                                |   18=
=20
 drivers/crypto/chelsio/chtls/chtls_cm.c                            |    2=
=20
 drivers/crypto/chelsio/chtls/chtls_io.c                            |    2=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c                        |    7=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                         |    3=
=20
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c                    |    3=
=20
 drivers/i2c/busses/i2c-aspeed.c                                    |   54=
=20
 drivers/i2c/busses/i2c-mt65xx.c                                    |    2=
=20
 drivers/i2c/busses/i2c-stm32f7.c                                   |   21=
=20
 drivers/irqchip/irq-gic-v3-its.c                                   |   21=
=20
 drivers/irqchip/irq-sifive-plic.c                                  |    4=
=20
 drivers/isdn/capi/capi.c                                           |    2=
=20
 drivers/net/dsa/b53/b53_common.c                                   |    1=
=20
 drivers/net/dsa/bcm_sf2.c                                          |   36=
=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                     |   13=
=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c                     |   28=
=20
 drivers/net/ethernet/chelsio/cxgb4/sge.c                           |    8=
=20
 drivers/net/ethernet/faraday/ftgmac100.c                           |   25=
=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                         |   15=
=20
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                        |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c            |   21=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h            |    1=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c              |   11=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c          |   28=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h          |    1=
=20
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c              |   42=
=20
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c                |   12=
=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c               |    2=
=20
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                    |    5=
=20
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c              |   15=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |    1=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |   22=
=20
 drivers/net/ethernet/mellanox/mlxsw/core.c                         |    4=
=20
 drivers/net/ethernet/realtek/r8169_main.c                          |    4=
=20
 drivers/net/phy/bcm7xxx.c                                          |    1=
=20
 drivers/net/phy/phylink.c                                          |   16=
=20
 drivers/net/usb/cdc_ether.c                                        |    7=
=20
 drivers/net/usb/lan78xx.c                                          |   17=
=20
 drivers/net/usb/r8152.c                                            |    1=
=20
 drivers/net/vxlan.c                                                |    6=
=20
 drivers/of/unittest.c                                              |    1=
=20
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c                              |    4=
=20
 drivers/pinctrl/intel/pinctrl-intel.c                              |   27=
=20
 drivers/pinctrl/pinctrl-stmfx.c                                    |    2=
=20
 drivers/platform/x86/pmc_atom.c                                    |    7=
=20
 drivers/regulator/da9062-regulator.c                               |  118 -
 drivers/regulator/of_regulator.c                                   |    8=
=20
 drivers/regulator/pfuze100-regulator.c                             |    8=
=20
 drivers/regulator/ti-abb-regulator.c                               |   26=
=20
 drivers/scsi/Kconfig                                               |    2=
=20
 drivers/scsi/device_handler/scsi_dh_alua.c                         |   21=
=20
 drivers/scsi/hpsa.c                                                |    4=
=20
 drivers/scsi/qla2xxx/qla_os.c                                      |    4=
=20
 drivers/scsi/sni_53c710.c                                          |    4=
=20
 drivers/target/target_core_device.c                                |   21=
=20
 drivers/tty/serial/8250/8250_men_mcb.c                             |    8=
=20
 drivers/usb/gadget/udc/core.c                                      |    2=
=20
 fs/cifs/cifsglob.h                                                 |    5=
=20
 fs/cifs/cifsproto.h                                                |    1=
=20
 fs/cifs/connect.c                                                  |   10=
=20
 fs/cifs/file.c                                                     |   23=
=20
 fs/cifs/smb2file.c                                                 |    2=
=20
 fs/cifs/transport.c                                                |   42=
=20
 include/linux/gfp.h                                                |   23=
=20
 include/linux/mlx5/mlx5_ifc.h                                      |    3=
=20
 include/linux/skbuff.h                                             |   36=
=20
 include/net/busy_poll.h                                            |    6=
=20
 include/net/flow_dissector.h                                       |    3=
=20
 include/net/fq.h                                                   |    2=
=20
 include/net/fq_impl.h                                              |    4=
=20
 include/net/ip.h                                                   |    4=
=20
 include/net/net_namespace.h                                        |   27=
=20
 include/net/sock.h                                                 |   15=
=20
 include/sound/simple_card_utils.h                                  |    8=
=20
 kernel/trace/trace_events_hist.c                                   |    2=
=20
 net/atm/common.c                                                   |    2=
=20
 net/bluetooth/af_bluetooth.c                                       |    4=
=20
 net/bridge/netfilter/nf_conntrack_bridge.c                         |    5=
=20
 net/caif/caif_socket.c                                             |    2=
=20
 net/core/datagram.c                                                |    8=
=20
 net/core/dev.c                                                     |    2=
=20
 net/core/ethtool.c                                                 |    4=
=20
 net/core/flow_dissector.c                                          |   38=
=20
 net/core/net_namespace.c                                           |   18=
=20
 net/core/rtnetlink.c                                               |   16=
=20
 net/core/sock.c                                                    |    6=
=20
 net/dccp/ipv4.c                                                    |    4=
=20
 net/decnet/af_decnet.c                                             |    2=
=20
 net/dsa/dsa2.c                                                     |    2=
=20
 net/ipv4/datagram.c                                                |    2=
=20
 net/ipv4/fib_frontend.c                                            |    2=
=20
 net/ipv4/inet_hashtables.c                                         |    2=
=20
 net/ipv4/ip_gre.c                                                  |    4=
=20
 net/ipv4/ip_output.c                                               |   14=
=20
 net/ipv4/tcp.c                                                     |    4=
=20
 net/ipv4/tcp_ipv4.c                                                |    4=
=20
 net/ipv4/udp.c                                                     |   29=
=20
 net/ipv6/inet6_hashtables.c                                        |    2=
=20
 net/ipv6/ip6_gre.c                                                 |    4=
=20
 net/ipv6/ip6_output.c                                              |    3=
=20
 net/ipv6/netfilter.c                                               |    3=
=20
 net/ipv6/udp.c                                                     |    2=
=20
 net/nfc/llcp_sock.c                                                |    4=
=20
 net/openvswitch/datapath.c                                         |   20=
=20
 net/phonet/socket.c                                                |    4=
=20
 net/rxrpc/ar-internal.h                                            |    1=
=20
 net/rxrpc/recvmsg.c                                                |   18=
=20
 net/sched/sch_hhf.c                                                |    8=
=20
 net/sched/sch_netem.c                                              |   11=
=20
 net/sched/sch_sfb.c                                                |   13=
=20
 net/sched/sch_sfq.c                                                |   14=
=20
 net/sctp/socket.c                                                  |    8=
=20
 net/smc/af_smc.c                                                   |   13=
=20
 net/tipc/socket.c                                                  |    4=
=20
 net/unix/af_unix.c                                                 |    6=
=20
 net/vmw_vsock/af_vsock.c                                           |    2=
=20
 sound/pci/hda/hda_intel.c                                          |    6=
=20
 sound/soc/codecs/msm8916-wcd-digital.c                             |   22=
=20
 sound/soc/codecs/pcm3168a.c                                        |    3=
=20
 sound/soc/codecs/rt5651.c                                          |    3=
=20
 sound/soc/codecs/rt5682.c                                          |   12=
=20
 sound/soc/codecs/wm8994.c                                          |   43=
=20
 sound/soc/codecs/wm_adsp.c                                         |    3=
=20
 sound/soc/intel/boards/sof_rt5682.c                                |   25=
=20
 sound/soc/rockchip/rockchip_i2s.c                                  |    2=
=20
 sound/soc/samsung/arndale_rt5631.c                                 |   34=
=20
 sound/soc/soc-topology.c                                           |    2=
=20
 sound/soc/sof/control.c                                            |   26=
=20
 sound/soc/sof/intel/Kconfig                                        |   10=
=20
 sound/soc/sof/intel/bdw.c                                          |    7=
=20
 sound/soc/sof/intel/byt.c                                          |    6=
=20
 sound/soc/sof/intel/hda-ctrl.c                                     |   12=
=20
 sound/soc/sof/intel/hda-loader.c                                   |    1=
=20
 sound/soc/sof/intel/hda-stream.c                                   |   45=
=20
 sound/soc/sof/intel/hda.c                                          |    7=
=20
 sound/soc/sof/intel/hda.h                                          |    5=
=20
 sound/soc/sof/loader.c                                             |    4=
=20
 sound/soc/sof/topology.c                                           |    4=
=20
 tools/perf/builtin-c2c.c                                           |   14=
=20
 tools/perf/builtin-kmem.c                                          |    1=
=20
 tools/perf/util/header.c                                           |    4=
=20
 tools/perf/util/util.c                                             |    6=
=20
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c                |   21=
=20
 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c     |    7=
=20
 tools/testing/selftests/net/fib_tests.sh                           |   21=
=20
 tools/testing/selftests/net/reuseport_dualstack.c                  |    3=
=20
 tools/testing/selftests/powerpc/mm/Makefile                        |    2=
=20
 tools/testing/selftests/powerpc/mm/tlbie_test.c                    |  734 =
++++++++++
 182 files changed, 1932 insertions(+), 684 deletions(-)

Adam Ford (2):
      ARM: dts: logicpd-torpedo-som: Remove twl_keypad
      ARM: dts: imx6q-logicpd: Re-Enable SNVS power key

Alain Volmat (1):
      i2c: stm32f7: remove warning when compiling with W=3D1

Alan Mikhak (1):
      irqchip/sifive-plic: Skip contexts except supervisor in plic_init()

Allen Pais (1):
      scsi: qla2xxx: fix a potential NULL pointer dereference

Amelie Delaunay (1):
      pinctrl: stmfx: fix null pointer on remove

Andrew Lunn (1):
      net: usb: lan78xx: Connect PHY before registering MAC

Andrey Smirnov (2):
      ARM: dts: am3874-iceboard: Fix 'i2c-mux-idle-disconnect' usage
      ARM: dts: vf610-zii-scu4-aib: Specify 'i2c-mux-idle-disconnect'

Andy Shevchenko (1):
      pinctrl: intel: Allocate IRQ chip dynamic

Aneesh Kumar K.V (1):
      selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue

Anson Huang (3):
      ARM: dts: imx7s: Correct GPT's ipg clock source
      arm64: dts: imx8mq: Use correct clock for usdhc's ipg clk
      arm64: dts: imx8mm: Use correct clock for usdhc's ipg clk

Axel Lin (1):
      regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all=
_txdone

Aya Levin (2):
      net/mlx5e: Initialize on stack link modes bitmap
      net/mlx5e: Fix ethtool self test: link speed

Benjamin Herrenschmidt (1):
      net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum

Bodo Stroesser (1):
      scsi: target: core: Do not overwrite CDB byte 1

Christian K=F6nig (2):
      drm/amdgpu: fix potential VM faults
      drm/amdgpu: fix error handling in amdgpu_bo_list_create

Chuhong Yuan (1):
      ASoC: Intel: sof-rt5682: add a check for devm_clk_get

Colin Ian King (1):
      8250-men-mcb: fix error checking when get_num_ports returns -ENODEV

Dan Carpenter (2):
      ASoC: topology: Fix a signedness bug in soc_tplg_dapm_widget_create()
      pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Daniel Baluta (1):
      ASoC: simple_card_utils.h: Fix potential multiple redefinition error

Daniel Wagner (1):
      net: usb: lan78xx: Disable interrupts before calling generic_handle_i=
rq()

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

David Howells (1):
      rxrpc: Fix handling of last subpacket of jumbo packet

Desnes A. Nunes do Rosario (1):
      selftests/powerpc: Fix compile error on tlbie_test due to newer gcc

Dmytro Linkin (2):
      net/mlx5e: Determine source port properly for vlan push action
      net/mlx5e: Remove incorrect match criteria assignment line

Don Brace (1):
      scsi: hpsa: add missing hunks in reset-patch

Doug Berger (3):
      net: bcmgenet: don't set phydev->link from MAC
      net: phy: bcm7xxx: define soft_reset for 40nm EPHY
      net: bcmgenet: reset 40nm EPHY on energy detect

Dragos Tarcatu (1):
      ASoC: SOF: control: return true when kcontrol values change

Eran Ben Elisha (1):
      net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Eric Dumazet (14):
      dccp: do not leak jiffies on the wire
      inet: stop leaking jiffies on the wire
      net: annotate accesses to sk->sk_incoming_cpu
      net: annotate lockless accesses to sk->sk_napi_id
      udp: fix data-race in udp_set_dev_scratch()
      net: add skb_queue_empty_lockless()
      udp: use skb_queue_empty_lockless()
      net: use skb_queue_empty_lockless() in poll() handlers
      net: use skb_queue_empty_lockless() in busy poll contexts
      net: add READ_ONCE() annotation in __skb_wait_for_more_packets()
      ipv4: fix IPSKB_FRAG_PMTU handling with fragmentation
      net: ensure correct skb->tstamp in various fragmenters
      net: reorder 'struct net' fields to avoid false sharing
      net/flow_dissector: switch to siphash

Fabien Parent (1):
      i2c: mt65xx: fix NULL ptr dereference

Fabrice Gasnier (2):
      i2c: stm32f7: fix first byte to send in slave mode
      i2c: stm32f7: fix a race in slave mode with arbitration loss irq

Florian Fainelli (3):
      net: dsa: bcm_sf2: Fix IMP setup for port different than 8
      net: phylink: Fix phylink_dbg() macro
      net: dsa: b53: Do not clear existing mirrored port mask

Greg Kroah-Hartman (1):
      Linux 5.3.10

Guillaume Nault (1):
      netns: fix GFP flags in rtnl_net_notifyid()

Hannes Reinecke (1):
      scsi: scsi_dh_alua: handle RTPG sense code correctly during state tra=
nsitions

Heiner Kallweit (1):
      r8169: fix wrong PHY ID issue with RTL8168dp

Hugh Cole-Baker (1):
      arm64: dts: rockchip: fix Rockpro64 RK808 interrupt line

Jae Hyun Yoo (1):
      i2c: aspeed: fix master pending state handling

Jakub Kicinski (2):
      net: netem: fix error path for corrupted GSO frames
      net: netem: correct the parent's backlog when corrupted packet was dr=
opped

Jan Kiszka (1):
      platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to critclk_system=
s DMI table

Jaska Uimonen (3):
      ASoC: rt5682: add NULL handler to set_jack function
      ASoC: intel: sof_rt5682: add remove function to disable jack
      ASoC: intel: bytcr_rt5651: add null check to support_button_press

Jernej Skrabec (2):
      arm64: dts: allwinner: a64: pine64-plus: Add PHY regulator delay
      arm64: dts: allwinner: a64: sopine-baseboard: Add PHY regulator delay

Jiangfeng Xiao (1):
      net: hisilicon: Fix ping latency when deal with high throughput

Jiri Pirko (1):
      mlxsw: core: Unpublish devlink parameters during reload

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays

Josef Bacik (2):
      nbd: protect cmd->status with cmd->lock
      nbd: handle racing with error'ed out commands

Kai Vehmanen (1):
      ASoC: SOF: Intel: hda: fix warnings during FW load

Kazutoshi Noguchi (1):
      r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Keyon Jie (1):
      ASoC: SOF: topology: fix parse fail issue for byte/bool tuple types

Liam Girdwood (1):
      ASoC: SOF: Intel: initialise and verify FW crash dump data.

Lucas Stach (1):
      arm64: dts: zii-ultra: fix ARM regulator states

Marco Felsch (2):
      regulator: of: fix suspend-min/max-voltage parsing
      regulator: da9062: fix suspend_enable/disable preparation

Masahiro Yamada (1):
      ARM: 8908/1: add __always_inline to functions called from __get_user_=
check()

Maxim Mikityanskiy (1):
      net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Mihail Atanassov (1):
      drm/komeda: Don't flush inactive pipes

Navid Emamdoost (1):
      of: unittest: fix memory leak in unittest_data_add

Nikolay Aleksandrov (1):
      net: rtnetlink: fix a typo fbd -> fdb

Pan Xiuli (1):
      ALSA: hda: Add Tigerlake/Jasperlake PCI ID

Paolo Abeni (2):
      ipv4: fix route update on metric change.
      selftests: fib_tests: add more tests for metric update

Parav Pandit (1):
      net/mlx5: Fix rtable reference leak

Pavel Shilovsky (1):
      CIFS: Fix retry mid list corruption on reconnects

Peter Ujfalusi (2):
      ARM: davinci: dm365: Fix McBSP dma_slave_map entry
      ASoC: pcm3168a: The codec does not support S32_LE

Pierre-Louis Bossart (1):
      ASoC: SOF: loader: fix kernel oops on firmware boot failure

Raju Rangoju (1):
      cxgb4: request the TX CIDX updates to status page

Ran Wang (1):
      arm64: dts: lx2160a: Correct CPU core idle state name

Ranjani Sridharan (1):
      ASoC: SOF: Intel: hda: Disable DMI L1 entry during capture

Rayagonda Kokatanur (1):
      arm64: dts: Fix gpio to pinmux mapping

Robin Murphy (1):
      ASoc: rockchip: i2s: Fix RPM imbalance

Roger Quadros (1):
      usb: gadget: udc: core: Fix segfault if udc_bind_to_driver() for pend=
ing driver fails

Roi Dayan (1):
      net/mlx5: Fix flow counter list auto bits struct

Russell King (1):
      ARM: mm: fix alignment handler faults under memory pressure

Soeren Moch (3):
      arm64: dts: rockchip: fix RockPro64 vdd-log regulator settings
      arm64: dts: rockchip: fix RockPro64 sdhci settings
      arm64: dts: rockchip: fix RockPro64 sdmmc settings

Srinivas Kandagatla (1):
      ASoC: msm8916-wcd-digital: add missing MIX2 path for RX1/2

Stefan Wahren (1):
      ARM: dts: bcm2837-rpi-cm3: Avoid leds-gpio probing issue

Stuart Henderson (1):
      ASoC: wm_adsp: Don't generate kcontrols without READ flags

Suman Anna (1):
      arm64: dts: ti: k3-am65-main: Fix gic-its node unit-address

Sylwester Nawrocki (2):
      ASoC: samsung: arndale: Add missing OF node dereferencing
      ASoC: wm8994: Do not register inapplicable controls for WM1811

Takeshi Misawa (1):
      keys: Fix memory leak in copy_net_ns

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim

Thomas Bogendoerfer (2):
      scsi: sni_53c710: fix compilation error
      scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Tony Lindgren (1):
      ARM: dts: Use level interrupt for omap4 & 5 wlcore

Ursula Braun (3):
      net/smc: fix closing of fallback SMC sockets
      net/smc: keep vlan_id for SMC-R in smc_listen_work()
      net/smc: fix refcounting for non-blocking connect()

Vasily Khoruzhick (1):
      arm64: dts: allwinner: a64: Drop PMU node

Vishal Kulkarni (1):
      cxgb4: fix panic when attaching to ULD fail

Vitaly Kuznetsov (2):
      selftests: kvm: vmx_set_nested_state_test: don't check for VMX suppor=
t twice
      selftests: kvm: fix sync_regs_test with newer gccs

Vivek Unune (1):
      arm64: dts: rockchip: Fix usb-c on Hugsun X99 TV Box

Vivien Didelot (1):
      net: dsa: fix switch tree list

Vladimir Murzin (1):
      ARM: 8914/1: NOMMU: Fix exc_ret for XIP

Wei Wang (1):
      selftests: net: reuseport_dualstack: fix uninitalized parameter

Xin Long (2):
      erspan: fix the tun_info options_len check for erspan
      vxlan: check tun_info options_len properly

Yizhuo (1):
      regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_p=
robe() could be uninitialized

Yonglong Liu (1):
      net: hns3: fix mis-counting IRQ vector numbers issue

Yunfeng Ye (3):
      perf tools: Fix resource leak of closedir() on the error paths
      perf c2c: Fix memory leak in build_cl_output()
      perf kmem: Fix memory leak in compact_gfp_flags()

Zenghui Yu (1):
      irqchip/gic-v3-its: Use the exact ITSList for VMOVP

Zhengjun Xing (1):
      tracing: Fix "gfp_t" format for synthetic events

afzal mohammed (1):
      ARM: 8926/1: v7m: remove register save to stack before svc

zhanglin (1):
      net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3IQBUACgkQONu9yGCS
aT4u6w/9ESn+Aq1D+1Jipb8pDGH6cxACoGrRENRd1/xda6NPUbido6eQlYaIkf3X
jHFW+GLC394FtRUJMOubt3+yKoVDaoxSa5YIiHJy4mS/5ODZBvcmwWTyos7tC8mI
odVRTjMw0giuW5GV9wFEJ/i3LRxDqu8I82Lr5Tz6fJbQhcV+IOS0VssJR18sMpox
mnm/jai1OkZqVuelmK24hwwEqY8hLd3G7XrhR1PW1kG2AbfTzoRD0rlEwS0wRD23
MlmsS1+perXKEJ+BEUJIIudgdz3dPup7Rk9yl18Ah7btsnvDjZeo/8AkVZb1oA4B
4FQNrHyDMRZ+aYMssvGLeFNVHTyPtKkS7Kw/JkON0GGCYx9zyXUlQrnJ+/31rozo
7yn/EnCcjp7Uyg1eP5IkDsarQw70jcEgQOSJqhDVeiJk1ynCWVm88LwX2TdX6FSt
sMQGdAkfBAEXkSv9pGQsa8qdysIfQ6xDTRz4JPcItzw0vvBlHHMJA2+baljcvLFd
BmNYgCsYCvya372gZ7FV2Slpif3Uk0Z/oIEHuXiQe8RMXl7GGnlZerh1u6YboS92
AlNCqAV4CoEM8ygFGTMb1nC8XPefYgLUkpUMCwjYfpDLjqGGGeRaI5gkqMD+UVIi
vZAsF9ohaFpOWgnAP2pcsnGYOnRU4SxmFt0yFpuDx0at5hrhmyI=
=eVOo
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
