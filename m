Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB3558842
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 19:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfF0R0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 13:26:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38877 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0R0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 13:26:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so1570463pfn.5
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 10:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yC2k06ZrEbrPsihnFyfnuoaYxoQZIAB/UpnmdloBBeM=;
        b=M4aPeAy351r9m7DiPtmkWbyW8Ee0+gq/RD1Lg9wqwC8OOoQUCONycYei3PscpDyOhk
         OkKPaUedgsFtCO1shdwjpN4h163e76jNh/Co8Wn7gl19QplRZcMrhqfV5KsibtyZlnn4
         hPQtpynZ7mgK5bBWvSUIRosOTKb186+XC2IUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yC2k06ZrEbrPsihnFyfnuoaYxoQZIAB/UpnmdloBBeM=;
        b=bzKkbjRLadzEJfKt4st0+ZP8bMEyx6y+Opw6imFt2d9WIULgKPehev4Rm2rn2wC+Gv
         C7dhuUOp1i1jsQajKA+eijbQXMa7SsgY2usjyqhZR1CWa5EY6UOsU8EEZ3mEuJSxq2Wn
         4IMh8OuRlf6SUSn28UuUu1x2zSe506U4Bfy5oIxlVUn6ny0lBuWj/uonKqn9fgt3kE+2
         qJ7sET9fllIdOPKU0EoTasjd+E6PVhQwIw3GiJTr12xzMPWeUv41tHO18l8E/+R04hUq
         a/SqDD8GvsxaU0Byx8isFt5bSfxXcmWrrifGU8Nr61RAk4bNJJ4FbFqW+hWBtNOQdk+U
         8vcw==
X-Gm-Message-State: APjAAAU36AQthN09GtvF/yI9QqlZ3xbCpFxYElBclvOc6s2e8h7YcUGS
        GmTgF6NWq29N9qcQ9G2KtFxPql3SuxU=
X-Google-Smtp-Source: APXvYqwf1jdzj0nrLT8fzBbcq9r+JxRpv7xWxbAyaYhGiAa9jeVaHMzeWiFPuJE8tePBzv+dt30lhA==
X-Received: by 2002:a17:90a:26ef:: with SMTP id m102mr7318879pje.50.1561656372771;
        Thu, 27 Jun 2019 10:26:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h18sm4658023pfr.75.2019.06.27.10.26.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Jun 2019 10:26:12 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:26:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/8] x86/vsyscall: Remove the vsyscall=native
 documentation
Message-ID: <201906271026.6AB1D9493@keescook>
References: <cover.1561610354.git.luto@kernel.org>
 <d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 09:45:02PM -0700, Andy Lutomirski wrote:
> The vsyscall=native feature is gone -- remove the docs.
> 
> Fixes: 076ca272a14c ("x86/vsyscall/64: Drop "native" vsyscalls")
> Cc: stable@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  Documentation/admin-guide/kernel-parameters.txt | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 138f6664b2e2..0082d1e56999 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5102,12 +5102,6 @@
>  			emulate     [default] Vsyscalls turn into traps and are
>  			            emulated reasonably safely.
>  
> -			native      Vsyscalls are native syscall instructions.
> -			            This is a little bit faster than trapping
> -			            and makes a few dynamic recompilers work
> -			            better than they would in emulation mode.
> -			            It also makes exploits much easier to write.
> -
>  			none        Vsyscalls don't work at all.  This makes
>  			            them quite hard to use for exploits but
>  			            might break your system.
> -- 
> 2.21.0
> 

-- 
Kees Cook
