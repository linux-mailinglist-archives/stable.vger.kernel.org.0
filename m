Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFFB9C487
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 16:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfHYOuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 10:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbfHYOuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 10:50:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA737206DD;
        Sun, 25 Aug 2019 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566744630;
        bh=LURVtCljpFMA2NAlijDtqqnYZ/nJ2StuBdb/8nbRctY=;
        h=Date:From:To:Cc:Subject:From;
        b=KKEXsLQ0p1uWu+hBXEvcB0mmMPYA+AA2u59vsaCMZx6PFOEzyLVfHVKYuO4ZMG2zT
         bavr17HA/V9qOU3MJMvMv5PgjcawxFPI3bITCZ5mFhk0fCODVDiBcL0PGdkP+2RSPQ
         LEvV8Azwb88XwtHpRh+VDwlJaSnk8EcxT/sV8Obo=
Date:   Sun, 25 Aug 2019 16:50:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.140
Message-ID: <20190825145028.GA30179@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.140 kernel.

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

 Documentation/sysctl/net.txt                         |    8 +
 Makefile                                             |    2=20
 arch/arm/net/bpf_jit_32.c                            |    2=20
 arch/arm64/include/asm/efi.h                         |    6=20
 arch/arm64/include/asm/pgtable.h                     |    4=20
 arch/arm64/kernel/ftrace.c                           |   21 +-
 arch/arm64/kernel/hw_breakpoint.c                    |    7=20
 arch/arm64/kernel/return_address.c                   |    3=20
 arch/arm64/kernel/stacktrace.c                       |    3=20
 arch/arm64/net/bpf_jit_comp.c                        |    2=20
 arch/mips/net/bpf_jit.c                              |    2=20
 arch/mips/net/ebpf_jit.c                             |    2=20
 arch/powerpc/net/bpf_jit_comp.c                      |    2=20
 arch/powerpc/net/bpf_jit_comp64.c                    |    2=20
 arch/s390/net/bpf_jit_comp.c                         |    2=20
 arch/sh/kernel/hw_breakpoint.c                       |    1=20
 arch/sparc/net/bpf_jit_comp_32.c                     |    2=20
 arch/sparc/net/bpf_jit_comp_64.c                     |    2=20
 arch/x86/include/asm/pgtable_64.h                    |   22 +--
 arch/x86/mm/pgtable.c                                |    8 -
 arch/x86/net/bpf_jit_comp.c                          |    2=20
 arch/xtensa/kernel/setup.c                           |    1=20
 drivers/ata/libahci_platform.c                       |    3=20
 drivers/ata/libata-zpodd.c                           |    2=20
 drivers/clk/at91/clk-generated.c                     |    2=20
 drivers/clk/renesas/renesas-cpg-mssr.c               |   16 --
 drivers/gpu/drm/bridge/Kconfig                       |    1=20
 drivers/gpu/drm/msm/msm_drv.c                        |    3=20
 drivers/hid/hid-holtek-kbd.c                         |    9 -
 drivers/hid/usbhid/hiddev.c                          |   12 +
 drivers/iio/adc/max9611.c                            |    2=20
 drivers/infiniband/core/mad.c                        |   20 +-
 drivers/infiniband/core/user_mad.c                   |    6=20
 drivers/input/joystick/iforce/iforce-usb.c           |    5=20
 drivers/input/mouse/trackpoint.h                     |    3=20
 drivers/input/tablet/kbtab.c                         |    6=20
 drivers/iommu/amd_iommu_init.c                       |    2=20
 drivers/irqchip/irq-gic-v3-its.c                     |    2=20
 drivers/irqchip/irq-imx-gpcv2.c                      |    1=20
 drivers/mmc/host/sdhci-of-arasan.c                   |    3=20
 drivers/net/bonding/bond_main.c                      |    4=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |    7=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h      |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c     |   17 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c           |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c    |   97 ++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    3=20
 drivers/net/team/team.c                              |    4=20
 drivers/net/usb/pegasus.c                            |    2=20
 drivers/net/xen-netback/netback.c                    |    2=20
 drivers/scsi/hpsa.c                                  |   12 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                  |   12 -
 drivers/scsi/qla2xxx/qla_init.c                      |    2=20
 drivers/staging/comedi/drivers/dt3000.c              |    8 -
 drivers/usb/class/cdc-acm.c                          |   12 -
 drivers/usb/core/file.c                              |   10 -
 drivers/usb/core/message.c                           |    4=20
 drivers/usb/gadget/udc/renesas_usb3.c                |    5=20
 drivers/usb/serial/option.c                          |   10 +
 drivers/xen/xen-pciback/conf_space_capability.c      |    3=20
 fs/ocfs2/xattr.c                                     |    3=20
 include/asm-generic/getorder.h                       |   50 ++----
 include/kvm/arm_vgic.h                               |    1=20
 include/linux/filter.h                               |    1=20
 include/net/tcp.h                                    |    3=20
 include/net/xfrm.h                                   |    1=20
 kernel/bpf/core.c                                    |   77 +++++++++-
 mm/memcontrol.c                                      |   39 +++--
 mm/usercopy.c                                        |    2=20
 net/bridge/netfilter/ebtables.c                      |   28 ++-
 net/core/sysctl_net_core.c                           |   75 +++++++++-
 net/netfilter/nf_conntrack_core.c                    |   16 +-
 net/packet/af_packet.c                               |    7=20
 net/sctp/sm_sideeffect.c                             |    2=20
 net/socket.c                                         |    9 -
 net/xfrm/xfrm_device.c                               |   10 -
 net/xfrm/xfrm_policy.c                               |  138 --------------=
