Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E81F6A4E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKJQuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJQuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 11:50:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 730062080F;
        Sun, 10 Nov 2019 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573404654;
        bh=sXX+Uucl/Ho+jAZaetrpDfJKwqZ1+cP6r/WldbTQmOo=;
        h=Date:From:To:Cc:Subject:From;
        b=1N+MbSTCk2wtZJ8Mi4ESpHcJYRfYbAMgNuj8UsdqXaQDZYkcs1MlSc3JEw2TdXfXy
         vHiYfG+136n3kh250AjCyAz2dKM40OTgPqQUtQef65IrhHocflL9pvRBTrC1S2LamM
         +Jq1DO2rt0/grrASzZmKdmUoh6kysc5er5tnb/Ps=
Date:   Sun, 10 Nov 2019 17:50:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.153
Message-ID: <20191110165051.GA2873143@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.153 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |   11=20
 arch/arm/boot/dts/imx7s.dtsi                                |    8=20
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi                  |    4=20
 arch/arm/mach-davinci/dm365.c                               |    4=20
 arch/arm/mm/alignment.c                                     |   44=20
 arch/arm/mm/proc-v7m.S                                      |    1=20
 arch/arm64/boot/dts/broadcom/stingray/stingray-pinctrl.dtsi |    5=20
 arch/arm64/boot/dts/broadcom/stingray/stingray.dtsi         |    3=20
 arch/mips/bcm63xx/prom.c                                    |    2=20
 arch/mips/include/asm/bmips.h                               |   10=20
 arch/mips/kernel/smp-bmips.c                                |    8=20
 arch/powerpc/include/asm/cputable.h                         |    5=20
 arch/powerpc/kernel/dt_cpu_ftrs.c                           |   32=20
 arch/powerpc/kvm/book3s_64_mmu_radix.c                      |    3=20
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                         |   33=20
 arch/powerpc/mm/hash_native_64.c                            |   38=20
 arch/powerpc/mm/pgtable_64.c                                |    1=20
 arch/powerpc/mm/tlb-radix.c                                 |   94 +
 drivers/block/nbd.c                                         |    6=20
 drivers/dma/qcom/bam_dma.c                                  |   14=20
 drivers/i2c/busses/i2c-stm32f7.c                            |    2=20
 drivers/iio/adc/stm32-adc-core.c                            |   70 -
 drivers/iio/adc/stm32-adc-core.h                            |  135 ++
 drivers/iio/adc/stm32-adc.c                                 |  107 -
 drivers/isdn/capi/capi.c                                    |    2=20
 drivers/net/dsa/b53/b53_common.c                            |    1=20
 drivers/net/dsa/bcm_sf2.c                                   |   36=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c              |    9=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c              |   29=20
 drivers/net/ethernet/faraday/ftgmac100.c                    |   25=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                  |   15=20
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c       |   42=20
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c             |    5=20
 drivers/net/usb/cdc_ether.c                                 |    7=20
 drivers/net/usb/lan78xx.c                                   |   12=20
 drivers/net/usb/r8152.c                                     |    1=20
 drivers/net/vxlan.c                                         |    5=20
 drivers/of/unittest.c                                       |    1=20
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c                       |    4=20
 drivers/platform/x86/pmc_atom.c                             |    7=20
 drivers/regulator/pfuze100-regulator.c                      |    8=20
 drivers/regulator/ti-abb-regulator.c                        |   26=20
 drivers/scsi/Kconfig                                        |    2=20
 drivers/scsi/device_handler/scsi_dh_alua.c                  |   21=20
 drivers/scsi/sni_53c710.c                                   |    4=20
 drivers/target/target_core_device.c                         |   21=20
 fs/cifs/cifsglob.h                                          |    5=20
 fs/cifs/cifsproto.h                                         |    1=20
 fs/cifs/file.c                                              |   23=20
 fs/cifs/smb2file.c                                          |    2=20
 include/linux/gfp.h                                         |   23=20
 include/linux/skbuff.h                                      |   36=20
 include/net/busy_poll.h                                     |    6=20
 include/net/flow_dissector.h                                |    3=20
 include/net/fq.h                                            |    2=20
 include/net/fq_impl.h                                       |    4=20
 include/net/sock.h                                          |   15=20
 kernel/sched/core.c                                         |    7=20
 net/atm/common.c                                            |    2=20
 net/bluetooth/af_bluetooth.c                                |    4=20
 net/caif/caif_socket.c                                      |    2=20
 net/core/datagram.c                                         |    8=20
 net/core/ethtool.c                                          |    4=20
 net/core/flow_dissector.c                                   |   48=20
 net/core/sock.c                                             |    6=20
 net/dccp/ipv4.c                                             |    4=20
 net/dsa/dsa2.c                                              |    2=20
 net/ipv4/datagram.c                                         |    2=20
 net/ipv4/inet_hashtables.c                                  |    2=20
 net/ipv4/ip_gre.c                                           |    3=20
 net/ipv4/tcp.c                                              |    4=20
 net/ipv4/tcp_ipv4.c                                         |    4=20
 net/ipv4/udp.c                                              |   29=20
 net/ipv6/inet6_hashtables.c                                 |    2=20
 net/ipv6/udp.c                                              |    2=20
 net/nfc/llcp_sock.c                                         |    4=20
 net/phonet/socket.c                                         |    4=20
 net/sched/sch_hhf.c                                         |    8=20
 net/sched/sch_sfb.c                                         |   13=20
 net/sched/sch_sfq.c                                         |   14=20
 net/sctp/socket.c                                           |    8=20
 net/tipc/socket.c                                           |    4=20
 net/unix/af_unix.c                                          |    6=20
 net/vmw_vsock/af_vsock.c                                    |    2=20
 sound/soc/codecs/wm_adsp.c                                  |    3=20
 sound/soc/rockchip/rockchip_i2s.c                           |    2=20
 tools/perf/builtin-c2c.c                                    |   14=20
 tools/perf/builtin-kmem.c                                   |    1=20
 tools/testing/selftests/net/reuseport_dualstack.c           |    3=20
 tools/testing/selftests/powerpc/mm/Makefile                 |    2=20
 tools/testing/selftests/powerpc/mm/tlbie_test.c             |  734 +++++++=
