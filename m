Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D583CD05
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388078AbfFKNeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 09:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387683AbfFKNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 09:34:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E882063F;
        Tue, 11 Jun 2019 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560260061;
        bh=t4Qqv/WZV8wSLeZjUXagtjBsSoY3VvG/IvTPKJjdAsU=;
        h=Date:From:To:Cc:Subject:From;
        b=tWE0L5AvcCQshCiT3qtPAkEuVHPKGfH9kRBW0ncy6n70ibcjZkYOR2IR4oCCgyi3L
         o0RoKty4n6Xl8RNaWyOIFVJ0yx6gBwPbCfeEGLFfH5/t6oX1vSKqulAH2LYyv5PJeD
         4Ung7HP6s1R3ju9IhuDknUkNs60NcejtpRxfuDTE=
Date:   Tue, 11 Jun 2019 15:34:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.9
Message-ID: <20190611133418.GA17369@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.9 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                          |    2=
=20
 arch/arc/mm/fault.c                                               |    9=
=20
 arch/mips/mm/mmap.c                                               |    5=
=20
 arch/mips/pistachio/Platform                                      |    1=
=20
 arch/parisc/kernel/alternative.c                                  |    3=
=20
 arch/s390/mm/fault.c                                              |    5=
=20
 arch/x86/lib/insn-eval.c                                          |   47 +=
+--
 arch/x86/power/cpu.c                                              |   10 +
 arch/x86/power/hibernate.c                                        |   33 +=
++
 drivers/block/xen-blkfront.c                                      |   38 +=
--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                          |    3=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                           |   19 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c                           |    4=
=20
 drivers/gpu/drm/amd/amdgpu/soc15.c                                |    5=
=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                 |    3=
=20
 drivers/gpu/drm/amd/display/include/dal_asic_id.h                 |    7=
=20
 drivers/gpu/drm/drm_atomic_helper.c                               |   22 +-
 drivers/gpu/drm/drm_connector.c                                   |    6=
=20
 drivers/gpu/drm/drm_edid.c                                        |   25 ++
 drivers/gpu/drm/gma500/cdv_intel_lvds.c                           |    3=
=20
 drivers/gpu/drm/gma500/intel_bios.c                               |    3=
=20
 drivers/gpu/drm/gma500/psb_drv.h                                  |    1=
=20
 drivers/gpu/drm/i915/gvt/gtt.c                                    |    6=
=20
 drivers/gpu/drm/i915/gvt/scheduler.c                              |   19 +
 drivers/gpu/drm/i915/i915_reg.h                                   |    6=
=20
 drivers/gpu/drm/i915/intel_fbc.c                                  |    4=
=20
 drivers/gpu/drm/i915/intel_workarounds.c                          |    2=
=20
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                        |    4=
=20
 drivers/gpu/drm/nouveau/Kconfig                                   |   13 +
 drivers/gpu/drm/nouveau/nouveau_drm.c                             |    7=
=20
 drivers/gpu/drm/radeon/radeon_display.c                           |    4=
=20
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                       |   51 +=
+---
 drivers/gpu/drm/vc4/vc4_plane.c                                   |    2=
=20
 drivers/i2c/busses/i2c-xiic.c                                     |    5=
=20
 drivers/memstick/core/mspro_block.c                               |   13 -
 drivers/misc/genwqe/card_dev.c                                    |    2=
=20
 drivers/misc/genwqe/card_utils.c                                  |    4=
=20
 drivers/misc/habanalabs/debugfs.c                                 |   60 +=
-----
 drivers/mmc/host/sdhci_am654.c                                    |    2=
=20
 drivers/mmc/host/tmio_mmc_core.c                                  |    3=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c      |   14 -
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c |    4=
=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                   |    4=
=20
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                   |    4=
=20
 drivers/net/ethernet/mellanox/mlx4/port.c                         |    5=
=20
 drivers/net/ethernet/ti/cpsw.c                                    |    1=
=20
 drivers/net/phy/sfp.c                                             |   24 ++
 drivers/nvme/host/rdma.c                                          |   99 +=
+++++----
 drivers/parisc/ccio-dma.c                                         |    4=
=20
 drivers/parisc/sba_iommu.c                                        |    3=
=20
 drivers/tty/serial/serial_core.c                                  |   24 +-
 fs/fuse/file.c                                                    |   14 +
 fs/nfs/nfs4proc.c                                                 |   32 +=
--
 fs/pstore/platform.c                                              |    7=
