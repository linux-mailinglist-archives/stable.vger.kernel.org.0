Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB4BF6A52
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfKJQvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJQvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 11:51:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3525B21655;
        Sun, 10 Nov 2019 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573404670;
        bh=wfaBKXRFEgcB6gGtKOdY/SAJWO3kMKa0U8e95omHs6I=;
        h=Date:From:To:Cc:Subject:From;
        b=RP3xJQ4FAyrb/K+MW0Gfg6Spbtt10OllW4hndKsyDEATXpAPlF4B1APMwVc2qgt2M
         lC62YSFcH4ZSqfeY7geGKpEYNI9ne8O6rnj5AAQt56ZvMUerxdRcZy94OoOFW+XNmb
         KOmB5fmoEmLBHJhwNRc4qS51JFDkbIkuP0LhZo3c=
Date:   Sun, 10 Nov 2019 17:51:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.83
Message-ID: <20191110165108.GA2873244@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.83 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                      |    8=20
 arch/arm/boot/dts/imx7s.dtsi                                  |    8=20
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi                    |    4=20
 arch/arm/mach-davinci/dm365.c                                 |    4=20
 arch/arm/mm/alignment.c                                       |   44=20
 arch/arm/mm/proc-v7m.S                                        |    1=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dts      |    9=20
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts |    6=20
 arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi   |    5=20
 arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi           |    3=20
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                      |    2=20
 arch/mips/bcm63xx/prom.c                                      |    2=20
 arch/mips/include/asm/bmips.h                                 |   10=20
 arch/mips/kernel/smp-bmips.c                                  |    8=20
 arch/powerpc/include/asm/cputable.h                           |    3=20
 arch/powerpc/kernel/dt_cpu_ftrs.c                             |    2=20
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                           |   42=20
 arch/powerpc/mm/hash_native_64.c                              |   29=20
 arch/powerpc/mm/tlb-radix.c                                   |   80 -
 drivers/block/nbd.c                                           |   18=20
 drivers/crypto/chelsio/chtls/chtls_cm.c                       |    2=20
 drivers/crypto/chelsio/chtls/chtls_io.c                       |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                    |    3=20
 drivers/i2c/busses/i2c-stm32f7.c                              |   21=20
 drivers/irqchip/irq-gic-v3-its.c                              |   21=20
 drivers/isdn/capi/capi.c                                      |    2=20
 drivers/net/dsa/b53/b53_common.c                              |    1=20
 drivers/net/dsa/bcm_sf2.c                                     |   36=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                |   13=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c                |   29=20
 drivers/net/ethernet/faraday/ftgmac100.c                      |   25=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                    |   15=20
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c         |   42=20
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c               |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c         |   15=20
 drivers/net/ethernet/realtek/r8169.c                          |    4=20
 drivers/net/phy/bcm7xxx.c                                     |    1=20
 drivers/net/usb/cdc_ether.c                                   |    7=20
 drivers/net/usb/lan78xx.c                                     |   17=20
 drivers/net/usb/r8152.c                                       |    1=20
 drivers/net/vxlan.c                                           |    6=20
 drivers/of/unittest.c                                         |    1=20
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c                         |    4=20
 drivers/platform/x86/pmc_atom.c                               |    7=20
 drivers/regulator/of_regulator.c                              |    8=20
 drivers/regulator/pfuze100-regulator.c                        |    8=20
 drivers/regulator/ti-abb-regulator.c                          |   26=20
 drivers/scsi/Kconfig                                          |    2=20
 drivers/scsi/device_handler/scsi_dh_alua.c                    |   21=20
 drivers/scsi/qla2xxx/qla_os.c                                 |    4=20
 drivers/scsi/sni_53c710.c                                     |    4=20
 drivers/target/target_core_device.c                           |   21=20
 drivers/tty/serial/8250/8250_men_mcb.c                        |    8=20
 drivers/usb/gadget/udc/core.c                                 |    2=20
 fs/cifs/cifsglob.h                                            |    5=20
 fs/cifs/cifsproto.h                                           |    1=20
 fs/cifs/file.c                                                |   23=20
 fs/cifs/smb2file.c                                            |    2=20
 include/linux/gfp.h                                           |   23=20
 include/linux/skbuff.h                                        |   36=20
 include/net/busy_poll.h                                       |    6=20
 include/net/flow_dissector.h                                  |    3=20
 include/net/fq.h                                              |    2=20
 include/net/fq_impl.h                                         |    4=20
 include/net/net_namespace.h                                   |    2=20
 include/net/sock.h                                            |   15=20
 kernel/trace/trace_events_hist.c                              |    2=20
 net/atm/common.c                                              |    2=20
 net/bluetooth/af_bluetooth.c                                  |    4=20
 net/caif/caif_socket.c                                        |    2=20
 net/core/datagram.c                                           |    8=20
 net/core/dev.c                                                |    2=20
 net/core/ethtool.c                                            |    4=20
 net/core/flow_dissector.c                                     |   38=20
 net/core/net_namespace.c                                      |   17=20
 net/core/rtnetlink.c                                          |   14=20
 net/core/sock.c                                               |    6=20
 net/dccp/ipv4.c                                               |    4=20
 net/decnet/af_decnet.c                                        |    2=20
 net/dsa/dsa2.c                                                |    2=20
 net/ipv4/datagram.c                                           |    2=20
 net/ipv4/fib_frontend.c                                       |    2=20
 net/ipv4/inet_hashtables.c                                    |    2=20
 net/ipv4/ip_gre.c                                             |    4=20
 net/ipv4/tcp.c                                                |    4=20
 net/ipv4/tcp_ipv4.c                                           |    4=20
 net/ipv4/udp.c                                                |   29=20
 net/ipv6/inet6_hashtables.c                                   |    2=20
 net/ipv6/ip6_gre.c                                            |    4=20
 net/ipv6/udp.c                                                |    2=20
 net/nfc/llcp_sock.c                                           |    4=20
 net/openvswitch/datapath.c                                    |   20=20
 net/phonet/socket.c                                           |    4=20
 net/sched/sch_hhf.c                                           |    8=20
 net/sched/sch_sfb.c                                           |   13=20
 net/sched/sch_sfq.c                                           |   14=20
 net/sctp/socket.c                                             |    8=20
 net/tipc/socket.c                                             |    4=20
 net/unix/af_unix.c                                            |    6=20
 net/vmw_vsock/af_vsock.c                                      |    2=20
 net/wireless/Makefile                                         |    1=20
 sound/soc/codecs/pcm3168a.c                                   |    3=20
 sound/soc/codecs/rt5682.c                                     |   12=20
 sound/soc/codecs/wm8994.c                                     |   43=20
 sound/soc/codecs/wm_adsp.c                                    |    3=20
 sound/soc/rockchip/rockchip_i2s.c                             |    2=20
 tools/perf/builtin-c2c.c                                      |   14=20
 tools/perf/builtin-kmem.c                                     |    1=20
 tools/testing/selftests/net/fib_tests.sh                      |   21=20
 tools/testing/selftests/net/reuseport_dualstack.c             |    3=20
 tools/testing/selftests/powerpc/mm/Makefile                   |    2=20
 tools/testing/selftests/powerpc/mm/tlbie_test.c               |  734 +++++=
