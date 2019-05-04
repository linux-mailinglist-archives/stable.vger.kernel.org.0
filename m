Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1041C13842
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 10:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfEDIUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 04:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfEDIUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 04:20:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E524A2084A;
        Sat,  4 May 2019 08:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556958044;
        bh=z8c8fEt0oNabGqoykDwj20sTtLDGK2Cx5FP4eXjoAkE=;
        h=Date:From:To:Cc:Subject:From;
        b=d7BKvYj7trBveL34JwMwp4WklrAu2xSI5HFKh4xGENNQsth67fXoSvjLPKSgaaIF9
         GYOa+dy3esfJ8LvbrVnsADo88HB2nN24AAx3rb/kyykC0UHR4GH4w8R0aunN0cwoxy
         /cU87Zph/u8Ic7NpNudrKosUzSl5diEihIBZCUqU=
Date:   Sat, 4 May 2019 10:20:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.39
Message-ID: <20190504082042.GA28243@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.39 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-i801                   |    1=20
 Makefile                                            |    2=20
 arch/arm/Kconfig                                    |    1=20
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts            |    2=20
 arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi            |    4 -
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi        |    1=20
 arch/arm/include/asm/kvm_mmu.h                      |   11 ++++
 arch/arm/mach-imx/mach-imx51.c                      |    1=20
 arch/arm64/include/asm/kvm_mmu.h                    |   11 ++++
 arch/arm64/kvm/reset.c                              |    6 +-
 arch/s390/include/asm/elf.h                         |   11 +++-
 arch/x86/mm/mmap.c                                  |    2=20
 arch/x86/realmode/init.c                            |    2=20
 drivers/acpi/acpica/evgpe.c                         |    6 --
 drivers/ata/libata-zpodd.c                          |   34 ++++++++++-----
 drivers/gpio/gpio-aspeed.c                          |    2=20
 drivers/gpio/gpiolib-of.c                           |    8 +++
 drivers/gpu/drm/drm_drv.c                           |    6 --
 drivers/gpu/drm/drm_file.c                          |    6 --
 drivers/gpu/drm/meson/meson_drv.c                   |    9 ++--
 drivers/gpu/drm/tegra/hub.c                         |    4 +
 drivers/i2c/busses/Kconfig                          |    1=20
 drivers/i2c/busses/i2c-i801.c                       |    4 +
 drivers/iommu/amd_iommu.c                           |    9 ++--
 drivers/iommu/amd_iommu_init.c                      |    7 +--
 drivers/iommu/amd_iommu_types.h                     |    2=20
 drivers/leds/leds-pca9532.c                         |    8 ++-
 drivers/leds/trigger/ledtrig-netdev.c               |   16 +++----
 drivers/net/ethernet/cadence/macb_main.c            |   10 +++-
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    1=20
 drivers/net/ethernet/micrel/ks8851.c                |   36 ++++++++--------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |   14 +++---
 drivers/net/ethernet/ti/netcp_ethss.c               |    8 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   |    2=20
 drivers/net/ieee802154/adf7242.c                    |    4 +
 drivers/net/ieee802154/mac802154_hwsim.c            |    2=20
 drivers/nvme/host/multipath.c                       |    5 --
 drivers/s390/net/qeth_l3_main.c                     |    4 +
 drivers/s390/scsi/zfcp_fc.c                         |   21 +++++++--
 drivers/scsi/aacraid/aacraid.h                      |    7 ++-
 drivers/scsi/aacraid/commsup.c                      |    4 -
 drivers/scsi/mpt3sas/mpt3sas_base.c                 |    6 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                |   12 +++++
 drivers/scsi/qla4xxx/ql4_os.c                       |    2=20
 drivers/staging/axis-fifo/Kconfig                   |    1=20
 drivers/staging/mt7621-pci/Kconfig                  |    1=20
 drivers/staging/rtl8188eu/core/rtw_xmit.c           |    9 +++-
 drivers/staging/rtl8188eu/include/rtw_xmit.h        |    2=20
 drivers/staging/rtl8712/rtl8712_cmd.c               |   10 ----
 drivers/staging/rtl8712/rtl8712_cmd.h               |    2=20
 drivers/staging/rtl8723bs/core/rtw_xmit.c           |   14 +++---
 drivers/staging/rtl8723bs/include/rtw_xmit.h        |    2=20
 drivers/staging/rtlwifi/phydm/rtl_phydm.c           |    2=20
 drivers/staging/rtlwifi/rtl8822be/fw.c              |    2=20
 drivers/tty/serial/ar933x_uart.c                    |   24 +++-------
 drivers/tty/serial/sc16is7xx.c                      |   12 ++++-
 drivers/usb/dwc3/dwc3-pci.c                         |    4 +
 drivers/usb/gadget/udc/net2272.c                    |    1=20
 drivers/usb/gadget/udc/net2280.c                    |    8 +--
 drivers/usb/host/u132-hcd.c                         |    3 +
 drivers/usb/misc/usb251xb.c                         |    2=20
 fs/ceph/inode.c                                     |    2=20
 fs/fuse/dev.c                                       |   12 ++---
 fs/nfs/client.c                                     |    2=20
 fs/pipe.c                                           |    4 -
 fs/splice.c                                         |   12 ++++-
 include/linux/mm.h                                  |   15 ++++++
 include/linux/pipe_fs_i.h                           |   10 ++--
 include/linux/sched/signal.h                        |   18 ++++++++
 include/net/tc_act/tc_gact.h                        |    2=20
 include/net/xdp_sock.h                              |    1=20
 kernel/ptrace.c                                     |   15 +++++-
 kernel/trace/trace.c                                |    6 ++
 mm/gup.c                                            |   45 +++++++++++++++=
