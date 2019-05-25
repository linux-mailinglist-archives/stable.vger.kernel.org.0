Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CD72A5AC
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 19:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfEYRBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 13:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbfEYRBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 13:01:21 -0400
Received: from localhost (unknown [62.129.28.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2942216FD;
        Sat, 25 May 2019 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558803680;
        bh=JpLQNd4VDFZa7rq3L4qwjsF1TLZ3qdmLP60H+Qlg1M4=;
        h=Date:From:To:Cc:Subject:From;
        b=Jg08e3Moq2jSD8QRH9Tg46BPyJeVBfwcv8m2XPsMdLAWPib+02YrvPsGAUNNoHQ+5
         DWcI/7xmCqxFAixYJVg8TFui9/Gvy4ElRCl7cXbej1KUTGuj4OrOkh+79PQl9U2rNA
         /5nVbhWJG277BHF8gEvpIghlJcAotxwxZPOVkUk8=
Date:   Sat, 25 May 2019 19:01:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.179
Message-ID: <20190525170117.GA7628@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.179 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm/kvm/arm.c                                  |   11=20
 arch/parisc/include/asm/assembly.h                  |    6=20
 arch/parisc/kernel/head.S                           |    4=20
 arch/parisc/kernel/process.c                        |    1=20
 arch/parisc/kernel/syscall.S                        |    2=20
 drivers/clk/tegra/clk-pll.c                         |    4=20
 drivers/hwtracing/intel_th/msu.c                    |   35 ++
 drivers/hwtracing/stm/core.c                        |    2=20
 drivers/iommu/tegra-smmu.c                          |   25 +-
 drivers/md/dm-delay.c                               |    3=20
 drivers/md/md.c                                     |    6=20
 drivers/md/raid5.c                                  |   29 +-
 drivers/media/i2c/soc_camera/ov6650.c               |    2=20
 drivers/memory/tegra/mc.c                           |    2=20
 drivers/net/ethernet/mellanox/mlx4/mcg.c            |    2=20
 drivers/net/ppp/ppp_deflate.c                       |   20 +
 drivers/net/wireless/intersil/p54/p54pci.c          |    3=20
 drivers/parisc/led.c                                |    3=20
 drivers/pci/pcie/aspm.c                             |   49 ++--
 drivers/pci/quirks.c                                |   18 +
 drivers/power/supply/power_supply_sysfs.c           |    6=20
 drivers/video/fbdev/sm712.h                         |   12=20
 drivers/video/fbdev/sm712fb.c                       |  243 +++++++++++++++=
+----
 fs/btrfs/extent-tree.c                              |   25 +-
 fs/ceph/super.c                                     |    7=20
 fs/cifs/smb2ops.c                                   |   14 -
 fs/fuse/file.c                                      |    9=20
 fs/nfs/nfs4state.c                                  |    4=20
 fs/ufs/util.h                                       |    2=20
 include/linux/of.h                                  |    4=20
 include/linux/pci.h                                 |    2=20
 kernel/trace/trace_events.c                         |    3=20
 net/core/dev.c                                      |    2=20
 net/ipv4/ip_vti.c                                   |    5=20
 net/ipv4/xfrm4_policy.c                             |   24 +
 net/ipv6/xfrm6_tunnel.c                             |    4=20
 net/mac80211/iface.c                                |    3=20
 net/tipc/core.c                                     |   14 -
 net/vmw_vsock/virtio_transport.c                    |   13 -
 net/vmw_vsock/virtio_transport_common.c             |    7=20
 net/xfrm/xfrm_user.c                                |    2=20
 tools/objtool/Makefile                              |    3=20
 tools/perf/bench/numa.c                             |    4=20
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   31 +-
 45 files changed, 499 insertions(+), 173 deletions(-)

Adrian Hunter (3):
      perf intel-pt: Fix instructions sampling rate
      perf intel-pt: Fix improved sample timestamp
      perf intel-pt: Fix sample timestamp wrt non-taken branches

Al Viro (1):
      ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Alexander Shishkin (1):
      intel_th: msu: Fix single mode with IOMMU

Andrew Jones (1):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Andrey Smirnov (1):
      power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_S=
UPPLY_DEBUG

Arnaldo Carvalho de Melo (1):
      perf bench numa: Add define for RUSAGE_THREAD if not present

Bhagavathi Perumal S (1):
      mac80211: Fix kernel panic due to use of txq after free

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_opl=
ock_level()

Dmitry Osipenko (3):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divi=
der
      iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
      memory: tegra: Fix integer overflow on tick value calculation

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file

Eric Dumazet (1):
      net: avoid weird emergency message

Greg Kroah-Hartman (1):
      Linux 4.9.179

Helge Deller (3):
      parisc: Export running_on_qemu symbol for modules
      parisc: Skip registering LED when running in QEMU
      parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD co=
de

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset

Janusz Krzysztofik (1):
      media: ov6650: Fix sensor possibly not detected on probe

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount

Jeremy Sowden (1):
      vti4: ipip tunnel deregistration fixes.

Jorge E. Moreira (1):
      vsock/virtio: Initialize core virtio vsock before registering the dri=
ver

Junwei Hu (2):
      tipc: switch order of device registration to fix a crash
      tipc: fix modprobe tipc failed after switch order of device registrat=
ion

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Miklos Szeredi (1):
      fuse: fix writepages on 32bit

Mikulas Patocka (1):
      dm delay: fix a crash when invalid device is specified

Nathan Chancellor (1):
      objtool: Allow AR to be overridden with HOSTAR

Nigel Croxon (1):
      md/raid: raid5 preserve the writeback action after the parity check

Nikolay Borisov (1):
      btrfs: Honour FITRIM range constraints during free space trim

Pan Bian (1):
      p54: drop device reference count if fails to enable device

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()

Song Liu (1):
      Revert "Don't jump to compute_result state from check_result state"

Stefan M=E4tje (2):
      PCI: Factor out pcie_retrain_link() function
      PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum

Stefano Garzarella (1):
      vsock/virtio: free packets during the socket release

Steffen Klassert (1):
      xfrm4: Fix uninitialized memory read in _decode_session4

Su Yanjun (1):
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

Tingwei Zhang (1):
      stm class: Fix channel free in stm output free path

Yifeng Li (9):
      fbdev: sm712fb: fix brightness control on reboot, don't set SR30
      fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75
      fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-C=
R3F
      fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA
      fbdev: sm712fb: fix crashes during framebuffer writes by correctly ma=
pping VRAM
      fbdev: sm712fb: fix support for 1024x768-16 mode
      fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled disp=
lay
      fbdev: sm712fb: fix crashes and garbled display during DPMS modesetti=
ng
      fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallth=
rough

YueHaibing (2):
      ppp: deflate: Fix possible crash in deflate_init
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

Yufen Yu (1):
      md: add mddev->pers to avoid potential NULL pointer dereference

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzpdN0ACgkQONu9yGCS
aT652A/9HNs6/n4a6ukQIs0LX7gMuUZTJsxN+zOGwRYba8Be31licPvtkXHKt8Vg
9MEpIVTFeCpfri0w09bdW24pyDhzW1H0ghlHiaPW1SrtF89M/tgMhPGZZ34j8HQ7
axB5dpc1tLuHN3gl427MSFdHZUkV4+/O6cETDUncRaMKtT1xc/U4dDttM1Ub/N9V
DLJR7MAYjHW8hvbpM5+VGoffOF/0mQAyDB5V9P5Z2nXyjzppZ0j4Q2NblYj1hZls
xZ2XTmj1IicK3316zDP6b4sWA64qAwMNx2lHdCZeYmtSVX4N6wqExciKULJZ/lZo
qCe17wKpV9uNfgtPV7NVgWb01ki2LfCdjW5YKDeiL/EG5zLg5NiE8cq7nBOJWvqL
Ft03OwCvCNxsyVkdJrTfUzd8soVVSsdCLJ5iPeuGxl0Smq9S2i4t+FYZT1WCQgC1
SKUgSMZVQEdLs/pTQRgqtPwe1nCDkuMJXmMeGFimiLy6Vl/EGb9lMyLgNpBa0gcX
dm9mLR6KrPr+RD9Ejf5yozyEJgQH/Du3A/4xZWQ19Jvi247NFOzVjvqYFEUKn1Pf
jSBcrEbpvK6FyJiO60tkzSRe6i2GP55+wsj9mf/93YCmTbhVYb4f4M8v6bnd2DyV
RSYKvWsObdWohMI16ZuZ2vfAlewcDdRIHRO7bFTjn15NcNt6pkQ=
=0aD9
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
