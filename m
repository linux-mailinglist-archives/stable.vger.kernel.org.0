Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6084C23EE79
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgHGNy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:54:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:41096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgHGNyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 09:54:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E4AA2AC50;
        Fri,  7 Aug 2020 13:54:18 +0000 (UTC)
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
To:     gregkh@linuxfoundation.org, airlied@redhat.com,
        alexander.deucher@amd.com, armijn@tjaldur.nl,
        daniel.vetter@ffwll.ch, emil.velikov@collabora.com,
        kraxel@redhat.com, krzk@kernel.org, noralf@tronnes.org,
        sam@ravnborg.org, stable@vger.kernel.org, tglx@linutronix.de
References: <159680700523135@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
Date:   Fri, 7 Aug 2020 15:53:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159680700523135@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S08Cu9QVuws7z7Lro0z9K5Z8vLpgMRkHa"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S08Cu9QVuws7z7Lro0z9K5Z8vLpgMRkHa
Content-Type: multipart/mixed; boundary="fiiyjQfggM1pQgEfBXTbgB1Zwf8gHSWrs";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: gregkh@linuxfoundation.org, airlied@redhat.com,
 alexander.deucher@amd.com, armijn@tjaldur.nl, daniel.vetter@ffwll.ch,
 emil.velikov@collabora.com, kraxel@redhat.com, krzk@kernel.org,
 noralf@tronnes.org, sam@ravnborg.org, stable@vger.kernel.org,
 tglx@linutronix.de
Message-ID: <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
References: <159680700523135@kroah.com>
In-Reply-To: <159680700523135@kroah.com>

--fiiyjQfggM1pQgEfBXTbgB1Zwf8gHSWrs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
> The patch below was submitted to be applied to the 5.8-stable tree.
>=20
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
>=20
> I could be totally wrong, and if so, please respond to=20
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to b=
e
> seen again.

Sorry for the noise. There's no reason this should go into stable.

Best regards
Thomas

>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c Mon Sep 17 00:00:00 2001
> From: Thomas Zimmermann <tzimmermann@suse.de>
> Date: Fri, 5 Jun 2020 15:57:50 +0200
> Subject: [PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from=
 header
>  file
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> Commit 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
> removed the implementation of mgag200_mmap(). Also remove the declarati=
on.
>=20
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Fixes: 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Noralf Tr=C3=B8nnes" <noralf@tronnes.org>
> Cc: Armijn Hemel <armijn@tjaldur.nl>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Emil Velikov <emil.velikov@collabora.com>
> Cc: <stable@vger.kernel.org> # v5.3+
> Link: https://patchwork.freedesktop.org/patch/msgid/20200605135803.1981=
1-2-tzimmermann@suse.de
>=20
> diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mg=
ag200/mgag200_drv.h
> index 47df62b1ad29..92b6679029fe 100644
> --- a/drivers/gpu/drm/mgag200/mgag200_drv.h
> +++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
> @@ -198,6 +198,5 @@ void mgag200_i2c_destroy(struct mga_i2c_chan *i2c);=

> =20
>  int mgag200_mm_init(struct mga_device *mdev);
>  void mgag200_mm_fini(struct mga_device *mdev);
> -int mgag200_mmap(struct file *filp, struct vm_area_struct *vma);
> =20
>  #endif				/* __MGAG200_DRV_H__ */
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--fiiyjQfggM1pQgEfBXTbgB1Zwf8gHSWrs--

--S08Cu9QVuws7z7Lro0z9K5Z8vLpgMRkHa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFIBAEBCAAyFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl8tXPgUHHR6aW1tZXJt
YW5uQHN1c2UuZGUACgkQaA3BHVMLeiPpYQf/SdWeAFUtub+UeDF5k8V3CvttkVmj
h5uuoaAwubQBQOv6ZAH6DlMuPx01iAOzpAK8Z953mUYsqzYRxq1Rvp7v7uqrFlf4
tN2+ePcPPMSvieOp+weaEbjgc7WjeFW/c4Lw/sFG5rfH8paZGYnLxqs4BT3CXgKa
U5B1Aag4yyB/dmeu0BWHRyIrUWGleZR0dIIPRP9jAfp7xLrjzIaUld9PXW38Ugwj
xFmakI2x919q/utycqr0QQGPyabKF0ohsAx6LEz2r3DyRYCeOgNbd81ZPeMRL0rm
Xw7sh3gG6/IpERpZIjVQ3ljblx4QqwYu5j8RD34+nnrRli/maGWsWMz3GA==
=k4kl
-----END PGP SIGNATURE-----

--S08Cu9QVuws7z7Lro0z9K5Z8vLpgMRkHa--
