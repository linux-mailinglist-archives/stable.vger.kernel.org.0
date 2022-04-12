Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC94FE0A7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353125AbiDLMoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353896AbiDLMmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4987013D36;
        Tue, 12 Apr 2022 05:07:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 006B7B81B3B;
        Tue, 12 Apr 2022 12:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3091DC385A5;
        Tue, 12 Apr 2022 12:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649765234;
        bh=HElbpEp36SC+U2mOLk3U92uAL/Z9YUiPP4dM37u9zlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M/B6TZqYrKLYCklOOVU0gKAdNLzpxZZQTouCDWTqTAO5cLBG0RNVGaHLeAaJ/N6E4
         T2bTNcoKuxy73nb7uQUq4MmE9msmyUeEmVpJEeyhqWkoEwg71QWmWuRey08YFiNq5v
         KGFJqY3YMnZJTPYhhdIgRSmTYdm5hPlEO3lw4Og/SVNSQBczScPjzv/4D7EWLcDnQE
         mVtWtz58he+7Uu720ASzKT6sR/HEncfksMJNvSWfDlsknwBUXoJBciiaDdVZFWMn5P
         c67CJIjRonUOHAk8ZtYtvvZ6yIF8+ULPvBNOUpeAp++2j/10pjICgyz2Q0AfHnbCdy
         taRNehvT8xCkg==
Date:   Tue, 12 Apr 2022 13:07:09 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        Pratyush Yadav <p.yadav@ti.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 34/49] spi: cadence-quadspi: fix protocol
 setup for non-1-1-X operations
Message-ID: <YlVrbR6Giy2OXe1R@sirena.org.uk>
References: <20220412004411.349427-1-sashal@kernel.org>
 <20220412004411.349427-34-sashal@kernel.org>
 <d618fc184f162b1da8d75729b5939bed52308040.camel@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4+g+U9H/I8tUHNb6"
Content-Disposition: inline
In-Reply-To: <d618fc184f162b1da8d75729b5939bed52308040.camel@ew.tq-group.com>
X-Cookie: Approved for veterans.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4+g+U9H/I8tUHNb6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 12, 2022 at 01:49:19PM +0200, Matthias Schiffer wrote:

Please don't top post, reply in line with needed context.  This allows
readers to readily follow the flow of conversation and understand what
you are talking about and also helps ensure that everything in the
discussion is being addressed.

> what's your plan regarding this patch and the other patch I sent [1]? I
> think there has been some confusion regarding which solution we want to
> backport to stable kernels (well, at least I'm confused...)

Well, it's up to the stable people what they choose to backport -
they're generally fairly aggressive about what they pick up so I guess
they want to take this one?

> I'm fine with this patch getting backported, but in that case [1]
> doesn't make sense anymore (in fact I expected this patch to be dropped
> for now when I submitted [1], due to Pratyush Yadav's concerns).

> [1] https://patchwork.kernel.org/project/spi-devel-general/patch/20220406132832.199777-1-matthias.schiffer@ew.tq-group.com/

For the benefit of those playing at home that's "spi: cadence-quadspi:
fix incorrect supports_op() return value".  It's much more the sort of
thing I'd expect to see backported to stable so it seems good from that
point of view.

--4+g+U9H/I8tUHNb6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJVa20ACgkQJNaLcl1U
h9BClAf/UqUUpSphtpgTNkktLrxmPRmeDDAcukSyTu4K97s55pKoZsTJ0y666nAk
nozPL3LN1OPxpjiUiwn2+IFjYY2U3IV+VwTnUEFZgSq5D7G0/+kiRY9DWZB//8td
1T6jDSzqZVQ3r19WePZGI3yFsTf3WrcykirQc7kKc7YtL/UvzQOLobSDstdfLY2v
9GZrztzHepoyO2vvf0UTAWs8RtEhyEwmtwCmWm0z5kt4cnhsMAhhttAXBUWmRJMz
tcvti4BADXte7/dqG1sJXiy8GhDDQeU9iT0+OCZawVjbAVS6LFv4WfTPQSvBpTVG
tDn0Fc4aYcfnb5wjzHcTVmqH2/2cCQ==
=4C/4
-----END PGP SIGNATURE-----

--4+g+U9H/I8tUHNb6--
