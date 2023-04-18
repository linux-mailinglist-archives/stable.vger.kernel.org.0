Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF36E686F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 17:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjDRPmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 11:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjDRPmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 11:42:12 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AB2137
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 08:42:09 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D7CD5C0070;
        Tue, 18 Apr 2023 11:42:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 18 Apr 2023 11:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681832529; x=1681918929; bh=5d
        nIXnZZkWl12mvSlX/krMj6UqSYY+KpPqHyy1MFQxU=; b=Hq2Og/PJzTtELsjZ5e
        c3PXxrw1pJHr/l2RuFvbBrjKbnFFn2IzsS6jrPbQZxd0M4v1Izm4Oq3vfkxtKfTM
        LR1dfMHmIoe9S5/jUGki5Ntjkgn90HiXxl/gMixylAcurdhOUHkg10XbXQ/ig4+/
        4HeVpAhxfJ+zx16hsKQjweFlrY2Qoyz/Sj1ZYj7QfA6yYjQCk7T80O0C2nXgXsgL
        +xZRtjMvc6XRcmhozyosAC0CZOVAcGdVFkjaaJ4qtw/BIQcDAHZQIcld9fzKWpq/
        0kqnJaszh/ao4hnFy3hwJ5ksXreBEhohQj04VscC6+1P2nfcrpyJ0I+E3fb2y3Cr
        TOTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681832529; x=1681918929; bh=5dnIXnZZkWl12
        mvSlX/krMj6UqSYY+KpPqHyy1MFQxU=; b=BxcVS1RZbKwp7iQsXChq4J0UwWYSi
        6aedy7aPhxGF6wOm5sH7yjn4fDFxIbqEEj3l8bdu7M0t89Q3LmTsSttjAUDvNfTz
        lJ9f91Xm404TFMGBvc4dkA2QM3K4NmvZgnEJ8PSawrKSWMPisYl7OQWdRvo/wF+R
        KKKBipSCfbrD21EpRvokUx4bk55YWx8anxGFjHKtpQ6jU3hAMhO5UoAxyY4jW1A7
        Eazr4Fmv88sV7pv9fQaZJ0IW0B7C9tSZfqy494VybHLbTIZkRAsbRYcuay8M/xcp
        Gy58EfPdZr8PYJdAcgXzggAOxIVWhhfkuenSIXLCxUGt3xCWJuRUuAyDg==
X-ME-Sender: <xms:ULo-ZIpZzpsMyPWj3yO4ntvOqvew5wqReQ6pso7T7vYuuqAlRzVHhQ>
    <xme:ULo-ZOo3fDpOl0DMKTfNpwwAdZvB_mwT2b9jEwwqd9oLUnXwgkm52yOKg5DNRLyAh
    rY1pqRg2-NWIIUvaQ>
X-ME-Received: <xmr:ULo-ZNNiOPCiuvqb0nzQe7FTE_-Vi1Ngjhs8dVK_2PV3nt0FDd--bf6VRw0Ar1RnMQ76Te8o1xwThO0AFdNyBEIasGYvL9JCxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdelkedgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtvdenucfhrhhomheptehlhihs
    shgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepvd
    ejfeeuhedutdfgleehkedugffhgfegkedthffhvdetledtueeiveejudekudeinecuffho
    mhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:ULo-ZP4RM0oIrbupR2Wbq8FUYjjXJNFU_A9X9UYNOsPlDll9YtcIkw>
    <xmx:ULo-ZH6hVJC7fByqrRAmgm74dqFi4shYtBB5snAL6VZZVy8Om78oBA>
    <xmx:ULo-ZPiSLiI2U95JhZFd-UOjzFtmiFDJchfphST4F9DMAFCbL9-ncg>
    <xmx:Ubo-ZEyPPkxAdSAqwxcmET7s-uxvxyphgmDdh3Wp4UymZPXmtAsZQA>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Apr 2023 11:42:08 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id DA5DA323D; Tue, 18 Apr 2023 15:42:04 +0000 (UTC)