+++++
 91 files changed, 1556 insertions(+), 444 deletions(-)

Adam Ford (1):
      ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Alain Volmat (1):
      i2c: stm32f7: remove warning when compiling with W=3D1

Andrew Lunn (1):
      net: usb: lan78xx: Connect PHY before registering MAC

Aneesh Kumar K.V (5):
      powerpc/mm: Fixup tlbie vs store ordering issue on POWER9
      powerpc/book3s64/mm: Don't do tlbie fixup for some hardware revisions
      powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag
      powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9
      selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue

Anson Huang (1):
      ARM: dts: imx7s: Correct GPT's ipg clock source

Axel Lin (1):
      regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all=
_txdone

Benjamin Herrenschmidt (1):
      net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum

Bodo Stroesser (1):
      scsi: target: core: Do not overwrite CDB byte 1

Dan Carpenter (1):
      pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Desnes A. Nunes do Rosario (1):
      selftests/powerpc: Fix compile error on tlbie_test due to newer gcc

Doug Berger (1):
      net: bcmgenet: reset 40nm EPHY on energy detect

Eran Ben Elisha (1):
      net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Eric Dumazet (11):
      dccp: do not leak jiffies on the wire
      net: annotate accesses to sk->sk_incoming_cpu
      net: annotate lockless accesses to sk->sk_napi_id
      udp: fix data-race in udp_set_dev_scratch()
      net: add READ_ONCE() annotation in __skb_wait_for_more_packets()
      net: add skb_queue_empty_lockless()
      udp: use skb_queue_empty_lockless()
      net: use skb_queue_empty_lockless() in poll() handlers
      net: use skb_queue_empty_lockless() in busy poll contexts
      inet: stop leaking jiffies on the wire
      net/flow_dissector: switch to siphash

