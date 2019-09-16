Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B6BB3A48
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 14:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbfIPMZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 08:25:38 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37403 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732502AbfIPMZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 08:25:38 -0400
Received: by mail-pg1-f195.google.com with SMTP id c17so11995141pgg.4;
        Mon, 16 Sep 2019 05:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZBwA+TLAS/DGqtF1lMRcmG75YqhDF6MQPn0lAr8U6IE=;
        b=no/GjN/4VSnZ1MYi7lb8OORnnBCjoOd8MzPZvDthpELhjVGrUsny3Pb1aD0rY1uL30
         vRlBtCshoxIfhiFba2xg4/Np8E0B5oCG1jiEA6ys0fFZQrKr5JkL/iV6AdbAoy581876
         rK/9wYdAYyIUPsj9WqKINyi7VjXH6OCgTSwkuI/T4dnMcKFTooRR/0CfxiRERo+ORY8X
         DW3OXUybn8x+uMzXE8/W8mkZZQdTFnrkAdBs5d1AlcGhSDO/Ly5HnfandrzRxt1IEnhZ
         GgzWqg6RZBWkE9L9PW6H3w7cRLzGmRzNe2/oJquC41e0GUjrvNndPwS/RjcidEs7YN+5
         b+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZBwA+TLAS/DGqtF1lMRcmG75YqhDF6MQPn0lAr8U6IE=;
        b=WrhIi1DVls97Tna4ASvkErfKZDN9kL9zoAASLRsmTpO2F/TLhXHUN5jJbu2DgdH+ei
         YgTXxl+L/cwiew/IsQ7p2NxgnrF4OTgODzJ9zJ6qFGEGP0jn0JDN4Z5TkwRSVDxC/Pfl
         aRFvjqVYP7SqvV2Si+pfFkXyizGhpL7olArP4YWelAwsODvfOJOZ8STspCV18IIAwj/E
         9E0SYcl6Rs6KgyJccgSU5w+OGtB2IPr4qw/QN1GS8BM138abn54li7lWdCw1Sqyz6noA
         gAud1vLeH9a8ez84OhOlaSBXBTVvL+n+sUgMDTv9xIN0nBvj/IuYsdQOA295EWuXDJV1
         tanw==
X-Gm-Message-State: APjAAAX7gZRYcaERLgGUgHZdFAMbzUnTiA8Sfu1ct9cfxSGju00BzTDG
        ZvrOd6CBUzMcWbFBcpNFyuQ=
X-Google-Smtp-Source: APXvYqxOJ9zeLo/JTj8qS0+HUW6RwaLD6wPhdONhqrGvgafrJCFdojT+w8zuXvHD9/4ZFfx1DLZ8jQ==
X-Received: by 2002:a65:5cca:: with SMTP id b10mr57451780pgt.365.1568636737470;
        Mon, 16 Sep 2019 05:25:37 -0700 (PDT)
Received: from ArchLinux ([103.231.91.34])
        by smtp.gmail.com with ESMTPSA id z23sm11787032pje.2.2019.09.16.05.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 05:25:36 -0700 (PDT)
Date:   Mon, 16 Sep 2019 17:55:20 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.15
Message-ID: <20190916122520.GA6067@ArchLinux>
References: <20190916104324.GA1387052@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20190916104324.GA1387052@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:43 Mon 16 Sep 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.15 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>


 Thanks, a bunch Greg! :)

 Thanks,
 Bhaskar

>------------
>
> Makefile                                            |    2
> arch/powerpc/kernel/process.c                       |   21 ---
> arch/powerpc/mm/nohash/tlb.c                        |    1
> drivers/gpio/gpio-pca953x.c                         |   15 --
> drivers/gpu/drm/i915/i915_reg.h                     |    7 +
> drivers/gpu/drm/i915/intel_cdclk.c                  |   11 +
> drivers/gpu/drm/i915/intel_workarounds.c            |  136 ++++++++++++++=
++----
> drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gp102.c |   12 +
> drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                 |    8 -
> drivers/infiniband/hw/hfi1/rc.c                     |   28 ----
> drivers/infiniband/hw/qib/qib_rc.c                  |   26 ---
> drivers/infiniband/sw/rdmavt/qp.c                   |   31 +---
> drivers/md/bcache/btree.c                           |   49 ++++++-
> drivers/md/bcache/btree.h                           |    2
> drivers/md/bcache/journal.c                         |    7 +
> drivers/mmc/host/sdhci-acpi.c                       |    2
> drivers/mmc/host/sdhci-esdhc-imx.c                  |    2
> drivers/mmc/host/sdhci-of-at91.c                    |    2
> drivers/mmc/host/sdhci-pci-core.c                   |    4
> drivers/mmc/host/sdhci-pxav3.c                      |    2
> drivers/mmc/host/sdhci-s3c.c                        |    2
> drivers/mmc/host/sdhci-sprd.c                       |    2
> drivers/mmc/host/sdhci-xenon.c                      |    2
> drivers/mmc/host/sdhci.c                            |    4
> drivers/mmc/host/sdhci.h                            |    2
> drivers/s390/virtio/virtio_ccw.c                    |    3
> drivers/usb/chipidea/ci_hdrc_imx.c                  |   43 +++++-
> drivers/usb/chipidea/usbmisc_imx.c                  |    4
> drivers/vhost/test.c                                |   13 +
> drivers/vhost/vhost.c                               |    4
> fs/btrfs/extent_io.c                                |   35 +++--
> include/linux/usb/chipidea.h                        |    1
> include/rdma/rdmavt_qp.h                            |  117 +++++++++++---=
---
> kernel/sched/fair.c                                 |    5
> net/batman-adv/bat_iv_ogm.c                         |   20 +-
> net/batman-adv/netlink.c                            |    2
> sound/pci/hda/hda_auto_parser.c                     |    4
> sound/pci/hda/hda_generic.c                         |    3
> sound/pci/hda/hda_generic.h                         |    1
> sound/pci/hda/patch_realtek.c                       |   17 ++
> 40 files changed, 434 insertions(+), 218 deletions(-)
>
>Andr=E9 Draszik (1):
>      usb: chipidea: imx: fix EPROBE_DEFER support during driver probe
>
>Baolin Wang (1):
>      mmc: sdhci-sprd: Fix the incorrect soft reset operation when runtime=
 resuming
