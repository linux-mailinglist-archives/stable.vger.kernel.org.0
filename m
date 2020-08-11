Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4F42422ED
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgHKXvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 19:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgHKXvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 19:51:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD26C06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 16:51:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c10so2138161pjn.1
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 16:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1qDjAS8ZPDC4LMj3s+e938rgxLp1azn8ZYiupGKT1A=;
        b=LSyGz2XPxyFM3a7EELo0+9cZruahgSS3Xdj43kI3SsqFLqLvmHR+4jQZUM4MlywVGs
         ejzocF7Unh99hy/ZX0lwkFBotZ5g2ke1cdra15udZNChK/2h4QNfEjKvQcJeh4JHuWq8
         YuOyhdvE4oeumVeErrDAroO4irfdR/E7I1U4J2oNcLp/qv4kO7d0TJ7wi57BuLY8vjnp
         ExLi2Vt3JYjlRDAGLR27Bi4ACwfIa1FcbEGIZ5zE1/eLOykhF3762DP/UR/2MhQtcVt6
         bGEgyDKsoVooUyMnrRKxG1v8lf0B4h7lrl4Bu13FAQzlaulBqSLNvrmDn16yd7UkimTi
         SsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1qDjAS8ZPDC4LMj3s+e938rgxLp1azn8ZYiupGKT1A=;
        b=Ew/uHT9XhPUZ4uh8e4zAEFml8rwhVUE4OqmlRmtxC/QPehOHgMkgcLijlgJYUctj3f
         wmqp1yPZR4jhvSXzGkhqcME5w4sU8t6bwvYMY7ZLTr7eVDcYVQ2PGlkVZBJHy+ylcD9u
         lym16Ks3HUanGc8vnIeNVc76/W0uGRFTBjdf2sDvlekXUPhy4tw0xgbzcvXLo106KzXM
         TH3wgJ4AI+yFfD3OoJWnmKo0/50Qsh6Pa85rDf3xvym7qbB7hEctbYV6Z8H+Kw3PERj3
         l//PP9ZMEdN5dGDTQL0Hn2ebdB0g1gGFaAGAIMdv0gPz9hkPPB/7PfTPgpWko9t//b8k
         BdoA==
X-Gm-Message-State: AOAM5330ki8n4pp5y5SzF2Rd0HBmoIME2LTmHZGRbqaZR/akkIBicpqS
        niKj4gOjPgkZBN3yMQIP3RIgBEeco/jdv3zmxztKiw==
X-Google-Smtp-Source: ABdhPJwl83TdiqH7Wf9zH5IsdOJlr3YTPMp4gMXBUvmqE89/OQjI2H/fChrF0Q4OLTWIubwlBnkHEKn+nnBFdiEVr+A=
X-Received: by 2002:a17:90a:fc98:: with SMTP id ci24mr3603977pjb.101.1597189895220;
 Tue, 11 Aug 2020 16:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
 <20200811173655.1162093-1-nivedita@alum.mit.edu> <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
 <20200811224436.GA1302731@rani.riverdale.lan> <CAKwvOdnvyVapAJBchivu8SxoQriKEu1bAimm8688EH=uq5YMqA@mail.gmail.com>
 <20200811234340.GA1318440@rani.riverdale.lan>
In-Reply-To: <20200811234340.GA1318440@rani.riverdale.lan>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 11 Aug 2020 16:51:23 -0700
Message-ID: <CAKwvOdn5gCjcAVHZ3jHU+q=mD5rmFAHpEyHyLf7ixtdaQ3Z-PQ@mail.gmail.com>
Subject: Re: [PATCH] x86/boot/compressed: Disable relocation relaxation for
 non-pie link
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 4:43 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Tue, Aug 11, 2020 at 04:04:40PM -0700, Nick Desaulniers wrote:
> > On Tue, Aug 11, 2020 at 3:44 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > >
> > > On Tue, Aug 11, 2020 at 10:58:40AM -0700, Nick Desaulniers wrote:
> > > > > Cc: stable@vger.kernel.org # 4.19.x
> > > >
> > > > Thanks Arvind, good write up.  Just curious about this stable tag, how
> > > > come you picked 4.19?  I can see boot failures in our CI for x86+LLD
> > > > back to 4.9.  Can we amend that tag to use `# 4.9`? I'd be happy to
> > > > help submit backports should they fail to apply cleanly.
> > > > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/179237488
> > > >
> > >
> > > 4.19 renamed LDFLAGS to KBUILD_LDFLAGS. For 4.4, 4.9 and 4.14 the patch
> > > needs to be modified, KBUILD_LDFLAGS -> LDFLAGS, so I figured we should
> > > submit backports separately. For 4.19 onwards, it should apply without
> > > changes I think.
> >
> > Cool, sounds good.  I'll keep an eye out for when stable goes to pick this up.
> >
> > tglx, Ingo, BP, can we pretty please get this in tip/urgent for
> > inclusion into 5.9?
> > --
> > Thanks,
> > ~Nick Desaulniers
>
> Another alternative is to just do this unconditionally instead of even
> checking for the -pie flag. None of the GOTPCRELs are in the
> decompressor, so they shouldn't be performance-sensitive at all.
>
> It still wouldn't apply cleanly to all the stable versions, but
> backporting would be even simpler.
>
> What do you think?
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 3962f592633d..10c2ba59d192 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -43,6 +43,7 @@ KBUILD_CFLAGS += -Wno-pointer-sign
>  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
>  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  KBUILD_CFLAGS += -D__DISABLE_EXPORTS
> +KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)

We'd still want it for KBUILD_AFLAGS, too, just to be safe. Maybe a
one line comment to the effect of `# remove me once we can link as
-pie` would help us rip off this band-aid in the future?  It's more
obvious that the added hunk can be reverted once -pie linkage is
achieved with the current patch; either are fine by me.  Thanks!

>
>  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  GCOV_PROFILE := n



-- 
Thanks,
~Nick Desaulniers
