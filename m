Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87537B9CA8
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 08:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407393AbfIUGfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 02:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407392AbfIUGfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 02:35:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A20208C0;
        Sat, 21 Sep 2019 06:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569047742;
        bh=Er+SSWEBGOx6k1BvsO37dBRnCXq2lS4XfaL8GFwGUDU=;
        h=Date:From:To:Cc:Subject:From;
        b=B3Sl5Q5MEvJiZ+VCq4Wq4ENJNQanZOY0ZGOlaIEO69j4Ga8+cwj+4WHf/aPXL/xnY
         Im1HK++jxL5iWnNF+HP/9KJ1D+EMBS9rlrtOU69Zjm3Es2CsZpZpd9ZfIH62Wpg8Dd
         rNltmOiAYHKUIMFyI7Ht/7I5giZLTyZ99f68WiHI=
Date:   Sat, 21 Sep 2019 08:35:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.146
Message-ID: <20190921063540.GA1082786@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.146 kernel.

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

 Makefile                                                        |    2=20
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi                       |   50 +++=
+-----
 arch/arm/mach-omap2/omap4-common.c                              |    3=20
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c                       |    3=20
 arch/arm/mm/init.c                                              |    8 +
 arch/powerpc/mm/pgtable-radix.c                                 |   16 +-
 arch/s390/net/bpf_jit_comp.c                                    |   12 +-
 arch/x86/events/amd/ibs.c                                       |   13 +-
 arch/x86/events/intel/core.c                                    |    6 +
 arch/x86/hyperv/mmu.c                                           |    8 -
 arch/x86/include/asm/perf_event.h                               |   12 +-
 arch/x86/include/asm/uaccess.h                                  |    4=20
 arch/x86/kernel/apic/io_apic.c                                  |    8 +
 drivers/atm/Kconfig                                             |    2=20
 drivers/block/floppy.c                                          |    4=20
 drivers/dma/omap-dma.c                                          |    4=20
 drivers/dma/ti-dma-crossbar.c                                   |    4=20
 drivers/firmware/google/vpd.c                                   |    4=20
 drivers/firmware/google/vpd_decode.c                            |   55 +++=
++-----
 drivers/firmware/google/vpd_decode.h                            |    6 -
 drivers/fpga/altera-ps-spi.c                                    |   11 +-
 drivers/hid/wacom_sys.c                                         |   10 +
 drivers/hid/wacom_wac.c                                         |    4=20
 drivers/i2c/busses/i2c-designware-slave.c                       |    1=20
 drivers/input/mouse/elan_i2c_core.c                             |    2=20
 drivers/iommu/amd_iommu.c                                       |   40 +++=
+++-
 drivers/media/usb/dvb-usb/technisat-usb2.c                      |   22 +---
 drivers/media/usb/tm6000/tm6000-dvb.c                           |    3=20
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                       |   10 +
 drivers/net/ethernet/marvell/sky2.c                             |    7 +
 drivers/net/ethernet/qlogic/qed/qed_main.c                      |    4=20
 drivers/net/ethernet/seeq/sgiseeq.c                             |    7 -
 drivers/net/usb/r8152.c                                         |    5=20
 drivers/net/wireless/marvell/mwifiex/ie.c                       |    3=20
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c                  |    9 +
 drivers/net/xen-netfront.c                                      |    2=20
 drivers/pci/dwc/pcie-kirin.c                                    |    4=20
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                        |    2=20
 drivers/tty/serial/atmel_serial.c                               |    1=20
 drivers/tty/serial/sprd_serial.c                                |    2=20
 drivers/usb/core/config.c                                       |   12 +-
 fs/binfmt_elf.c                                                 |   11 ++
 fs/cifs/connect.c                                               |   22 ++++
 fs/nfs/dir.c                                                    |    2=20
 fs/nfs/nfs4file.c                                               |   12 +-
 fs/nfs/pagelist.c                                               |    2=20
 fs/nfs/proc.c                                                   |    7 -
 include/uapi/linux/netfilter/xt_nfacct.h                        |    5=20
 kernel/kallsyms.c                                               |    6 -
 net/batman-adv/bat_v_ogm.c                                      |   18 ++-
 net/ipv4/tcp.c                                                  |    6 -
 net/netfilter/nf_conntrack_ftp.c                                |    2=20
 net/netfilter/xt_nfacct.c                                       |   36 +++=
+--
 net/sched/sch_generic.c                                         |    6 -
 net/wireless/nl80211.c                                          |    4=20
 security/keys/request_key_auth.c                                |    6 +
 tools/power/x86/turbostat/turbostat.c                           |    2=20
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c |   28 ++-=
--
 virt/kvm/coalesced_mmio.c                                       |   17 +--
 59 files changed, 392 insertions(+), 185 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report

Alan Stern (1):
      USB: usbcore: Fix slab-out-of-bounds bug during device reset

Aneesh Kumar K.V (1):
      powerpc/mm/radix: Use the right page size for vmemmap mapping

Ben Hutchings (1):
      tools/power x86_energy_perf_policy: Fix "uninitialized variable" warn=
ings at -O2

Benjamin Tissoires (1):
      Input: elan_i2c - remove Lenovo Legion Y7000 PnpID

Christoph Paasch (2):
      tcp: Reset send_head when removing skb from write-queue
      tcp: Don't dequeue SYN/FIN-segments from write-queue

Christophe JAILLET (2):
      Kconfig: Fix the reference to the IDT77105 Phy driver in the descript=
