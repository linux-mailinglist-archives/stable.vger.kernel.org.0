Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE2E842B
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfJ2JTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbfJ2JTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:19:34 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A48E82086D;
        Tue, 29 Oct 2019 09:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340772;
        bh=LnaehMqsVNfjDAt86oxxkcMNaH+S5MtxjDnDXNHncCI=;
        h=Date:From:To:Cc:Subject:From;
        b=B6fVP0j/VT5H1RpSPdtrXSnNq+r0uAs5p5ay8sXWw46nKgduuzA/ecUW4HBXKBZjI
         sw/6UkhIWjoC40Ma2QRnD14KqVWfP5NCFSmNMB0vFPS3UQzi/MRbRHGsuFl65bNsTq
         vNezmT6dKJotKpOFGbHO1wPfFKvgQp8yl2jYbA6M=
Date:   Tue, 29 Oct 2019 10:19:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.81
Message-ID: <20191029091929.GA581952@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.81 kernel.

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

 Makefile                                                |    2=20
 arch/arm/boot/dts/am4372.dtsi                           |    2=20
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |    3=20
 arch/arm/mach-omap2/pm.c                                |  100 -----------=
-----
 arch/arm/xen/efi.c                                      |    2=20
 arch/arm64/kernel/cpu_errata.c                          |   33 +++++
 arch/mips/boot/dts/qca/ar9331.dtsi                      |    2=20
 arch/mips/loongson64/common/serial.c                    |    2=20
 arch/mips/mm/tlbex.c                                    |   23 ++-
 arch/parisc/mm/ioremap.c                                |   12 +
 arch/x86/kernel/apic/x2apic_cluster.c                   |    3=20
 arch/x86/kernel/head64.c                                |   22 +++
 arch/x86/xen/efi.c                                      |    2=20
 arch/xtensa/kernel/xtensa_ksyms.c                       |    7 -
 block/blk-rq-qos.h                                      |   13 --
 drivers/acpi/cppc_acpi.c                                |    2=20
 drivers/ata/ahci.c                                      |    4=20
 drivers/base/core.c                                     |    3=20
 drivers/base/memory.c                                   |    3=20
 drivers/cpufreq/cpufreq.c                               |   10 -
 drivers/edac/ghes_edac.c                                |    4=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                 |   35 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                 |   35 -----
 drivers/gpu/drm/drm_edid.c                              |    3=20
 drivers/gpu/drm/radeon/radeon_drv.c                     |    8 -
 drivers/gpu/drm/ttm/ttm_bo_vm.c                         |   16 +-
 drivers/infiniband/hw/cxgb4/mem.c                       |   28 ++--
 drivers/input/misc/da9063_onkey.c                       |    5=20
 drivers/input/rmi4/rmi_driver.c                         |    6=20
 drivers/md/dm-cache-target.c                            |   28 ----
 drivers/md/raid0.c                                      |    2=20
 drivers/memstick/host/jmb38x_ms.c                       |    2=20
 drivers/mmc/host/cqhci.c                                |    3=20
 drivers/net/dsa/qca8k.c                                 |    4=20
 drivers/net/dsa/rtl8366rb.c                             |   16 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h          |    1=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c            |   11 +
 drivers/net/ethernet/hisilicon/hns_mdio.c               |    6=20
 drivers/net/ethernet/i825xx/lasi_82596.c                |    4=20
 drivers/net/ethernet/i825xx/lib82596.c                  |    4=20
 drivers/net/ethernet/i825xx/sni_82596.c                 |    4=20
 drivers/net/ethernet/ibm/ibmvnic.c                      |    8 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |   12 +
 drivers/net/ieee802154/ca8210.c                         |    2=20
 drivers/net/usb/r8152.c                                 |    3=20
 drivers/net/xen-netback/interface.c                     |    1=20
 drivers/nvme/host/core.c                                |    5=20
 drivers/pci/pci.c                                       |   24 +--
 drivers/pinctrl/intel/pinctrl-cherryview.c              |    4=20
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c             |   26 ++--
 drivers/s390/scsi/zfcp_fsf.c                            |   16 ++
 drivers/scsi/ch.c                                       |    1=20
 drivers/scsi/megaraid.c                                 |    4=20
 drivers/scsi/qla2xxx/qla_target.c                       |    4=20
 drivers/scsi/scsi_error.c                               |    3=20
 drivers/scsi/scsi_sysfs.c                               |   11 +
 drivers/scsi/sd.c                                       |    3=20
 drivers/scsi/ufs/ufshcd.c                               |    3=20
 drivers/staging/wlan-ng/cfg80211.c                      |    6=20
 drivers/usb/class/usblp.c                               |    4=20
 drivers/usb/gadget/udc/lpc32xx_udc.c                    |    6=20
 drivers/usb/misc/ldusb.c                                |   23 +--
 drivers/usb/misc/legousbtower.c                         |    5=20
 drivers/usb/serial/ti_usb_3410_5052.c                   |   10 -
 fs/btrfs/extent-tree.c                                  |    1=20
 fs/btrfs/file.c                                         |   36 ++---
 fs/btrfs/relocation.c                                   |    2=20
 fs/cifs/file.c                                          |    6=20
 fs/cifs/smb1ops.c                                       |    3=20
 fs/ocfs2/journal.c                                      |    3=20
 fs/ocfs2/localalloc.c                                   |    3=20
 fs/proc/page.c                                          |   28 ++--
 include/scsi/scsi_eh.h                                  |    1=20
 include/trace/events/btrfs.h                            |    3=20
 kernel/events/core.c                                    |    2=20
 kernel/trace/trace_event_perf.c                         |    4=20
 lib/textsearch.c                                        |    4=20
 mm/hugetlb.c                                            |    5=20
 mm/memfd.c                                              |   18 +-
 mm/memory-failure.c                                     |   36 +++--
 mm/page_owner.c                                         |    5=20
 mm/slub.c                                               |   13 +-
 net/ipv4/route.c                                        |   11 +
 net/ipv6/ip6_input.c                                    |    4=20
 net/mac80211/debugfs_netdev.c                           |   11 +
 net/mac80211/mlme.c                                     |    5=20
 net/netfilter/nft_connlimit.c                           |    7 -
 net/sched/act_api.c                                     |   14 +-
 net/sctp/socket.c                                       |    4=20
 net/wireless/nl80211.c                                  |    3=20
 net/wireless/wext-sme.c                                 |    8 -
 scripts/namespace.pl                                    |   13 +-
 sound/pci/hda/patch_hdmi.c                              |    2=20
 sound/pci/hda/patch_realtek.c                           |   14 ++
 sound/soc/sh/rcar/core.c                                |    1=20
 sound/usb/pcm.c                                         |    3=20
 96 files changed, 494 insertions(+), 438 deletions(-)

