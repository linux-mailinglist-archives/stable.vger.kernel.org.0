Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1ACC4CD05D
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 09:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiCDIoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 03:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbiCDIoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 03:44:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66977652D6;
        Fri,  4 Mar 2022 00:43:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F8A1614DC;
        Fri,  4 Mar 2022 08:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B38C340F3;
        Fri,  4 Mar 2022 08:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646383388;
        bh=Y/h5g78WyLqqOP8Rn0lKLi8NsiNAlk4GlgEJY1S01sI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hwgDBdQxwNwUxcqs7Mrm6x8e1VA+vX8/2al4UI9R/pPxoeGSTYzEB/JANFjqUVv8B
         wcUkeo0ApVoHqGCkQsQ8Y9gFq9xBYQB7ON9ca+8tP2IuFxZM/4FeBGnV1NTP4mWZON
         a0TqKCG0m7L8u76K9yjxGxprev3gBcg7oAkH8NbaWWYQSP59sHR6fDU1q0j3j7AGnq
         yXsNaFMViEmYKAkisJEWLmbF/WzGEQlgxXvW9r+z/3zPPbKU5Tu8ocANRM52/qDBQs
         W5D6LPPO361ku0kN+AkN25Vx7ya8oXUA5k5freV1T0vy9r9cU0EhA32R7ZZU1Q6WVT
         ohjD9Bq4GhB7Q==
Date:   Fri, 4 Mar 2022 09:43:05 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc:     Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Message-ID: <YiHRGa5bDJAuBuHj@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, stable@vger.kernel.org
References: <20220303161724.3324948-1-michael@walle.cc>
 <fff424e7-247c-38d8-4151-8b0503a16a7d@amd.com>
 <YiHIIjSs03gDJmHV@shikoro>
 <4e25e595-cccb-0970-67b3-fc215bfd5b14@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MgWtAcUD42BapLAT"
Content-Disposition: inline
In-Reply-To: <4e25e595-cccb-0970-67b3-fc215bfd5b14@amd.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MgWtAcUD42BapLAT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I'm getting quite a bunch of unrelated mails because the regex is not the
> best.

I can imagine!

> On the other hand the framework is used in a lot of drivers and I do want to
> be notified when they mess with their interfaces.

Sure thing. I am convinced the regex can be improved to ensure that to a
high degree. I think it is also less work for you than asking people to
rename their variable all the time :)

> Going to take a another look at that when I have time.

Thank you!


--MgWtAcUD42BapLAT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIh0RQACgkQFA3kzBSg
KbaJFBAAqSSNSBv1vXoKC5gg1YCzVL7Z8QcCOY32Q2Ai40kXufU/bZLFFViRm1lF
TiAd3E3ENGMg7jK9VPwxHQGhbMSQ0Agf8tzNXYbDBCp9dYtgD6Xx42KSK6PAXGZX
wI4zyr4QpW+gwqPa/1ZzFdAi6YJ6Ow4yzUnLcmF4X/0D01B/VwnRf3pQMdA7Zi5N
at2M36wMnW5hYx/YXTg7CAP6BRhLdvbxzGeEvQySX1CK0CGOM38zYSjucL+FMB/+
FosFvlt7/yjNHe9Gp0yO673YNaiZ0ugk63PoaM2+U5gsMvYRuJ1FEeXpsQfissVy
O9co7S6LkoIQ3HfnIWEQ7FUfIANmYsiX4+zE9j/JDV+RxqbkLARQVAXJbIB9v1oN
0ZlxorUzxT5fpxLwgyWSJe4/ZqnbPapjr8tXFrl/7Rqzgl9HpgSfeqtbAPHNwSo5
xZB1z2JgUEtTaljT75JeuLs3D6DhYl75uZLqkl47iybY45+tCFJOKo51PB3CIKfn
lHk3hnPstc2TgUtGP3uxqn8PjIlqybOEGFnfCdfJNEajsPdcskyKlDOOtUkvO2NC
j/RR84QKsz8AcbfmbS47kAmS3owUeQLHvZF7Jf0AZwrg5sWTJb5MuabNc1uJscYK
H2df7m+0afUQeOVx40UmLUDZDl3pDW1J8bmvIQh0tPhL6+RG3nU=
=H7in
-----END PGP SIGNATURE-----

--MgWtAcUD42BapLAT--
