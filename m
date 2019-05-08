Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C5174FE
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfEHJWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfEHJWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:22:09 -0400
Received: from localhost (unknown [84.241.196.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C35DB21655;
        Wed,  8 May 2019 09:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557307327;
        bh=xIubDuF+goKmw9FENFNJHb2B8tZs0e4F0vEQFd6xQF0=;
        h=Date:From:To:Cc:Subject:From;
        b=AtqZqnrTJn4rjDtjRNwaHH84IYLpZkkc5sgyNIzJO31u4kiXefKJiorsSGQ2DN5Jm
         kFOzJQXSGHbnD/bB8U9ABXGDw3P76vnugZszJ+OZOcmtsMDk3xtp5Rbr4li/f1HnVF
         1HjAooPhhWNN7fl9X3Vc+DpwsfFoo4i0hvhZj4A4=
Date:   Wed, 8 May 2019 11:22:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.117
Message-ID: <20190508092204.GA2174@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.117 kernel.

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

 Documentation/driver-api/usb/power-management.rst   |   14 +-
 Makefile                                            |    2=20
 arch/arm/boot/dts/rk3288.dtsi                       |   12 +-
 arch/arm/mach-iop13xx/setup.c                       |    8 -
 arch/arm/mach-iop13xx/tpmi.c                        |   10 -
 arch/arm/plat-iop/adma.c                            |    6 -
 arch/arm/plat-orion/common.c                        |    4=20
 arch/arm64/include/asm/traps.h                      |    6 +
 arch/arm64/kernel/armv8_deprecated.c                |    8 -
 arch/arm64/kernel/cpufeature.c                      |    2=20
 arch/arm64/kernel/traps.c                           |   22 +++
 arch/powerpc/kernel/kvm.c                           |    7 +
 arch/powerpc/mm/slice.c                             |   10 +
 arch/sh/boards/of-generic.c                         |    4=20
 arch/x86/events/amd/core.c                          |  111 +++++++++++++++=
++++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c           |    5=20
 drivers/block/xsysace.c                             |    2=20
 drivers/bluetooth/btusb.c                           |    2=20
 drivers/clk/x86/clk-pmc-atom.c                      |   14 +-
 drivers/hid/hid-debug.c                             |    5=20
 drivers/hid/hid-input.c                             |    1=20
 drivers/hid/hid-logitech-hidpp.c                    |    8 +
 drivers/i2c/busses/i2c-stm32f7.c                    |    2=20
 drivers/infiniband/core/security.c                  |   11 +
 drivers/infiniband/core/verbs.c                     |   41 ++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c               |   11 +
 drivers/input/keyboard/snvs_pwrkey.c                |    6 -
 drivers/input/touchscreen/stmfts.c                  |   30 ++---
 drivers/media/i2c/ov7670.c                          |   16 +-
 drivers/net/bonding/bond_sysfs_slave.c              |    4=20
 drivers/net/dsa/bcm_sf2_cfp.c                       |    6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |   10 +
 drivers/net/ethernet/hisilicon/hns/hnae.c           |    4=20
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c  |   33 ++++-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c |    2=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c       |   12 --
 drivers/net/ethernet/intel/igb/e1000_defines.h      |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c           |   57 +---------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c   |    6 -
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c      |   12 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c     |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |   14 +-
 drivers/net/phy/marvell.c                           |    6 -
 drivers/nvme/target/core.c                          |   20 +--
 drivers/platform/x86/pmc_atom.c                     |   21 +++
 drivers/rtc/rtc-da9063.c                            |    7 +
 drivers/rtc/rtc-sh.c                                |    2=20
 drivers/scsi/scsi_devinfo.c                         |    1=20
 drivers/scsi/scsi_dh.c                              |    1=20
 drivers/scsi/storvsc_drv.c                          |   13 +-
 drivers/staging/iio/addac/adt7316.c                 |   22 ++-
 drivers/usb/core/driver.c                           |   13 --
 drivers/usb/core/message.c                          |    4=20
 drivers/usb/misc/yurex.c                            |    1=20
 drivers/usb/storage/realtek_cr.c                    |   13 --
 drivers/usb/usbip/stub_rx.c                         |   12 --
 drivers/usb/usbip/usbip_common.h                    |    7 +
 drivers/vfio/pci/vfio_pci.c                         |    4=20
 drivers/w1/masters/ds2490.c                         |    6 -
 fs/debugfs/inode.c                                  |   13 +-
 fs/hugetlbfs/inode.c                                |   20 ++-
 fs/jffs2/readinode.c                                |    5=20
 fs/jffs2/super.c                                    |    5=20
 include/linux/platform_data/x86/clk-pmc-atom.h      |    3=20
 include/linux/usb.h                                 |    2=20
 include/net/caif/cfpkt.h                            |   27 ++++
 include/net/sctp/command.h                          |    1=20
 lib/Makefile                                        |    1=20
 lib/test_kasan.c                                    |    2=20
 mm/kmemleak.c                                       |   18 ++-
 mm/vmscan.c                                         |    9 +
 net/batman-adv/bridge_loop_avoidance.c              |   16 ++
 net/batman-adv/translation-table.c                  |   32 ++++-
 net/caif/cfctrl.c                                   |   50 +++------
 net/ipv4/ip_output.c                                |    1=20
 net/ipv6/ip6_flowlabel.c                            |   22 ++-
 net/packet/af_packet.c                              |   24 ++--
 net/rxrpc/call_object.c                             |   32 ++---
 net/sctp/sm_sideeffect.c                            |   29 -----
 net/sctp/sm_statefuns.c                             |   35 ++++--
 security/selinux/hooks.c                            |   40 +++++--
 sound/pci/hda/patch_realtek.c                       |    9 +
 sound/soc/stm/stm32_sai_sub.c                       |    2=20
 sound/usb/line6/driver.c                            |   60 ++++++----
 sound/usb/line6/podhd.c                             |   21 ++-
 sound/usb/line6/toneport.c                          |   24 +++-
 86 files changed, 779 insertions(+), 421 deletions(-)

Aaro Koskinen (4):
      net: stmmac: ratelimit RX error logs
      net: stmmac: don't overwrite discard_frame status
      net: stmmac: fix dropping of multi-descriptor RX frames
      net: stmmac: don't log oversized frames

Al Viro (2):
      jffs2: fix use-after-free on symlink traversal
      debugfs: fix use-after-free on symlink traversal

Alan Stern (4):
      USB: yurex: Fix protection fault after device removal
      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
      USB: core: Fix unterminated string returned by usb_string()
      USB: core: Fix bug caused by duplicate interface PM usage counter

Alexandre Belloni (1):
      rtc: da9063: set uie_unsupported when relevant

Andrew Lunn (1):
      net: phy: marvell: Fix buffer overrun with stats counters

Andrey Konovalov (1):
      kasan: prevent compiler from optimizing away memset in tests

Aneesh Kumar K.V (1):
      powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area =
topdown search

Anson Huang (1):
      Input: snvs_pwrkey - initialize necessary driver data before enabling=
 IRQ

Arnaud Pouliquen (1):
      ASoC: stm32: fix sai driver name initialisation

Arnd Bergmann (4):
      caif: reduce stack size with KASAN
      ARM: orion: don't use using 64-bit DMA masks
      ARM: iop: don't use using 64-bit DMA masks
      mm/kmemleak.c: fix unused-function warning

Arvind Sankar (1):
      igb: Fix WARN_ONCE on runtime suspend

Bart Van Assche (1):
      scsi: RDMA/srpt: Fix a credit leak for aborted commands

Brian Norris (1):
      Bluetooth: btusb: request wake pin with NOAUTOEN

Catalin Marinas (1):
      kmemleak: powerpc: skip scanning holes in the .bss section

Colin Ian King (1):
      kasan: remove redundant initialization of variable 'real_size'

Dan Carpenter (1):
      net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc

Daniel Jurgens (2):
      IB/core: Unregister notifier before freeing MAD security
      IB/core: Fix potential memory leak while creating MAD agents

David Howells (1):
      rxrpc: Fix net namespace cleanup

David M=FCller (1):
      clk: x86: Add system specific quirk to mark clocks as critical

Dmitry Torokhov (2):
      HID: input: add mapping for Assistant key
      Input: stmfts - acknowledge that setting brightness is a blocking call

Douglas Anderson (1):
      ARM: dts: rockchip: Fix gpu opp node names for rk3288

Eric Dumazet (1):
      ipv6/flowlabel: wait rcu grace period before put_pid()

Geert Uytterhoeven (1):
      rtc: sh: Fix invalid alarm warning for non-enabled alarm

Greg Kroah-Hartman (2):
      ALSA: line6: use dynamic buffers
      Linux 4.14.117

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup

He, Bo (1):
      HID: debug: fix race condition with between rdesc_show() and device r=
emoval

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jeremy Fertic (3):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix the dac write calculation

Julien Thierry (1):
      arm64: Fix single stepping in kernel traps

Kailang Yang (2):
      ALSA: hda/realtek - Add new Dell platform for headset mode
      ALSA: hda/realtek - Fixed Dell AIO speaker noise

Kangjie Lu (1):
      HID: logitech: check the return value of create_singlethread_workqueue

Kim Phillips (1):
      perf/x86/amd: Update generic hardware cache events for Family 17h

Konstantin Khorenko (1):
      bonding: show full hw address in sysfs for slave entries

Liubin Shu (1):
      net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Louis Taylor (1):
      vfio/pci: use correct format characters

Malte Leip (1):
      usb: usbip: fix isoc packet num validation in get_pipe

Mark Rutland (1):
      arm64: only advance singlestep for user instruction traps

Michael Chan (1):
      bnxt_en: Improve multicast address setup logic.

Michael Kelley (1):
      scsi: storvsc: Fix calculation of sub-channel count

Mike Kravetz (1):
      hugetlbfs: fix memory leak for resv_map

Minchan Kim (1):
      mm: do not stall register_shrinker()

Nicolas Le Bayon (1):
      i2c: i2c-stm32f7: Fix SDADEL minimum formula

Omri Kahalon (1):
      net/mlx5: E-Switch, Fix esw manager vport indication for more vport c=
ommands

Ondrej Mosnacek (1):
      selinux: never allow relabeling on context mounts

Randy Dunlap (1):
      sh: fix multiple function definition build errors

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Sven Eckelmann (3):
      batman-adv: Reduce claim hash refcnt only for removed entry
      batman-adv: Reduce tt_local hash refcnt only for removed entry
      batman-adv: Reduce tt_global hash refcnt only for removed entry

Tony Luck (1):
      x86/mce: Improve error message when kernel cannot recover, p2

Vasundhara Volam (1):
      bnxt_en: Free short FW command HWRM memory in error path in bnxt_init=
_one()

Willem de Bruijn (2):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: validate msg_namelen in send directly

Xin Long (1):
      sctp: avoid running the sctp state machine recursively

Xose Vazquez Perez (1):
      scsi: core: add new RDAC LENOVO/DE_Series device

Yonglong Liu (4):
      net: hns: Use NAPI_POLL_WEIGHT for hns driver
      net: hns: Fix probabilistic memory overwrite when HNS driver initiali=
zed
      net: hns: fix ICMP6 neighbor solicitation messages discard problem
      net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yufen Yu (1):
      nvme-loop: init nvmet_ctrl fatal_err_work when allocate

Yuval Avnery (1):
      IB/core: Destroy QP if XRC QP fails


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzSn7wACgkQONu9yGCS
aT4aaxAAw507qvDsHRp54+nz6EGVm/7Ua8QTNOekIdInRAofUXBCMe9+CluQypIA
rAHDy/+axOrimn25SxTDSCKoefYnv+/0mmWvt3Btwfdrqefnm3r2SQBTQ8Bx/TZ1
4jn2mO4vAPY675ERbTYBv3xaQlsAW1GG2+ICqzAO5lsiwNRl7BoxhvlgeotAJ2RU
w00PxDk99CBPfzHi27a4iOecTFgq4qrRm73YlK2WkOtMm3usZVGMCRwgaDjxzCQq
37F6OQABvrChE++dRn2vi3vKNmlGo3YJEMVaYoSdO0hdVLOp5C7w7BPeMxZZINGR
umakln+6uH4A6akkOT89Z76udfpUYg/znSGi6KgY808A5Yu+BjhmjRD+DqhZI6TE
K9BmrysGQ8fZobhLIHzfIY+uqBT7cca+0DHR0XF/k4IOkcDVSIvcSGy+mT6mJ/FV
urjU+J1z4gRroK2/Y+bSMy1X9yHNMBCf3PUU1+2jNAwUxRsHKRYOkusaVzJ+OE7F
3SDGXNfZ0Kyu0TXc5tV0rx7CDMhyU3BJ1fOkj/fF6TObVSlJ7q+P9w7dNgVKbP01
kWsv6YWv/jeOFIlIEXCZbHBFynAih2N3b5dYiLjPowu8oT7ynVMmJdN/X4vwz6B3
YOVgxJiCtrA/3QCaELHrQgQlAWphK72ZaOyP7AsK+HeelLAWJuo=
=srOz
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
