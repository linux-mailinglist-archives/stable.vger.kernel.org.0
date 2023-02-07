Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533D468DF89
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjBGSBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbjBGSBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:01:45 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C045F37F04
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 10:01:33 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r8so16504675pls.2
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 10:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZduzSQedcfK0VkSdKK8LkGwE1Lav/aAuVJtPsAz85U=;
        b=OBxGFk75lDiGUlUvrFhIHJPcRAslCw/EEvSQNDBB5YCIzMHVA4EnksKV25d5GBa8T9
         dFS19YdvdlPngB22IpK6355pvCbZS88YSXZJn0ypE20zzdLdc3hFS7GLG9O2Oi6SBDZr
         iX8gB/ssqdae0nsogt7pu+1nXVASgEzoB3iba34bqufCITrZzBbSUG72BPS1U/xt4PMm
         ZvdfoPHZ8gwvGgVZ8ryLTePkyRraoiOf8yX2ucJpoHts2vqjlVXcdjCZI1HRRTIdUqEJ
         I07rC4JoFiNgx1KV8OsL+j5niabSt3T/7hR+ulfJikexep4XdQnX2OIPRZ7KcZnGiE4h
         yBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZduzSQedcfK0VkSdKK8LkGwE1Lav/aAuVJtPsAz85U=;
        b=1X7ujHhfN3UtTlS3zRPx6/embyPUvQf1Ovo5hLchEzIT2bof1BnfFrlwWBjJm2RSW+
         +iV7rhB8v3eQd5e6AOX9rHQtacf+DQRu+/oyiQ7VFvVDPX8EoVUPTZh+F/I/M8phFT7Q
         s6o/UZpmuoW0Tf2YmY5U5J8ctG4uy3//xLtswm4T8bCvxaVX7UbudUilWGgBVEM7HeHp
         fYnxxY0nn61Dq3mPMdJi8xa3iZoWDTZV7NJeVEKUUdoba+35noabU7c7TXdKAuNjsL6I
         4VUQh3abgX2BIRldsQeZJjo60DSDZZOoD7BG7ILDHoTKKtHp48lDzXr3uwTEyd+L+O5C
         A6PQ==
X-Gm-Message-State: AO0yUKVtA01kqFJKkZM7bAAquiBo7Fwzj6bLppyH7gRmIXJv4kvFuElB
        tpjKyTlKJo1mjRS9YcmYpMbEnUTF1IxW240WzEv5eQ==
X-Google-Smtp-Source: AK7set/5/7deqTUQyO/sBNCbUgkmz7QmmOIK18S7lNp32mxnhOYV8HOSgp8+KUAArWSXjr58XkSfzZwy3swzWUzfUDI=
X-Received: by 2002:a17:903:555:b0:196:14ea:d3c6 with SMTP id
 jo21-20020a170903055500b0019614ead3c6mr923273plb.20.1675792892586; Tue, 07
 Feb 2023 10:01:32 -0800 (PST)
MIME-Version: 1.0
References: <20230203194201.92015-1-ebiggers@kernel.org> <63deacb1.170a0220.f078.6779@mx.google.com>
 <CAFP8O3Kwa2V7GvJPEbr87o6hMi8i2JquWniFOaiFR3nv9pGc_g@mail.gmail.com>
In-Reply-To: <CAFP8O3Kwa2V7GvJPEbr87o6hMi8i2JquWniFOaiFR3nv9pGc_g@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 7 Feb 2023 10:01:21 -0800
Message-ID: <CAKwvOdm8F_VcdegPGw3vPu+-H1Gyh0rqQWpf=+Yh9YAowVuWSA@mail.gmail.com>
Subject: Re: [PATCH] randstruct: temporarily disable clang support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 6, 2023 at 3:41 PM Fangrui Song <maskray@google.com> wrote:
>
> On Sat, Feb 4, 2023 at 11:06 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, Feb 03, 2023 at 11:42:01AM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Randstruct with clang is currently unsafe to use in any clang release
> > > that supports it, due to a clang bug that is causing miscompilations:
> > > "-frandomize-layout-seed inconsistently randomizes all-function-point=
ers
> > > structs" (https://github.com/llvm/llvm-project/issues/60349).  Disabl=
e
> > > it temporarily until the bug is fixed and the fix is released in a cl=
ang
> > > version that can be checked for.
> > >
> > > Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  security/Kconfig.hardening | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> > > index 53baa95cb644..aad16187148c 100644
> > > --- a/security/Kconfig.hardening
> > > +++ b/security/Kconfig.hardening
> > > @@ -280,7 +280,8 @@ config ZERO_CALL_USED_REGS
> > >  endmenu
> > >
> > >  config CC_HAS_RANDSTRUCT
> > > -     def_bool $(cc-option,-frandomize-layout-seed-file=3D/dev/null)
> > > +     # Temporarily disabled due to https://github.com/llvm/llvm-proj=
ect/issues/60349
> > > +     def_bool n
> > >
> > >  choice
> > >       prompt "Randomize layout of sensitive kernel structures"
> > >
> > > base-commit: 7b753a909f426f2789d9db6f357c3d59180a9354
> > > --
> > > 2.39.1
> >
> > This should be fixed with greater precision -- i.e. this is nearly fixe=
d
> > in Clang now, and is likely to be backported. So I think we'll need
> > versioned checks here.
> >
> > --
> > Kees Cook
> >
>
> Bill has requested cherry-pick the llvm-project fix into the
> release/16.x branch [1].
> https://github.com/llvm/llvm-project-release-prs/pull/276
> It may take one day to land.
>
> [1]: https://github.com/llvm/llvm-project/tree/release/16.x
>
> --
> =E5=AE=8B=E6=96=B9=E7=9D=BF
>

All landed; the version check should be for 16+. (And the link to the
issue report would be nice to retain).
--=20
Thanks,
~Nick Desaulniers
