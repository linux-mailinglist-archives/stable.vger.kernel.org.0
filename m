Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85ECF2D5
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 08:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbfJHGhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 02:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730030AbfJHGhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 02:37:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A55206BB;
        Tue,  8 Oct 2019 06:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570516620;
        bh=6/AH4h3n1zedpb0sPmb6CjywabTrOkb/SFJXrFo3bRc=;
        h=Date:From:To:Cc:Subject:From;
        b=A9v4NjM8iHGr85VtHzXgzQo0wjCFLgWlrQLPvd0PNtPpoz1QmBJqV+trPIp3XqC0R
         U8zImjKto4ssg4xkiToGQLPA/fFcVbiNgDNNxe5lgRgj2WqfV4Yb0vfgJRan7XY6Ui
         nmxJJnDZCCZBF2Dt1wUbQkV34fSwaVnkaoWNeM9E=
Date:   Tue, 8 Oct 2019 08:36:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.148
Message-ID: <20191008063658.GA2467093@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.148 kernel.

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

 Makefile                                        |    2=20
 arch/arm/mm/fault.c                             |    4=20
 arch/arm/mm/fault.h                             |    1=20
 arch/arm/mm/mmu.c                               |   16 +
 arch/arm64/include/asm/cmpxchg.h                |    6=20
 arch/mips/mm/tlbex.c                            |    2=20
 arch/powerpc/include/asm/futex.h                |    3=20
 arch/powerpc/kernel/exceptions-64s.S            |    4=20
 arch/powerpc/kernel/rtas.c                      |   11 -
 arch/powerpc/platforms/pseries/mobility.c       |    9 +
 arch/powerpc/platforms/pseries/setup.c          |    3=20
 arch/powerpc/xmon/xmon.c                        |   15 +
 arch/s390/hypfs/inode.c                         |    9 -
 drivers/block/pktcdvd.c                         |    1=20
 drivers/char/ipmi/ipmi_si_intf.c                |   24 ++
 drivers/char/tpm/tpm-chip.c                     |    5=20
 drivers/char/tpm/tpm-sysfs.c                    |  201 ++++++++++++++-----=
-----
 drivers/char/tpm/tpm.h                          |   13 -
 drivers/clk/at91/clk-main.c                     |   10 -
 drivers/clk/clk-qoriq.c                         |    2=20
 drivers/clk/sirf/clk-common.c                   |   12 -
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c            |    3=20
 drivers/clk/zte/clk-zx296718.c                  |  109 +++++--------
 drivers/dma-buf/sw_sync.c                       |   16 -
 drivers/gpu/drm/amd/amdgpu/si.c                 |    6=20
 drivers/gpu/drm/bridge/tc358767.c               |    2=20
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/volt.c |    2=20
 drivers/gpu/drm/panel/panel-simple.c            |    6=20
 drivers/gpu/drm/radeon/radeon_connectors.c      |    2=20
 drivers/gpu/drm/radeon/radeon_drv.c             |    8=20
 drivers/gpu/drm/stm/ltdc.c                      |    2=20
 drivers/hid/hid-apple.c                         |   49 +++--
 drivers/i2c/busses/i2c-cht-wc.c                 |   46 +++++
 drivers/mfd/intel-lpss-pci.c                    |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c  |    9 -
 drivers/net/ethernet/qlogic/qla3xxx.c           |    1=20
 drivers/net/usb/hso.c                           |   12 -
 drivers/net/usb/qmi_wwan.c                      |    1=20
 drivers/net/xen-netfront.c                      |   17 +-
 drivers/pci/dwc/pci-exynos.c                    |    2=20
 drivers/pci/dwc/pci-imx6.c                      |    4=20
 drivers/pci/host/pci-tegra.c                    |   22 +-
 drivers/pci/host/pcie-rockchip.c                |   16 -
 drivers/pinctrl/tegra/pinctrl-tegra.c           |    4=20
 drivers/rtc/rtc-snvs.c                          |   11 -
 drivers/scsi/scsi_logging.c                     |   48 -----
 drivers/vfio/pci/vfio_pci.c                     |   17 +-
 drivers/video/fbdev/ssd1307fb.c                 |    2=20
 fs/fat/dir.c                                    |   13 +
 fs/fat/fatent.c                                 |    3=20
 fs/ocfs2/dlm/dlmunlock.c                        |   23 ++
 include/scsi/scsi_dbg.h                         |    2=20
 kernel/bpf/syscall.c                            |   30 ++-
 kernel/kexec_core.c                             |    2=20
 kernel/livepatch/core.c                         |    1=20
 lib/Kconfig.debug                               |    2=20
 net/core/sock.c                                 |   11 -
 net/ipv4/ip_gre.c                               |    1=20
 net/ipv4/route.c                                |    5=20
 net/ipv6/addrconf.c                             |   17 +-
 net/ipv6/ip6_input.c                            |   10 +
 net/nfc/llcp_sock.c                             |    7=20
 net/nfc/netlink.c                               |    6=20
 net/rds/ib.c                                    |    6=20
 net/sched/sch_cbq.c                             |   30 ++-
 net/sched/sch_dsmark.c                          |    2=20
 net/tipc/link.c                                 |   30 ++-
 net/tipc/msg.c                                  |    5=20
 net/vmw_vsock/af_vsock.c                        |   16 +
 net/vmw_vsock/hyperv_transport.c                |    2=20
 net/vmw_vsock/virtio_transport_common.c         |    2=20
 security/smack/smack_access.c                   |    6=20
 security/smack/smack_lsm.c                      |    7=20
 usr/Makefile                                    |    3=20
 74 files changed, 625 insertions(+), 389 deletions(-)

