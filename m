Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C355FE0D3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiJMSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiJMSMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C386321;
        Thu, 13 Oct 2022 11:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71A1061A28;
        Thu, 13 Oct 2022 18:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DC0C433D6;
        Thu, 13 Oct 2022 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684151;
        bh=JXVgEoItyp9K7yWI6SmXgW2Qv+LtJDXJH/9YZ0IrpzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=smKHlIFOp9LelP2KIHZYjK7zA+Gn2SifepaIRtdDHaIz7FqGVHSjxRgoTEmgRHf1E
         1P/HvjuZ71fgjjgUM5FWFb8oUYIZODDZdm+83z3SWLJGMSzIIUs20CSTU7qk5ujdli
         3r+9oBF67aLS06cEuxL7kY0S5mp7zNPiFAUTxcFuy3wpywZ7YhiWco6ra0Ten1F/v/
         dGFAhRJ82YfXBs+pEw40zDZ1mQgVEnvXYqzkq8s4uUIQ8nZiW6CcGdHYPg5ODQmYbL
         a5+gZY5Wht5NgCgXyuEDpEd01AyJrHSsIyWACTq7PeL/0Q2DBfzi1R5oxTJ7Fq3OIc
         3OdZ9Kr5MtvZw==
Date:   Thu, 13 Oct 2022 19:02:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 15/46] kselftest/arm64: Allow larger buffers
 in get_signal_context()
Message-ID: <Y0hSsrwXLy4qCgkl@sirena.org.uk>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-15-sashal@kernel.org>
 <Y0WGCuHDriRctkeL@sirena.org.uk>
 <Y0hRxpVqigP4amOD@sashalap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="laXRcuvRLoswDask"
Content-Disposition: inline
In-Reply-To: <Y0hRxpVqigP4amOD@sashalap>
X-Cookie: The Killer Ducks are coming!!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--laXRcuvRLoswDask
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2022 at 01:58:30PM -0400, Sasha Levin wrote:
> On Tue, Oct 11, 2022 at 04:04:42PM +0100, Mark Brown wrote:
> > On Tue, Oct 11, 2022 at 10:49:43AM -0400, Sasha Levin wrote:
> > > From: Mark Brown <broonie@kernel.org>

> > > In order to allow testing of signal contexts that overflow the base signal
> > > frame allow callers to pass the buffer size for the user context into
> > > get_signal_context(). No functional change.

> > This doesn't obviously make sense independently, even by the relaxed
> > standards stable uses these days?

> I can drop this one, or, are there maybe additional patches we do want
> to take?

Unless you're going to start backporting extra tests as well I'd drop
it.

--laXRcuvRLoswDask
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNIUrIACgkQJNaLcl1U
h9CCMwf9ECWzA0rKDkvQ7mcxeBHE36ogVnHiT937Cq+OAuNf8tNiytSiqL5WyY7d
1yuma53V8jRCSEUXZnUXXdZG6pB907uV4kk02Gupy4h4QEJVTnbjLFO0JymATzRZ
wrU+eJhdxAdlCOXXn0Ld2SsXnP52DRr1EbFQoe80+R9J3G2ZKf441tsAYTqGvASL
DH19Vjw2z+reDKFq7kH5+sxmspvQM4yUs1zzbBJ8aQT+qgt5hg4RRGZ/dsxy2huc
el6lj2URleB4Ig0POj7j0YCMOovt8btCJQpzSsQsAB9qbbW9V4GV43p3j6kWPDjb
jvnVxuj77U8SFkWVZs4/jlVlRM9vfw==
=dA5v
-----END PGP SIGNATURE-----

--laXRcuvRLoswDask--
