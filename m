Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978656E5F08
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjDRKkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjDRKj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:39:59 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE987D99
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 03:39:57 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AB3B35C00BF;
        Tue, 18 Apr 2023 06:39:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 18 Apr 2023 06:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681814394; x=1681900794; bh=S6
        nFtPxVE8iEJoteN9MPimXAtcUtXbp9CTIgiYOiMKo=; b=Qzjl4BGKkhRr315JcJ
        APAs4ad6XqcFLYNc0RC8ow/ubbCx+vWlyebOL6UxrJERu6tuvmspVgVoQTEL4ipR
        Fzy59lX0xW4SDcETrgZc0PZYYJw1jT+EDW3TotOABkQf+myDvl1jszHygrxGIzOS
        W5DfHUGVzR8B1EkLXXOZp+0irWmyvvQsFYnO8/Msb/KvyePC5lhgtwmWVHuqDzze
        JSe+KrdYULXxCaP93X+L5itRnA+r7ir/sPnyZEHcupYSzXLQtd4GtY1JWX0JPoMR
        8Ybkas+BY3Rp8837luWCAPE30+5fByImWIRwlq+Qh84XaKRIsNsaBRFXEqYCsXFn
        IkRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681814394; x=1681900794; bh=S6nFtPxVE8iEJ
        oteN9MPimXAtcUtXbp9CTIgiYOiMKo=; b=SthNxDfW6PonAGIWtTUYEzHMIRSNI
        xJlEiqbDKoZJfHpb6l84bAhfVLhSBD97mElFtPqx07+uC/uk13BhkYuCicSrwJps
        O4HuYoR4QKxkZCV56fH6m8X7gqpxMaLM55teELCXh+LpgpurmKgnGDkgg7xTRyZH
        Ddvg7tDIiCTIYiXHSWlOPhWUmr9EkJPu1oaf8XsGosmKVjCjOedlQWJIHsQVrG4Z
        e3ziDq1ACBzpAM/i6xjRnSRI8HhqrqrdWLzioWD47YfhDUEtmiC+nYg6zj1V+lzm
        ryXKlxXeYj0ekiGdoIUECo14wz9Bj4jpxJqEVvCDrg17JRALWlHww5OBg==
X-ME-Sender: <xms:enM-ZK-ETr_HgmQKW_iPQAhX361tRQN-llCSoOocjF1J1KXz7k5bgw>
    <xme:enM-ZKvU7Vpc8XL4lvie2EbD0hHCzYY9phawrgGOjHDo9XSAcNPu4FSE7zBZAngPa
    ESDg9fTuuorQtspNg>
X-ME-Received: <xmr:enM-ZACHWbP4UtVEKs7-6l1gDlra0ixlJOoboUN_py31tUkIq1m2tZwp8vuCcPGdOQTQfse1SOZfe5RBNACe6bA0cN1RZjv03Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdelkedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomheptehlhihs
    shgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepve
    etvedvkeetveeggfeijeelveegfedvffdtveetueeiveehtdduffethfduieejnecuffho
    mhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:enM-ZCfnS4VGu5pdVzrufO9iug0Q-w1kYyH4UmzvndNKCfZQ2h3mWg>
    <xmx:enM-ZPM5Nhn_X3LrcN5w6Xam-vQ3u5FyphH-N5wafBsb1MHYQO1eXQ>
    <xmx:enM-ZMmaERthMEo6fVH-Dag9n6wnkA3J-W72_xWah5GLlJ8EvzrenA>
    <xmx:enM-ZKof1ep_DY7umzDS93PXCpDVlttUGrUeSXEJdpRUGEPqutLlRQ>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Apr 2023 06:39:53 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id F3DF23236; Tue, 18 Apr 2023 10:39:51 +0000 (UTC)
Date:   Tue, 18 Apr 2023 10:39:51 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: Patch "purgatory: fix disabling debug info" has been added to
 the 5.15-stable tree