Ahmad Fatoum (1):
      drm/stm: attach gem fence to atomic state

Andrey Konovalov (1):
      NFC: fix attrs checks in netlink interface

Andrey Smirnov (1):
      drm/bridge: tc358767: Increase AUX transfer length limit

Anson Huang (1):
      rtc: snvs: fix possible race condition

Arnd Bergmann (1):
      arm64: fix unreachable code issue with cmpxchg

Bart Van Assche (1):
      scsi: core: Reduce memory required for SCSI logging

Changwei Ge (1):
      ocfs2: wait for recovering done after direct unlock request

Chris Wilson (1):
      dma-buf/sw_sync: Synchronize signal vs syncpt free

Christophe Leroy (1):
      powerpc/futex: Fix warning: 'oldval' may be used uninitialized in thi=
s function

Corey Minyard (1):
      ipmi_si: Only schedule continuously in the thread in maintenance mode

C=E9dric Le Goater (1):
      powerpc/xmon: Check for HV mode when dumping XIVE info from OPAL

Daniel Borkmann (1):
      bpf: fix use after free in prog symbol exposure

David Ahern (1):
      ipv6: Handle missing host route in __ipv6_ifa_notify

David Howells (1):
      hypfs: Fix error number left in struct pointer member

Dexuan Cui (1):
      vsock: Fix a lockdep warning in __vsock_release()

Dongli Zhang (1):
      xen-netfront: do not use ~0U as error return value for xennet_fill_fr=
ags()

Dotan Barak (1):
      net/rds: Fix error handling in rds_ib_add_one()

Eric Biggers (1):
      smack: use GFP_NOFS while holding inode_smack::smk_lock

Eric Dumazet (4):
      ipv6: drop incoming packets having a v4mapped source address
      nfc: fix memory leak in llcp_sock_bind()
      sch_dsmark: fix potential NULL deref in dsmark_init()
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash

Eugen Hristev (1):
      clk: at91: select parent if main oscillator or bypass is enabled

Greg Kroah-Hartman (1):
      Linux 4.14.148

Greg Thelen (1):
      kbuild: clean compressed initramfs image

Haishuang Yan (1):
      erspan: remove the incorrect mtu limit for erspan

Hans de Goede (1):
      i2c-cht-wc: Fix lockdep warning

Icenowy Zheng (1):
      clk: sunxi-ng: v3s: add missing clock slices for MMC2 module clocks

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is =
set

Jarkko Sakkinen (2):
      tpm: migrate pubek_show to struct tpm_buf
      tpm: use tpm_try_get_ops() in tpm-sysfs.c.

Jean Delvare (1):
      drm/amdgpu/si: fix ASIC tests

Jens Axboe (1):
      pktcdvd: remove warning on attempting to register non-passthrough dev

Jia-Ju Bai (2):
      gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_c=
onnector_set_property()
      security: smack: Fix possible null-pointer dereferences in smack_sock=
et_sock_rcv_skb()

Joao Moreno (1):
      HID: apple: Fix stuck function keys when using FN

Johan Hovold (1):
      hso: fix NULL-deref on tty open