+++++
 112 files changed, 1479 insertions(+), 399 deletions(-)

Adam Ford (1):
      ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Alain Volmat (1):
      i2c: stm32f7: remove warning when compiling with W=3D1

Allen Pais (1):
      scsi: qla2xxx: fix a potential NULL pointer dereference

Andrew Lunn (1):
      net: usb: lan78xx: Connect PHY before registering MAC

Aneesh Kumar K.V (2):
      powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9
      selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue

Anson Huang (1):
      ARM: dts: imx7s: Correct GPT's ipg clock source

Axel Lin (1):
      regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all=
_txdone

Aya Levin (1):
      net/mlx5e: Fix ethtool self test: link speed

Benjamin Herrenschmidt (1):
      net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum

Bodo Stroesser (1):
      scsi: target: core: Do not overwrite CDB byte 1

Christian K=F6nig (1):
      drm/amdgpu: fix potential VM faults

Colin Ian King (1):
      8250-men-mcb: fix error checking when get_num_ports returns -ENODEV

Dan Carpenter (1):
      pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Daniel Wagner (1):
      net: usb: lan78xx: Disable interrupts before calling generic_handle_i=
rq()

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Desnes A. Nunes do Rosario (1):
      selftests/powerpc: Fix compile error on tlbie_test due to newer gcc

Doug Berger (3):
      net: bcmgenet: don't set phydev->link from MAC
      net: phy: bcm7xxx: define soft_reset for 40nm EPHY
      net: bcmgenet: reset 40nm EPHY on energy detect

Eran Ben Elisha (1):
      net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Eric Dumazet (11):
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
      net/flow_dissector: switch to siphash

Fabrice Gasnier (2):
      i2c: stm32f7: fix first byte to send in slave mode
      i2c: stm32f7: fix a race in slave mode with arbitration loss irq

Florian Fainelli (2):
      net: dsa: bcm_sf2: Fix IMP setup for port different than 8
      net: dsa: b53: Do not clear existing mirrored port mask

Greg Kroah-Hartman (1):
      Linux 4.19.83

