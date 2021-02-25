Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7FC324D27
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhBYJrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:47:52 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44490 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbhBYJrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:47:48 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1DB8C1C0B81; Thu, 25 Feb 2021 10:47:05 +0100 (CET)
Date:   Thu, 25 Feb 2021 10:47:04 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <20210225094704.GA4967@amd>
References: <20210224092304.29932-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20210224092304.29932-1-tzimmermann@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> USB devices cannot perform DMA and hence have no dma_mask set in their
> device structure. Therefore importing dmabuf into a USB-based driver
> fails, which breaks joining and mirroring of display in X11.
>=20
> For USB devices, pick the associated USB controller as attachment device.
> This allows the DRM import helpers to perform the DMA setup. If the DMA
> controller does not support DMA transfers, we're out of luck and cannot
> import. Our current USB-based DRM drivers don't use DMA, so the actual
> DMA device is not important.
>=20
> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> instance of struct drm_driver.
>=20
> Tested by joining/mirroring displays of udl and radeon un der
> Gnome/X11.

Thanks for doing this.

Tested-by: Pavel Machek <pavel@ucw.cz>

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA3chcACgkQMOfwapXb+vIvNgCgnkqccxMPEBZvAvoSGYP5Izg/
hOkAnjPFv3/Z+XyGHTA3IEpbRbEBFT5Z
=hOj3
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