=20
 fs/pstore/ram.c                                                   |   36 +=
+-
 include/drm/drm_modeset_helper_vtables.h                          |    8=
=20
 include/linux/cpu.h                                               |    4=
=20
 include/linux/rcupdate.h                                          |    6=
=20
 include/net/arp.h                                                 |    8=
=20
 include/net/ip6_fib.h                                             |    3=
=20
 include/net/tls.h                                                 |    4=
=20
 include/uapi/drm/i915_drm.h                                       |    2=
=20
 kernel/cpu.c                                                      |    4=
=20
 kernel/power/hibernate.c                                          |    9=
=20
 lib/test_firmware.c                                               |   14 -
 net/core/ethtool.c                                                |    5=
=20
 net/core/fib_rules.c                                              |    6=
=20
 net/core/neighbour.c                                              |   11 +
 net/core/pktgen.c                                                 |   11 +
 net/ipv4/ipmr_base.c                                              |    3=
=20
 net/ipv4/route.c                                                  |   22 +-
 net/ipv4/udp.c                                                    |    3=
=20
 net/ipv6/raw.c                                                    |   25 +-
 net/packet/af_packet.c                                            |    2=
=20
 net/rds/ib_rdma.c                                                 |   10 -
 net/sched/cls_matchall.c                                          |    3=
=20
 net/sctp/sm_make_chunk.c                                          |   13 -
 net/sctp/sm_sideeffect.c                                          |    5=
=20
 net/sunrpc/clnt.c                                                 |   30 +=
--
 net/tls/tls_device.c                                              |   27 ++
 scripts/Kbuild.include                                            |    7=
=20
 81 files changed, 619 insertions(+), 362 deletions(-)

Aaron Liu (1):
      drm/amdgpu: remove ATPX_DGPU_REQ_POWER_FOR_DISPLAYS check when hotplu=
g-in

Alex Deucher (2):
      drm/amdgpu/psp: move psp version specific function pointers to early_=
init
      drm/amdgpu/soc15: skip reset on init

Andres Rodriguez (1):
      drm: add non-desktop quirk for Valve HMDs

Chris Wilson (1):
      drm/i915: Fix I915_EXEC_RING_MASK

Christian K=F6nig (1):
      drm/radeon: prefer lower reference dividers

Dan Carpenter (3):
      memstick: mspro_block: Fix an error code in mspro_block_issue_req()
      genwqe: Prevent an integer overflow in the ioctl
      test_firmware: Use correct snprintf() limit

Daniel Drake (1):
      drm/i915/fbc: disable framebuffer compression on GeminiLake

Dave Airlie (1):
      drm/nouveau: add kconfig option to turn off nouveau legacy contexts. =
(v3)

David Ahern (4):
      neighbor: Reset gc_entries counter if new entry is released before in=
sert
      neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
      ipmr_base: Do not reset index in mr_table_dump
      ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled

Erez Alfasi (1):
      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Eugeniy Paltsev (1):
      ARC: mm: SIGSEGV userspace trying to access kernel virtual memory

Faiz Abbas (1):
      mmc: sdhci_am654: Fix SLOTTYPE write

Gerald Schaefer (1):
      s390/mm: fix address space detection in exception handling

Greg Kroah-Hartman (1):
      Linux 5.1.9

Hangbin Liu (1):
      Revert "fib_rules: return 0 directly if an exactly same rule exists w=
hen NLM_F_EXCL not supplied"

Harry Wentland (1):
      drm/amd/display: Add ASICREV_IS_PICASSO

Helen Koike (5):
      drm/rockchip: fix fb references in async update
      drm/vc4: fix fb references in async update
      drm/msm: fix fb references in async update
      drm: don't block fb changes for async plane updates
      drm/amd: fix fb references in async update

Helge Deller (1):
      parisc: Fix crash due alternative coding for NP iopdir_fdc bit

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpsw_ethtool: fix ethtool ring param set

Jakub Kicinski (1):
      net/tls: replace the sleeping lock around RX resync with a bit lock

Jann Horn (2):
      habanalabs: fix debugfs code
      x86/insn-eval: Fix use-after-free access to LDT entry

Jiri Kosina (1):
      x86/power: Fix 'nosmt' vs hibernation triple fault during resume

Jiri Slaby (1):
      TTY: serial_core, add ->install

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coheren=
ce index of I/O pdirs

Jonathan Corbet (1):
      drm/i915: Maintain consistent documentation subsection ordering

