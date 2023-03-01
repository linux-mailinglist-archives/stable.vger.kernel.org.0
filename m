Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0737E6A6D00
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 14:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCAN0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 08:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCAN0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 08:26:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044FF38019;
        Wed,  1 Mar 2023 05:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 949B861309;
        Wed,  1 Mar 2023 13:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338E6C433EF;
        Wed,  1 Mar 2023 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677677202;
        bh=kJHUAHlz97yUOJaZQyxEScFLubK3mASBfXnct/E80rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ui73bJFZ6yQT4Fv97MIscyh6DxXnbSsOia542BXC8r2ymIUYjhfkTg0g68VskfDV+
         U929vEdgnHulbQBZX0E8XzPKMW5OPCHIMy3S+fYoa4Pn/fTqsVmpIqiTWLyQo+fT4Z
         q7wBeoPXGRlHwsikucj2F43Ohdm3h6r/Mb9ULXJUHcwX6UhdaQYUwJ3dq9LBqLGoxc
         /t4BBJri0agdW5TWyRtPCijVhXRtv25vH0XuUXI29XG07FlqSpXGESXgvhtoJCnb0w
         ON9UnMF9C3KdEYsDqyvK8pAjauAdhMTp6gDuIKAyVjEt0Liz+DUeZEdtqTndgJUYOP
         XXmH33wu7xDeg==
Date:   Wed, 1 Mar 2023 13:26:36 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/9SjIDSss390Ki/@sirena.org.uk>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="adcGMmTVGJJ8PcSt"
Content-Disposition: inline
In-Reply-To: <Y/3lV0P9h+FxmjyF@kroah.com>
X-Cookie: They also surf who only stand on waves.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--adcGMmTVGJJ8PcSt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2023 at 12:28:23PM +0100, Greg KH wrote:

> In an ideal world, all maintainers would properly mark their patches for
> stable backporting (as documented for the past 15+ years, with a cc:
> stable tag, NOT a Fixes: tag), but we do not live in that world, and
> hence, the need for the AUTOSEL work.

Just as a datapoint here: I stopped making any effort to copy stable on
things due to AUTOSEL, it's pulling back so much more than I would
consider for stable that it no longer seems worthwhile to try to make
decisions about what might fit.

--adcGMmTVGJJ8PcSt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmP/UosACgkQJNaLcl1U
h9BjtQf/f/WaWQ+wWiQwPh4CH6Sx5qKJ8vYaI4h36Be15bxeQATfKNB7ypB5Mm4w
Mil4ox7p7JMlyR2q2p0+8WvDV/zkevvTTdqiZF4J3uDG761M2yfg8amzeLIDqPLH
ojnUUXpIDPiAaOO4sYUaeT/Ia3N+TXCRk7yHSMyIAsorsb4vB3qCWfJ/tu1K3Xpu
nteiYr1AvLeWafaP42Eq8eYLrXNKN53szNAnfgwDhPxR5DPjI7vQXSNQzATPb0za
P+FnxKS4l6/Lb8s28qheORYDwxf49jDiYyS6G9wBdQ6wFbXQE8NtySgEx+29+cH+
ultACzSjbFnOT1LJQOCNHB1UsBZInA==
=ArvS
-----END PGP SIGNATURE-----

--adcGMmTVGJJ8PcSt--
