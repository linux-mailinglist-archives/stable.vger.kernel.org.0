Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA62C506D49
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 15:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiDSNSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 09:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiDSNSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 09:18:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0F633E0B;
        Tue, 19 Apr 2022 06:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39B5561605;
        Tue, 19 Apr 2022 13:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40465C385A5;
        Tue, 19 Apr 2022 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650374134;
        bh=XyLeUd/v63OA7SUTUm0rez8xElwKroMr+psf6pn932Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLl0fxObFpL5KXlYroSc8qt8bgjljkyAsi/GCsHFxNwrkZiau7vl+4nRFWJ1V9jNl
         sZp7pRHZ3yipIISK0qweCepkBfbxtXzz+efrwtlm1UDi1YZta2xS7995BnHX+Uz1JA
         ALK5xe3MoaNr/rxVwtLYYPf4S5ZG9REGjKxTop/fCWXNA8wuMQ1oLMC67PXlyJOe2Q
         35VNNfG6Vmdy4espTVVQIk9NMn9XcLDnXZg17jQ7AZ1yRUcrzKgPLOEZ1lAxOSrVG9
         VkXrTg6ut13jj698dTAVFpVifH0KzNCBsiHk/WjqW9I7+7qNcPj0BAQBxMe/VZVGRB
         uHeWdFUPHGF8Q==
Date:   Tue, 19 Apr 2022 14:15:29 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        linux-spi@vger.kernel.org, Pratyush Yadav <p.yadav@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 34/49] spi: cadence-quadspi: fix protocol
 setup for non-1-1-X operations
Message-ID: <Yl618Qfbm3NpGjB5@sirena.org.uk>
References: <20220412004411.349427-1-sashal@kernel.org>
 <20220412004411.349427-34-sashal@kernel.org>
 <d618fc184f162b1da8d75729b5939bed52308040.camel@ew.tq-group.com>
 <YlVrbR6Giy2OXe1R@sirena.org.uk>
 <YlyHqKVBC9u1F9xS@sashalap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="um3oZgsUst9dpcPu"
Content-Disposition: inline
In-Reply-To: <YlyHqKVBC9u1F9xS@sashalap>
X-Cookie: That's what she said.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--um3oZgsUst9dpcPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 17, 2022 at 05:33:28PM -0400, Sasha Levin wrote:
> On Tue, Apr 12, 2022 at 01:07:09PM +0100, Mark Brown wrote:

> > For the benefit of those playing at home that's "spi: cadence-quadspi:
> > fix incorrect supports_op() return value".  It's much more the sort of
> > thing I'd expect to see backported to stable so it seems good from that
> > point of view.

> I'm a bit confused as I don't see the other patch in Linus's tree?

> I'll queue this one up then...

I've only recently applied the above commit, it's not sent to Linus yet.

--um3oZgsUst9dpcPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJetfEACgkQJNaLcl1U
h9CDZQf/TY/cVb9af5Ei63uqOeKzzcs5loIODBJ04wcdky0mYlICzwT4NKRcWp+P
t7T/O0b+AGrhzo0vXw1B16RAdm6hYcmZ7hPzw4zp1EoC/EwY/jUustgwOn0ZRMWT
tBfVKS0IVu98ptUgeYu14xX57jqPkHx5QkoXk32Deuv/d781sApq3+wK9licaIZA
+mZb5mEttMx1pVk5wCFEgVrylMu1yhwu7roTI2HLC4wlw1jhDXfE3e8MBmLvL3xe
uUTYVak90sl5pJc6J69sfUdI5I6HG0C36BHArucu9/p7bGa/iMV7YqwaD4EpefqY
HzxI+3UIgt0DXIvI5KuQG+vO8eVSdw==
=9Ape
-----END PGP SIGNATURE-----

--um3oZgsUst9dpcPu--
