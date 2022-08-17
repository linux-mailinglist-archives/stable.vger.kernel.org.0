Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A94596A57
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 09:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiHQHZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 03:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHQHZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 03:25:40 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFED26BCD5;
        Wed, 17 Aug 2022 00:25:39 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D70873200A02;
        Wed, 17 Aug 2022 03:25:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 17 Aug 2022 03:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1660721137; x=1660807537; bh=vJVx4WtDzf
        lqfh/jerRWkx6erDZLmKZWLsZEwHAhgJU=; b=NScLqu1b8Cggis4Ov9NKv0oP17
        Xb9SUCUeBrk/YEp96L1H31qDaZyxGJDMRO83Q/25VSUbAxNHIJaSBh6F/Zp2fpuH
        eQfW8asOsp4kOriA0PDRm0Rewo1WbtuARkN5hFSeBxCyK1NKwmLC+puKvEWnIhJ+
        4ZYH+URo49ynS6bVRyhh2H4JtLXVGi+xBRPjj3m7B+onz+nRhZbCoiQ/jAmOUEXO
        vAKS8OXpnYYNeK07J49sypSjzmvgZsFOwXQJAqyebAQ6SZhIWQ+L9szEuPU/cDKe
        5ASC3NtDJRfUDPhjIveg33tuksFpZh/0kSFJ7L5+xUCPysz8RN4vChikettA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660721137; x=1660807537; bh=vJVx4WtDzflqfh/jerRWkx6erDZL
        mKZWLsZEwHAhgJU=; b=NeLWExoCwPDyyfCfpqM8YJ2Xy5kdzWOMgNvZoedkWDBL
        ++yxxuj75HbAulWsmrcNuZ9NyYl1t6dYOJWv8zN2JQ+lKpgx9l33VeJSfJdB120K
        xTQxWtNbvrKnfjIpZkIPsHJUFUoABG2efznUztq7BwNFLQLvhkdaNQyoiZKdy+o/
        jamsJAgEXKn4kQnvn9GbeSznz0nAxikWXsjoZ5xzu1+wqWpxsKmtyHep08dRikJE
        j1xnZU2bNdWxiwOyFydoFUwCMjVchy6BZlUxeUMXvHU4ksWBkaQHU5chpWo03ACY
        N8I9tUuicqvdtCgb3uud1gOl4k+gFVTM74W8lzp1Qw==
X-ME-Sender: <xms:8Jf8Ynsleye5XXe5dMGrfk5SmMfru_MwT67UUen3NDCqM6R1VLYqFA>
    <xme:8Jf8YoeTdfLd0WZHsVW-hjCDWt7N5keCjmI6RNFG0GxwfTH4hBiaVsICNmOySWUwi
    57rIcU2wu5CRgdyyQs>
X-ME-Received: <xmr:8Jf8Yqxyb-g23OdIBSoVfEw0c73wEzI_3Z7pj_RD4I0xTq3Dsei_zLQO0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehhedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgig
    ihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrf
    grthhtvghrnhepieeuvdeiffevteejhefhveejheevheelgfejtefhteejudeukeehtdek
    uedufeffnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpfhhrvggvuggvshhkthhoph
    drohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:8Jf8YmPH7TsgSYPiqR4OFH9RVZiFiv0Lw0OYRhBWtjr9penEHKJyxA>
    <xmx:8Jf8Yn-b6ApkRaVkh0bLbxVYBXDvCsvQ-tp5lJuQjxQmVOxszbeW5g>
    <xmx:8Jf8YmXruJwrIrmxAe1BNuVLSWHW5htxgNGcEj5wDR0Hy0pGrkc5eQ>
    <xmx:8Zf8YrW6gYxVlVHBXKTI5fLXZRBFbQvwFTLe7Q9_ZBsjCXjGdfLRHg>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 03:25:35 -0400 (EDT)
Date:   Wed, 17 Aug 2022 09:25:33 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Dave Stevenson <dave.stevenson@raspberrypi.com>
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <20220817072533.g52swuix3rdr33fk@houat>
References: <20220816124604.978842485@linuxfoundation.org>
 <CA+G9fYuhJw5vW7A8Wsqe_+fNK4pWCGdQ+0zfkNyd3y7_X0=CBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="elypw663ujamzoz6"
Content-Disposition: inline
In-Reply-To: <CA+G9fYuhJw5vW7A8Wsqe_+fNK4pWCGdQ+0zfkNyd3y7_X0=CBA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--elypw663ujamzoz6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2022 at 12:45:14AM +0530, Naresh Kamboju wrote:
> On Tue, 16 Aug 2022 at 18:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.18.18 release.
> > There are 1094 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.18.18-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.18.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Results from Linaro's test farm.
> No regressions on arm64, arm, x86_64, and i386.
>=20
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>=20
> NOTE:
> Following warning found on both 5.19 and 5.18 on Rpi4 device
> Which was already reported by on mainline kernel on June 30.
>=20
> WARNING: CPU: 0 PID: 246 at drivers/gpu/drm/vc4/vc4_hdmi_regs.h:487
> vc5_hdmi_reset+0x1f0/0x240 [vc4]
>=20
>  - https://lore.kernel.org/all/CA+G9fYve16J7=3D4f+WAVrTUspxkKA+3BonHzGyk8=
VP=3DU+D9irOQ@mail.gmail.com/
>  - https://lists.freedesktop.org/archives/dri-devel/2022-June/362244.html

It's fixed in drm-misc-next but missed the merge window cut,

https://lore.kernel.org/all/20220629123510.1915022-38-maxime@cerno.tech/
https://lore.kernel.org/all/20220629123510.1915022-39-maxime@cerno.tech/

If it fixes it for you as well, I'll apply them to drm-misc-fixes

Maxime

--elypw663ujamzoz6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYvyX7QAKCRDj7w1vZxhR
xb44AP908OqrM0yDmjPv8loLAW4oRdkcTwh0TOI0gdoFucrEZgEAm6KizJY0OcP5
BFaL9EP8cqeaIEcsU6owXK/pGtri3AA=
=GOuM
-----END PGP SIGNATURE-----

--elypw663ujamzoz6--
