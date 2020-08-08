Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606F123F5D1
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 03:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHHBnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 21:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHHBnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 21:43:32 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35092C061756;
        Fri,  7 Aug 2020 18:43:32 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 2so3417920qkf.10;
        Fri, 07 Aug 2020 18:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NeMTx5ad2H12Pv+IrkQPOiim237u3kUlwVWeiu51cS0=;
        b=QOuvOjIQJhIMpytXpSq3TMC4lNM5MBHoI8vZYRffUd51TB01fBRPXNmRthqpOuatYk
         SLIplZ3mxDOzQGSllvpaeSgXRqiEDfMENNWmxYSxGwpXpwBnJ+/6ZRqxY/yF74bTv04A
         1JOSOJhkhr4lAoIN3V1AkfGdRhOFslvYE3RfV36XWoErH9WtY3bw4WX32nN2l0+TbJqp
         7rlplxGLBmRsg7eemTB2COECA6Snl+w5DIBEGrVpTLWCjK3oAMfth7vGnJETV5W1FxtH
         jYK68EOesjd/JEverBJfOJZnyG0XPPtIMB+RRQ4iwQgJnpyOuaTdoIN9VYGaTEvGLSO5
         QLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NeMTx5ad2H12Pv+IrkQPOiim237u3kUlwVWeiu51cS0=;
        b=m32LASIXmvTKFPNwul4gGxUrafDVjhkKpjDNphngutMTAmiQqzY6q7tgtVgi20VWGA
         L2t7jUPuZIt2ERhzzGwzSfI01stV5g0xmN9kr/K6t+nNZD/cmLCv/gdw+QhDshhjStjK
         ZbvhNRcZ+DBiXCzp6lujwXrTjmS1uTX/MpXdBqSemfCRkyk6eorY3lf99x3NKf2MbyjO
         FB3Y1cjQrDVF7skVg0663Zjm7ynrk+Sh01p3QT7qcqtx1hrDCLkGymGkoAZ2YNz7Gcsq
         hCWdwYrLm62ddTFSDa7YzKB3iBtgJUbYtGPqy4f2HxBoc+dPZh+hXOyI8Bh3wbDlqoYs
         dBAA==
X-Gm-Message-State: AOAM531FEQqdA/bt+lDlssoZiVvx8zp/6EIclJYJj7VooMbbGWYKCbZ6
        xRqnt5aEX97AoM2+Xxrz1d4=
X-Google-Smtp-Source: ABdhPJyLrHEGAYXBmTWqrCyDqQATZplH/FFgvjgbLtLoexuagfgzWG1h3JzrFb+Kc9u5ntsSTbVQ/Q==
X-Received: by 2002:a37:9f13:: with SMTP id i19mr15547501qke.316.1596851010808;
        Fri, 07 Aug 2020 18:43:30 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id j31sm9699527qtb.63.2020.08.07.18.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 18:43:30 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 7 Aug 2020 21:43:27 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com, "# 3.4.x" <stable@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Dmitry Golovin <dima@golovin.in>,
        Marco Elver <elver@google.com>, Nick Terrell <terrelln@fb.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/boot: avoid relaxable symbols with Clang
Message-ID: <20200808014327.GA1925552@rani.riverdale.lan>
References: <20200807194100.3570838-1-ndesaulniers@google.com>
 <20200807212914.GB1454138@rani.riverdale.lan>
 <CAKwvOdmD1OMnYE55O+YUkAh+C4Der+2CqKd7JVzfr0+6hYx6jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKwvOdmD1OMnYE55O+YUkAh+C4Der+2CqKd7JVzfr0+6hYx6jw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 02:54:39PM -0700, Nick Desaulniers wrote:
> On Fri, Aug 7, 2020 at 2:29 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > On Fri, Aug 07, 2020 at 12:41:00PM -0700, Nick Desaulniers wrote:
> > > A recent change to a default value of configuration variable
> > > (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
> > > integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
> > > relocations. LLD will relax instructions with these relocations based on
> > > whether the image is being linked as position independent or not.  When
> > > not, then LLD will relax these instructions to use absolute addressing
> > > mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with Clang
> > > and linked with LLD to fail to boot.
> >
> > It could also cause kernels compiled with gcc and linked with LLD to
> > fail in the same way, no? The gcc/gas combination will generate the
> > relaxed relocations from I think gas-2.26 onward. Although the only
> > troublesome symbol in the case of gcc/gas is trampoline_32bit_src,
> > referenced from pgtable_64.c (gcc doesn't use a GOTPC reloc for _pgtable
> > etc).
> 
> Thanks for taking a look, and the feedback. I appreciate it!
> 
> $ gcc --version | head -n 1
> gcc (Debian 9.3.0-11) 9.3.0
> $ make -j71 clean defconfig bzImage
> $ llvm-readelf -r arch/x86/boot/compressed/*.o | grep -e
> R_X86_64_GOTPCRELX -e R_X86_64_REX_GOTPCRELX
> 0000000000000114  000000120000002a R_X86_64_REX_GOTPCRELX
> 0000000000000000 trampoline_32bit_src - 4
> $ llvm-readelf -r arch/x86/boot/compressed/vmlinux | grep -e
> R_X86_64_GOTPCRELX -e R_X86_64_REX_GOTPCRELX
> $
> 
> So it looks like yes.  I guess then we'd need to add a check for
> CONFIG_LD_IS_LLD and CONFIG_CC_IS_GCC and binutils version is 2.26+?
> I don't mind adding support for that combination, but I'd like to skip
> it in this patch for the sake of backporting something small to stable
> to get our CI green ASAP, since CONFIG_LD_IS_LLD probably doesn't
> exist for those stable branches, which will complicate the backport of
> such a patch.  So I'd do it in a follow up patch if we're cool with
> that?
> 

What if we did it only if we couldn't enable -pie, like the below patch?
I think this should cover all the cases without needing LD_IS_LLD
checks.

For BFD, the only case that should change is binutils-2.26, which
supports relaxations but not -z noreloc-overflow, and will now have
relax-relocations disabled. It currently works (with gcc) only because
the relaxation of
	movq foo@GOTPCREL(%rip), %reg
to
	movq $foo, %reg
in the non-pie case was only added in 2.27, which is also when -z
noreloc-overflow was added, allowing -pie to be enabled. With 2.26, it
only gets relaxed to
	leaq foo(%rip), %reg
which is all LLD currently does as well.

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 8abc30b27ba3..d25bb71f195a 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -60,6 +60,13 @@ else
 KBUILD_LDFLAGS += $(shell $(LD) --help 2>&1 | grep -q "\-z noreloc-overflow" \
 	&& echo "-z noreloc-overflow -pie --no-dynamic-linker")
 endif
+
+# Disable relocation relaxation if not building as PIE
+ifeq ($(filter -pie,$(KBUILD_LDFLAGS)),)
+KBUILD_CFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
+KBUILD_AFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
+endif
+
 LDFLAGS_vmlinux := -T
 
 hostprogs	:= mkpiggy