Guillaume Nault (1):
      netns: fix GFP flags in rtnl_net_notifyid()

Hannes Reinecke (1):
      scsi: scsi_dh_alua: handle RTPG sense code correctly during state tra=
nsitions

Heiner Kallweit (1):
      r8169: fix wrong PHY ID issue with RTL8168dp

Jan Kiszka (1):
      platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to critclk_system=
s DMI table

Jaska Uimonen (1):
      ASoC: rt5682: add NULL handler to set_jack function

Jernej Skrabec (2):
      arm64: dts: allwinner: a64: pine64-plus: Add PHY regulator delay
      arm64: dts: allwinner: a64: sopine-baseboard: Add PHY regulator delay

Jiangfeng Xiao (1):
      net: hisilicon: Fix ping latency when deal with high throughput

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays

Josef Bacik (2):
      nbd: protect cmd->status with cmd->lock
      nbd: handle racing with error'ed out commands

Kazutoshi Noguchi (1):
      r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Marco Felsch (1):
      regulator: of: fix suspend-min/max-voltage parsing

Maxim Mikityanskiy (2):
      net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget
      wireless: Skip directory when generating certificates

Navid Emamdoost (1):
      of: unittest: fix memory leak in unittest_data_add

Paolo Abeni (2):
      ipv4: fix route update on metric change.
      selftests: fib_tests: add more tests for metric update

Peter Ujfalusi (2):
      ARM: davinci: dm365: Fix McBSP dma_slave_map entry
      ASoC: pcm3168a: The codec does not support S32_LE

Rayagonda Kokatanur (1):
      arm64: dts: Fix gpio to pinmux mapping

Robin Murphy (1):
      ASoc: rockchip: i2s: Fix RPM imbalance

Roger Quadros (1):
      usb: gadget: udc: core: Fix segfault if udc_bind_to_driver() for pend=
ing driver fails

Russell King (1):
      ARM: mm: fix alignment handler faults under memory pressure

Seth Forshee (1):
      kbuild: add -fcf-protection=3Dnone when using retpoline flags

Stuart Henderson (1):
      ASoC: wm_adsp: Don't generate kcontrols without READ flags

Suman Anna (1):
      arm64: dts: ti: k3-am65-main: Fix gic-its node unit-address

Sylwester Nawrocki (1):
      ASoC: wm8994: Do not register inapplicable controls for WM1811

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim

Thomas Bogendoerfer (2):
      scsi: sni_53c710: fix compilation error
      scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Vishal Kulkarni (1):
      cxgb4: fix panic when attaching to ULD fail

Vivien Didelot (1):
      net: dsa: fix switch tree list

Wei Wang (1):
      selftests: net: reuseport_dualstack: fix uninitalized parameter

Xin Long (2):
      erspan: fix the tun_info options_len check for erspan
      vxlan: check tun_info options_len properly

Yizhuo (1):
      regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_p=
robe() could be uninitialized

Yunfeng Ye (2):
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


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3IP/sACgkQONu9yGCS
aT44JhAApxEqYFgXRZmzkFWLA6BObSj1VHQ5HZHMPlyQP/hDY0ojJGiODBcpIlhf
HZGd6gvRN+RIkRljcjaoAL0MA1CFdTQeSH09lFkSvmB+lTCBy/yxwo8h8dTWS050
2tHyLoZm1OzwkLEIWwb4h3RFWFOAaSJCus4NvcOb6RRuthBd/ROaDHZoP+1JVAh6
f/0bt9LL+o5Nxu00TVPttSZ01lz9fnDPxj0bhENOqmNnEajWPpSEdZ5tFT1QLI+X
jHMwh5W0o0yC9XwpX3bzgVBg38JtrvgzyTabMI9uG/8ULzLwhKbXB4CRH73Ebfen
GK4tShfzaU0spnW09gYk20y3GUAsfLeiG/ceE78uEv0jsZdPrVGZcQcl2OO2jmYp
HwTxPzNDMnxy1eYJoyVUXET4uNSOuBcmAr99rH5PYuLeRf7hvAt6CujjHPgjAtTW
PUXrCOai+ppPO8l4fKU1HJGGCi1VvIDwBipkfM0UPYq1okt4pmBiVSSVk9jVGcsm
ouLFlnEEfIKAPH0/0WE1P+X7icg82JDRHS35Oac1PESc7NmdxxqA3qifWS6rVyRN
EiZY+TMsO3C/yfTmSgy//DOZwwsAcylHFgUMD9D8iUWC3bRR9b9MFz3nlVdkA/zo
ZSbLzzjV/e2ZcRaOQz3G/KSb1xHqVU0U0YesoXiGDreeuN4sC0M=
=Ze4H
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