Alex Deucher (1):
      Revert "drm/radeon: Fix EEH during kexec"

Alexander Shishkin (1):
      perf/aux: Fix AUX output stopping

Balbir Singh (1):
      nvme-pci: Fix a race in controller removal

Bart Van Assche (1):
      scsi: ch: Make it possible to open a ch device multiple times again

Biao Huang (1):
      net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow

Christophe JAILLET (2):
      mips: Loongson: Fix the link time qualifier of 'serial_exit()'
      memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Colin Ian King (1):
      staging: wlan-ng: fix exit return when sme->key_idx >=3D NUM_WEPKEYS

C=C3=A9dric Le Goater (1):
      net/ibmvnic: Fix EOI when running in XIVE mode.

Damien Le Moal (1):
      scsi: core: save/restore command resid for error handling

Dan Williams (1):
      libata/ahci: Fix PCS quirk application

Daniel Drake (1):
      ALSA: hda/realtek - Enable headset mic on Asus MJ401TA

David Hildenbrand (4):
      drivers/base/memory.c: don't access uninitialized memmaps in soft_off=
line_page_store()
      fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c
      mm/memory-failure.c: don't access uninitialized memmaps in memory_fai=
lure()
      hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_giga=
ntic()

Dmitry Torokhov (1):
      pinctrl: cherryview: restore Strago DMI workaround for all versions

