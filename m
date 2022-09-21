Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071AE5E5423
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 22:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiIUUFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 16:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiIUUFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 16:05:05 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B5983BF6;
        Wed, 21 Sep 2022 13:05:03 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9836A1C0001; Wed, 21 Sep 2022 22:05:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1663790702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L3i8CrY0Wz6CA26khVWO3vC3EQiWpR72sUtehjPqVOo=;
        b=mlWW1kFoLnqdT3Jq65bA12jFiD1Gl0uBMa0B8XA+M7YUQ0gkkuaeGyavAlW8QDb++YQx/2
        nHJUWZ+RvMJHlQxyA7k/L5XPxavRDs85o2/Ajug9ecmeldCJ3b2F+OGxxAdXYTtpDaq/lS
        d1gstiaRT4LNyWbfgWwQdUke8+9J864=
Date:   Wed, 21 Sep 2022 22:05:02 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 5.10 25/39] Revert "serial: 8250: Fix reporting real
 baudrate value in c_ospeed field"
Message-ID: <20220921200502.GA32055@duo.ucw.cz>
References: <20220921153645.663680057@linuxfoundation.org>
 <20220921153646.560456712@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20220921153646.560456712@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Johan Hovold <johan@kernel.org>
>=20
> commit d02b006b29de14968ba4afa998bede0d55469e29 upstream.
>=20
> This reverts commit 32262e2e429cdb31f9e957e997d53458762931b7.
>=20
> The commit in question claims to determine the inverse of
> serial8250_get_divisor() but failed to notice that some drivers override
> the default implementation using a get_divisor() callback.

I believe it would be better to remove bad commit and its revert,
since it was not yet released.

Best regards,
								Pavel
							=09
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYytubgAKCRAw5/Bqldv6
8nLOAJ4xNdt97pwANYEU/OdEbf7EWBvjnwCfSD69jlFjtu5xDixFA+z/ATYDs14=
=Moo5
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
