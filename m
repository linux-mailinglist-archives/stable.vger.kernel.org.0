Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1156D687
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 23:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfGRVe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 17:34:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45221 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbfGRVe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 17:34:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so14518877plr.12
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 14:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rq6ZXaexVOr1g5rKeqsc4reNWPARrrLFOhCOfoYVB1A=;
        b=JYSGf+r6eqoqQXX0LxoRCLQDVYXbMATf/dpdcE8ADt32cleMWPhkS3t8ujcPp/F8L0
         ARA/T0eJ8YG7/V3eto9Oku1wbLM0q1/7v64O7YrF2pG1UGKmaEs6dKYavTv1gxh4K4Sd
         hvb0+ujdaFBp2ez+/CFo23PINM0BaOD7YPAa1MQN1+ZA3NWnzV4lKASRcqB/9N/R0sDJ
         omrdWuCFXV6uec9Xbs/JlzrKhcefsdWp4qB3G+KvmRJfPuu91EXML6M8XYQBjj9kkAe2
         8VcbdSBEdoYA3S5tKGsdtVXvNmpbZvxuNC1V/Wkxc+kTjckG/kN/VZ0xSa4VyUZX2PLh
         D1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rq6ZXaexVOr1g5rKeqsc4reNWPARrrLFOhCOfoYVB1A=;
        b=G8Yv747noMVLGxP9cK8DLOV5BazywMY7HzKCTj+TrTN6QMMjPFgfLTMutpDSJnE9QG
         5NJDVsNCO+xalW6bryHdzRZeSEkFgYjEA5yWHqDdEN0nkk7Pqq/k+H8WCH5BpDN7Tq9B
         t33TmNzpKMQ8RviwGOHNmqQizYdPPq0qCSCMeu680M3MfTq9nqazCLggjPm1+9WmTj73
         UDjEGIXYy0C+B/sKeJ18y8OX51vGf43vlLf0bgee6lb6CR8/aZhlNaWjY2qYKE4kw2SH
         dYhz/ItFO79zihzsSGp9MZaununGPHrdub6zOE6O6CKopCVqy2MvbgrPxyZXndO0PJAx
         l22A==
X-Gm-Message-State: APjAAAWdLCjFTzhOd+c116nsZXiavX7A9h5fUJP84Ihy2HpQsxeDVZy8
        1D4xPv31CY7alBCjf2zy601FYqzWRRCokY9ZjgunfQ==
X-Google-Smtp-Source: APXvYqzepu9AlsPIvI969TgZ5nsQiSeZ9SiaxA4mD7hWWMjIhA7AV4zKxe75qx/Skek8PAJwZVprrnGOEcloIamJ3ok=
X-Received: by 2002:a17:902:4aa3:: with SMTP id x32mr50406455pld.119.1563485695394;
 Thu, 18 Jul 2019 14:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190718000206.121392-1-vaibhavrustagi@google.com> <20190718000206.121392-2-vaibhavrustagi@google.com>
In-Reply-To: <20190718000206.121392-2-vaibhavrustagi@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 18 Jul 2019 14:34:44 -0700
Message-ID: <CAKwvOdkHHNR7utufOcDwAOgBEA9MnOLh713Gaq01R=n26EyjZw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to Makefile
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 5:02 PM Vaibhav Rustagi
<vaibhavrustagi@google.com> wrote:
>
> Compiling the purgatory code with clang results in using of mmx
> registers.
>
> $ objdump -d arch/x86/purgatory/purgatory.ro | grep xmm
>
>      112:       0f 28 00                movaps (%rax),%xmm0
>      115:       0f 11 07                movups %xmm0,(%rdi)
>      122:       0f 28 00                movaps (%rax),%xmm0
>      125:       0f 11 47 10             movups %xmm0,0x10(%rdi)
>
> Add -mno-sse, -mno-mmx, -mno-sse2 to avoid generating SSE instructions.
>
> Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> ---
>  arch/x86/purgatory/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 3cf302b26332..3589ec4a28c7 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -20,6 +20,7 @@ KCOV_INSTRUMENT := n
>  # sure how to relocate those. Like kexec-tools, use custom flags.
>
>  KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
> +KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-sse2

Yep, this is a commonly recurring bug in the kernel, observed again
and again for Clang builds.  The top level Makefile carefully sets
KBUILD_CFLAGS, then lower subdirs in the kernel wipe them away with
`:=` assignment. Invariably important flags don't always get re-added.
In this case, these flags are used in arch/x86/Makefile, but not here
and should be IMO.  Thanks for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

(Note that arch/x86/Makefile additionally sets -mno-3dnow and -mno-avx
(if supported by the compiler).  Not sure if the maintainers would
like a v2 with those added, and we don't strictly need them yet, but
we may someday).
-- 
Thanks,
~Nick Desaulniers
