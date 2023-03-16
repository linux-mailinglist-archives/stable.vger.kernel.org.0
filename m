Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63A6BD9FC
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 21:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCPUQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 16:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCPUQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 16:16:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2EBE484F;
        Thu, 16 Mar 2023 13:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A380E620F4;
        Thu, 16 Mar 2023 20:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D40C433EF;
        Thu, 16 Mar 2023 20:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678997774;
        bh=jlXhA5WRMW3e1eu3Us06Y6/jpgMKHSd/CZT/eb/t3DM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oj3CgPgWYIko2xRoVO4OkNNwglvSochqZUdad3WAoVYYfKPQOK9zrNrChOTlbAN2l
         hbpP9B+iAXztRMHIxZiDgc0aPLPyQyIoHfsOVdvrPRoFeS4a1O1z1TA0Nw5XU7gT6g
         m4MnmjzfczvpLNYF5xwl0uMJtNDP00TwrTs88jm02R9UjxGBSESyKlPAtK03OnaH4Z
         Bito4BO6qH0DpjPw4KOaEspqgqjtcu8trcXraaJrqRMrtwTwHvjMB+qNDLMfp9/l+s
         aYJRBn6mj+E39/C0aho+8nyDhT9iNXSNuIdOMqgD6DVOIupPSZklz1CUTxSaR1A+4q
         evFxfsCiRvJVw==
Date:   Thu, 16 Mar 2023 21:16:10 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     andi.shyti@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] i2c: xgene-slimpro: Fix out-of-bounds bug in
 xgene_slimpro_i2c_xfer()
Message-ID: <ZBN5Chq547oaiLVj@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Wei Chen <harperchen1110@gmail.com>, andi.shyti@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230314165421.2823691-1-harperchen1110@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="D9T8JFYh2WhWZbPb"
Content-Disposition: inline
In-Reply-To: <20230314165421.2823691-1-harperchen1110@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--D9T8JFYh2WhWZbPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 14, 2023 at 04:54:21PM +0000, Wei Chen wrote:
> The data->block[0] variable comes from user and is a number between
> 0-255. Without proper check, the variable may be very large to cause
> an out-of-bounds when performing memcpy in slimpro_i2c_blkwr.
>=20
> Fix this bug by checking the value of writelen.
>=20
> Fixes: f6505fbabc42 ("i2c: add SLIMpro I2C device driver on APM X-Gene pl=
atform")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>
> Cc: stable@vger.kernel.org

Applied to for-current, thanks!


--D9T8JFYh2WhWZbPb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQTeQoACgkQFA3kzBSg
Kbbb1xAAgJYVo0SUjAn1biH+YjwVrwVkwuK8ULAc4Y51/RBni/lpOVijAU/xsiuZ
oyEVRGDc9e9Vco5pzli074ZMD//qz2yNAt7aG/K7pwV6SsAV/lYZ2ktBhXtREXIL
WtXHiCp+e0eDljG+0oADilP0w3UKkymdC4YN111dbnR71Ino2NpjVarG/tauJpb1
a7SCsjlRTzf0af442Gr+OqriI1HgrC/7CB5aQwOmqM1BryIFh4p47QzMbvntlpRA
K25YQjX49k95uGOlbT4WVBcOjFgTShBparVVMA1kfPv05rmIGqf8SC2wEcPTqzQw
4qY0TurVpqRrqgtL1xTDbq+OrUXg9hYus2dAc8KJaHgK3YblOh5E4EOwyZomUerb
lN79x2ELgdTMYzAQJMzOReeMvwMXrVbxNzjlztQQKvpFW5sv2ZKF34MPIu7jRrHw
6Bjhn7qy+LmljQqaRIcuN0qXEOfXu8XqsnbWAiYxAZxRBvWj+9CK9G2TT8Efeyi6
Q+Z6pYXW1SzdnBHu0C2BZQ1wb+hRDxvNQ+sOMI77CeYyhLBpjRV5cAjbswv8EPDb
CAGy1VdKpq7uwwgTCNCxa0SxSuhpU8ijC4Uid0uTihyv8ElZUS9zKSJYVvLa44R/
W4sg5EQsKU2mKYiJjl4nBL1Bqjg/FLWvRXx3Xy9VdncQbFR7mTI=
=I+CR
-----END PGP SIGNATURE-----

--D9T8JFYh2WhWZbPb--