Kees Cook (1):
      pstore/ram: Run without kernel crash dump region

Linus Torvalds (1):
      rcu: locking and unlocking need to always be at least barriers

Louis Li (1):
      drm/amdgpu: fix ring test failure issue during s3 in vce 3.0 (V2)

Mario Kleiner (1):
      drm: Fix timestamp docs for variable refresh properties.

Masahiro Yamada (1):
      kbuild: use more portable 'command -v' for cc-cross-prefix

Matteo Croce (1):
      cls_matchall: avoid panic when receiving a packet before filter set

Maxime Chevallier (1):
      net: mvpp2: Use strscpy to handle stat strings

Miklos Szeredi (2):
      fuse: fallocate: fix return with locked inode
      fuse: fix copy_file_range() in the writeback case

Neil Horman (1):
      Fix memory leak in sctp_process_init

Nikita Danilov (1):
      net: aquantia: fix wol configuration not applied sometimes

Olga Kornievskaia (1):
      SUNRPC fix regression in umount of a secure mount

Olivier Matz (2):
      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
      ipv6: fix EFAULT on sendto with icmpv6 and hdrincl

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Paul Burton (2):
      MIPS: Bounds check virt_addr_valid
      MIPS: pistachio: Build uImage.gz by default

Pi-Hsun Shih (1):
      pstore: Set tfm to NULL on free_buf_for_compression

Robert Hancock (1):
      i2c: xiic: Add max_read_len quirk

Roger Pau Monne (1):
      xen-blkfront: switch kcalloc to kvcalloc for large array allocation

Russell King (1):
      net: sfp: read eeprom in maximum 16 byte increments

Ryan Pavlik (1):
      drm: add non-desktop quirks to Sensics and OSVR headsets.

Sagi Grimberg (1):
      nvme-rdma: fix queue mapping when queue count is limited

Takeshi Saito (1):
      mmc: tmio: fix SCC error handling to avoid false positive CRC error

Tim Beale (1):
      udp: only choose unbound UDP socket for multicast when not in a VRF

Tina Zhang (1):
      drm/i915/gvt: Initialize intel_gvt_gtt_entry in stack

Trond Myklebust (1):
      SUNRPC: Fix a use after free when a server rejects the RPCSEC_GSS cre=
dential

Vivien Didelot (1):
      ethtool: fix potential userspace buffer overflow

Weinan (1):
      drm/i915/gvt: emit init breadcrumb for gvt request

Willem de Bruijn (1):
      packet: unconditionally free po->rollover

Xin Long (2):
      ipv4: not do cache for local delivery if bc_forwarding is enabled
      ipv6: fix the check before getting the cookie in rt6_get_cookie

Yihao Wu (2):
      NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake a waiter
      NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz/rdcACgkQONu9yGCS
aT4kDA/+PdpqvVQYCeJtlXWgH0j3+nqT2ZT8/LysJUbTK70fepqgJn/tEC7EVPlf
dr9FYjvnM342garc2zYemcaNp5AhbJLUxbAm63mvu0hNBWzoth/sxk0x7lKVRGN1
tu4YQwsBuhNJR1H4toic1U5OCR6XtIa8S6INOmbG0Qm0SvYyXNDbSmjs3OCD2OzS
8St/GKkSkZ4A1yiEd3xuRpyejhf0hA7L3DhyN0Fax7Vj30tj9mEm2f62LQXEGt0C
jNE1qZFNFmODR7BPXZ099Z7eO1aLg5U/J152nyv2gZp462Cq83fMfeYDAvfX+u4F
yT3pvWf6jKNcZkFmyWVaJieUhVadO+VGAjge34lHmy54XJ9l9m3IHK+uUl/9ye9a
fND5A82NQxnFDBgHPKTJO3q2DXJtCZ16UdxSU5tofUu89KBoVAPhoGm+wRhcF2uv
9TQSeHHs7flq89zxfHxIEP8Rx7qJBxLoj0ZNSp/Xff2CQrAsRrbkWPBHbWcIF4Mf
qKHbOfRTK8UrboPebrKeov+GMETM0eZnX31WWhOr/2zTdpCAf/cWNyzjwfIvbaD0
F/mGbpaASacxVjaFE1sw1drKMz14zosz6ZMVrVGXQgTsnz4B0K26Kxn0h7Hiazd+
HUewKLVkagcNAuYjpPZ4/3Hz8uVn0IM7xjQTKTwSi4B3IrQTI1Y=
=v43o
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