Eric Dumazet (1):
      net: avoid potential infinite loop in tc_ctl_action()

Evan Green (1):
      Input: synaptics-rmi4 - avoid processing unknown IRQs

Faiz Abbas (1):
      mmc: cqhci: Commit descriptors before setting the doorbell

Filipe Manana (2):
      Btrfs: add missing extents release on file extent cluster relocation =
error
      Btrfs: check for the full sync flag while holding the inode lock duri=
ng fsync

Florian Fainelli (2):
      net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
      net: bcmgenet: Set phydev->dev_flags only for internal PHYs

Greg KH (1):
      RDMA/cxgb4: Do not dma memory off of the stack

Greg Kroah-Hartman (1):
      Linux 4.19.81

Gustavo A. R. Silva (1):
      usb: udc: lpc32xx: fix bad bit shift operation

Hans de Goede (1):
      drm/amdgpu: Bail earlier when amdgpu.cik_/si_support is not set to 1

Helge Deller (1):
      parisc: Fix vmap memory leak in ioremap()/iounmap()

Jacob Keller (1):
      namespace: fix namespace.pl script to support relative paths

James Morse (1):
      EDAC/ghes: Fix Use after free in ghes_edac remove path

Jane Chu (1):
      mm/memory-failure: poison read receives SIGKILL instead of SIGBUS if =
mmaped more than once

Johan Hovold (5):
      USB: legousbtower: fix memleak on disconnect
      USB: serial: ti_usb_3410_5052: fix port-close races
      USB: ldusb: fix memleak on disconnect
      USB: usblp: fix use-after-free on disconnect
      USB: ldusb: fix read info leaks

John Garry (1):
      ACPI: CPPC: Set pcc_data[pcc_ss_id] to NULL in acpi_cppc_processor_ex=
it()

Juergen Gross (1):
      xen/netback: fix error path of xenvif_connect_data()

Junya Monden (1):
      ASoC: rsnd: Reinitialize bit clock inversion flag for every format se=
tting

Kai-Heng Feng (2):
      r8152: Set macpassthru in reset_resume callback
      drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Kailang Yang (1):
      ALSA: hda/realtek - Add support for ALC711

Lukas Wunner (1):
      ALSA: hda - Force runtime PM on Nvidia HDMI codecs

Marc Zyngier (1):
      arm64: Enable workaround for Cavium TX2 erratum 219 when running SMT

Marco Felsch (1):
      Input: da9063 - fix capability and drop KEY_SLEEP

Matthew Wilcox (Oracle) (1):
      memfd: Fix locking when tagging pins

Max Filippov (1):
      xtensa: drop EXPORT_SYMBOL for outs*/ins*

Miaoqing Pan (2):
      nl80211: fix null pointer dereference
      mac80211: fix txq null pointer dereference

Michal Vok=C3=A1=C4=8D (1):
      net: dsa: qca8k: Use up to 7 ports for all operations

Mikulas Patocka (1):
      dm cache: fix bugs when a GFP_NOWAIT allocation fails

Navid Emamdoost (1):
      ieee802154: ca8210: prevent memory leak

Oleksij Rempel (1):
      MIPS: dts: ar9331: fix interrupt-controller size

Oliver Neukum (1):
      scsi: sd: Ignore a failure to sync cache due to lack of authorization

Pablo Neira Ayuso (1):
      netfilter: nft_connlimit: disable bh on garbage collection

Patrick Williams (2):
      pinctrl: armada-37xx: fix control of pins 32 and up
      pinctrl: armada-37xx: swap polarity on LED group

Paul Burton (1):
      MIPS: tlbex: Fix build_restore_pagemask KScratch restore

Pavel Shilovsky (1):
      CIFS: Fix use after free of file info structures

Peter Ujfalusi (1):
      ARM: dts: am4372: Set memory bandwidth limit for DISPC

Prateek Sood (1):
      tracing: Fix race in perf_trace_buf initialization

Qian Cai (2):
      mm/slub: fix a deadlock in show_slab_objects()
      mm/page_owner: don't access uninitialized memmaps when reading /proc/=
pagetypeinfo

Qu Wenruo (2):
      btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_=
