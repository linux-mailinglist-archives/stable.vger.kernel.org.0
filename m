Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47454AD05F
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 05:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiBHEbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 23:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346500AbiBHEbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 23:31:20 -0500
X-Greylist: delayed 177 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 20:31:19 PST
Received: from condef-05.nifty.com (condef-05.nifty.com [202.248.20.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490BFC0401EE
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 20:31:19 -0800 (PST)
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-05.nifty.com with ESMTP id 2184OdOJ029910
        for <stable@vger.kernel.org>; Tue, 8 Feb 2022 13:24:39 +0900
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 2184O8tY026277;
        Tue, 8 Feb 2022 13:24:09 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 2184O8tY026277
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1644294249;
        bh=19uR+JQrTDSNjb/M+uvq075l3b28UXxtfZ5ZKrtYtzw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k640Df3SrCi6fK+IspeoU5KOGEeWwlg3V0VARZ5jpH+hr622BV+dar0DE7tkD4ftM
         Nl8bp7u1erlyxLSu7DOS28i/BOL9BBocT+yIqqO7x9ZpcSkjsj+n9yvxR4KvIayebH
         8CvETzc3aKM1ewcrZCpzZ5q3npOMgarvQjNQzmwWYbLHbozp/qZbEIQP8kVXptxpts
         YzYU6N2O/jGo/3gqJdnr2ZkNdRl1cEtBqTBLLrtZIsfzqTvO7xvhq6S6y1SidE9aV4
         /LCU14Cc8LW50UKekJ/LMXcHcDbfM8FCjJDb6kxxozk8tZvjnq2yCERk2OTRQgr0Yd
         L7TBqmYiSvgPA==
X-Nifty-SrcIP: [209.85.214.171]
Received: by mail-pl1-f171.google.com with SMTP id y7so7560887plp.2;
        Mon, 07 Feb 2022 20:24:09 -0800 (PST)
X-Gm-Message-State: AOAM531RgVJZ+A9WM1ZLG1XjKixD4UM5vQADJkBYYfHk6Qg/EnmBFXDI
        VVsGhGZIASjueIUHKlLrYEOujnWPK0/+QjUM4Lo=
X-Google-Smtp-Source: ABdhPJz2z9KXlrVLO5E7bA267/kU9GqMyolRq34mQQWWV79UiH2n6X5+/PWBXovs/xUvLsayHJ/bKqkNLxzPi6m7E1k=
X-Received: by 2002:a17:902:6948:: with SMTP id k8mr2866496plt.136.1644294248161;
 Mon, 07 Feb 2022 20:24:08 -0800 (PST)
MIME-Version: 1.0
References: <20220202230515.2931333-1-nathan@kernel.org> <CAKwvOdkQ__2A3NohrcJgF+JABSDnSyEKzD97qVa4cpM==GPONQ@mail.gmail.com>
In-Reply-To: <CAKwvOdkQ__2A3NohrcJgF+JABSDnSyEKzD97qVa4cpM==GPONQ@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 8 Feb 2022 13:23:32 +0900
X-Gmail-Original-Message-ID: <CAK7LNASCGbLWkDXYqyCf08sFHjGqvqSgmFsJ741MHGSKzkifLg@mail.gmail.com>
Message-ID: <CAK7LNASCGbLWkDXYqyCf08sFHjGqvqSgmFsJ741MHGSKzkifLg@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile.extrawarn: Move -Wunaligned-access to W=1
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 3, 2022 at 8:12 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 3:07 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > -Wunaligned-access is a new warning in clang that is default enabled for
> > arm and arm64 under certain circumstances within the clang frontend (see
> > LLVM commit below). On v5.17-rc2, an ARCH=arm allmodconfig build shows
> > 1284 total/70 unique instances of this warning (most of the instances
> > are in header files), which is quite noisy.
> >
> > To keep a normal build green through CONFIG_WERROR, only show this
> > warning with W=1, which will allow automated build systems to catch new
> > instances of the warning so that the total number can be driven down to
> > zero eventually since catching unaligned accesses at compile time would
> > be generally useful.
> >
> > Cc: stable@vger.kernel.org
> > Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1569
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1576
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> Thanks to you and Arnd for working out whether this is important to
> pursue. Sounds like it is.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> > ---


I assume this should be considered as a bug fix
to avoid the error for the combination of CONFIG_WERROR=y
and the latest Clang.

Applied to linux-kbuild/fixes.
Thanks.



> >
> > v1 -> v2: https://lore.kernel.org/r/20220201232229.2992968-1-nathan@kernel.org/
> >
> > * Move to W=1 instead of W=2 so that new instances are caught (Arnd).
> > * Add links to the ClangBuiltLinux issue tracker.
> >
> >  scripts/Makefile.extrawarn | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> > index d53825503874..8be892887d71 100644
> > --- a/scripts/Makefile.extrawarn
> > +++ b/scripts/Makefile.extrawarn
> > @@ -51,6 +51,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
> >  KBUILD_CFLAGS += -Wno-format-zero-length
> >  KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
> >  KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
> > +KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
> >  endif
> >
> >  endif
> >
> > base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
> > --
> > 2.35.1
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers



-- 
Best Regards
Masahiro Yamada
