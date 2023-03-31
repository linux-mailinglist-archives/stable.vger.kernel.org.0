Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C7B6D296A
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjCaU13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 16:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCaU12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 16:27:28 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9FF1A473;
        Fri, 31 Mar 2023 13:27:25 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id A134F320093C;
        Fri, 31 Mar 2023 16:27:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 31 Mar 2023 16:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1680294440; x=1680380840; bh=2K
        aDfnSCtOWrHyBu2V1/Tu+MXWIzeMCyWkOEPXXvaWk=; b=Ag5zGN9HSqPjMK4d+J
        SRuD/Aofhi3GL1NozAFav0isdGswvhAsuTvf9WXQjyVKxhuTHAPkJ5i/SvIKrMK/
        I9qeI/57PTOYFuXw1AmV5R3IlgSc/NULBuSC1OxgnR7yScwLmjQSd3vMeFpk8fMr
        xkHvFtgcDWyN8RalB8dpO2GWgb/VNc7MFi36Mcj5Dfd9+Zb1AjnpCI/m6IaUOzay
        5jBHMcFLOBmqTXzxMPHFoDlB14+O7iuOornUqUYpbKGJ57i0ESxKE2qI6nV4Wgs9
        6sp2atONQadMr/fc98sW36Pu/nVqfcXJdc57usGJZR5RWcvCEY2wzM/OA2krp2/7
        4Veg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680294440; x=1680380840; bh=2KaDfnSCtOWrH
        yBu2V1/Tu+MXWIzeMCyWkOEPXXvaWk=; b=fg10GJqfHss8Y4g1bY36F2aDEtYTi
        L742C5MmvJffl5sJ92cltSCkfrrNCe8uDuV/vHYcT75ZTT7p4stCwKPAzkyhe52F
        YpdbhOQCehgSFxOZOv6wIukj6ryNcNz6jyk4YIv3ISrcd3sGXOB/ZGx5kLTGxuEK
        +swhhMrj/vRQKiCyPFJs85Qfy3HjMSvBQ67+9scaJWklXZRh7cP+AKmSsmBAaB/2
        YHvfmBn/eCWM8F2WOYlxt+16cbDf8PNQY9ZnPXrr8DcghZf7pdIKWAJa576jwFk7
        aXCF8ubT6tE73SucJVKZDkW7rHWyssawSLzlq5LGOg37m/5aRhuDTANjg==
X-ME-Sender: <xms:J0InZAPLQO0KWnEOCP-3GcptVAT08wX26Jh7xrtEbAiLttsSCcknkA>
    <xme:J0InZG8-tUOug5IKHBWMmCPic9XGsUmf5gLpNO3QaMviw_izDUaVnTQb37L9UrpHJ
    wvFMTTGdQdPn5fVhQ>
X-ME-Received: <xmr:J0InZHSn93Ek-YysWXC_I_AROdjuJoOA2Ohkda_HiLHKY3JvtpWyai0LC8IM97etGSNnkp9sK2kOcX3RxzyTnhebYGNTrXuHVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiuddgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeetlhih
    shhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpe
    egjeeigeejhffgffehueeludevhfeiffefudegvdegudfhudejheefhfeugfeghfenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhihesrghlhi
    hsshgrrdhish
X-ME-Proxy: <xmx:J0InZIvwt0KcRCWd6HWcpIOqUUwob02rP7b2N5LjRs4jAMHtzaA0yg>
    <xmx:J0InZIcR1jDsKNWi-fHf9UNTVv4QSIFKmBFcM-xiEnWJrHgC_SujAg>
    <xmx:J0InZM1cP9r8YKs_NuGHideaTAJXAJLCwURTCdg6eaJvqxhXxKqybw>
    <xmx:KEInZHCZhvt-BdM-NL_5v8GNpyZPkhbet07f0zLPijisZxryCHFN1w>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Mar 2023 16:27:18 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 47FB924C6; Fri, 31 Mar 2023 20:27:16 +0000 (UTC)
