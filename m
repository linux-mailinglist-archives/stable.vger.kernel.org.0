Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0619F39B53
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 07:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfFHFsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 01:48:38 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:41408 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730056AbfFHFsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 01:48:38 -0400
Received: from chianamo (n58-108-67-123.per1.wa.optusnet.com.au [58.108.67.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id 10C00180045;
        Sat,  8 Jun 2019 01:48:33 -0400 (EDT)
Message-ID: <0667fc81810f2da5110c7da00963c93da90a6cd7.camel@bonedaddy.net>
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
        protocol="application/pgp-signature"; boundary="=-gCmOviOCfWkL5Vf5iN5c"
Date:   Sat, 08 Jun 2019 13:48:30 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-gCmOviOCfWkL5Vf5iN5c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-06-08 at 13:10 +0800, Paul Wise wrote:

> I've tested these two patches on top of Linux v5.2-rc3 and the EDID
> override works correctly on an Intel Ironlake GPU with a monitor that
> lost its EDID a while ago.

While testing I noticed a couple of things:

While everything the GUI is the correct resolution, GNOME is unable to
identify the monitor vendor or model. This is a regression from the
previous edid override functionality. It looks like this is because the
edid file in /sys is not populated with the EDID override data.

I got a crash due to null pointer dereference at one point, I'll try to
track down when this happens.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-gCmOviOCfWkL5Vf5iN5c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAlz7TCsACgkQMRa6Xp/6
aaNqGhAAna9/HB08ZoGq/hpmTWLlR7LzL7iAV4ooRMur8rg8hSxZ4OQFewlsIkZ1
O3LveyPZJXqkc/higW/xwtnkhI4qq4W3IvwhTYwRkPiEVhnoi1wTuGlSa75mO/lt
VTDse6tRtVZGdFjs19aeIg3lslOzVfZt7GlX4XWggipQ2jvA0MY7g92OWaRsc04r
ogcN/ygzrM94m13IubI+2lFDl0AC6rAmbzjtiz5Rqwv/OzkhTZ2spJhj/ILm8dVQ
Q7B7QD6717FDShJ0M9XmqSA2M3amUIeqdDXfDns2dC/7ncZPOUYpPVZ6nbp77Mao
pLaDh38zFhEFHCf+bUl1AdNsRkFylgKRwVrV3Y/z4F76fg5wAtZ6i2zuUzxY7xta
QUT6a17irglQAxxzln+wx5hPBFxycD5dHBuxZE2WxTcmsz503ZjLSKS1lNTMrV+U
gulP3UufxJnEpOAbO6BAjSp/3rwCjCDVDZBwGFDiImbbA3E5I4g+y4SmKGiei2cn
kxcoY9DTdG+V5RI+pqKMFA+8FsmV3P8W89OyMZPbbyakug5/rCIiPO8Qebsmg3X6
87dGX7z1OgvHNaPpvnQgSyb8OlkSyn9Y/up2hoehYgtQHwkTrx3Du/hg2cmPG2E5
VmEz2jFYAI/KHB0uPIkTmX9/OqFsetoXPuaIAKiPsVVOaeTugo8=
=Kmhb
-----END PGP SIGNATURE-----

--=-gCmOviOCfWkL5Vf5iN5c--

