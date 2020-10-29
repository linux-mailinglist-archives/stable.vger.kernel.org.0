Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C7329F43A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 19:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgJ2Smd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 14:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJ2Smb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 14:42:31 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6859C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:42:30 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id t25so5149795ejd.13
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 11:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mej6eukC5PTZqXIPkS9F7D1m3B/P6HH0uiBYCexoXFI=;
        b=T6rc/5mNjYSdllkwEt1yyX577WdGSeIPCb7UntfqlbzQmTCSDYRAp1DG8VEwe6wp5E
         m98F8at5Ll52ia8sKXynstSWPMcvmQjlk0t56QuS2qV1hkU7YJbvRSuNiIvqK/cgNgOZ
         nL2TeuY3llUDBEf8rkqabaiX+kq/KxKBcwrcX9cr2JO6uT2qw4pAh5eWTNEOHvFFJSVo
         831qfGjGXvIpC5g20lS46PVVfPsCyoXD1fa1t55Wa6UIOte6cSrTmLTLLrxQptFmSakU
         b5aTRhUpHxuDSh0+8I1TX9fVTyXOJozxHR8i38pIMmiJARfXYQZh7SLez1M7Qr+oX8iZ
         x/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mej6eukC5PTZqXIPkS9F7D1m3B/P6HH0uiBYCexoXFI=;
        b=ky8bx8DlhBArIa+uVutKmBk6vdrOxWHVoLNuK+wwGXsCD8R2+P3Rp3/gNuRuvETctg
         d/hCw2ymlVPdlFcuhEgES2epb0Vi+9mF53tS36PemjoKBH6UkkjX+w6ugiUKfeNLDOp1
         Mc18/8K3qN9sVHeShVqcgG1zpZLSdFaAvmUVAQ3Zj9WGjKz9tBuPtH7Cbtkg4KVQgSae
         Kf7z7aJd9s1TuHQ2f6MM35LvuYpE9vu9qNUpJsswBdYXa2px1Rx3Ckg0OrjnqOmO5Maq
         E4ZuW333s08oqDSDOwko0fQ+sX+K1fU0qSk1PD6CWs5DHE3DqFq9TZxwRbMfv/S58yII
         MJFg==
X-Gm-Message-State: AOAM531h+5Bh4RwDx0Pa94z+1TP3PUUf+ssz549viLNnGdF7kgIrzVHb
        0CRxHwB5skYd6C/TaIpjbaWzMORJrqskcQtA3HaqkQ==
X-Google-Smtp-Source: ABdhPJwvAsHyE/A3VuQ2W3RWKOnDxqGKW+H1a2nXg1BEguymuNBE9XpjX2R8879s2F6JLiwjXc8HMRd8YgoQd2Ta7wM=
X-Received: by 2002:a17:906:53d7:: with SMTP id p23mr5363816ejo.232.1603996949344;
 Thu, 29 Oct 2020 11:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201029180525.1797645-1-maskray@google.com>
In-Reply-To: <20201029180525.1797645-1-maskray@google.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Thu, 29 Oct 2020 11:42:18 -0700
Message-ID: <CABCJKuceep1jo_hkZA0bEAZxL49K4QbR4aAnOcJnvnF9YdRgUg@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
To:     Fangrui Song <maskray@google.com>
Cc:     X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 11:05 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
> memset/memmove/memcpy functions") added .weak directives to
> arch/x86/lib/mem*_64.S instead of changing the existing SYM_FUNC_START_*
> macros. This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
>
> Use the appropriate SYM_FUNC_START_WEAK instead.
>
> Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/lib/memcpy_64.S  | 4 +---
>  arch/x86/lib/memmove_64.S | 4 +---
>  arch/x86/lib/memset_64.S  | 4 +---
>  3 files changed, 3 insertions(+), 9 deletions(-)

Thank you for fixing this! I tested the patch with gcc 9.3 and clang
12, both with and without Clang's integrated assembler, and the kernel
builds and boots with all compilers again.

Tested-by: Sami Tolvanen <samitolvanen@google.com>

Sami