Message-ID: <20230418103951.2b7kia6nb2zdeqje@x220>
References: <20230418012722.330253-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lts26yyqmxqncvoj"
Content-Disposition: inline
In-Reply-To: <20230418012722.330253-1-sashal@kernel.org>
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


--lts26yyqmxqncvoj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 17, 2023 at 09:27:22PM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
>
>     purgatory: fix disabling debug info
>
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>
> The filename of the patch is:
>      purgatory-fix-disabling-debug-info.patch
> and it can be found in the queue-5.15 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

There's no need for this patch on 5.15, as the regression it fixes was
only introduced in 6.0.  It won't do any harm though =E2=80=94 is it consid=
ered
good practice to keep the code in sync between stable kernels to make
backports of other patches easier?  If so, it would make sense to
backport after all.

> commit 618ea690941689fe28fa9c150f90bb096db5f8a5
> Author: Alyssa Ross <hi@alyssa.is>
> Date:   Sun Mar 26 18:21:21 2023 +0000
>
>     purgatory: fix disabling debug info
>
>     [ Upstream commit d83806c4c0cccc0d6d3c3581a11983a9c186a138 ]
>
>     Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
>     Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
>     -Wa versions of both of those if building with Clang and GNU as.  As a
>     result, debug info was being generated for the purgatory objects, even
>     though the intention was that it not be.
>
>     Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S fil=
es")
>     Signed-off-by: Alyssa Ross <hi@alyssa.is>
>     Cc: stable@vger.kernel.org
>     Acked-by: Nick Desaulniers <ndesaulniers@google.com>
>     Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 95ea17a9d20cb..1d6ccd4214d5a 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -64,8 +64,7 @@ CFLAGS_sha256.o			+=3D $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_string.o		+=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_string.o			+=3D $(PURGATORY_CFLAGS)
>
> -AFLAGS_REMOVE_setup-x86_$(BITS).o	+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o			+=3D -Wa,-gdwarf-2
> +asflags-remove-y		+=3D $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x=
))
>
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)

--lts26yyqmxqncvoj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQ+c3YACgkQ+dvtSFmy
ccD2ig//bx1Sp9jiWvlsrz9XqxehvKzZKLQwr02CUenWXIAeoVFY7eK+yrOEk5vS
5VOCo2o0iOzzdBo+BHNFDbkCJ4ypuRSUTMx1wnogYcFYHE1fiNltGa+Mdu2iei7s
GTAwkNqsuNOwyETJydkoAcDtsZtCf6/TqjNDdy45Hpcf+m1TegTsUq1QRh/ySwvn
s8RshN6VPLo/VIci4K5xjwiuERFP2MeMR2NRw7xkHlicU+FEmf+JqmZWFYtXAIfZ
dU+afjg5DbPJ0nvc83L5pGtzPfzI/XIgptwWCWsxYnDEWw91pt54/YiS6SyMW2or
ll6U1RIxztLvbgz4l9dXOPtHnq+Tpl85jsVQ3WVWqjR28wKnlFSORppRisOwDzP5
y8c/SCxTcwn9rzApS3sHfZjuyhoKD6Qj/oIUO3riPGQQsAq37tz7Ngq/0Fzj8xZH
Yf36hznhYt3PU3/u9qWnQtFMY0bCMSy98+RsGW3ag/sdxpRMZm2A4wvt0chMPsfu
VeKFv3MQIdIGYEk5HCLfePbjwpE+t09MwjddJGr0PlNBrzZsPcub65DmtuBJ8SIV
uwPNinoN65LccNgxyazVIVQ2sX/PfMZuJ9JWLH1/PDkTa75L7rsJAmgNaAN2JRCB
O8CqjK/MjTPWGOpnhsKa5Xyu0ulVzSDofgTvv7+2oRQqa6SBVK4=
=e+Uu
-----END PGP SIGNATURE-----

--lts26yyqmxqncvoj--