Date:   Fri, 31 Mar 2023 20:27:16 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nathan Chancellor <nathan@kernel.org>, Nick Cao <nickcao@nichi.co>,
        linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-riscv@lists.infradead.org, Tom Rix <trix@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] purgatory: fix disabling debug info
Message-ID: <20230331202716.mvny65ybaat3wsmm@x220>
References: <20230330182223.181775-1-hi@alyssa.is>
 <20230330222928.GA644044@dev-arch.thelio-3990X>
 <CAK7LNARU444UrZXVodNftud-scy5KKUjdtTM0GOrxHB9pyKmkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="axvolp336zjbpvuu"
Content-Disposition: inline
In-Reply-To: <CAK7LNARU444UrZXVodNftud-scy5KKUjdtTM0GOrxHB9pyKmkg@mail.gmail.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--axvolp336zjbpvuu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 01, 2023 at 12:42:13AM +0900, Masahiro Yamada wrote:
> On Fri, Mar 31, 2023 at 7:29=E2=80=AFAM Nathan Chancellor <nathan@kernel.=
org> wrote:
> >
> > On Thu, Mar 30, 2023 at 06:22:24PM +0000, Alyssa Ross wrote:
> > > Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> > > Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> > > -Wa versions of both of those if building with Clang and GNU as.  As a
> > > result, debug info was being generated for the purgatory objects, even
> > > though the intention was that it not be.
> > >
> > > Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S fil=
es")
> > > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > > Cc: stable@vger.kernel.org
> > > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> >
> > This is definitely more future proof.
> >
> > Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
>
>
>
> I prefer v3 since it is cleaner, but unfortunately
> it does not work for Clang+GAS.
>
>
> With v3 applied, I still see the debug info.
>
>
>
> $ make LLVM=3D1 LLVM_IAS=3D0  arch/x86/purgatory/setup-x86_64.o
>   UPD     include/config/kernel.release
>   UPD     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   DESCEND objtool
>   INSTALL libsubcmd_headers
>   AS      arch/x86/purgatory/setup-x86_64.o
> $ readelf -S arch/x86/purgatory/setup-x86_64.o
> There are 18 section headers, starting at offset 0x14d8:
>
> Section Headers:
>   [Nr] Name              Type             Address           Offset
>        Size              EntSize          Flags  Link  Info  Align
>   [ 0]                   NULL             0000000000000000  00000000
>        0000000000000000  0000000000000000           0     0     0
>   [ 1] .text             PROGBITS         0000000000000000  00000040
>        0000000000000027  0000000000000000  AX       0     0     16
>   [ 2] .rela.text        RELA             0000000000000000  000012f8
>        0000000000000060  0000000000000018   I      15     1     8
>   [ 3] .data             PROGBITS         0000000000000000  00000067
>        0000000000000000  0000000000000000  WA       0     0     1
>   [ 4] .bss              NOBITS           0000000000000000  00001000
>        0000000000001000  0000000000000000  WA       0     0     4096
>   [ 5] .rodata           PROGBITS         0000000000000000  00001000
>        0000000000000020  0000000000000000   A       0     0     16
>   [ 6] .rela.rodata      RELA             0000000000000000  00001358
>        0000000000000018  0000000000000018   I      15     5     8
>   [ 7] .debug_line       PROGBITS         0000000000000000  00001020
>        000000000000005f  0000000000000000           0     0     1
>   [ 8] .rela.debug_line  RELA             0000000000000000  00001370
>        0000000000000018  0000000000000018   I      15     7     8
>   [ 9] .debug_info       PROGBITS         0000000000000000  0000107f
>        0000000000000027  0000000000000000           0     0     1
>   [10] .rela.debug_info  RELA             0000000000000000  00001388
>        0000000000000090  0000000000000018   I      15     9     8
>   [11] .debug_abbrev     PROGBITS         0000000000000000  000010a6
>        0000000000000014  0000000000000000           0     0     1
>   [12] .debug_aranges    PROGBITS         0000000000000000  000010c0
>        0000000000000030  0000000000000000           0     0     16
>   [13] .rela.debug_[...] RELA             0000000000000000  00001418
>        0000000000000030  0000000000000018   I      15    12     8
>   [14] .debug_str        PROGBITS         0000000000000000  000010f0
>        0000000000000054  0000000000000001  MS       0     0     1
>   [15] .symtab           SYMTAB           0000000000000000  00001148
>        0000000000000168  0000000000000018          16    12     8
>   [16] .strtab           STRTAB           0000000000000000  000012b0
>        0000000000000041  0000000000000000           0     0     1
>   [17] .shstrtab         STRTAB           0000000000000000  00001448
>        000000000000008d  0000000000000000           0     0     1
> Key to Flags:
>   W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
>   L (link order), O (extra OS processing required), G (group), T (TLS),
>   C (compressed), x (unknown), o (OS specific), E (exclude),
>   D (mbind), l (large), p (processor specific)
>
>
>
>
>
>
> With -g0 given, GCC stops passing -g -gdwarf-4 down to GAS.
>
>
> Clang does not do anything about -g0 for the external assembler.