>
>Ben Skeggs (1):
>      drm/nouveau/sec2/gp102: add missing MODULE_FIRMWAREs
>
>Christophe Leroy (1):
>      powerpc/64e: Drop stale call to smp_processor_id() which hangs SMP s=
tartup
>
>Coly Li (3):
>      bcache: only clear BTREE_NODE_dirty bit when it is set
>      bcache: add comments for mutex_lock(&b->write_lock)
>      bcache: fix race in btree_flush_write()
>
>Dan Carpenter (1):
>      drm/vmwgfx: Fix double free in vmw_recv_msg()
>
>David Jander (2):
>      gpio: pca953x: correct type of reg_direction
>      gpio: pca953x: use pca953x_read_regs instead of regmap_bulk_read
>
>Eric Dumazet (1):
>      batman-adv: fix uninit-value in batadv_netlink_get_ifindex()
>
>Filipe Manana (1):
>      Btrfs: fix unwritten extent buffers and hangs on future writeback at=
tempts
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.15
>
>Gustavo Romero (2):
>      powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction
>      powerpc/tm: Fix restoring FP/VMX facility incorrectly on interrupts
>
>Halil Pasic (1):
>      virtio/s390: fix race on airq_areas[]
>
>Hui Wang (1):
>      ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCent=
re
>
>Jian-Hong Pan (1):
>      ALSA: hda/realtek - Enable internal speaker & headset mic of ASUS UX=
431FL
>
>John Harrison (3):
>      drm/i915: Support flags in whitlist WAs
>      drm/i915: Support whitelist workarounds on all engines
>      drm/i915: Add whitelist workarounds for ICL
>
>Kaike Wan (1):
>      IB/hfi1: Unreserve a flushed OPFN request
>
>Kenneth Graunke (1):
>      drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.
>
>Liangyan (1):
>      sched/fair: Don't assign runtime for throttled cfs_rq
>
>Lionel Landwerlin (2):
>      drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT
>      drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT
>
>Mike Marciniszyn (2):
>      IB/rdmavt: Add new completion inline
>      IB/{rdmavt, qib, hfi1}: Convert to new completion API
>
>Peter Chen (1):
>      usb: chipidea: imx: add imx7ulp support
>
>Sam Bazley (1):
>      ALSA: hda/realtek - Add quirk for HP Pavilion 15
>
>Sven Eckelmann (1):
>      batman-adv: Only read OGM tvlv_len after buffer len check
>
>Takashi Iwai (2):
>      ALSA: hda - Fix potential endless loop at applying quirks
>      ALSA: hda/realtek - Fix overridden device-specific initialization
>
>Tiwei Bie (2):
>      vhost/test: fix build for vhost test
>      vhost/test: fix build for vhost test - again
>
>Ville Syrj=E4l=E4 (1):
>      drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV
>
>yongduan (1):
>      vhost: make sure log_num < in_num
>



--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1/fywACgkQsjqdtxFL
KRXLjgf/Z1ADIGHOzV6vsIZa58fZe3BwJMqdoDBB54Qjx2niPku0uxqDItJQOgWH
1OMC0XxvXkgCRfiIM5i2G/crX6MzgCTf4xqNLUrXdMTbwOKumFQRTbwFvS2Bny+q
1Bpk0z7vaR30mlCxx3c3uByK15Q0AOzzWnJdA5XWH8GDcEaoRDHEiPfG1WIJVjpS
d+eJLcqbKtsEPDjxSjhi/PKRYPdjeRKwMwgnOgWzQcR5SVKg7XmzstbKnOJpME8i
m9jQvF1u5tz9FTVX0SACgAXYhEEN2Hu40vLJ9dbOen2/Xxwsl4erFo2qcKbpFuh9
MnhmkCnrV+dC6DieM+VLVrpkVurFNw==
=qghG
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
