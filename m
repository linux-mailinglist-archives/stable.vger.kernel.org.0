Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845C559A30D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354820AbiHSRsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 13:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351314AbiHSRr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 13:47:57 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCEBB9431
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 10:15:06 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id x10so5101373ljq.4
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 10:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JAXhCl3E9jd9ApnOWZBAjKRPaL6FpmdOdGj2ig44w3U=;
        b=YTvX3/p+STgYcKJuwODn8Uc2Aou3SxtXuHaCCf7vVsR3gKxBrq7ZAMDSwSiCbB4VOw
         frem9BQfTK15GIHNFl7F7raHe34pjYsm1E8g01nDz+2/OVBD3wTKZKiCWkNs/7bALyz0
         bOiDvwn8NCVcAJiAf3RbfLshZ9IbeZ1rh0baIar/vssInLWH64yottw/7dBYcphX8V34
         4EdLdkSZdpcZH79nWgSM441h/ciz/UmRA6ABKwmbvFF/Ohf7mxyVmdjraKmXcVUkHuQ8
         xcqJ7JPRusqrN7kUR223Yrc0yypsAxBh+WsQJpZAwvCdMBg9E/HfQU6pU3Y4S+HfNbM9
         Q+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JAXhCl3E9jd9ApnOWZBAjKRPaL6FpmdOdGj2ig44w3U=;
        b=sTD2Y/DEp2SrtgYDJKUzfVPNkX/fm+/+z21lLWGRNP9dnHmmvGQcRffEC962zm4MQ2
         w4LqE8yZOl+ykFaEWqduqdBHplrRMItBkceN7UsgCsI1Fj0/1RytPxO9XSk2cOUNNBaY
         ZlzMSbyCeSXLXkgx8qoeeYFpzOXVjyRoE9BQs79SQeeagvsbdrLBn23UkaB1lF6EzSxn
         CfblGd8MHRpM5cVQA70mw+HO6SSWv6p9XM3wtlvlF6matdgn9mx1gq7iTLSv3IDxPBLf
         k+c1WWH+wxAeLASV/3MGoc+iWqLrnOQlW94xTBFGxHZdnTFLwCWVi+6QisyA67P6AhKN
         7pFQ==
X-Gm-Message-State: ACgBeo1uEe0U8bCETg2IR2++UcOGJrqk/hPCmlWMZyH96bF2OpDyWTKg
        Uy/Fyib3WAebY9QRNL7FrSFZYzN7lBAOLn3WNuAqZw==
X-Google-Smtp-Source: AA6agR7GKpemeJnJ8VnG9PjjkIm1ieSXlIFGKo/VPqH7oed8eOn1lSRe+2EBvu50VsAbVa33qJMy+FeN/vfsCpCuvg8=
X-Received: by 2002:a2e:a910:0:b0:261:b408:1169 with SMTP id
 j16-20020a2ea910000000b00261b4081169mr2289309ljq.360.1660929304284; Fri, 19
 Aug 2022 10:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153829.135562864@linuxfoundation.org> <20220819153829.220984987@linuxfoundation.org>
In-Reply-To: <20220819153829.220984987@linuxfoundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 19 Aug 2022 10:14:51 -0700
Message-ID: <CAKwvOdmu72iN8NE3dbCaoWNf9mbr9UcRAzmRgezRsKsWmT5xJg@mail.gmail.com>
Subject: Re: [PATCH 5.10 001/545] Makefile: link with -z noexecstack --no-warn-rwx-segments
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fangrui Song <maskray@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 8:46 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
>
> commit 0d362be5b14200b77ecc2127936a5ff82fbffe41 upstream.
>
> Users of GNU ld (BFD) from binutils 2.39+ will observe multiple
> instances of a new warning when linking kernels in the form:
>
>   ld: warning: vmlinux: missing .note.GNU-stack section implies executable stack
>   ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
>   ld: warning: vmlinux has a LOAD segment with RWX permissions
>
> Generally, we would like to avoid the stack being executable.  Because
> there could be a need for the stack to be executable, assembler sources
> have to opt-in to this security feature via explicit creation of the
> .note.GNU-stack feature (which compilers create by default) or command
> line flag --noexecstack.  Or we can simply tell the linker the
> production of such sections is irrelevant and to link the stack as
> --noexecstack.
>
> LLVM's LLD linker defaults to -z noexecstack, so this flag isn't
> strictly necessary when linking with LLD, only BFD, but it doesn't hurt
> to be explicit here for all linkers IMO.  --no-warn-rwx-segments is
> currently BFD specific and only available in the current latest release,
> so it's wrapped in an ld-option check.
>
> While the kernel makes extensive usage of ELF sections, it doesn't use
> permissions from ELF segments.
>
> Link: https://lore.kernel.org/linux-block/3af4127a-f453-4cf7-f133-a181cce06f73@kernel.dk/
> Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ba951afb99912da01a6e8434126b8fac7aa75107
> Link: https://github.com/llvm/llvm-project/issues/57009
> Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
> Suggested-by: Fangrui Song <maskray@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Makefile |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- a/Makefile
> +++ b/Makefile
> @@ -983,6 +983,11 @@ KBUILD_CFLAGS   += $(KCFLAGS)
>  KBUILD_LDFLAGS_MODULE += --build-id=sha1
>  LDFLAGS_vmlinux += --build-id=sha1
>
> +KBUILD_LDFLAGS += -z noexecstack
> +ifeq ($(CONFIG_LD_IS_BFD),y)
> +KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
> +endif

5.10.y is missing CONFIG_LD_IS_BFD. Specifically

commit 02aff8592204 ("kbuild: check the minimum linker version in Kconfig")
which first landed in v5.12-rc1.  I'd recommend simply dropping the
`ifeq` guards; the ld-option guard will still work.  Otherwise GNU BFD
2.39 users will observe linker warnings related to rwx-segments.

Greg, do you mind dropping this patch and I'll supply a v2, or is it
too late and I should send a patch on top?

> +
>  ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
>  LDFLAGS_vmlinux        += $(call ld-option, -X,)
>  endif
>
>


-- 
Thanks,
~Nick Desaulniers
