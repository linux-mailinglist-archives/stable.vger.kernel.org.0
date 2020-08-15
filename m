Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0924525D
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgHOVpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgHOVpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:45:44 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626BDC03D1C6;
        Sat, 15 Aug 2020 14:10:07 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u63so11421791oie.5;
        Sat, 15 Aug 2020 14:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=YiKLZJugL5RJYSeoiMgi97mxBoh+Q6jTGSD7PLvnSOw=;
        b=fy89CnAcyDqTO8FQ9kx6MEk3xPkZ+70AFpWltcr89koDfHXWORds3qU5W+QLsJvkyQ
         3c6kIFMM6op7cMmVfnqSRHwnbGo7jzpkLTO4I/DcKlo5BtwY9S90vrqB79U3EZrJkZLp
         frHlpueWWCesRmupH/REb/4PRhv8jTgN1677kA6JXpPBL/aT384GFjxDX47C6VD6JG1n
         H35qMyPOSWKXgc6qYjPiGdZyF+jKvjLpIK1GXH37CkW4qeMugUkM5yvWaTKM3N6w0Sr7
         ZO9AkAGqL460KfUEVy+b8zvDFQjn0qTeJaJ+wMB8ctO9D1VlosMrBXEuSy+UorRJoo3K
         VE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=YiKLZJugL5RJYSeoiMgi97mxBoh+Q6jTGSD7PLvnSOw=;
        b=bbqzQ0vuO+upl+XEGFBnq8ZOPyJ+W67bmjFjYxzBgZbMC6f9t5xy9eLJCa66Mgu5at
         xT/+RwCjXaunTlqyx5n0jyrjsaRfJCFxmcBQ0bUWWVgp37NobbdozCbypxaoOa8V/7Kz
         BRnirC6K+K3ujLj1h7i24KU7TAtB2LngN6SqEfyXmCX8HLGz3ahKRm4Gk1deW2DfuP6w
         AmE28E7y1OU9KYcPyo5Djm8Z424wz6s7eNjajgk413xjH8G4QlpJNGm4HRUUej+jTNMV
         UmbAKjpH+HGhdS27cWed9WuvjVkToygdhV9LI95i+NUdeohXNnP3P93p6gPvOhwmTKjH
         xKww==
X-Gm-Message-State: AOAM530d1oXOsD+Emm9YsPdLAM31CmX/xLdlNDSQvRnVZ+NZBIxJTHce
        +Z+VZNZoPAALmN7NxDReIyd/Z6aTQMdBOw4RmLo=
X-Google-Smtp-Source: ABdhPJwivhEkoC6LPXf1+oC7ZJdzValcCd0jlUao03MJvRh7rRZqySTJsKKeOtBq490Lpnk/w/f+/dQfI5hf3FFGDmM=
X-Received: by 2002:a05:6808:311:: with SMTP id i17mr5555813oie.72.1597525806479;
 Sat, 15 Aug 2020 14:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200812004158.GA1447296@rani.riverdale.lan> <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com> <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
In-Reply-To: <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 15 Aug 2020 23:09:54 +0200
Message-ID: <CA+icZUXhPakmkVOEHOq7FON+3ETRNN8DHEiRws-BJaAUad4hOg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
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

On Sat, Aug 15, 2020 at 10:57 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Hi Ingo,
> I saw you picked up Arvind's other series into x86/boot.  Would you
> mind please including this, as well?  Our CI is quite red for x86...
>
> EOM
>

+1

- Sedat -

> On Sat, Aug 15, 2020 at 8:49 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Wed, Aug 12, 2020 at 2:43 AM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > >
> > > The x86-64 psABI [0] specifies special relocation types
> > > (R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
> > > Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
> > > can take advantage of for optimization (relaxation) at link time. This
> > > is supported by LLD and binutils versions 2.26 onwards.
> > >
> > > The compressed kernel is position-independent code, however, when using
> > > LLD or binutils versions before 2.27, it must be linked without the -pie
> > > option. In this case, the linker may optimize certain instructions into
> > > a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.
> > >
> > > This potential issue has been present with LLD and binutils-2.26 for a
> > > long time, but it has never manifested itself before now:
> > > - LLD and binutils-2.26 only relax
> > >         movq    foo@GOTPCREL(%rip), %reg
> > >   to
> > >         leaq    foo(%rip), %reg
> > >   which is still position-independent, rather than
> > >         mov     $foo, %reg
> > >   which is permitted by the psABI when -pie is not enabled.
> > > - gcc happens to only generate GOTPCREL relocations on mov instructions.
> > > - clang does generate GOTPCREL relocations on non-mov instructions, but
> > >   when building the compressed kernel, it uses its integrated assembler
> > >   (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
> > >   which has so far defaulted to not generating the GOTPCRELX
> > >   relocations.
> > >
> > > Nick Desaulniers reports [1,2]:
> > >   A recent change [3] to a default value of configuration variable
> > >   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
> > >   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
> > >   relocations. LLD will relax instructions with these relocations based
> > >   on whether the image is being linked as position independent or not.
> > >   When not, then LLD will relax these instructions to use absolute
> > >   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
> > >   Clang and linked with LLD to fail to boot.
> > >
> > > Patch series [4] is a solution to allow the compressed kernel to be
> > > linked with -pie unconditionally, but even if merged is unlikely to be
> > > backported. As a simple solution that can be applied to stable as well,
> > > prevent the assembler from generating the relaxed relocation types using
> > > the -mrelax-relocations=no option. For ease of backporting, do this
> > > unconditionally.
> > >
> > > [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> > > [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> > > [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> > > [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> > > [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
> > >
> > > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> >
> > Thanks for the patch.
> >
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >
> > - Sedat -
> >
> > [1] https://github.com/ClangBuiltLinux/linux/issues/1120#issuecomment-674409705
> >
> > > ---
> > >  arch/x86/boot/compressed/Makefile | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> > > index 3962f592633d..ff7894f39e0e 100644
> > > --- a/arch/x86/boot/compressed/Makefile
> > > +++ b/arch/x86/boot/compressed/Makefile
> > > @@ -43,6 +43,8 @@ KBUILD_CFLAGS += -Wno-pointer-sign
> > >  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
> > >  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
> > >  KBUILD_CFLAGS += -D__DISABLE_EXPORTS
> > > +# Disable relocation relaxation in case the link is not PIE.
> > > +KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
> > >
> > >  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
> > >  GCOV_PROFILE := n
> > > --
> > > 2.26.2
> > >
> > > --
> > > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200812004308.1448603-1-nivedita%40alum.mit.edu.
>
>
>
> --
> Thanks,
> ~Nick Desaulniers
