Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9316E7B61
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDSN5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjDSN5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:57:18 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6451BC0;
        Wed, 19 Apr 2023 06:57:10 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DACDC5C015C;
        Wed, 19 Apr 2023 09:57:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 19 Apr 2023 09:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681912629; x=1681999029; bh=aA
        NURjJrra5ieWwAN31+1D8c8uBUG0QwdxLP+gGSNJA=; b=UpNMqlebQ3vZz4L2qH
        Ae6SH+aFJnN2pbWzaLxq1e3Vy+RYlzAQ9ozMAmyF5A72YBaNvWbPsYd+HXKZPKVL
        3aaTg11+9/QBNhTFzsnrYb9oiImTFGEBO2l9xnKhDOR9ZwcosIM+sdm1p+qSx+n1
        jYM2NlKsrmQ3svFJvJ1RkNuXHpo8z0wXN7CYCNl51CZyXUhTUILpxZul9pv5ai4w
        x7BRlQGhNihKi2stsgVUz6bfmAtWzpuZBVq2iGcS8A4A2PutR0N8iqDQYRw76e7Y
        WOXYoe7/HhpFyXZ3Wmm7Y6/yuCPSSJ0q8+DWkMdw7NlJHI7JwL5Ig7u3zmwuJ5YZ
        KSaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681912629; x=1681999029; bh=aANURjJrra5ie
        WwAN31+1D8c8uBUG0QwdxLP+gGSNJA=; b=Cpj8rsaTTfDcb0Erdhu7ERPG8OLxS
        AOR85CqXa8EKSPI7Bvs7JPmZc8przKffq1HDo+xYQWzuAZMAXQ6cfDJkMZg9uuKs
        X50z/9zcygAq5VyfOoYIr4Oe6MoWRrcJSl1sGF+ayA43yT9lVhbeuIfUXPW+I+Lf
        WOXubzNfYOU39pivOgG8fv45ADIiqEvp+Wkw0nIVqP51HHc2BYwwyqMqz0UjAV7m
        yNaoUcD79mGqScBgiEIOw/57Nr60QDzU/OMmPtNbPXKtRM1LDaLb5Tcxshl6r25h
        b64Yk8vq4N3zmv6j5NBZOG6qKvHXKzFS0CT1VU4P0mbb0OanTb2OyF/LQ==
X-ME-Sender: <xms:NPM_ZH2FLrw2hbmKrwXsSK9haXTRPYNKklYEZJ5SoGrt58bRwwH12A>
    <xme:NPM_ZGFA76gk15buLDf6EfwjKmgGzogKiiYOZX8GnXscR6Uv10wloiuWdpmz7-fKH
    bD9qxcIfFL0tmsMNw>
X-ME-Received: <xmr:NPM_ZH7ngVBZ8CdhUh0iHFV1l2EbldI9lZ4wTnUqKsIHiEOa4HLlxTs5DFSpZWHdn4jl6f-rKNP-69dHt1FpWueqJK5Dy6leOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedttddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtvdenucfhrhhomheptehlhihs
    shgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepvd
    ejfeeuhedutdfgleehkedugffhgfegkedthffhvdetledtueeiveejudekudeinecuffho
    mhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:NfM_ZM0wVu7QVZn-c-WVSXswg1uURsOgV2DbQsGN-deTrC9bVkZo6Q>
    <xmx:NfM_ZKG5yulQUJuIYXZjlVplGnQriceZ00pYs6JLBC9czTr0-lOw6g>
    <xmx:NfM_ZN9Lau002amiFWuWsfGa8MIEAwWpvyno4VvTcdkupA0AiIBXLQ>
    <xmx:NfM_ZIGPhn0CQl2I848qV-CGNwlJonCT5wclPMHcWv_T9mmSWEgZQw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Apr 2023 09:57:08 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id BE7B63389; Wed, 19 Apr 2023 13:57:05 +0000 (UTC)
Date:   Wed, 19 Apr 2023 13:57:05 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Conor.Dooley@microchip.com, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/138] 6.2.12-rc2 review
Message-ID: <20230419135705.phaf4qmqhorwx3jd@x220>
References: <20230419093655.693770727@linuxfoundation.org>
 <b6e0cc8b-eb4b-4906-9697-a1dab4741745@microchip.com>
 <2023041957-sector-purposely-859f@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xepdzsfmadiz2ero"
Content-Disposition: inline
In-Reply-To: <2023041957-sector-purposely-859f@gregkh>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xepdzsfmadiz2ero
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 19, 2023 at 03:17:13PM +0200, Greg KH wrote:
> On Wed, Apr 19, 2023 at 12:26:26PM +0000, Conor.Dooley@microchip.com wrote:
> > On 19/04/2023 10:40, Greg Kroah-Hartman wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > >
> > > This is the start of the stable review cycle for the 6.2.12 release.
> > > There are 138 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 21 Apr 2023 09:36:26 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc2.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > > Alyssa Ross <hi@alyssa.is>
> > >      purgatory: fix disabling debug info
> > >
> > > Heiko Stuebner <heiko.stuebner@vrull.eu>
> > >      RISC-V: add infrastructure to allow different str* implementations
> >
> > Lore is ~dead for me right now, but there should be a custom backport of
> > Alyssa's commit, submitted by her, here:
> > https://lore.kernel.org/all/20230417134044.1821014-1-hi@alyssa.is/
> >
> > Perhaps the reason is just the quantity of email, but that was
> > submitted against the "fail" email (and within a few hours), so why
> > was another commit pulled back instead of using what she provided?
>
> Ok, now both dropped, this got confusing fast.

So what's my next step to getting my patch backported?

Do I have to wait for these kernels to be released, and then submit my
backport again and hope it gets selected the second time round?

--xepdzsfmadiz2ero
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQ/8ycACgkQ+dvtSFmy
ccC7YQ//YbfLYoL0js+hEFkF2dIaykhvZFbSSW9QpbTGwabDOnzv1jgntew617Az
i4keU8RAE/OUc5l84a8rZflPXZStn1nPdNp3/WXzGkghu9dq1m4agv46bRawSD63
V9mG4sMmVKWAuP9oUXzINQ+Jg122sR7O5ppc0A9uwgnpJ47zhlkZaF6Q79JgOYYr
LQXDEcwIpcYbOwmh5ndVe0cWlPkZOStBLFKEojzwx3eC66s3V2mGVkZ6ger5NNn7
vyfElAa+oH4T4WXc/OAnZnj/LGx8O4MMEGqdiO2kNJEQpzfwHqZ/+LwLQaCaP4/n
WHBfYtXoAddNs4RWef0z4zOrZ0tAlrsnFYQTUwp+o+H+lfkBYTirpqWRZYyzZoAE
JVTZpnMcPGH5MXJ5RQa6+9e8M8eWRfyUbxTdhhU/Uz5EDdKhU/pn71LLk816DOQK
SLQLNp/K95FSE1N4BNrHUVwpjzdLuS2BVDWb9RUdNjBtXqlcs3H99Pe3PO6IMEDN
N4Pg9aTjtHhzPqInpEHzl0jIgkxjIIaTQiBK6oveC5jeCv8Ni5ArWK8Qs2Nk2pUX
bhJBVd30/EYkqydocouu3UfCt2KDZhFMajaZi8r99RNDvGEEDMpNDS1aU3naVO9J
TM9SlPROL1psqDBJHeehoP2gw6CY9o+luAEJ+i/YDiYl4kvrWls=
=I169
-----END PGP SIGNATURE-----

--xepdzsfmadiz2ero--
