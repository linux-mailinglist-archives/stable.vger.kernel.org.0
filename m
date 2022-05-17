Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6385552AA81
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiEQSV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 14:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351994AbiEQSU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 14:20:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8745EDEEE
        for <stable@vger.kernel.org>; Tue, 17 May 2022 11:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2268261571
        for <stable@vger.kernel.org>; Tue, 17 May 2022 18:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7689CC385B8;
        Tue, 17 May 2022 18:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652811656;
        bh=o4YnPO2zCm3/l/lgeERP6gHXMF/WjAEl9gph3kEWbAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eU4PZnptgzI+oYklDg9hk1aiYO3gqI2jZWcfy62CZm6Il8XXsi7L7MGjE0gSphQiI
         lx+sek59D29VwxYcG2rowpOxNuaRDJV6NGNriCQbMXCXxhDwwvYPo7KmJ+h7zhzr7w
         Xtcq4idGbYrU70xsdWLyaDyiewicDFMBKW28tFiTZMdpGtqsHgzVIZ71yO5+OSGQOF
         EIcZjDz8csPRPcWOGm/D3IVuapRn2M44/tgOIVsqUze+IvfNB4wwcV599yWEILXPkI
         6XfoMKk1vaomKUHZWvLjzYd0hHVQ6KAnCy5Fz9fTnM2nhXbidYorWPAtP5wKbSYsFn
         tF/AAHl7Pckew==
Date:   Tue, 17 May 2022 19:20:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Tan =?utf-8?B?TmF5xLFy?= <tannayir@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Message-ID: <YoPnhDRMwoT42vS7@sirena.org.uk>
References: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
 <20220517011201.23530-1-tannayir@gmail.com>
 <YoOdauC5Q8POpHLe@sirena.org.uk>
 <2f331adf-6f95-06c1-a366-ea81b5bf6ec2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mPeorUta12cKt0D1"
Content-Disposition: inline
In-Reply-To: <2f331adf-6f95-06c1-a366-ea81b5bf6ec2@gmail.com>
X-Cookie: Fats Loves Madelyn.
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mPeorUta12cKt0D1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2022 at 05:25:48PM +0300, Tan Nay=C4=B1r wrote:

> The problem is that the snd_soc_put_volsw_sx, checks the userspace value
> that has a range
> starting from 0, directly against the $mc->platform_max value mentioned
> above
> which is set to 40 at that point so it checks for the incorrect range.

Do you have the fix in 698813ba8c58 ("ASoC: ops: Fix bounds check for
_sx controls")?

--mPeorUta12cKt0D1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKD54MACgkQJNaLcl1U
h9COhQf7B+9mlkPfcMrEUGVphkjGt2eRlgfMJD1rn/3DlZiO6lKeYV2ucHqAqOTk
+bs8+atKKXclIFAP2E93ShgpQDEjMKZQWxoi9GoYZ6XBLtmbcKFTitDnmMava4lW
7v5KgP3ZhFZx5bBrPucYz/fV4Z+mAMQu6RSB29UwvxClh7vKWTeJciPNapS97pWp
yw1NIftwIuDVe2bmHQn2wBDNwpPmZUohyLot/ENMPli7O/CvXQNINq7cmUNEJxfj
orI8Yw15BCw4+fraycoqs3qrldnxFtr8WFwC/pEM6+xYdMNatZNNtMC52xrceAtQ
IiRLAB0bIlGsU83Q6/DHg6rRT+2v6A==
=76U2
-----END PGP SIGNATURE-----

--mPeorUta12cKt0D1--
