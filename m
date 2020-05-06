Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1F41C7095
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgEFMpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgEFMpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB0820746;
        Wed,  6 May 2020 12:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588769103;
        bh=n/RCmi6LXzIs5Pou3igGLe59OKZGVtvUNz5AKWSTWeE=;
        h=Date:From:To:Cc:Subject:From;
        b=OnR6GEVZWDdjPxUePMg4Nr4yDgD8SBPkVRrHk9a5jXTbAeGrfOpFNgazE+7RuNgg4
         XRK2PYqfVwcuzpTHHKydJ9A0tnIhhfHdWX7eiG0KviiDnGoWk+P3NeTZH3AC3fFVpx
         WiaTSGbcz11azfeSTwIlNdxXNL7qf6+i1H8FHcs8=
Date:   Wed, 6 May 2020 14:45:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.222
Message-ID: <20200506124501.GA3144161@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.222 kernel.

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

 Makefile                           |    2 -
 drivers/acpi/device_pm.c           |    4 +-
 drivers/dma/dmatest.c              |    4 +-
 drivers/gpu/drm/drm_edid.c         |    2 -
 drivers/gpu/drm/qxl/qxl_cmd.c      |   10 ++---
 drivers/gpu/drm/qxl/qxl_display.c  |    8 ++--
 drivers/gpu/drm/qxl/qxl_draw.c     |   13 +++----
 drivers/gpu/drm/qxl/qxl_ioctl.c    |    5 --
 drivers/infiniband/hw/mlx4/main.c  |    3 +
 drivers/iommu/amd_iommu_init.c     |    2 -
 drivers/md/dm-verity-fec.c         |    2 -
 drivers/vfio/vfio_iommu_type1.c    |    4 +-
 fs/btrfs/extent-tree.c             |   16 +++++---
 fs/ext4/inode.c                    |    2 -
 fs/nfs/nfs3acl.c                   |   22 ++++++++---
 kernel/power/hibernate.c           |    7 +++
 security/selinux/hooks.c           |   68 +++++++++++++++++++++++---------=
-----
 sound/core/oss/pcm_plugin.c        |   20 ++++++----
 sound/isa/opti9xx/miro.c           |    9 +++-
 sound/isa/opti9xx/opti92x-ad1848.c |    9 +++-
 sound/pci/hda/patch_hdmi.c         |    4 +-
 21 files changed, 133 insertions(+), 83 deletions(-)

Alaa Hleihel (1):
      RDMA/mlx4: Initialize ib_spec on the stack

Andreas Gruenbacher (1):
      nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl

Andy Shevchenko (1):
      dmaengine: dmatest: Fix iteration non-stop logic

Arnd Bergmann (1):
      ALSA: opti9xx: shut up gcc-10 range warning

Dexuan Cui (1):
      PM: hibernate: Freeze kernel threads in software_resume()

Greg Kroah-Hartman (1):
      Linux 4.9.222

Kai-Heng Feng (1):
      PM: ACPI: Output correct message on target power state

Paul Moore (1):
      selinux: properly handle multiple messages in selinux_netlink_send()

Sean Christopherson (1):
      vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()

Sunwook Eom (1):
      dm verity fec: fix hash block number in verity_fec_decode

Suravee Suthikulpanit (1):
      iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system

Takashi Iwai (1):
      ALSA: pcm: oss: Place the plugin buffer overflow checks correctly

Theodore Ts'o (1):
      ext4: fix special inode number checks in __ext4_iget()

Vasily Averin (3):
      drm/qxl: qxl_release leak in qxl_draw_dirty_fb()
      drm/qxl: qxl_release leak in qxl_hw_surface_alloc()
      drm/qxl: qxl_release use after free

Ville Syrj=E4l=E4 (1):
      drm/edid: Fix off-by-one in DispID DTD pixel clock

Wu Bo (1):
      ALSA: hda/hdmi: fix without unlocked before return

Xiyu Yang (1):
      btrfs: fix block group leak when removing fails


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ysUsACgkQONu9yGCS
aT7AWBAAzDAe1rEi8UIop3qZtHa3IS7guYRgl1nonFta4w6SbgZ2TgrZRxFXTggm
0Oibc8TQVkWzwyXtQDtBkymYFfswrDv5+oC8Ex15NwLgFyEXegN0IDjw6jpUI6ZY
D/1Xja4kBnmXjcTV5G3mo7Vqm6GlAtv5au2+a8JV8qpjuHnXlaotYwj0scZaEJIv
kHeN0FReKuFDUR2B2iw4NVsPOl8QloeE0WkTGbkqztmYlbPM5tiYo08CtcUhzjtK
5W3nuHvV+5O4pXDCQFbgcR0OL4I9yZvgdcbi8HAfYbgbyybLu5u//EmAxLq8CCty
1cxRuxKQclZhxutFXiJa0MI4jMqifSVlqjYjZH3j15+PRDu9FNsWv5RUDKAzjrem
uvrmFhUtoA44oCtbhq3mPs+g+mDcCfgUMtVuCw2e+hdEz3zpjtyyPOgnuWRb1bqu
pE/4s6MkBWMBiL+8r4Wk5ADCJoRLA6Zh0JCLVOTnd4DarySa9ROKJJz6ctopKClg
3EIPOFwslzZsykKgLIDzFXuFcvQErUEovriMAtafjZUaiOQl0P53PAV0692ocMYh
pGg3EZo6KvS+qsK26uzgtV9MsnFFiCPnQ4ciRtWOUAuSzfk1f9CoWOs+Sc0mzBcH
4sPoK0cFYjyHkjkrB5WXXo0/4nBIRrCdLlyCxuNLFBoyTNz1NeM=
=osdP
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
