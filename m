Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6795919F42C
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 13:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgDFLKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 07:10:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:40542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgDFLKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 07:10:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8ADA1ABAD;
        Mon,  6 Apr 2020 11:10:11 +0000 (UTC)
Subject: Re: [PATCH] thermal: devfreq_cooling: inline all stubs for
 CONFIG_DEVFREQ_THERMAL=n
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        rui.zhang@intel.com, daniel.lezcano@linaro.org,
        amit.kucheria@verdurent.com, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, javi.merino@kernel.org,
        edubezval@gmail.com, orjan.eide@arm.com, stable@vger.kernel.org
References: <20200403205133.1101808-1-martin.blumenstingl@googlemail.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 mQENBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAG0J1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPokBVAQTAQgAPhYh
 BHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsDBQkDwmcABQsJCAcCBhUKCQgLAgQWAgMB
 Ah4BAheAAAoJEGgNwR1TC3ojR80H/jH+vYavwQ+TvO8ksXL9JQWc3IFSiGpuSVXLCdg62AmR
 irxW+qCwNncNQyb9rd30gzdectSkPWL3KSqEResBe24IbA5/jSkPweJasgXtfhuyoeCJ6PXo
 clQQGKIoFIAEv1s8l0ggPZswvCinegl1diyJXUXmdEJRTWYAtxn/atut1o6Giv6D2qmYbXN7
 mneMC5MzlLaJKUtoH7U/IjVw1sx2qtxAZGKVm4RZxPnMCp9E1MAr5t4dP5gJCIiqsdrVqI6i
 KupZstMxstPU//azmz7ZWWxT0JzgJqZSvPYx/SATeexTYBP47YFyri4jnsty2ErS91E6H8os
 Bv6pnSn7eAq5AQ0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRH
 UE9eosYbT6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgT
 RjP+qbU63Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+R
 dhgATnWWGKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zb
 ehDda8lvhFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r
 12+lqdsAEQEAAYkBPAQYAQgAJhYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsMBQkD
 wmcAAAoJEGgNwR1TC3ojpfcIAInwP5OlcEKokTnHCiDTz4Ony4GnHRP2fXATQZCKxmu4AJY2
 h9ifw9Nf2TjCZ6AMvC3thAN0rFDj55N9l4s1CpaDo4J+0fkrHuyNacnT206CeJV1E7NYntxU
 n+LSiRrOdywn6erjxRi9EYTVLCHcDhBEjKmFZfg4AM4GZMWX1lg0+eHbd5oL1as28WvvI/uI
 aMyV8RbyXot1r/8QLlWldU3NrTF5p7TMU2y3ZH2mf5suSKHAMtbE4jKJ8ZHFOo3GhLgjVrBW
 HE9JXO08xKkgD+w6v83+nomsEuf6C6LYrqY/tsZvyEX6zN8CtirPdPWu/VXNRYAl/lat7lSI
 3H26qrE=
Message-ID: <0af90cb5-f6ba-d3a9-2cc7-8813ebab5ed6@suse.de>
Date:   Mon, 6 Apr 2020 13:10:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403205133.1101808-1-martin.blumenstingl@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rs5boHrlPxoqBFfxZ68VQcjl33WRm3lV0"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rs5boHrlPxoqBFfxZ68VQcjl33WRm3lV0
Content-Type: multipart/mixed; boundary="XtqKdN7vdrbl3NXOzpHyXgHa0EpwxDHhz";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
 rui.zhang@intel.com, daniel.lezcano@linaro.org, amit.kucheria@verdurent.com,
 linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, javi.merino@kernel.org,
 edubezval@gmail.com, orjan.eide@arm.com, stable@vger.kernel.org
Message-ID: <0af90cb5-f6ba-d3a9-2cc7-8813ebab5ed6@suse.de>
Subject: Re: [PATCH] thermal: devfreq_cooling: inline all stubs for
 CONFIG_DEVFREQ_THERMAL=n
References: <20200403205133.1101808-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20200403205133.1101808-1-martin.blumenstingl@googlemail.com>

--XtqKdN7vdrbl3NXOzpHyXgHa0EpwxDHhz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



Am 03.04.20 um 22:51 schrieb Martin Blumenstingl:
> When CONFIG_DEVFREQ_THERMAL is disabled all functions except
> of_devfreq_cooling_register_power() were already inlined. Also inline
> the last function to avoid compile errors when multiple drivers call
> of_devfreq_cooling_register_power() when CONFIG_DEVFREQ_THERMAL is not
> set. Compilation failed with the following message:
>   multiple definition of `of_devfreq_cooling_register_power'
> (which then lists all usages of of_devfreq_cooling_register_power())
>=20
> Thomas Zimmermann reported this problem [0] on a kernel config with
> CONFIG_DRM_LIMA=3D{m,y}, CONFIG_DRM_PANFROST=3D{m,y} and
> CONFIG_DEVFREQ_THERMAL=3Dn after both, the lima and panfrost drivers
> gained devfreq cooling support.
>=20
> [0] https://www.spinics.net/lists/dri-devel/msg252825.html
>=20
> Fixes: a76caf55e5b356 ("thermal: Add devfreq cooling")
> Cc: stable@vger.kernel.org
> Reported-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>=


Tested-by: Thomas Zimmermann <tzimmermann@suse.de>

> ---
>  include/linux/devfreq_cooling.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/devfreq_cooling.h b/include/linux/devfreq_co=
oling.h
> index 4635f95000a4..79a6e37a1d6f 100644
> --- a/include/linux/devfreq_cooling.h
> +++ b/include/linux/devfreq_cooling.h
> @@ -75,7 +75,7 @@ void devfreq_cooling_unregister(struct thermal_coolin=
g_device *dfc);
> =20
>  #else /* !CONFIG_DEVFREQ_THERMAL */
> =20
> -struct thermal_cooling_device *
> +static inline struct thermal_cooling_device *
>  of_devfreq_cooling_register_power(struct device_node *np, struct devfr=
eq *df,
>  				  struct devfreq_cooling_power *dfc_power)
>  {
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--XtqKdN7vdrbl3NXOzpHyXgHa0EpwxDHhz--

--rs5boHrlPxoqBFfxZ68VQcjl33WRm3lV0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl6LDhIACgkQaA3BHVML
eiPOmggAo2AgrVyoaHLR1NAsGf/aJPm535dYRX/7X3exyn7bcEApm1TYiMsmbZI2
KJ4umEw7myXEoQQfmUpRKywvdTOyAaapShsIm8xvIj/F8/U/yKGWXQNIfcPhhoFh
4LrhPYQ/tTkju79OLVcVMc7DK2darHAnpYwlgW2CKOFZCix4mONZQNp+HKfc+j07
rXzL8N9TrDugLDaVqpLum9Lf+VMATa4ojnHts0quf72cPYQn4pp1g+CVyjb6mzIn
bcVyRfp+fc2v92jz2KHWC6vxz54jnv7E6C1HMYCDdPThriG3dM62L65p1+J1i8Hp
BopII8/+/VpG8DRx70xtMuiW+NJvXg==
=KDV+
-----END PGP SIGNATURE-----

--rs5boHrlPxoqBFfxZ68VQcjl33WRm3lV0--
