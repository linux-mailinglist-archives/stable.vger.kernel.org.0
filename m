Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624EF18AD52
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCSHa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:30:27 -0400
Received: from sauhun.de ([88.99.104.3]:54514 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSHa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:30:27 -0400
Received: from localhost (p54B33261.dip0.t-ipconnect.de [84.179.50.97])
        by pokefinder.org (Postfix) with ESMTPSA id F26B42C08EE;
        Thu, 19 Mar 2020 08:30:24 +0100 (CET)
Date:   Thu, 19 Mar 2020 08:30:21 +0100
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Martin Volf <martin.volf.42@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 49/73] i2c: i801: Do not add ICH_RES_IO_SMI
 for the iTCO_wdt device
Message-ID: <20200319073021.wh2b7kumxgbj5wkf@katana>
References: <20200318205337.16279-1-sashal@kernel.org>
 <20200318205337.16279-49-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vw6a4yg6vf7n7izb"
Content-Disposition: inline
In-Reply-To: <20200318205337.16279-49-sashal@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vw6a4yg6vf7n7izb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> [wsa: complete fix needs all of http://patchwork.ozlabs.org/project/linux-i2c/list/?series=160959&state=*]

Please take care of the line above if you want to backport. I don't
think the dependencies are suitable for stable, so they don't have the
stable tag.


--vw6a4yg6vf7n7izb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl5zH4gACgkQFA3kzBSg
KbbTpg/8CMJm8JuY0ArAK03GeTDFjfCQeeiV8hUWfXSoThBU5+R050ajL+ETWgaa
5ZlAE8Lr18FR7j3ukJTDC/GJwkTUN2uarRioLXuogrh5JRoXns72nFSdEqiyhRdS
n4ESriIrXYfQPrAoInn23ow+rBWVSnYQkHlQF6dxCKYlT6/BOWq6WPkBuU0qfLbx
BvQkblFwYI/0dbjbBDTJhUIwpSR2tovO6Ewfa17Sm5zYq1oy02eCXam14W1HnWuz
wbPJX0wOBtsIi6Ky+LtAiKfG0I/FZfa9Um9RaxkeYraY+6FvYAFKtWDRaPGWHbuO
fhbRRxlN6XwxZZNjh7KGlCQ1q7VHAIbWUk0EWiaTiNR9B+gskTZZmf+teTOp5nT6
ZxTAwSsEPCz2Lyzr185MpxDUsN0rUMc1HDg9bJYriTuy8jqeRDpQxPrUln6joTuO
slyJ/rAeLpkonuvwvcgwRV1b2atb5ShNgSbvJ0nkvriuLbxwWAM5hq4gqKZc2iYH
mMlyc6lg7AsJ7Gm+jWuQ2F6NGvtCOhutGlqeMrWWu0IvJMTPDYekDYb0VNPwfO3C
WMxZtBc1exC9B4jKZGyW7vSBCb8KXgf+Wcr7fhGgF1GWnQBwVoKJKIxX71gmlorR
W/uSd3MlauRLsUmlVMJYPS+N5ZF4xpfCT1nT3I5t03insPmc3vg=
=I2UB
-----END PGP SIGNATURE-----

--vw6a4yg6vf7n7izb--