ion of ATM_NICSTAR_USE_IDT77105
      net: seeq: Fix the function used to release some memory in an error h=
andling path

Chunyan Zhang (1):
      serial: sprd: correct the wrong sequence of arguments

Cong Wang (1):
      net_sched: let qdisc_put() accept NULL pointer

Dan Carpenter (1):
      cifs: Use kzfree() to zero out the password

Dongli Zhang (1):
      xen-netfront: do not assume sk_buff_head list is empty in error handl=
ing

Doug Berger (1):
      ARM: 8874/1: mm: only adjust sections of valid mm structures

Faiz Abbas (1):
      ARM: dts: dra74x: Fix iodelay configuration for mmc3

Greg Kroah-Hartman (1):
      Linux 4.14.146

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()

Hung-Te Lin (1):
      firmware: google: check if size is valid when decoding VPD data

Ilya Leoshkevich (2):
      s390/bpf: fix lcgr instruction encoding
      s390/bpf: use 32-bit index for tail calls

Jann Horn (1):
      floppy: fix usercopy direction

Jarkko Nikula (1):
      i2c: designware: Synchronize IRQs when unregistering slave client

Joerg Roedel (1):
      iommu/amd: Fix race in increase_address_space()

Josh Hunt (1):
      perf/x86/intel: Restrict period on Nehalem

Juliana Rodrigueiro (1):
      netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info

Kees Cook (1):
      binfmt_elf: move brk out of mmap when doing direct loader exec

Kim Phillips (1):
      perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Marc Zyngier (1):
      kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving =
the first symbol

Masashi Honma (1):
      nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

Naoya Horiguchi (1):
      tools/power turbostat: fix buffer overrun

Nathan Chancellor (1):
      PCI: kirin: Fix section mismatch warning

Peter Zijlstra (1):
      x86/uaccess: Don't leak the AC flags into __get_user() argument evalu=
ation

Phil Reid (1):
      fpga: altera-ps-spi: Fix getting of optional confd gpio

Prashant Malani (1):
      r8152: Set memory to all 0xFFs on failed reg reads

Razvan Stefanescu (1):
      tty/serial: atmel: reschedule TX after RX was started

Ronnie Sahlberg (1):
      cifs: set domainName when a domain-key is used in multiuser

Sean Young (2):
      media: tm6000: double free if usb disconnect while streaming
      media: technisat-usb2: break out of loop at end of buffer

Stuart Hayes (1):
      iommu/amd: Flush old domains in kdump kernel

Sven Eckelmann (1):
      batman-adv: Only read OGM2 tvlv_len after buffer len check

Takashi Iwai (1):
      sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

Thomas Gleixner (1):
      x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Thomas Jarosch (1):
      netfilter: nf_conntrack_ftp: Fix debug output

Tianyu Lan (1):
      x86/hyper-v: Fix overflow bug in fill_gva_list()

Tony Lindgren (2):
      ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss
      ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Trond Myklebust (5):
      NFSv4: Fix return values for nfs4_file_open()
      NFSv4: Fix return value in nfs_finish_open()
      NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup
      NFSv2: Fix eof handling
      NFSv2: Fix write regression

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_se=
ttings

Wenwen Wang (3):
      qed: Add cleanup in qed_slowpath_start()
      dmaengine: ti: dma-crossbar: Fix a memory leak bug
      dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

YueHaibing (1):
      amd-xgbe: Fix error path in xgbe_mod_init()

Zephaniah E. Loss-Cutler-Hull (1):
      tools/power x86_energy_perf_policy: Fix argument parsing

zhaoyang (1):
      ARM: 8901/1: add a criteria for pfn_valid of arm


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2FxLwACgkQONu9yGCS
aT5w6g//ZYT2q/1eNuVTO5KZx5zHN9b/zGmoF8A921j0LLofCKtvxP31qElROnK7
nJwCTGXM1EBQT6Lv9chZcv0dlobWO6wL4FxOR4zs6IzvV9/kpLwvuF16ki5clpAr
3Te7kME2ZCeJRKQSUw8I7tjlkaSfzsB4higzcvTwW+4C0UnAnhjJyGixQeypJyNw
lbeoF92g4iE/yeQbB8f+jaX4oUEbfrRIGY03uzuorkHSVAuM6/Mfetr0FkGXosSd
V5LpSaP5Rgb451vnzRcjuVVEp2qPlt6KdXe7fi0m+2W/ZLCPK5JJPsheIczsaEr+
KSSeHHGjXRnXRABd3RMhbL2JPW2B2U/iiRJG6HJ8tnpF+2+hrzNXrjmM6cHXEY2p
cd+atQ3NX9aVATMQZBP7MCXBFI4/hKDK55omyoMvzl8H2sWSSUavLll5ZA8fqUjr
ubF5A77+KJZsHBoeQTVAnh0QPuPwgfyALdHi7BjptG3N9G2uA7T+DmTeFURnRp4t
OWQdwHIGscb5rpZ+4uh9pHnJ98Mpl3iqpvQRCIyq0wOY2TEF3hfnJJmpw0PMuyng
I0tQx4mhDiUf81n69ZUOHkjhM4IASAX2un6rvq/H4BD6/S95SN2sFCwic5s8qAfQ
+u7sNQwOIRlaf1FEPSWusOEBGnMKsY2gy4K+tU3iBHpPWHuUqrw=
=DUqW
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
