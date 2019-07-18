Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E126D680
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391564AbfGRVaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 17:30:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41830 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391558AbfGRVaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 17:30:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so13197651pff.8
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 14:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Kg4e7WJhopl3gfQ88VPQnEvXn0fCE4TNc6Qi8excrA=;
        b=XGlyw6Q8ysBBtTHOOum9BHjDmPSc1sI8WLNMUrICUYMGmrsPez8FFPxmSwfvUqUFVT
         fKCDRQp2fLC+FniwHviGGwD6ys/rDQhiy9Q6Vzl0TSVZnuWgtg9rB/BN3RAjo0IvUG15
         uJnWwS0ATKe3d+RGYew8jbtLXtwjIO78vyz+YbvaCuVeMqmCrUZ9EI6G6VSChiBxYwUH
         9jc5Cy9BDQMr4BOqXkp4rmsB4U+ImgqOf9zpYVygOEqUhOtup4FuvV1k27/1VjBGxJaS
         V9wCPaRfptfw7vKmU9KJk9eXz6Q/YFDXIXDdDVEq/C80XPvnPc8uw1jXZEVRG8Z/KkjP
         /rMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Kg4e7WJhopl3gfQ88VPQnEvXn0fCE4TNc6Qi8excrA=;
        b=c2dzq3dT8pgH+VxuUhn34XwHIJRzig/4EvAhc7mgXPWQvoNSntntkM3rgr1Rq4RyJQ
         qoeZajcIqoT/noRVK3OxBTMD5ue73lsk0/1F3MPmYw8db1FqJDlEdApoa6ls6L1Nu3bK
         69D77dk8sXC3EEcGn0rfeWPGYICya3j6JGenAhO1MC1D0UdJyh8k6dNT7anvyDEiLj7m
         W7mX/ZlnA4C3OblExavHoAIimHUpXNykchLJyGy5/zoEgN2rXZy0nCK6KnpwEZMni3Eg
         pQEgsd2YcWEj46oGOphFUkcZkvaDPt5F4Lam2lBocEgbo0/1hH1gTFJ8QOj3XqQpPHHL
         Efyg==
X-Gm-Message-State: APjAAAXyn9mPKlz4nUMEm+VsJfPxMsjs6sGiKRjJQV2MVI3yhjLUOA2P
        7cBlKX3Q+W4mSwvy6jRT68xFweOkKYDS39v2WuToSg==
X-Google-Smtp-Source: APXvYqx8k89qmHUDy6zioXETxvVwoCx81KNoNX8Y5A8x1AMK1kTaZwhrNuMPCtzQJ+jSQATFEDc69e9BwaH91rPEBm8=
X-Received: by 2002:a63:60a:: with SMTP id 10mr19112038pgg.381.1563485409250;
 Thu, 18 Jul 2019 14:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
In-Reply-To: <20190718000206.121392-1-vaibhavrustagi@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 18 Jul 2019 14:29:58 -0700
Message-ID: <CAKwvOdm_D1RnbzP6ZSuyOjm5DuNFrST4s8ihwVfOyAXm6wOc_g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Support kexec/kdump for clang built kernel
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
> This patch series includes the following:
>
> 1. Adding compiler options to not use XMM registers in the purgatory code.
> 2. Reuse the implementation of memcpy and memset instead of relying on
> __builtin_memcpy and __builtin_memset as it causes infinite recursion
> in clang.

Thanks for the series, and debugging and finding the issue.  These
would explain why I couldn't get kexec to work with Clang built
kernels.  Comments/reviews inbound on the individual patches.

>
> Nick Desaulniers (1):
>   x86/purgatory: do not use __builtin_memcpy and __builtin_memset.
>
> Vaibhav Rustagi (1):
>   x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to Makefile
>
>  arch/x86/purgatory/Makefile    |  4 ++++
>  arch/x86/purgatory/purgatory.c |  6 ++++++
>  arch/x86/purgatory/string.c    | 23 -----------------------
>  3 files changed, 10 insertions(+), 23 deletions(-)
>  delete mode 100644 arch/x86/purgatory/string.c
>
> --
> 2.22.0.510.g264f2c817a-goog
>


-- 
Thanks,
~Nick Desaulniers