-----
 mm/hugetlb.c                                        |   13 +++++
 net/bridge/br_netfilter_hooks.c                     |    1=20
 net/bridge/br_netfilter_ipv6.c                      |    2=20
 net/ipv6/netfilter/ip6t_srh.c                       |    6 ++
 net/netfilter/Kconfig                               |    1=20
 net/netfilter/nft_set_rbtree.c                      |    7 +--
 net/xdp/xdp_umem.c                                  |   19 --------
 scripts/kconfig/lxdialog/inputbox.c                 |    3 -
 scripts/kconfig/nconf.c                             |    2=20
 scripts/kconfig/nconf.gui.c                         |    3 -
 scripts/selinux/genheaders/genheaders.c             |    1=20
 scripts/selinux/mdp/mdp.c                           |    1=20
 security/selinux/include/classmap.h                 |    1=20
 tools/perf/util/machine.c                           |   32 ++++++++------
 virt/kvm/arm/vgic/vgic-its.c                        |   21 ++++++---
 virt/kvm/arm/vgic/vgic-v3.c                         |    4 -
 91 files changed, 450 insertions(+), 227 deletions(-)

Aaro Koskinen (1):
      net: stmmac: don't set own bit too early for jumbo frames

Aditya Pakki (5):
      qlcnic: Avoid potential NULL pointer dereference
      staging: rtl8188eu: Fix potential NULL pointer dereference of kcalloc
      staging: rtlwifi: rtl8822b: fix to avoid potential NULL pointer deref=
erence
      staging: rtlwifi: Fix potential NULL pointer dereference of kzalloc
      usb: usb251xb: fix to avoid potential NULL pointer dereference

Al Viro (1):
      ceph: fix use-after-free on symlink traversal

Andrei Vagin (1):
      ptrace: take into account saved_sigmask in PTRACE{GET,SET}SIGMASK

Arnd Bergmann (2):
      staging: axis-fifo: add CONFIG_OF dependency
      netfilter: fix NETFILTER_XT_TARGET_TEE dependencies

Bj=C3=B6rn T=C3=B6pel (1):
      xsk: fix umem memory leak on cleanup

Changbin Du (1):
      kconfig/[mn]conf: handle backspace (^H) key

Dan Carpenter (1):
      staging: rtl8712: uninitialized memory in read_bbreg_hdl()

Dave Carroll (1):
      scsi: aacraid: Insure we don't access PCIe space during AER/EEH

Davide Caratti (1):
      net/sched: don't dereference a->goto_chain to read the chain index

Felipe Balbi (1):
      usb: dwc3: pci: add support for Comet Lake PCH ID

Geert Uytterhoeven (1):
      gpio: of: Fix of_gpiochip_add() error path

Greg Kroah-Hartman (1):
      Linux 4.19.39

Guido Kiener (3):
      usb: gadget: net2280: Fix overrun of OUT messages
      usb: gadget: net2280: Fix net2280_dequeue()
      usb: gadget: net2272: Fix net2272_dequeue()

Harini Katakam (1):
      net: macb: Add null check for PCLK and HCLK

Helen Koike (1):
      ARM: dts: bcm283x: Fix hdmi hpd gpio pull

Jarkko Nikula (1):
      i2c: i801: Add support for Intel Comet Lake

Jean-Philippe Brucker (2):
      drm/meson: Fix invalid pointer in meson_drv_unbind()
      drm/meson: Uninstall IRQ handler

Joerg Roedel (1):
      iommu/amd: Reserve exclusion range in iova-domain

Julian Wiedmann (1):
      s390/qeth: fix race when initializing the IP address table

Kangjie Lu (5):
      net: ieee802154: fix a potential NULL pointer dereference
      netfilter: ip6t_srh: fix NULL pointer dereferences
      gpio: aspeed: fix a potential NULL pointer dereference
      scsi: qla4xxx: fix a potential NULL pointer dereference
      leds: pca9532: fix a potential NULL pointer dereference