-----
 net/xfrm/xfrm_state.c                                |    5=20
 scripts/Makefile.modpost                             |    2=20
 sound/pci/hda/hda_generic.c                          |   21 ++
 sound/pci/hda/hda_generic.h                          |    1=20
 sound/pci/hda/hda_intel.c                            |    3=20
 sound/pci/hda/patch_conexant.c                       |   15 --
 sound/pci/hda/patch_realtek.c                        |   11 -
 tools/perf/util/header.c                             |    9 +
 virt/kvm/arm/arm.c                                   |   10 +
 virt/kvm/arm/vgic/vgic-v2.c                          |   11 +
 virt/kvm/arm/vgic/vgic-v3.c                          |    7=20
 virt/kvm/arm/vgic/vgic.c                             |   11 +
 virt/kvm/arm/vgic/vgic.h                             |    2=20
 90 files changed, 531 insertions(+), 462 deletions(-)

Alan Stern (1):
      USB: core: Fix races in character device registration and deregistrai=
on

Bob Ham (1):
      USB: serial: option: add the BroadMobi BM818 card

Codrin Ciubotariu (1):
      clk: at91: generated: Truncate divisor to GENERATED_MAX_DIV + 1

Daniel Borkmann (4):
      bpf: get rid of pure_initcall dependency to enable jits
      bpf: restrict access to core bpf sysctls
      bpf: add bpf_jit_limit knob to restrict unpriv allocations
      bpf: fix bpf_jit_limit knob for PAGE_SIZE >=3D 64K

Denis Kirjanov (1):
      net: usb: pegasus: fix improper read if get_registers() fail

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Don Brace (1):
      scsi: hpsa: correct scsi command status issue after reset

Eric Dumazet (1):
      net/packet: fix race in tpacket_snd()

Florian Westphal (2):
      netfilter: ebtables: also count base chain policies
      xfrm: policy: remove pcpu policy cache

Geert Uytterhoeven (1):
      clk: renesas: cpg-mssr: Fix reset control race condition

Greg Kroah-Hartman (1):
      Linux 4.14.140

Gustavo A. R. Silva (1):
      sh: kernel: hw_breakpoint: Fix missing break in switch statement

Hillf Danton (2):
      HID: hiddev: avoid opening a disconnected device
      HID: hiddev: do cleanup in failure of opening a device

Hui Wang (2):
      ALSA: hda - Add a generic reboot_notify
      ALSA: hda - Let all conexant codec enter D3 when rebooting

Huy Nguyen (1):
      net/mlx5e: Only support tx/rx pause setting for port owner

Ian Abbott (2):
      staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
      staging: comedi: dt3000: Fix rounding up of timer divisor

Isaac J. Manjarres (1):
      mm/usercopy: use memory range to be accessed for wraparound check

Jack Morgenstein (1):
      IB/mad: Fix use-after-free in ib mad completion handling

Jacopo Mondi (1):
      iio: adc: max9611: Fix temperature reading in probe

Jeffrey Hugo (1):
      drm: msm: Fix add_gpu_components

Jia-Ju Bai (1):
      scsi: qla2xxx: Fix possible fcport null-pointer dereferences

Joerg Roedel (1):
      iommu/amd: Move iommu_init_pci() to .init section

Kees Cook (1):
      libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Lucas Stach (1):
      irqchip/irq-imx-gpcv2: Forward irq type to parent

Manish Chopra (1):
      bnx2x: Fix VF's VLAN reconfiguration in reload.

Marc Zyngier (1):
      KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block

Masahiro Yamada (1):
      kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules

Masami Hiramatsu (1):
      arm64: unwind: Prohibit probing on return_address()

Max Filippov (1):
      xtensa: add missing isync to the cpu_reset TLB code

Maxim Mikityanskiy (1):
      net/mlx5e: Use flow keys dissector to parse packets for ARFS

Michal Simek (1):
      mmc: sdhci-of-arasan: Do now show error message in case of deffered p=
robe

Miles Chen (1):
      mm/memcontrol.c: fix use after free in mem_cgroup_iter()

Miquel Raynal (1):
      ata: libahci: do not complain in case of deferred probe

Nadav Amit (1):
      x86/mm: Use WRITE_ONCE() when setting PTEs

Nianyao Tang (1):
      irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail

Numfor Mbiziwo-Tiapo (1):
      perf header: Fix use of unitialized value warning

Oliver Neukum (5):
      HID: holtek: test for sanity of intfdata
      Input: kbtab - sanity check for endpoint type
      Input: iforce - add sanity checks
      usb: cdc-acm: make sure a refcount is taken early enough
      USB: CDC: fix sanity checks in CDC union parser

Qian Cai (3):
      arm64/efi: fix variable 'si' set but not used
      arm64/mm: fix variable 'pud' set but not used
      asm-generic: fix -Wtype-limits compiler warnings

Rogan Dawes (1):
      USB: serial: option: add D-Link DWM-222 device ID

Ross Lagerwall (1):
      xen/netback: Reset nr_frags before freeing skb

Sasha Levin (1):
      Revert "tcp: Clear sk_send_head after purging the write queue"

Suganath Prabu (1):
      scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Takashi Iwai (1):
      ALSA: hda - Apply workaround for another AMD chip 1022:1487

Tony Lindgren (1):
      USB: serial: option: Add Motorola modem UARTs

Tony Luck (1):
      IB/core: Add mitigation for Spectre V1

Vince Weaver (1):
      perf header: Fix divide by zero error if f_header.attr_size=3D=3D0

Wenwen Wang (2):
      ALSA: hda - Fix a memory leak bug
      net/mlx4_en: fix a memory leak bug

Will Deacon (2):
      arm64: compat: Allow single-byte watchpoints on all addresses
      arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side

Xin Long (1):
      sctp: fix the transport error_count check

Yoshiaki Okamoto (1):
      USB: serial: option: Add support for ZTE MF871A

Yoshihiro Shimoda (1):
      usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"

YueHaibing (6):
      xen/pciback: remove set but not used variable 'old_state'
      drm/bridge: lvds-encoder: Fix build error while CONFIG_DRM_KMS_HELPER=
=3Dm
      ocfs2: remove set but not used variable 'last_hash'
      Input: psmouse - fix build error of multiple definition
      team: Add vlan tx offload to hw_enc_features
      bonding: Add vlan tx offload to hw_enc_features


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1ioDQACgkQONu9yGCS
aT4JNg//WW5/eVORv5T2utY+2sRIJN4nyohZnS3ZN6vMZ0EnsO2kCEkaSYOJkXS9
ii9XUG0niG6l8Z6k505f2KG7mh9t9+8+Tye88RurDMBmVYy/zhfd3h61ieelk03o
AQxSXLGel3o5sMXrdICYXbBHnv3pZic2pNsDfzk1+7k04z9sC+Ga6zGUMnj3v2PV
0iFQ0sxJvPwS+HsaL40cEKNI0097+pAS31R8L+IUomVgBwhg+RLs/pxKCIVWLSvy
JBrato1oUGdyRBbAwqMPknTnz6x2c4PzX/gM/mXckLJijqPdqeLFZh6gbgjxe9HL
fGabrVzRdIiMrrggfW8VpAC+qJYdtnseOg9ciiuEy0siVPSUATR9QeNfGa5yi7Mo
4eIQ1dotD9eq9Cjx8XPcdWtgvLENRjN8HWPqtR63ilZCggCxgC3sAWQ78+g3ivuV
SOsM8xpLwco1zbg7EOsNJ/hxuv4KZ1zZgqrPG5DRpf1JypPqHMdkSsU5aBmBpkbF
pXs+/P9g2eYbCDw+kSIRY8f+4SSsqXYFzySflrTKrsbAvERfq5y2mJgMO5Kbop3f
qXkWBo6ZWLKPK+C8wGgHYo6ykoDhixnHCGdnCtqF3iFDgitzALK0TbJzfZqLHtot
miCkBOWPXl/r9u+/SFj9gVQPP72oe/iJlu6h/sYu1X0KRv7sRKk=
=+QSZ
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
