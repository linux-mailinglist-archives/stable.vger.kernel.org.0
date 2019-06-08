Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2339A02
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 03:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfFHBPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 21:15:46 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:40518 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbfFHBPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 21:15:45 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2019 21:15:45 EDT
Received: from chianamo (n58-108-67-123.per1.wa.optusnet.com.au [58.108.67.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id 141C7180041;
        Fri,  7 Jun 2019 21:07:06 -0400 (EDT)
Message-ID: <f1bad113987c43d11a99f58db43c720edfba6fbe.camel@bonedaddy.net>
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
In-Reply-To: <20190607151021.GJ21222@phenom.ffwll.local>
References: <20190607110513.12072-1-jani.nikula@intel.com>
         <20190607110513.12072-2-jani.nikula@intel.com>
         <20190607151021.GJ21222@phenom.ffwll.local>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-maax3mrChKPjJo+a28Ho"
Date:   Sat, 08 Jun 2019 09:06:53 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-maax3mrChKPjJo+a28Ho
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-06-07 at 17:10 +0200, Daniel Vetter wrote:

> As discussed on irc, we need tested-by here from the reporters since
> there's way too many losing and frustrangingly few winning moves here.

I'm building it now, hopefully will be done today.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-maax3mrChKPjJo+a28Ho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAlz7CikACgkQMRa6Xp/6
aaNE3w/9HX+8kIhfhFnjtAf7mZWmE1PXcqI+Fah4wpzl73fAjiHhWt7pl3tRdjbY
mdJZlgc4Ooqq+skAcTB2TZmCARp+GBAS6yQoVxrobOiT6fh1csjyyBXLpK9gEnBi
SVBeqsGzFuo/XT/VN2JiKw6Vu6QL9by9KJT6vWNNu0vM19acKOsVNmkzB2EtQNi6
Yvh7N45rnnbct/2zPvxGOzk8j2RIBQJRD1Izx2oAb+PW5EsZk+eZcZOwUDbwDhp7
Imw4jbiS8adARPzI7wcaRR3OqiuWM/VirJn7jFJM+DNHIkBu5QUII28cxQsy+vIL
8UPkVHRbJihvs8qY0WLOTM/TG1yyvts6olM9+xR6i7i5dG4xp/UWfhN9ouJtijVH
Zp0kYcqo4fA0hUm12UP4Pr8MSgJVU/81VZHpN3vw65ph/i5ia6AP42Ql6mxllM7J
f0II8entqNiqefP9qKiyKrL6GppO18D0yivBWTsXxbyyfR6EOr9+2HjA8g1c2Z6u
GSUMQxl05MPx9/tqqEfZ3Uo9iuqK7En+4ZcI+hhp01+wD+ymiO8/k/wdqFRvpA2X
u4FxMdUw8Cx2ism8or+1Xn4kSeCHM7/pB8/U4nC91d4gFXH8/1RJxCOfNvw+LQ1h
vQMNGo9n+aH4Q2CrEN/emzc4Wcpa5kAEWD3WcaFyLWrFwAJBbPI=
=ko3R
-----END PGP SIGNATURE-----

--=-maax3mrChKPjJo+a28Ho--