group()
      btrfs: tracepoints: Fix bad entry members of qgroup events

Quinn Tran (1):
      scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Rafael J. Wysocki (2):
      cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown
      PCI: PM: Fix pci_power_up()

Randy Dunlap (1):
      lib: textsearch: fix escapes in example code

Roberto Bergantinos Corpas (1):
      CIFS: avoid using MID 0xFFFF

Ross Lagerwall (1):
      xen/efi: Set nonblocking callbacks

Sean Christopherson (1):
      x86/apic/x2apic: Fix a NULL pointer deref when handling a dying cpu

Song Liu (1):
      md/raid0: fix warning message for parameter default_layout

Stanley Chu (1):
      scsi: ufs: skip shutdown if hba is not powered

Stefano Brivio (1):
      ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Steffen Maier (1):
      scsi: zfcp: fix reaction on bit error threshold notification

Steve Wahl (1):
      x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area

Szabolcs Sz=C5=91ke (1):
      ALSA: usb-audio: Disable quirks for BOSS Katana amplifiers

Tejun Heo (1):
      blk-rq-qos: fix first node deletion of rq_qos_del()

Thomas Bogendoerfer (1):
      net: i82596: fix dma_alloc_attr for sni_82596

Thomas Hellstrom (1):
      drm/ttm: Restore ttm prefaulting

Tony Lindgren (2):
      ARM: OMAP2+: Fix missing reset done flag for am3 and am43
      ARM: OMAP2+: Fix warnings with broken omap2_set_init_voltage()

Wei Wang (1):
      ipv4: fix race condition between route lookup and invalidation

Wen Yang (1):
      net: dsa: rtl8366rb: add missing of_node_put after calling of_get_chi=
ld_by_name

Will Deacon (2):
      cfg80211: wext: avoid copying malformed SSIDs
      mac80211: Reject malformed SSID elements

Xiang Chen (1):
      scsi: megaraid: disable device when probe failed after enabled device

Xin Long (2):
      net: ipv6: fix listify ip6_rcv_finish in case of forwarding
      sctp: change sctp_prot .no_autobind with true

Yi Li (1):
      ocfs2: fix panic due to ocfs2_wq is null

Yizhuo (1):
      net: hisilicon: Fix usage of uninitialized variable in function mdio_=
sc_cfg_reg_write()

Yufen Yu (1):
      scsi: core: try to get module before removing device


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl24BCEACgkQONu9yGCS
aT4FWw//axKB5iH993VpVxFzYvWZosDr4ZfM7B1VXQXXt+k98oBX5SAPWpVumjD3
EOGh7GkK+QaxtkgkbP0sLMdvzwil6LiJt0cQl+AF7JRy1R+nf+dKk9z0EcwAgOEq
mzaFUqiTdMQ2RJwBcJdFnBOo4b+nOqnYXnsANJnj/UsA7sBqxqYhQYi6Dd/eFswA
LsJEiyyFaddzpna7yLotcDqjf6EtVLgEzZqfUlsY0MApS1EiFL01p1dTDDb+Xh/3
ZMbw+ycZxz/E05xfRsvN0QlHdGlKLzZ1NqutNqbMoRVUzIFyBLmiVmYHex8XKjsJ
qHZdZEHxp8k2KL/EAxoYaFWku6iUzMXe42LSBaC/msgS77t47l7dD3U49yAKSSFF
jA9dvg/gpp7Mg/THIz9djlvpGlIQ3oQlEAbUJYgkNX9W28VVosSjn2U0HztFyW8i
isT55zNAH60I433XuTE8EL8MU3KUR3oKTmKPuVjsdvah1tsHH9N/h9RzlkhTbj0Q
teQa/D7pGs50kySFdlkohL5mxaILfzWTNM9UzMhCmQZ3AfrvSdGrLftVsGlxNHou
6N1R8KiYXa+annSvj7PrLAaWXjrWivtL4HEjBBw0A37RO3XxDkw41y/bjUWabv4W
iMaHeLqO6nsK/KiNiC6756CtsLs2TjglDLq2yC+7Jnk0kq22lgc=
=9sNO
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
