Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4959B4CAF4E
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 21:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiCBUFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 15:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiCBUFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 15:05:34 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D532CCA316
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 12:04:46 -0800 (PST)
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nPVDI-0003vC-F7; Wed, 02 Mar 2022 21:04:44 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nPVDH-000X2x-PB;
        Wed, 02 Mar 2022 21:04:43 +0100
Message-ID: <72f61101e4b40d4986435058d43eeb21c80d5c64.camel@decadent.org.uk>
Subject: Re: [stable] usb: gadget: Fix potential use-after-free
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Hangyu Hua <hbh25y@gmail.com>, stable <stable@vger.kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>
Date:   Wed, 02 Mar 2022 21:04:43 +0100
In-Reply-To: <a4cc25a6-c6a7-37d6-d889-ddd80b2d8a44@gmail.com>
References: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
         <a4cc25a6-c6a7-37d6-d889-ddd80b2d8a44@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-LBFGkRM93rUvSivwmLd/"
User-Agent: Evolution 3.43.2-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-LBFGkRM93rUvSivwmLd/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-03-01 at 09:33 +0800, Hangyu Hua wrote:
> All right. I will do that.

That was actually a request to the stable maintainers.  You don't need
to do anything, unless there is some reason why these fixes don't apply
to older versions or need to be adjusted in some way.

Ben.

> Thanks.
>=20
> On 2022/3/1 02:47, Ben Hutchings wrote:
> > Please pick these two commits for all stable branches:
> >=20
> > commit 89f3594d0de58e8a57d92d497dea9fee3d4b9cda
> > Author: Hangyu Hua <hbh25y@gmail.com>
> > Date:   Sat Jan 1 01:21:37 2022 +0800
> >  =20
> >      usb: gadget: don't release an existing dev->buf
> >  =20
> > commit 501e38a5531efbd77d5c73c0ba838a889bfc1d74
> > Author: Hangyu Hua <hbh25y@gmail.com>
> > Date:   Sat Jan 1 01:21:38 2022 +0800
> >  =20
> >      usb: gadget: clear related members when goto fail
> >=20
> > Ben.
> >=20

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-LBFGkRM93rUvSivwmLd/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmIfzdsACgkQ57/I7JWG
EQk1SA//WeOq17OQ4iN0S0tS7PWh4oJCdnR9/F4I25Czp6s6MCBiHRrXXwzo8rIZ
QlO2Q6cwZqvNib9srf7IwM+Yh1MsGWayodxVXk/oVGm06jggIwq8oV8sMK32NtBK
nUDQaQ6/2Qebf3lugLusSlcra5KtbGPCh7htKQJ78sGFPza4+LzR7bH16H2R47Ol
zLF1kUomzEtaQCOm1yOVSxjtseY03RU1hCKty+j/7x6r5LO1kMYkJPQRwKpnezE7
kUsXil6KGd5A++AGZAb6JBx5W+/iSOmv1Asfs0V8SOppmpJyxWlbQYHxcG7rrmoE
Scm7Bl0oab2sM4E7UssLNX2fQtFRTi0iKstAObGrNDX1GHgbgr7mHUrD0nbRpXr1
09WjFoFTwZWx5tQZxl+AHXox1y5rQjJRXTW7gipdsDy/etVi4jcmJy1rXbvgn15N
iIo5S8zj6Wvbt5wQ+7ttf4D8isuQv4k1rkGidcAGE9BQqzM1ExvnPN3O01TmSdYY
bPvLoSt7qA1ADQK7cTgKnYi25EIjEDaPz4xxQTScVfRTaPjQ/7eMaNBFfw/nMQ2a
vY1Q4iiaZJ7j3xjdYdpmVfHfb5Y/m6WmrSvWj0URIvaZyJuDRFPPqZcyXMrEpPtx
fvnkzUAmimHfGMVnpQw9PZyPnEwueMEhZ7MhcvDj4fjmCU2tF5A=
=TiyY
-----END PGP SIGNATURE-----

--=-LBFGkRM93rUvSivwmLd/--