Li RongQing (1):
      ieee802154: hwsim: propagate genlmsg_reply return code

Linus Torvalds (3):
      mm: make page ref count overflow check tighter and more explicit
      mm: add 'try_get_page()' helper function
      mm: prevent get_user_pages() from overflowing page refcount

Lukas Wunner (4):
      net: ks8851: Dequeue RX packets explicitly
      net: ks8851: Reassert reset pin if chip ID check fails
      net: ks8851: Delay requesting IRQ until opened
      net: ks8851: Set initial carrier state to down

Mao Wenan (1):
      sc16is7xx: missing unregister/delete driver on error in sc16is7xx_ini=
t()

Marc Zyngier (3):
      KVM: arm64: Reset the PMU in preemptible context
      KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest me=
mory
      KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots

Marco Felsch (1):
      ARM: dts: pfla02: increase phy reset duration

Martin George (1):
      nvme-multipath: relax ANA state check

Martin Schwidefsky (1):
      s390: limit brk randomization to 32MB

Masanari Iida (1):
      ARM: dts: imx6qdl: Fix typo in imx6qdl-icore-rqs.dtsi

Matteo Croce (1):
      x86/realmode: Don't leak the trampoline kernel address

Matthew Wilcox (1):
      fs: prevent page refcount overflow in pipe_buf_get

Maxim Zhukov (1):
      staging, mt7621-pci: fix build without pci support

Mukesh Ojha (1):
      usb: u132-hcd: fix resource leak

Noralf Tr=C3=B8nnes (1):
      drm: Fix drm_release() and device unplug

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: check for inactive element after flag mism=
atch

Paulo Alcantara (1):
      selinux: use kernel linux/socket.h for genheaders and mdp

Petr =C5=A0tetiar (1):
      serial: ar933x_uart: Fix build failure with disabled console

Rafael J. Wysocki (1):
      Revert "ACPICA: Clear status of GPEs before enabling them"

Rafa=C5=82 Mi=C5=82ecki (1):
      leds: trigger: netdev: fix refcnt leak on interface rename

Ralph Campbell (1):
      x86/mm: Don't exceed the valid physical address space

Rasmus Villemoes (1):
      leds: trigger: netdev: use memcpy in device_name_store

Sekhar Nori (1):
      ARM: davinci: fix build failure with allnoconfig

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during expander reset

Steffen Maier (1):
      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RS=
CN

Thierry Reding (1):
      drm/tegra: hub: Fix dereference before check

Trond Myklebust (1):
      NFS: Fix a typo in nfs_init_timeout_values()

Wei Li (1):
      perf machine: Update kernel map address and re-order properly

Wen Yang (4):
      ARM: imx51: fix a leaked reference by adding missing of_node_put
      net: xilinx: fix possible object reference leak
      net: ibm: fix possible object reference leak
      net: ethernet: ti: fix possible object reference leak

Xin Long (1):
      netfilter: bridge: set skb transport_header before entering NF_INET_P=
RE_ROUTING

raymond pang (1):
      libata: fix using DMA buffers on stack


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzNS1kACgkQONu9yGCS
aT5R1Q//ZW7KKGwC0JHBkuflAaO3kOgFywmzMvp0DRImMzCCZsWypGoFz8ojepFp
M1cLdyKXWU/d4GboY0HFHNSR+7x+9l1ivFKwAHvaZjH67Afw6Md65Qzs/hb1KVSP
iC7G5EcfPt2CRcFdMgUGObTu0fAsOKQB02uINxQIurMwUmOiNBldyZn6TUo9HeZU
pINzkKDUgEilIRfPgD2aLRNh1JQdMT7u5MHSBHb20Oenw6NAqHk2qKggOACzGxod
FiftO/buSRqYDT6qrRkYXpaIjAZwTacWUNqiMA0lIGflFGuI6gDG/8Url0VM9iBT
0QN609n3841MymYSF0StApVN0dCyjR7aFFKI6eIDHiAhbtxcJMhN9g2u8TVt2+k1
jr2pKwUr8VOuoaNO1+EpOltsjbCCRbBU2pmCYw656dWIQPDjaXzm7ZkjgAIGRapN
eSRXf34MJ1Ykz9iHV60XfZTZLsLjmlsYAMA8cOqMs+Mh0W7R1YZxXT8Qfb3uGUk/
unO79BtfRarNpIfV+ZFtSWKWUqtj2dq6g8x5y3Ggmi6R3XqPyB1Aij9sepRp3zlY
bkaQX5HGnMEOFRi+1Ql0EpiN6pqTRzsrJGv8QS5G/XD6lDtgt0Ll/E7dzmU9bdG/
Bh9uMsxmcjsMOC6Gt3olENogKjwrzxnN3NpaJ32tw6cMaH46Pgs=
=H0Wg
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