Kai-Heng Feng (1):
      mfd: intel-lpss: Remove D3cold delay

KyleMahlkuch (1):
      drm/radeon: Fix EEH during kexec

Lucas Stach (1):
      drm/panel: simple: fix AUO g185han01 horizontal blanking

Mark Menzynski (1):
      drm/nouveau/volt: Fix for some cards having 0 maximum voltage

Marko Kohtala (1):
      video: ssd1307fb: Start page range at page_offset

Martin KaFai Lau (1):
      net: Unpublish sk from sk_reuseport_cb before call_rcu

Mike Rapoport (1):
      ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-al=
igned address

Miroslav Benes (1):
      livepatch: Nullify obj->mod in klp_module_coming()'s error path

Nathan Chancellor (1):
      MIPS: tlbex: Explicitly cast _PAGE_NO_EXEC to a boolean

Nathan Huckleberry (1):
      clk: qoriq: Fix -Wunused-const-variable

Nathan Lynch (3):
      powerpc/rtas: use device model APIs and serialization during LPM
      powerpc/pseries/mobility: use cond_resched when updating device tree
      powerpc/pseries: correctly track irq state in default idle

Navid Emamdoost (1):
      net: qlogic: Fix memory leak in ql_alloc_large_buffers

Nicholas Piggin (1):
      powerpc/64s/exception: machine check use correct cfar for late handler

Nicolas Boichat (1):
      kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

Nishka Dasgupta (1):
      PCI: tegra: Fix OF node reference leak

OGAWA Hirofumi (1):
      fat: work around race with userspace's read via blockdev while mounti=
ng

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Reinhard Speyerer (1):
      qmi_wwan: add support for Cinterion CLS8 devices

Sowjanya Komatineni (1):
      pinctrl: tegra: Fix write barrier placement in pmx_writel

Stephen Boyd (2):
      clk: sirf: Don't reference clk_init_data after registration
      clk: zx296718: Don't reference clk_init_data after registration

Tetsuo Handa (1):
      kexec: bail out upon SIGKILL when allocating memory.

Thierry Reding (3):
      PCI: rockchip: Propagate errors for optional regulators
      PCI: imx6: Propagate errors for optional regulators
      PCI: exynos: Propagate errors for optional PHYs

Tuong Lien (1):
      tipc: fix unlimited bundling of small messages

Vadim Sukhomlinov (1):
      tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations

Vishal Kulkarni (1):
      cxgb4:Fix out-of-bounds MSI-X info array access

Will Deacon (1):
      ARM: 8898/1: mm: Don't treat faults reported from cache maintenance a=
s writes

hexin (1):
      vfio_pci: Restore original state on release


--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2cLooACgkQONu9yGCS
aT7UKQ//WLrphk2LE4zDpt/H6LqTEnCBRTK5949uyIbfsrjDmd/F0Nq+jotrjrvS
r/OV2D82pOCTPont2u3KyZkBjqZMDGI1IDZPeNHZklZHy3r+iYmzB64rY139wsNZ
9/+HTKrWRjIvtpMgAxy+E8/LtPn5a6ksRyPHZ1CT3gl6r3FC/KM5G3XT8NXbxGu1
6BWyA/NVEyT/OBS0B6dAEkpFGP6jPhPJVbYY6uWcybzwy9GuCim5HbdEDAAcd573
udKTn6OenvtIJx15q0UR85apqIovNWfaFqiAJq4e69LZm0w2r5RGiB3kKPtZ9n5D
xPaiFWaTl722Ptls8NWjYFxJd/v4FYtBAN5kLrW22HVD6da5BkmD37iOQAwB30YY
opZFXKhN91AvVUkIl6jvKRDtA6mEP3HoA+j9oJNJyjyA+zBrI8t98YqD2zMoy6xK
FTDIdVPiZJ+Y+3puWh+jCxQUcC91IBFUxC0vH7vgQGET+DYbRguFK5MnEkSPfa5n
n4aGWkxz3/jHypcoeZOzbL63JEBXdoJJbj6vf8RJwb/f5Hqx0iKvzIJZ0n3897Md
g6TdIt9/u1BE1EHM2OknKWJyazQJO3xckSc7ecYr6hLY0K6QFufx4skHnaOI1hc6
mGrWa+gM2MejQSk3uhQhMA36h3Ud/znPMAH2O1dPBqyn87l1K4A=
=rFkl
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