Fabrice Gasnier (2):
      iio: adc: stm32-adc: move registers definitions
      iio: adc: stm32-adc: fix a race when using several adcs with dma and =
irq

Florian Fainelli (2):
      net: dsa: bcm_sf2: Fix IMP setup for port different than 8
      net: dsa: b53: Do not clear existing mirrored port mask

Greg Kroah-Hartman (1):
      Linux 4.14.153

Hannes Reinecke (1):
      scsi: scsi_dh_alua: handle RTPG sense code correctly during state tra=
nsitions

Jan Kiszka (1):
      platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to critclk_system=
s DMI table

Jeffrey Hugo (1):
      dmaengine: qcom: bam_dma: Fix resource leak

Jiangfeng Xiao (1):
      net: hisilicon: Fix ping latency when deal with high throughput

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays

Josef Bacik (1):
      nbd: handle racing with error'ed out commands

Kazutoshi Noguchi (1):
      r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Masahiro Yamada (1):
      kbuild: use -fmacro-prefix-map to make __FILE__ a relative path

Maxim Mikityanskiy (1):
      net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Navid Emamdoost (1):
      of: unittest: fix memory leak in unittest_data_add

Peter Ujfalusi (1):
      ARM: davinci: dm365: Fix McBSP dma_slave_map entry

Peter Zijlstra (1):
      sched/wake_q: Fix wakeup ordering for wake_q

Rayagonda Kokatanur (1):
      arm64: dts: Fix gpio to pinmux mapping

Robin Murphy (1):
      ASoc: rockchip: i2s: Fix RPM imbalance

Russell King (1):
      ARM: mm: fix alignment handler faults under memory pressure

Seth Forshee (1):
      kbuild: add -fcf-protection=3Dnone when using retpoline flags

Stuart Henderson (1):
      ASoC: wm_adsp: Don't generate kcontrols without READ flags

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
      vxlan: check tun_info options_len properly
      erspan: fix the tun_info options_len check for erspan

Yizhuo (1):
      regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_p=
robe() could be uninitialized

Yunfeng Ye (2):
      perf c2c: Fix memory leak in build_cl_output()
      perf kmem: Fix memory leak in compact_gfp_flags()

afzal mohammed (1):
      ARM: 8926/1: v7m: remove register save to stack before svc

zhanglin (1):
      net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3IP+sACgkQONu9yGCS
aT7WRA//YoVJPAJOQDThQ9d4jHfQGCE5tAaBFUowZTBenloxmmU/FG+5kDEJ07CG
k20OGw7tG5LozHVE5n8KE7V0+b42rhvGGy5vhWEZYfJDoHpW5EQKkye3T5ZsWAiQ
82qy2hoxXZ0tRVQ/Oibe0KliTkV90tQcA/BN48gcjd+k0B1l4HPmxYECeD6NKsiZ
Jm0zy/hSqiWF951dPfm2gKu0v4Ed+Zzbf+Z3/BRnljaWWdBmP9kwrXjafbGyNAOG
S3Rws87kcaGeR6n4EFFiVHeFnWQkjYNc0jP51bTlSt9rtd7Xox/m1PVHn9Yr8tBs
T1nvkhBqY/S+9BuH/XAo3kCdEZQeQGIu6/hj0+akJ0C4GvUeN3q0bw+jSe4FWDm4
7+KmyLibFA7RD7fE5DCfYnDcjHwD0z7/WQxRERlwNHyU85rGGVC7lVRadK2q1p4L
tA6bXhTuEo3Xo1Bpe596AEaOxd9/Nwg1BVhhgzBAtcCXsruy2CSUpKFZo/WkVqLN
SdwOC03AudS2GLKCNGA2CbKdkj/DAtFbrL3OApPDlKaDkqmB8FyN+Yl43yvcPRJI
oqpLkzsRDDlu4O2r6zR0uZrZEuhQva2DOXS4dhtDKEfLNkodnEqhHFv6X649TP2B
f2J5ub4TknXHNIXVxoFbrr+9ReJy721teRgS9duFqg16uu+jgGM=
=7+z/
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
