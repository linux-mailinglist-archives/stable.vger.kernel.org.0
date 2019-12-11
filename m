Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C733311A89D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 11:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfLKKIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 05:08:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39653 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbfLKKIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 05:08:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id d5so4764650wmb.4
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 02:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gk81PzAbLI8o98/2oqILv8CnZ7KtzZ7BGCA4s/qRTQo=;
        b=l0zmGy5nn/XJOskQPekSMLWGfaDGaziwasSrhR/VtnGbL6OmzWoGTFV7oIUqABr97R
         a8jSQzR6DL6rQ6WZaVNx7dWAnRhEqbV7CLxB2WeckvubXRGpv8pnnB9/tt662tToGI23
         qOVc2NKUue0s7faGQrdTJOQw6a+uoRftgHaiW1ZJlrmf/dV85oN8GFEDt0qwwXZJ9MhD
         aW+GoAjR4xKRP+hv0ZWB6X6W6azavprw7nkbC6LIkL2JqJ4z0MuOCQl9+fssxUlIxWgs
         ggoxo+G1CfP8n8/oRgykuzAI2hDNP5SjNexs1i81PX4GdggpHUiZuW6lCwwx3bcNa6gq
         HCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gk81PzAbLI8o98/2oqILv8CnZ7KtzZ7BGCA4s/qRTQo=;
        b=TX0adhXUxK1GT/2Tk+O1ZkwN8c7huJK72TRdMuqITDTMHJv+2RNz8lw9U2zrdChkQy
         LNpbG3YgeJ46dKqr2Vg1FxlZcc9zDC/TCg4zc9m1zz9FxXedgswlVefT6I6IdZGNVBg5
         Zjp8rp0NfCHiykpVoBHmOyS8DZJmctJkljbgyruEOksINIlCHU4HiCG58ioHnXTP1eZW
         hsTDY8uQYz0I+fcjTkviOytscdbMqnXwtkK/aA2f3X5ITXe3DrloZf8HMZ6H+G+6yRLK
         3r9yRlV+H3klT5NSB7nuGAl3pJCdLG8iUlFXdu2WNkSqmWAZ+g9pOyjCG8KUZNYHUG99
         oLlQ==
X-Gm-Message-State: APjAAAWiICUOKZG/jMRWYVz0FFajFWdbplzvcNSjhCYEZ33NNiWOsYQd
        L5MuSTTWPZ9oNzCS5WIE7+vBVfjPFj28VrgBdtjIJA==
X-Google-Smtp-Source: APXvYqwI6Cs4wMfaSiJabTG1VtEx71hprkRtI8lhwa9L9Yrmea6XD4zJIFcrmydevphRyDbiD5J3g6rP6zX5G7cSERo=
X-Received: by 2002:a1c:a943:: with SMTP id s64mr2546152wme.148.1576058877140;
 Wed, 11 Dec 2019 02:07:57 -0800 (PST)
MIME-Version: 1.0
References: <20191210210735.9077-1-sashal@kernel.org> <20191210210735.9077-277-sashal@kernel.org>
In-Reply-To: <20191210210735.9077-277-sashal@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 11 Dec 2019 10:07:54 +0000
Message-ID: <CAKv+Gu-KLGFUEP55iGFp-irspwoG1uc0ZVPW15YDFX9MtXQW2Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 316/350] int128: move __uint128_t compiler
 test to Kconfig
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-riscv@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 at 22:13, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit c12d3362a74bf0cd9e1d488918d40607b62a3104 ]
>
> In order to use 128-bit integer arithmetic in C code, the architecture
> needs to have declared support for it by setting ARCH_SUPPORTS_INT128,
> and it requires a version of the toolchain that supports this at build
> time. This is why all existing tests for ARCH_SUPPORTS_INT128 also test
> whether __SIZEOF_INT128__ is defined, since this is only the case for
> compilers that can support 128-bit integers.
>
> Let's fold this additional test into the Kconfig declaration of
> ARCH_SUPPORTS_INT128 so that we can also use the symbol in Makefiles,
> e.g., to decide whether a certain object needs to be included in the
> first place.
>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This does not fix a bug so no need to put it in -stable

> ---
>  arch/arm64/Kconfig | 2 +-
>  arch/riscv/Kconfig | 2 +-
>  arch/x86/Kconfig   | 2 +-
>  crypto/ecc.c       | 2 +-
>  init/Kconfig       | 4 ++++
>  lib/ubsan.c        | 2 +-
>  lib/ubsan.h        | 2 +-
>  7 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 3f047afb982c8..54c38c9cab88a 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -67,7 +67,7 @@ config ARM64
>         select ARCH_USE_QUEUED_SPINLOCKS
>         select ARCH_SUPPORTS_MEMORY_FAILURE
>         select ARCH_SUPPORTS_ATOMIC_RMW
> -       select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000 || CC_IS_CLANG
> +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
>         select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 8eebbc8860bbd..75a6c91176221 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -164,7 +164,7 @@ config ARCH_RV32I
>  config ARCH_RV64I
>         bool "RV64I"
>         select 64BIT
> -       select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000
> +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
>         select HAVE_FUNCTION_TRACER
>         select HAVE_FUNCTION_GRAPH_TRACER
>         select HAVE_FTRACE_MCOUNT_RECORD
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8ef85139553f5..f2aed8012e9c0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -24,7 +24,7 @@ config X86_64
>         depends on 64BIT
>         # Options that are inherently 64-bit kernel only:
>         select ARCH_HAS_GIGANTIC_PAGE
> -       select ARCH_SUPPORTS_INT128
> +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
>         select ARCH_USE_CMPXCHG_LOCKREF
>         select HAVE_ARCH_SOFT_DIRTY
>         select MODULES_USE_ELF_RELA
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index dfe114bc0c4af..6e6aab6c987c2 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -336,7 +336,7 @@ static u64 vli_usub(u64 *result, const u64 *left, u64 right,
>  static uint128_t mul_64_64(u64 left, u64 right)
>  {
>         uint128_t result;
> -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
>         unsigned __int128 m = (unsigned __int128)left * right;
>
>         result.m_low  = m;
> diff --git a/init/Kconfig b/init/Kconfig
> index b4daad2bac233..020526f681c03 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -785,6 +785,10 @@ config ARCH_SUPPORTS_NUMA_BALANCING
>  config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>         bool
>
> +config CC_HAS_INT128
> +       def_bool y
> +       depends on !$(cc-option,-D__SIZEOF_INT128__=0)
> +
>  #
>  # For architectures that know their GCC __int128 support is sound
>  #
> diff --git a/lib/ubsan.c b/lib/ubsan.c
> index 0c4681118fcd2..fc552d524ef77 100644
> --- a/lib/ubsan.c
> +++ b/lib/ubsan.c
> @@ -119,7 +119,7 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
>  {
>         if (type_is_int(type)) {
>                 if (type_bit_width(type) == 128) {
> -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
>                         u_max val = get_unsigned_val(type, value);
>
>                         scnprintf(str, size, "0x%08x%08x%08x%08x",
> diff --git a/lib/ubsan.h b/lib/ubsan.h
> index b8fa83864467f..7b56c09473a98 100644
> --- a/lib/ubsan.h
> +++ b/lib/ubsan.h
> @@ -78,7 +78,7 @@ struct invalid_value_data {
>         struct type_descriptor *type;
>  };
>
> -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
>  typedef __int128 s_max;
>  typedef unsigned __int128 u_max;
>  #else
> --
> 2.20.1
>
