Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100DD8C22C
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 22:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfHMUht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 16:37:49 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36465 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHMUht (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 16:37:49 -0400
Received: by mail-oi1-f196.google.com with SMTP id c15so14339382oic.3
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 13:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=byKhMu7iE8sv5znVqQ+3U3iaujQGk/7iMUq2QIwzgr4=;
        b=pe3QXrRG355WUHshDx+O9l0HshWgWRBTjwww/lawR4OIJFamXhnhQMQ/oerD0Mvlsy
         U/n2X0bRCIwL63suBNXXdvDc8AshozgKok6QiQLdhvMwqmiuJKY7vNcMeTRUqsIr3vcw
         rWyQBfVxbO/SQv+h2FO4i+jFYwmvWYLYxDzYXHT+XOvxYhc0oyNocTf+XYo+eT6a1nV0
         o1VJAbcE4u8uBfjWeQ3BAMsfZPsfH2jSmx7zVdX+NTnrEm2sgUZaC6TtCSGLOZF0DaEh
         auHTQqWmXUWY4UPvDcsubZNFFFDTb9Sf1ClVWQvmt5HUDg8YB46nN54Iiz1ecpiDVbb5
         sH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=byKhMu7iE8sv5znVqQ+3U3iaujQGk/7iMUq2QIwzgr4=;
        b=NNyK4/OXaccnHYRXh85nIHnuHBDSCQT/EsejFdGVDL56M77SPO0JOcr57eVqa/WM2e
         TYETKrbT8ln/tmfstN7TRpf72wB0HlNlBIOamtd+UKUO4AC0kwv9yEUw0C/Gkf5yiGhS
         HLy59Z3kvvl/zTzCAuUj/l4/6LvmGYJoXPyP3LGmqbpGpcLhEKfFgIGPmgBXX3ims+CF
         hmMMZBRkFYQuVZ35+esOufT3zCFsOlxzxBfNv+U5eM4klipGCaZBzSdlGSIXgk4nUkG+
         vtiwQRsqanZpEfTygwZUBFBVhKvF3oZN71NdtmrEjxh6PGhfcqTQEQge0g2uyE1UDNaX
         yYwA==
X-Gm-Message-State: APjAAAXcJ23U5d8oIkP2TQJi7O7A3LQ83c8WjplKI2rPlR88N5sMB4ZL
        JcF7biMN2suOOzt/BUmFq99df+NGJXfiaq5Oh/WEZw==
X-Google-Smtp-Source: APXvYqyxgZE2/EkiwSgNnGO/ak0uX3DZUx9k0hSLBIUKkYTKcyc87QWhx34Q49YC3XOWMhUowIf21+mIZGu703ltZU4=
X-Received: by 2002:a02:a503:: with SMTP id e3mr24804929jam.134.1565728667894;
 Tue, 13 Aug 2019 13:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <15657216291284@kroah.com> <CAKwvOd=GC4NmRFsYFxUDfy4aP1ZXAUZcOnqF7zg26B9rs7yvGQ@mail.gmail.com>
In-Reply-To: <CAKwvOd=GC4NmRFsYFxUDfy4aP1ZXAUZcOnqF7zg26B9rs7yvGQ@mail.gmail.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Tue, 13 Aug 2019 13:37:36 -0700
Message-ID: <CAMVonLj+YQyx2U8FEO+vsiTy+Kr=BNkZ+kNg1nP9WMf0Qz2b0Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] x86/purgatory: Use CFLAGS_REMOVE rather
 than reset" failed to apply to 4.9-stable tree
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 1:30 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Hi Vaibhav,
> What LTS kernel are you basing your distro off of?  IIRC, 4.19, or was
> it further back?
>
We are using 4.19.
> On Tue, Aug 13, 2019 at 11:40 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From b059f801a937d164e03b33c1848bb3dca67c0b04 Mon Sep 17 00:00:00 2001
> > From: Nick Desaulniers <ndesaulniers@google.com>
> > Date: Wed, 7 Aug 2019 15:15:33 -0700
> > Subject: [PATCH] x86/purgatory: Use CFLAGS_REMOVE rather than reset
> >  KBUILD_CFLAGS
> >
> > KBUILD_CFLAGS is very carefully built up in the top level Makefile,
> > particularly when cross compiling or using different build tools.
> > Resetting KBUILD_CFLAGS via := assignment is an antipattern.
> >
> > The comment above the reset mentions that -pg is problematic.  Other
> > Makefiles use `CFLAGS_REMOVE_file.o = $(CC_FLAGS_FTRACE)` when
> > CONFIG_FUNCTION_TRACER is set. Prefer that pattern to wiping out all of
> > the important KBUILD_CFLAGS then manually having to re-add them. Seems
> > also that __stack_chk_fail references are generated when using
> > CONFIG_STACKPROTECTOR or CONFIG_STACKPROTECTOR_STRONG.
> >
> > Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> > Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > Cc: stable@vger.kernel.org
> > Link: https://lkml.kernel.org/r/20190807221539.94583-2-ndesaulniers@google.com
> >
> > diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> > index 91ef244026d2..8901a1f89cf5 100644
> > --- a/arch/x86/purgatory/Makefile
> > +++ b/arch/x86/purgatory/Makefile
> > @@ -20,11 +20,34 @@ KCOV_INSTRUMENT := n
> >
> >  # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
> >  # in turn leaves some undefined symbols like __fentry__ in purgatory and not
> > -# sure how to relocate those. Like kexec-tools, use custom flags.
> > -
> > -KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
> > -KBUILD_CFLAGS += -m$(BITS)
> > -KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
> > +# sure how to relocate those.
> > +ifdef CONFIG_FUNCTION_TRACER
> > +CFLAGS_REMOVE_sha256.o         += $(CC_FLAGS_FTRACE)
> > +CFLAGS_REMOVE_purgatory.o      += $(CC_FLAGS_FTRACE)
> > +CFLAGS_REMOVE_string.o         += $(CC_FLAGS_FTRACE)
> > +CFLAGS_REMOVE_kexec-purgatory.o        += $(CC_FLAGS_FTRACE)
> > +endif
> > +
> > +ifdef CONFIG_STACKPROTECTOR
> > +CFLAGS_REMOVE_sha256.o         += -fstack-protector
> > +CFLAGS_REMOVE_purgatory.o      += -fstack-protector
> > +CFLAGS_REMOVE_string.o         += -fstack-protector
> > +CFLAGS_REMOVE_kexec-purgatory.o        += -fstack-protector
> > +endif
> > +
> > +ifdef CONFIG_STACKPROTECTOR_STRONG
> > +CFLAGS_REMOVE_sha256.o         += -fstack-protector-strong
> > +CFLAGS_REMOVE_purgatory.o      += -fstack-protector-strong
> > +CFLAGS_REMOVE_string.o         += -fstack-protector-strong
> > +CFLAGS_REMOVE_kexec-purgatory.o        += -fstack-protector-strong
> > +endif
> > +
> > +ifdef CONFIG_RETPOLINE
> > +CFLAGS_REMOVE_sha256.o         += $(RETPOLINE_CFLAGS)
> > +CFLAGS_REMOVE_purgatory.o      += $(RETPOLINE_CFLAGS)
> > +CFLAGS_REMOVE_string.o         += $(RETPOLINE_CFLAGS)
> > +CFLAGS_REMOVE_kexec-purgatory.o        += $(RETPOLINE_CFLAGS)
> > +endif
> >
> >  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
> >                 $(call if_changed,ld)
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
