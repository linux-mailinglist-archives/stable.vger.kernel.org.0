Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1470729F44B
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 19:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJ2SxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 14:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJ2SxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 14:53:11 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8724FC0613D3
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:53:11 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id x1so4163665eds.1
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yz8U+6jHNF7eLZlDj8rSpnVb9NWsY4EUsa4dd8qnWPc=;
        b=l7Fn4MpmYMpJ59JMFFh4fVKh4VNaObwJy/tQEslKgb9RN14cKcnOIVzBWEh7L8FEFo
         s9PkeCp4hhZK0TmHWBX5BPsKHhEwEMeuvHON1JWQ+MAXA+amk8/v4WSDeGXtcuJvvqaP
         ueMLFYlM+3iCJ4uK953ep1+uOOrKGtxpeZqEmDtK5NvyWvVNjNhZZlXfyZd9kVVDGbT1
         2KYFaDtew53smVqDtrcyd/dwl6WRZplpP7gu5P+qHdjg42Oy3oRqFwdWuadI9e+d91Py
         7VdDuA4c54wmPs7S1UikpaUBFhn3BRRhVRbLnu5oAE9A5wgk8Sv0dr8aHPQcrqlyMYWd
         /7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yz8U+6jHNF7eLZlDj8rSpnVb9NWsY4EUsa4dd8qnWPc=;
        b=XOt9Y9U5X6V64oEL83PWibp/tkrmuzC3+8TmByuPqgNbpirzF14enauNVJkpcXvLZ7
         qXX4ZJ4kWyR+Dzw9uMXeWJKu04AFdaZ6IQvGcxLdGrEgi6lSzAOPz0T8/iwlgofBEt5I
         MDHqu0f73e3fm15qRgPbpWlmFEYT4ig6hbQ1Xf4gLQ16H5p0qG+d3JqmLEWRHygz6o5s
         Yyqxv97VHzH/TNnVmGBTatzHzOKEae6MCoLWLhrPwSAEk/Os6XHlQSbhLb4HaibK/aDS
         M+NElvJCDoNbuXhlGeQsvYZymneBVWllr8u3G7IFHY3xVNzIUnaFo7sYuUK5Fb66HBmG
         1Qhg==
X-Gm-Message-State: AOAM530gM2T1qEOn5WjpS7Ns0lpEGJxKfmuMvO+N9fmsBnEiAyZOgJMc
        jsUSATxMui5kwx9c6Be+d9IGhxnzRPxDU20S6Dwazg==
X-Google-Smtp-Source: ABdhPJwtWjg++aqYDpxKzBSjfMoXw/BnVoMRSJHxamaCaBNlw01n14RlCxTXwaNEEdhXLfU5TvN7b1pEgS1YnvM0uyg=
X-Received: by 2002:aa7:c7d9:: with SMTP id o25mr5735409eds.318.1603997589963;
 Thu, 29 Oct 2020 11:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201029181951.1866093-1-maskray@google.com>
In-Reply-To: <20201029181951.1866093-1-maskray@google.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Thu, 29 Oct 2020 11:52:58 -0700
Message-ID: <CABCJKuddxRo7Ki2yEc5mkWRjox+9RUYUczjisJd5QepEXc_EOQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
To:     Fangrui Song <maskray@google.com>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 11:20 AM Fangrui Song <maskray@google.com> wrote:
>
> Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
> arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
> macros. This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
>
> Use the appropriate SYM_FUNC_START_WEAK_PI instead.
>
> Fixes: 39d114ddc682 ("arm64: add KASAN support")
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/arm64/lib/memcpy.S  | 3 +--
>  arch/arm64/lib/memmove.S | 3 +--
>  arch/arm64/lib/memset.S  | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)

Thanks for the patch! This fixes the build with Clang 12 + LLVM_IAS=1,
and also builds and boots with gcc 9.3 and Clang 12 without IAS.

Tested-by: Sami Tolvanen <samitolvanen@google.com>

Sami
