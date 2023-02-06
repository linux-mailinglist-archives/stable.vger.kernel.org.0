Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB8768CAAE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 00:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBFXlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 18:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFXlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 18:41:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1D62B295
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 15:41:17 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j1so7348671pjd.0
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 15:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cu0OFN8qZCYWAqVWMqFlj99/Zkr5M5+Eb6c07HRobgk=;
        b=X6O8KDVvbqMZvTq/dBZU/owDSJ8rL1va66hKecrnPQWO7NbZM9JZH8Ff/Kgp+8XR0h
         PYt06fY/twQ70b2B5OciSQ8Ux5zQk8addCp1zwAR7cPUZ6SWWHzhljSi58TNzatHnfol
         Nw0cL+/FeO5Zk1/pmkV2h5fDPZdIjoE9S3+kx/dy5qduoM1n6rDy2H4yiCv5UYABLcXL
         Qw1LbBH5z9Dv1M/TyXGJpC3wEbIASbTpvdDww3AN/Mp0Ls5TE0f+r5rWFT0hA8ZMtu38
         61NC8HORindS8z+Ya0AVJtBOUm6nbeuWTrtKUzw3Ahn2yR6TUWreNfWA1cLUKG9Qs6nY
         THCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cu0OFN8qZCYWAqVWMqFlj99/Zkr5M5+Eb6c07HRobgk=;
        b=z28ufBc1Wl8BomjcjlgAkE7lRqxZe82bm9/lR43VowzKzcecuZYD4N9gUPHUe4JwxP
         cjA2mipeGpOD5rUNu4yK0rxCEFy4yJG4w32CFhxK3Er/RsyBH3WQ470VtHsOl69e72yq
         FNTpQoFpY11IG+p5LNhO8XiWUsXDUycb7rv7c/1o6ifQxaDf9epoVCe2wzmUmpgC8JMM
         jVh19bbIHbFPk9hpBeCVbEQeAhLCQjVmKQcnzMbQOb+MIqbfO8NUIW/jWi7z7OWTCprr
         QG0WgAkNGOtOzAbRwfEtl72TCm1j+wxdiljwpTKReKcPipIzxoTush2mS9lYuDISgKg4
         6erA==
X-Gm-Message-State: AO0yUKVSmVLN6Rl1uBC2uZSrA0UVag4bZpzbpkVxpAKO/n0XM76YKZyH
        N4P6sttJMKhxfSu/kGZ7EE15F4fw9IiPvz+0QDShhQ==
X-Google-Smtp-Source: AK7set9uOOMShrxA48+C1j7fFNaTfn5dhIRadvFGX40qhOjytovXu9agQpf1EsZBGE57vO7ZYGhygwi7iKDB+HEsXBo=
X-Received: by 2002:a17:902:b7c9:b0:196:7127:2240 with SMTP id
 v9-20020a170902b7c900b0019671272240mr173745plz.11.1675726877236; Mon, 06 Feb
 2023 15:41:17 -0800 (PST)
MIME-Version: 1.0
References: <20230203194201.92015-1-ebiggers@kernel.org> <63deacb1.170a0220.f078.6779@mx.google.com>
In-Reply-To: <63deacb1.170a0220.f078.6779@mx.google.com>
From:   Fangrui Song <maskray@google.com>
Date:   Mon, 6 Feb 2023 15:41:05 -0800
Message-ID: <CAFP8O3Kwa2V7GvJPEbr87o6hMi8i2JquWniFOaiFR3nv9pGc_g@mail.gmail.com>
Subject: Re: [PATCH] randstruct: temporarily disable clang support
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 4, 2023 at 11:06 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Feb 03, 2023 at 11:42:01AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Randstruct with clang is currently unsafe to use in any clang release
> > that supports it, due to a clang bug that is causing miscompilations:
> > "-frandomize-layout-seed inconsistently randomizes all-function-pointer=
s
> > structs" (https://github.com/llvm/llvm-project/issues/60349).  Disable
> > it temporarily until the bug is fixed and the fix is released in a clan=
g
> > version that can be checked for.
> >
> > Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  security/Kconfig.hardening | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> > index 53baa95cb644..aad16187148c 100644
> > --- a/security/Kconfig.hardening
> > +++ b/security/Kconfig.hardening
> > @@ -280,7 +280,8 @@ config ZERO_CALL_USED_REGS
> >  endmenu
> >
> >  config CC_HAS_RANDSTRUCT
> > -     def_bool $(cc-option,-frandomize-layout-seed-file=3D/dev/null)
> > +     # Temporarily disabled due to https://github.com/llvm/llvm-projec=
t/issues/60349
> > +     def_bool n
> >
> >  choice
> >       prompt "Randomize layout of sensitive kernel structures"
> >
> > base-commit: 7b753a909f426f2789d9db6f357c3d59180a9354
> > --
> > 2.39.1
>
> This should be fixed with greater precision -- i.e. this is nearly fixed
> in Clang now, and is likely to be backported. So I think we'll need
> versioned checks here.
>
> --
> Kees Cook
>

Bill has requested cherry-pick the llvm-project fix into the
release/16.x branch [1].
https://github.com/llvm/llvm-project-release-prs/pull/276
It may take one day to land.

[1]: https://github.com/llvm/llvm-project/tree/release/16.x

--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
