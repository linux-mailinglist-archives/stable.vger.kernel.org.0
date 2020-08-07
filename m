Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022B723F43B
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 23:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGV3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 17:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGV3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 17:29:19 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6931AC061756;
        Fri,  7 Aug 2020 14:29:19 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id x69so3063884qkb.1;
        Fri, 07 Aug 2020 14:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6OCdZ+ZeCbuJb568osbDrIdPBoRSxq8uWrbOnWLeK5E=;
        b=noA9x5sq8cTXe/XXi9Q4ba+UczIxMQ928kgCeg9juRZTOVfCH+8OjGDFymehDxoyFa
         GlgOCtQ1HVmgoA5iKlaktjH6ZfIJCWDW8T9BC6T6Fm8dzJxZcPyZ48dhmpaiZhOcoebP
         NBa0RjCtozFkyOfdHK0Gr0eUBqvZMDAAOgjm6Iyk/QijpWQDLy90bo4zcOYEoGl/1MnK
         /AjQIlMBy4W0HDeUywa+vMcrn1BWFYz7rAJNNiZCE8S6Jg5QyqztFBvrRPZiP+5RvJid
         ZDJyzjN4HEIyC8z7jRbRZZTI5SvpPfxWzakb6OLBroLkqoyw0WP3IYNb928wOYPM7dUO
         XCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6OCdZ+ZeCbuJb568osbDrIdPBoRSxq8uWrbOnWLeK5E=;
        b=of+j5na8yD595Sd3duX0JMQ8hJMRZhJ7KCit0YDEADAQMylwL0RyjGThjzhhECqhTF
         S43KA2Ze0jCRPL1YV6Jww0f+VuUMUfUbAorEsxh27M01/NJ2to6+VFAfZxwYEXQMxGWC
         3MHxDMfUImYYICeNaAH3yW3pxVIb63RzggtH920XXpNpNC0ZRGqFfApr4EsEz2YFyrfv
         oS0by0/kBHNd64bqlvYDWDCqJtKfoOHWEMmvk5ev4JuRfmZy7T153tXWLbowFD6g8Rtr
         7A7ovs5PWThktKDsNCkYtTDJRj+hhAez/on2zxPDnkhc82uYAlViS4ZBXdZTeN6BRBgg
         uvMA==
X-Gm-Message-State: AOAM531kuhwEqYY9AsSlgEX0h81FrQdREp0GST4cuUzyrwX9CyqHuI2V
        elELeNt0GRGkAaep12T8KOM=
X-Google-Smtp-Source: ABdhPJxgMl4he648RZK+OwIGlkgBK6xjVlA/GQhmQeA4WNXiqRanMMXY26+OJDI0nbbGD/KTT9vmRA==
X-Received: by 2002:a05:620a:234:: with SMTP id u20mr14935734qkm.54.1596835758328;
        Fri, 07 Aug 2020 14:29:18 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t93sm8636947qtd.97.2020.08.07.14.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 14:29:17 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 7 Aug 2020 17:29:14 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux@googlegroups.com, e5ten.arch@gmail.com,
        stable@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dmitry Golovin <dima@golovin.in>,
        Marco Elver <elver@google.com>, Nick Terrell <terrelln@fb.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/boot: avoid relaxable symbols with Clang
Message-ID: <20200807212914.GB1454138@rani.riverdale.lan>
References: <20200807194100.3570838-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200807194100.3570838-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 12:41:00PM -0700, Nick Desaulniers wrote:
> A recent change to a default value of configuration variable
> (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
> integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
> relocations. LLD will relax instructions with these relocations based on
> whether the image is being linked as position independent or not.  When
> not, then LLD will relax these instructions to use absolute addressing
> mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with Clang
> and linked with LLD to fail to boot.

It could also cause kernels compiled with gcc and linked with LLD to
fail in the same way, no? The gcc/gas combination will generate the
relaxed relocations from I think gas-2.26 onward. Although the only
troublesome symbol in the case of gcc/gas is trampoline_32bit_src,
referenced from pgtable_64.c (gcc doesn't use a GOTPC reloc for _pgtable
etc).

I'm a bit surprised you were able to boot with just _pgtable fixed
(looking at the CBL issue), there are quite a few more GOTPC relocs with
clang -- maybe LLD isn't doing all the optimizations it could yet.

This potential issue was mentioned [0] in one of the earlier threads
(see last paragraph).

[0] https://lore.kernel.org/lkml/20200526191411.GA2380966@rani.riverdale.lan/

> 
> Also, the LLVM commit notes that these relocation types aren't supported
> until binutils 2.26. Since we support binutils 2.23+, avoid the
> relocations regardless of linker.

Note that the GNU assembler won't support the option to disable the
relaxations until 2.26, when they were added.

However, it turns out that clang always uses the integrated assembler
for the decompressor (and the EFI stub) because the no-integrated-as
option gets dropped when building these pieces, due to redefinition of
KBUILD_CFLAGS. You might want to mention this in the commit log or a
comment to explain why using the option unconditionally is safe. It
might need to be made conditional if the CFLAGS ever gets fixed to
maintain no-integrated-as.

Thanks.
