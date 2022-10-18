Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7C460200D
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 03:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiJRBAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 21:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiJRBAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 21:00:38 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884E549B6F
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:00:37 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id i127so4496626ybc.11
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GCJNXLNtMY8PRA9uS4Q+FrbmzG6Ya2XD3+/CMXDAKwk=;
        b=helX2wf70lsOa6PW1by64OgDBGMHa5Hx4FZW0FeaT5jhzITjLNZbHxegSSw9O+jtbj
         tFgtg4hqQ5tCOxYSpLIZphh0lKjxgag4yD1ehLHhWCaCx8/pXzKbscnEXSUIeqgFAE8L
         7/dSGQigATm/O7w4eUIDPr2+FfCUkvBEnPD8W8vSjR2PONlIazKdsNzmKd0H7pu8nTPx
         wXFPGUr1DxCm2rrSz9hsGhaTDos0Y87xwhHckEg72hwXw3OuI3XaU2iGfSOEKe77NfpR
         0HJeNR6iqvWluo0+3U+DSRNkb9oR2YkG6iBMBIlANol9tZbWCMjsvg7PN1hHGO0ACxHN
         hkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GCJNXLNtMY8PRA9uS4Q+FrbmzG6Ya2XD3+/CMXDAKwk=;
        b=OSbK6/2LP+G2Kob+C9tExPLQi1Us1gWp9EqObdUdSWxXO0mMLiGacqI8CWKOZ/hwwA
         70jFK/AznI607yQFl7L+bS8DsnSRnTGSBUHTU/4EaHzn2+M3b8o8TDeR/Y9l3pwIoaaP
         1p48vjcptEsg/zh/HtawRuLCMB2IXkiElM6rtKWUdyNVf2382lnx1UWl3AMHX00u9xP6
         h4U8V+2mFESrAbpJdZagFpRxHtyK9CjuZwUh+vOWjuJIIyIFposKE2fShKS3HCrwk0qh
         JNhwHqhdXhuK5faGJO5zHpwy3x0KkyeJhM0Iea/QllTD4/Gox3dKijZm0AstrpNKdhSL
         FHGQ==
X-Gm-Message-State: ACrzQf3OaOo31oLcPDUI46oU5iW71xFich4t7mH8m1LPyW0r4BdihnAA
        77qZssiFVxKlHQgkuHT/55xvedGaeEc6ijtrqhygSw==
X-Google-Smtp-Source: AMsMyM7egLQKDit6u0mkMbFcIR15tLImWisLBFPOH17ViWtzL8TUjfeB34tDsjBPLYGWyjjHxhI60kX9I9Wd2VhiAy8=
X-Received: by 2002:a25:c102:0:b0:6c4:c94:2842 with SMTP id
 r2-20020a25c102000000b006c40c942842mr352652ybf.611.1666054836648; Mon, 17 Oct
 2022 18:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20221018000729.2730519-1-sashal@kernel.org> <20221018000729.2730519-22-sashal@kernel.org>
In-Reply-To: <20221018000729.2730519-22-sashal@kernel.org>
From:   Marco Elver <elver@google.com>
Date:   Mon, 17 Oct 2022 18:00:00 -0700
Message-ID: <CANpmjNM3KrZGbmP2J3o_QNv6QquejA0fQN62mx-biYnEY4xF+g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.0 22/32] kmsan: disable instrumentation of
 unsupported common kernel code
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
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

[-Cc prune most]

Does this mean KMSAN is being backported to stable? I only see a
subset of patches.

On Mon, 17 Oct 2022 at 17:08, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Alexander Potapenko <glider@google.com>
>
> [ Upstream commit 79dbd006a6d6f51777ba4948046561b6d9270504 ]
>
> EFI stub cannot be linked with KMSAN runtime, so we disable
> instrumentation for it.
>
> Instrumenting kcov, stackdepot or lockdep leads to infinite recursion
> caused by instrumentation hooks calling instrumented code again.
>
> Link: https://lkml.kernel.org/r/20220915150417.722975-13-glider@google.com
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: Marco Elver <elver@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vegard Nossum <vegard.nossum@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/firmware/efi/libstub/Makefile | 1 +
>  kernel/Makefile                       | 1 +
>  kernel/locking/Makefile               | 3 ++-
>  lib/Makefile                          | 3 +++
>  4 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 2c67f71f2375..2c1eb1fb0f22 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -53,6 +53,7 @@ GCOV_PROFILE                  := n
>  # Sanitizer runtimes are unavailable and cannot be linked here.
>  KASAN_SANITIZE                 := n
>  KCSAN_SANITIZE                 := n
> +KMSAN_SANITIZE                 := n
>  UBSAN_SANITIZE                 := n
>  OBJECT_FILES_NON_STANDARD      := y
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 318789c728d3..d754e0be1176 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -38,6 +38,7 @@ KCOV_INSTRUMENT_kcov.o := n
>  KASAN_SANITIZE_kcov.o := n
>  KCSAN_SANITIZE_kcov.o := n
>  UBSAN_SANITIZE_kcov.o := n
> +KMSAN_SANITIZE_kcov.o := n
>  CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
>
>  # Don't instrument error handlers
> diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
> index d51cabf28f38..ea925731fa40 100644
> --- a/kernel/locking/Makefile
> +++ b/kernel/locking/Makefile
> @@ -5,8 +5,9 @@ KCOV_INSTRUMENT         := n
>
>  obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
>
> -# Avoid recursion lockdep -> KCSAN -> ... -> lockdep.
> +# Avoid recursion lockdep -> sanitizer -> ... -> lockdep.
>  KCSAN_SANITIZE_lockdep.o := n
> +KMSAN_SANITIZE_lockdep.o := n
>
>  ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_lockdep.o = $(CC_FLAGS_FTRACE)
> diff --git a/lib/Makefile b/lib/Makefile
> index ffabc30a27d4..fcebece0f5b6 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -275,6 +275,9 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
>  CFLAGS_stackdepot.o += -fno-builtin
>  obj-$(CONFIG_STACKDEPOT) += stackdepot.o
>  KASAN_SANITIZE_stackdepot.o := n
> +# In particular, instrumenting stackdepot.c with KMSAN will result in infinite
> +# recursion.
> +KMSAN_SANITIZE_stackdepot.o := n
>  KCOV_INSTRUMENT_stackdepot.o := n
>
>  obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
> --
> 2.35.1
>