You're right.  Thank you for your thoughtful testing =E2=80=94 I forgot to =
check
LLVM for v3.  I thought maybe adding -Wa,-g0 would be enough, but it
turns out that GAS doesn't support that.  If -g has been specified,
there doesn't seem to be any way to disable debug info again later in
the command line.

So we probably can't do better than v2 while LLVM_IAS=3D0 is supported.
The only other option I see is (untested):

asflags-y			+=3D -g0
asflags-remove-y		+=3D -Wa,-g -Wa,-gdwarf-4 -Wa,-gdwarf-5

But I don't like that option, because it means there are two completely
different ways of doing it depending on the compiler setup, and it makes
it even less likely anybody would remember to update asflags-remove-y
when DWARF 6 comes around or whatever.

> I was thinking of dropping LLVM_IAS=3D0 support.
> When we decide to give up -fno-integrated-as,
> we can clean up the code in various places.
>
>
> Anyway, v3 does not work in the current situation.
>
>
> V2 works for all usecases.
>
>
>
>
> --
> Best Regards
> Masahiro Yamada

--axvolp336zjbpvuu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQnQhsACgkQ+dvtSFmy
ccCgJg//Up2UwsM19Z7EQMr2CXFVXfpkdNdPwIbsFsakWJPwjEuK8BEjyOliDTMn
5o887uImSJut/XhOgX9uYxUUIK13gHjC5dUZX9Mf854ms67RqcPsSpBQGfwozcOK
m13N9Mfoqs6KG99zdiYQYfN5IGHotyf6u9HL03fWadH1DJf8iqRXBEx2+H1H+N8x
63ZKWfHope/vBtNS/SvATS8icIJWB99xzMy+N46eeICxqF9SMbECXVWBjXWNjSr9
brrQVbDOOQq/7enXtKHJOm+7FYAZRtbwwf48oNuK2PLW01QUQmti7JdiBujCrkUB
4wL3mlUrcRAn1Ui6YUjXxQTvoRduJHdXUV1MEI/u7d3v/UcPyxVlguFEnNzRbuhY
tyvTmc0Nq5R0zWMnbuCJuWUY1gvxi3Iyp57zrTN9GD8tY7BNhgKvkDNXLlu/f4tV
E3CKOpWVk3fSjMoImNbQmh9q6pJnJb/EU801H5duqE8O0++DeESLVWVnXRBz5kGw
tqkS74PvGbvFICkZLwKPrqJ0Dea16KA2KlhECczTt4nxTJ8BP7wMo1E0/D/UsakB
t6PlK6UwdiBn1WxQ8cW4T23FK6+3YxrwIFry/0Jrp9DRoiN0IxoEbKXvREAhSseS
gRxnmgn4Mk2jp/xxR5g1eZLW0510YtnZT0L1MeCFVUOSe0oG798=
=U0tH
-----END PGP SIGNATURE-----

--axvolp336zjbpvuu--
