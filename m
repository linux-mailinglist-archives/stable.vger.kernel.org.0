Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D514F3A080
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfFHPk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 11:40:29 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:49934 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfFHPk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 11:40:28 -0400
Received: from chianamo (n58-108-67-123.per1.wa.optusnet.com.au [58.108.67.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id 11D28180044;
        Sat,  8 Jun 2019 11:40:24 -0400 (EDT)
Message-ID: <5c61b516222261594aca5e6eb8fbf38fcaefe0ec.camel@bonedaddy.net>
Subject: Re: [PATCH 2/2] drm: add fallback override/firmware EDID modes
 workaround
From:   Paul Wise <pabs3@bonedaddy.net>
To:     Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>
In-Reply-To: <24d1a13799ae7e0331ff668d9b170c4920d7d762.camel@bonedaddy.net>
References: <20190607110513.12072-1-jani.nikula@intel.com>
         <20190607110513.12072-2-jani.nikula@intel.com>
         <20190607151021.GJ21222@phenom.ffwll.local>
         <24d1a13799ae7e0331ff668d9b170c4920d7d762.camel@bonedaddy.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-kOOwBpdc/ZHVwtVwc55x"
Date:   Sat, 08 Jun 2019 23:40:21 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-kOOwBpdc/ZHVwtVwc55x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-06-08 at 13:10 +0800, Paul Wise wrote:

> I'll test that it also works with an nVidia GPU & noveau drivers
> later today once that system is available.

Same results as with the Intel GPU:

Correct screen resolution but missing EDID override data.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-kOOwBpdc/ZHVwtVwc55x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAlz71uEACgkQMRa6Xp/6
aaMgCw/9EDgCzD7xCdK8YXcalOTEB5H+MIokDGLI18mh0EmU/VR+WweEZ0Ml9qEK
dHW3SJYvd36WvHX0YLxGEugUdGz8wu+fLx4oiX/tOecQLE+ZKqw+1v+wSuBoSPqH
DDc8Lpyj+PQ134o3wgbVUgTkNKUkJP4DrNYL3E5mKee/FyDGNvqjxPc99EA306by
TahoNY1UTIS+to+edHcxjPkDI0dZ9zaXNsnVLMRF/oKjZBSHSP4ytAhNy8ZHWTO1
UNZqWUg2ySbzgIkwii0SnmjY0NrFMY1nPSB+Di2XO3z2yPbvE7AjjM5ZYdu53buk
CTyN6PscYTlbNT5PlTnQAxM7agRNZbGBY7G9lKpPcb7gye45fDw+VSsbteRMKNql
MTUa/+rUI5bjvmVsxCfkVC5913/WYouRGfLyXbgKu5FFsR6hFJyUqK2SRpyQpd0x
+q4aNi14cSscqooOyout7cAyafHHlaO9hESywfbaXTJ9HvN/ebr8a8wiQbpwR1sh
YPxkURbPbEn7w/S/p3gugfMULPWGajUlg/5rNFS8eWds7QC8JqD/E2TL+5ZSXLl/
ke9HgXdmJnLEg/mGqZfMbfXcIxINT7So6KpXttVjNW7n+sJ+pXCuivKYAdsNOUav
srL8tHLYIVoWR650jPvHtyulKcK//nBN5/l3zqNoCCUcfXe0cuo=
=mGZA
-----END PGP SIGNATURE-----

--=-kOOwBpdc/ZHVwtVwc55x--

