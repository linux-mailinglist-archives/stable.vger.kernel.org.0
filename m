Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1B1C7531
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 17:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgEFPl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 11:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgEFPlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 11:41:52 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828BC061A0F;
        Wed,  6 May 2020 08:41:51 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e20so1695319otk.12;
        Wed, 06 May 2020 08:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/4Bf7uYJizHHCHu/IYW7D03zmrwhqK6qEQ4Buf+txbw=;
        b=O41+Bmx8B9NB10qlOMxkKc0/Rv3M6Si5CS/dzS1zYHq3s3oh4P78J7myxdWBSa8y7s
         TD5F8clLMBWSS1ZLwUnEC80SEY2vxP/eG5egZesXB3oTOocuQV8YKmYGSHFexTzy0lQA
         x6c14L+ldRqF5Nd/eK3gLz7QSa2FI5PiEnU0D8seFKuPxVS/oBHGIha5cS/7p9Mouuqe
         THcE6aPAzEfYI65zy/Ffx4s5unLOIJsNqQTlboU+HHBE1Grx2Ouxkr8TIdBtuUd2PCjM
         4f0tdzFCeGgvCPpfNRoGlgdhQY/+lGA6IoNjql+Ks0i2xqgQYonpZV09sQOuXW/qsynV
         NnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/4Bf7uYJizHHCHu/IYW7D03zmrwhqK6qEQ4Buf+txbw=;
        b=snOQJvCxRngpebz6HC0Kjk20I6iK1mEENBfM+7I0Xv/ZOP3lbGcEdUM6kv850bBhRe
         wHIMNFK3G8ZaQJQuxLUqWWtVhTCmnyt2Pu/mL0S+UUMOgZLpun3p4hXni5rGP7JoQMx+
         gXexA82wr1Vn+/vaZNabk8RR3Zx2+iHLig8q8STf/lFqxIfkEczJCE8WhM0EG4NfOKkW
         d6R174ZVXwiWbhPsstmLxLa2/noMcxCcVhfMaVP9G7ZD8pxQwtXRGO8hq/50Z+tqtCbr
         y6AK4JT8uL/y8eaHh0fA2rE8qTCUOLkcxPNKXKDjb84IGMRrIJMTezD4rxxy+56TKORm
         sgSA==
X-Gm-Message-State: AGi0Puay2YBpaucN9nnfhh0zgdkwwXKX0n0qEuc4d9XhGHzjtFsaJNyP
        wmLj9RWaTJzwTY+6rbzr5gk=
X-Google-Smtp-Source: APiQypII0o5v6UpXX6yiU/YBF8h71UF/2SWu7x/H3RFRnCZA7CNKMbDeTyEgZQ762wQ2tp22LhtsWQ==
X-Received: by 2002:a9d:569:: with SMTP id 96mr6710053otw.59.1588779710938;
        Wed, 06 May 2020 08:41:50 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id k19sm655259oof.33.2020.05.06.08.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:41:50 -0700 (PDT)
Date:   Wed, 6 May 2020 08:41:48 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] x86: bitops: fix build regression
Message-ID: <20200506154148.GC1213645@ubuntu-s3-xlarge-x86>
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <20200506043028.GA663805@ubuntu-s3-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506043028.GA663805@ubuntu-s3-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 09:30:28PM -0700, Nathan Chancellor wrote:
> On Tue, May 05, 2020 at 10:44:22AM -0700, Nick Desaulniers wrote:
> > From: Sedat Dilek <sedat.dilek@gmail.com>
> > 
> > It turns out that if your config tickles __builtin_constant_p via
> > differences in choices to inline or not, this now produces invalid
> > assembly:
> > 
> > $ cat foo.c
> > long a(long b, long c) {
> >   asm("orb\t%1, %0" : "+q"(c): "r"(b));
> >   return c;
> > }
> > $ gcc foo.c
> > foo.c: Assembler messages:
> > foo.c:2: Error: `%rax' not allowed with `orb'
> > 
> > The "q" constraint only has meanting on -m32 otherwise is treated as
> > "r".
> > 
> > This is easily reproducible via Clang+CONFIG_STAGING=y+CONFIG_VT6656=m,
> > or Clang+allyesconfig.
> 
> For what it's worth, I don't see this with allyesconfig.
> 
> > Keep the masking operation to appease sparse (`make C=1`), add back the
> > cast in order to properly select the proper 8b register alias.
> > 
> >  [Nick: reworded]
> > 
> > Cc: stable@vger.kernel.org
> 
> The offending commit was added in 5.7-rc1; we shouldn't need to
> Cc stable since this should be picked up as an -rc fix.
> 
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/961
> > Link: https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
> > Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Reported-by: kernelci.org bot <bot@kernelci.org>
> > Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> > Suggested-by: Ilie Halip <ilie.halip@gmail.com>
> 
> Not to split hairs but this is Ilie's diff, he should probably be the
> author with Sedat's Reported-by/Tested-by.
> 
> https://github.com/ClangBuiltLinux/linux/issues/961#issuecomment-608239458
> 
> But eh, it's all a team effort plus that can only happen with Ilie's
> explicit consent for a Signed-off-by.
> 
> I am currently doing a set of builds with clang-11 with this patch on
> top of 5.7-rc4 to make sure that all of the cases I have found work.
> Once that is done, I'll comment back with a tag.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com> # build

> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  arch/x86/include/asm/bitops.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> > index b392571c1f1d..139122e5b25b 100644
> > --- a/arch/x86/include/asm/bitops.h
> > +++ b/arch/x86/include/asm/bitops.h
> > @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> >  	if (__builtin_constant_p(nr)) {
> >  		asm volatile(LOCK_PREFIX "orb %1,%0"
> >  			: CONST_MASK_ADDR(nr, addr)
> > -			: "iq" (CONST_MASK(nr) & 0xff)
> > +			: "iq" ((u8)(CONST_MASK(nr) & 0xff))
> >  			: "memory");
> >  	} else {
> >  		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
> > @@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
> >  	if (__builtin_constant_p(nr)) {
> >  		asm volatile(LOCK_PREFIX "andb %1,%0"
> >  			: CONST_MASK_ADDR(nr, addr)
> > -			: "iq" (CONST_MASK(nr) ^ 0xff));
> > +			: "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
> >  	} else {
> >  		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
> >  			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");
> > -- 
> > 2.26.2.526.g744177e7f7-goog
> > 
> 
> Cheers,
> Nathan