Date:   Tue, 18 Apr 2023 15:42:04 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: Patch "purgatory: fix disabling debug info" has been added to
 the 5.15-stable tree
Message-ID: <20230418154204.5eywuttjx2efukqq@x220>
References: <20230418012722.330253-1-sashal@kernel.org>
 <20230418103951.2b7kia6nb2zdeqje@x220>
 <2023041837-dial-catchable-0203@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gd5km4os56rsu45y"
Content-Disposition: inline
In-Reply-To: <2023041837-dial-catchable-0203@gregkh>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gd5km4os56rsu45y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 18, 2023 at 01:19:39PM +0200, Greg KH wrote:
> On Tue, Apr 18, 2023 at 10:39:51AM +0000, Alyssa Ross wrote:
> > On Mon, Apr 17, 2023 at 09:27:22PM -0400, Sasha Levin wrote:
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     purgatory: fix disabling debug info
> > >
> > > to the 5.15-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > >
> > > The filename of the patch is:
> > >      purgatory-fix-disabling-debug-info.patch
> > > and it can be found in the queue-5.15 subdirectory.
> > >
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> >
> > There's no need for this patch on 5.15, as the regression it fixes was
> > only introduced in 6.0.
>
> Not according to the information in this commit, which says:
>
> Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
>
> And that commit is in the following releases:
>
> 	4.19.264 5.4.221 5.10.152 5.15.76 5.19.12 6.0
>
> So it should be also in 5.4.y and 4.19.y, right?

Okay, it turns out that it should be included in 5.15.y and 5.10.y,
and I was missing it because unlike in 6.x, in 5.15.y and 5.10.y the
problem only affects Clang builds (using the integrated assembler),
since their versions of the commit in the Fixes tag are different to
the ones in 6.1.y and 6.2.y.

As you point out, 5.4.y and 4.19.y are also affected, and in fact
4.14.y is too.  But porting to these kernels is harder, because they
don't include 15d5761ad31d, which introduced asflags-remove-y.

--gd5km4os56rsu45y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQ+ukUACgkQ+dvtSFmy
ccDzcA/9EQ7cj4EYhSMOlYuQWTJMEfxQJgE1jKXV4/fVRzN744u9i1PnI6BHu4yi
TVeP97xtYFQ0+M9cjWHbqUghZUVJNoMIvYYJnhhzRRjjo9QP9py5R1JPHZ83Es4k
UeFnpo1uocxOmesGGLNz/LL5ie161BqkJ5REpuRXe3VBRqWd5idhraajI0W8vmrb
g9siq3u8zJ2amlpigBPqNDk0vkFy9h68dHiafkoIUpiQ/dyLEk8CKT2VkQG2ZuG9
2C65bE14bTWbbrAvegqLpz7sykGwRiWNkAs62SjTwC9oyocPYi1YPjwGAEGQAjsO
8VFZ6nmweOpRuc/9Y5537SjsUlj8SGKX5LAytq7RICi+WwxAyNNnMn+MufJ3cx9V
BmL+WO5PF+aXfGKcCvBBa2Uc/mTbkjO+uTKhmwUdeTTgyllF4nSE//Ao5U02lPad
Pz6H3n69qApyt9k1DZfgf7F7guzp4e3J/Kfo/UsOTgc2OyBX3jLLeVOc5CN8EQXk
4RK+4+VbqCh7iEQsfRnZPopFM/GDffnKq+wY9VwaS8l9iEyvXz8QW5/rBouu1+La
ESWryqQ3++fEloOeWeAmQbct9Ikk9hfjf0vk5CUkaNAljVoZkl0f0q/lWA3XqUqE
LAJpBWDkZd/N8mp76gVCiHCmMUmJLYuDkNHWLbOlAoSzmMnaY18=
=G2gG
-----END PGP SIGNATURE-----

--gd5km4os56rsu45y--
