Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498B3381A4
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 01:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfFFXLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 19:11:35 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40949 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfFFXLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 19:11:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id r18so91420edo.7;
        Thu, 06 Jun 2019 16:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QEUnkE6Im8einmZj2C6MIq4PTwm8bjOQ1E1LQ2F5/1Q=;
        b=iYVyDjB27ZoY2J+fA/C4YM+TJgoVpnrkcjDB56OyGXRumXAtq/rIt8zYaszUOEfjp1
         iPAboJAJVTnITpR9DNOFQtSeD0c6dqkLPEGmQmdkMBlU09vEmrZqFwAPm6uv1Hl5xgkq
         RFeZRXsei4Cc6qaXjjzR19dokNaTAcwuk3E3husnIII9AlycYH/HFNwBjqenSlgFOAwb
         n1jnQkUAaQHPJfLnrY43VBExrRNH+UN9OyfAMk4fAuur0zlxdmCQ4oXh03j3h6TPRNMn
         GdsN3RA49FTjxKEnDS0j5IG79Yyz+2GasCYISZe801tgVCjmOOuDCFoYMCqdiSL61bpN
         jLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QEUnkE6Im8einmZj2C6MIq4PTwm8bjOQ1E1LQ2F5/1Q=;
        b=TOO33hjXeIoKO1zs2DF9NxFt05gjpCj+WuuCzjXV0svHKcjHn8cT1mhQQDHnhZhnXr
         VkCxR4+cB6CXenEuCw1U4UaLPBZkLBLn8ZNfBffHmnMj8QDlDWtFQ+z1LAmM9tOoIrwT
         qgkzEAl9Drsv8cknuPMf8pAAv/iricoB3WOtracCO2W0LsRJLTHVSS8CDo8x7OAwJuGT
         eKm+Fi7mFkR03G5wpweEasxsz26arl5qcDddIhTWHQXEBYc8Ww3qrCWVsLvBGrxD8/XA
         e57mtZRVJkAXzj4HcMmisLa4vmcHnksMPrKvpFpV8fZONpX+msnrQkKbQUp2LLPgteNb
         pBxw==
X-Gm-Message-State: APjAAAVnHz/Xdj3Dc3CKGwdpxvF/PVKfFKlIQuHb5fufDa2MiN7HpJaX
        F9HfHtILvpLy/cJuI5N9zdc=
X-Google-Smtp-Source: APXvYqzN7vH2/T1J4iZHUGpAwwlzUurd20U6+aeJE3pXfxKOhkrG4L0EgT0PfhZ6Ggh/Kh0AdX1QSA==
X-Received: by 2002:a50:f5c2:: with SMTP id x2mr6609917edm.13.1559862693382;
        Thu, 06 Jun 2019 16:11:33 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id a17sm72898edt.63.2019.06.06.16.11.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 16:11:32 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:11:30 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Joe Korty <Joe.Korty@concurrent-rt.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alistair Strachan <astrachan@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [BUG 4.4.178] x86_64 compat mode futexes broken
Message-ID: <20190606231130.GA69331@archlinux-epyc>
References: <20190606211140.GA52454@zipoli.concurrent-rt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606211140.GA52454@zipoli.concurrent-rt.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 09:11:43PM +0000, Joe Korty wrote:
> Starting with 4.4.178, the LTP test
> 
>   pthread_cond_wait/2-3
> 
> when compiled on x86_64 with 'gcc -m32', started failing.  It generates this log output:
> 
>   [16:18:38]Implementation supports the MONOTONIC CLOCK but option is disabled in test.           
>   [16:18:38]Test starting
>   [16:18:38] Process-shared primitive will be tested
>   [16:18:38] Alternative clock for cond will be tested
>   [16:18:38]Test 2-3.c FAILED: The child did not own the mutex inside the cleanup handler
> 

What is the exact build command + test case command? I'd like to
reproduce this myself.

> A git bisection between 4.4.177..178 shows that this commit is the culprit:
> 
>   Git-Commit: 79739ad2d0ac5787a15a1acf7caaf34cd95bbf3c
>   Author: Alistair Strachan <astrachan@google.com>
>   Subject: [PATCH] x86: vdso: Use $LD instead of $CC to link
> 

Have you tested 4.4.180? There were two subsequent fixes to this patch
in 4.4:

485d15db01ca ("kbuild: simplify ld-option implementation")
07d35512e494 ("x86/vdso: Pass --eh-frame-hdr to the linker")

> And, indeed, when I back this patch out of 4.4.178 proper, the above test
> passes again.
> 
> Please consider backing this patch out of linux-4.4.y, and from master, and from
> any other linux branch it has been backported to.
> 

So this is broken in mainline too?

> PS: In backing it out of 4.4.178, I first backed out
> 
>    7c45b45fd6e928c9ce275c32f6fa98d317e6f5ee
>    
> This is a follow-on vdso patch which collides with the
> patch we are interested in removing.  As it claims to be
> only removing redundant code, it probably should never
> have been backported in the first place.

While it is redundant for ld.bfd, it causes a build failure with the
release version of ld.lld:

https://github.com/ClangBuiltLinux/linux/issues/31

Cheers,
Nathan
