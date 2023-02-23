Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDA16A073D
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjBWLW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjBWLW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:22:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D8B54553;
        Thu, 23 Feb 2023 03:22:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC39615FA;
        Thu, 23 Feb 2023 11:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A69C4331F;
        Thu, 23 Feb 2023 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677151345;
        bh=xo2Pf2P6U/yXJr++QLv4G/WfT+FqgmfyXH9R0a6HcaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YLdIkk35PjLkrKtqyhSrP+Wt3STPqk4om6QPIAQMnvtf5HmgUz0hwSfPpZ06roLRX
         zF9tmVYUOmjEaEV5ORLbieXW3c+plSTTeV7iGVzbOGSAe7OmaOnWubGoc7KIAajhAI
         rvAIMcbxXe6f281XGAwllPD3yHP/GbbZUAuHq/tGxjg7phvewSpMgVfsOpd5VTVvsu
         wlGUc0qhNT8hDbWHmKDlToWKyz9RmMw7bDlwIpV3eG+arLlkd+gwdVERypK2cppWLE
         JrkYFsGg0LOhwoYzogiOq6UAjEu4aguMJ7XbGGSoZS9Z3S8FwOtPrcdq09F2HAO2Ak
         DIz6Q29naNW+g==
Date:   Thu, 23 Feb 2023 11:22:19 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Stephen Boyd <swboyd@chromium.org>,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] regulator: core: Use ktime_get_boottime() to
 determine how long a regulator was off
Message-ID: <Y/dMawzRWLVlotr2@sirena.org.uk>
References: <20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dyig4QpSD2uMQ4L5"
Content-Disposition: inline
In-Reply-To: <20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid>
X-Cookie: Hindsight is an exact science.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dyig4QpSD2uMQ4L5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 23, 2023 at 12:33:30AM +0000, Matthias Kaehlcke wrote:

> delay on resume before it is re-enabled, even though the regulator
> might have been off for hours. ktime_get_boottime() accounts for
> suspend time, use it instead of ktime_get().

This API seems like landmines...

--dyig4QpSD2uMQ4L5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmP3TGoACgkQJNaLcl1U
h9Bpdwf+OHvh7ReC4YwTcY6HcANB7pZVOyr2p0xYM875cGzEC7kwbPSl8ZN9HbWI
svloXDL4PRVUzE5ja2lSo7CiEWeEYflBs940noWAVZGjBTetbyKkc+T8C3dtC3R7
hBeP7hkPuBzjutw2CcXc/ISwsDcbpav1zjcgo03dD32KDMHh8JIlf7JH1rc690KW
XJHPCHRzJZRL2wkcvnA6cONOVFZAaB3jYqHb3D/ST2Oa4itoiTPsH6Ls1vpVoqkm
VNIXUeuczXQQ1XC4DXi3bZbeHEKu06glRP9v0zPxOXFUs6bCeMxroMYY9bhYggi0
SQktU7f+HaFn8bRpeCOtR+griE2kBA==
=Q2I/
-----END PGP SIGNATURE-----

--dyig4QpSD2uMQ4L5--
