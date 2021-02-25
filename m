Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDA8324BCD
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhBYIKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbhBYIKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 03:10:15 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DD1C061788
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 00:09:34 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id w11so4269670wrr.10
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 00:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RiN2cMKC+xppmO732DXmQGbrhZydASnzlrEnedGOXzk=;
        b=uz8UY5WABQ1HPTdrd0DwD7/+9T18JDPE2qP3nlNToxyH4/CNdzlBOcl2wcOiAm2xl+
         kZN1T1vKaXZm3l47Y281/BtBFbFvYHfZgkHvWkoTJFjK5B/dsvzaAgPnYXdKxbVXGt5D
         nNMu5mbuhLBdgGYoGJDIAbe3UxU46BXq061ppegxYHvA5n3/KrnR9HgL47p1FZkruNdA
         ZlNTKkeR1qgn81R10e1GLC76t8bx34rJJ0AtimZWYl7N9iogYF7cxwva0VxGFdY0tasd
         LiqiVcjGrjcnXYZXKVO72rCdrjgzXZvpTHGxuJO6eI1TjEdk/F5kI+gkcZt0Sr6ezEEc
         D59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RiN2cMKC+xppmO732DXmQGbrhZydASnzlrEnedGOXzk=;
        b=lJfBFy6CcjhlD471zUxmn0r8ZrF3bKS0qIrWbxcq5nDn1VxYMlHoL8DlqNY8pnLgOO
         E3pYe/goGmdDEvb6oeaXmlKgarC9Si61fbuGD86cS4z/1tMIwuv5Uma8j1pm0/9p5PXA
         P9FpX2ukkLhPXSRMaiX22iRcCSTR/Ma2y94mO4iBYV3V34R3XEWgqjvYTivq3apxlm4R
         qn1uPzDWfdQn2Wden3+j7/vHq/tZtUh2n+j+2D/Fu+hVPS+GGb9gBKGczS8Oqow9jq6T
         5WOkhTGJFXEmoPKoUAByox8niYJADJxkEAC/Vc6+zy4cJziLhk8NSQurqQjsFddc5PS2
         0WqA==
X-Gm-Message-State: AOAM532BS6q/YcJ+o8ikYts6FagISTXWuzzu2MttvlAzhUNlnZSp8FJS
        bkDYPbqCG7EV0xi7WAS+NJsp5d5wPKeJXw==
X-Google-Smtp-Source: ABdhPJxpeMmvf6CphQDye6ONrdfqLu2AHEXTJlN9fCIJ9VGJ3RJAsLyNggV8hsXDMhQ/CGWZm4KksQ==
X-Received: by 2002:a05:6000:89:: with SMTP id m9mr2113738wrx.3.1614240573667;
        Thu, 25 Feb 2021 00:09:33 -0800 (PST)
Received: from dell ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id h17sm6676991wrt.74.2021.02.25.00.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 00:09:32 -0800 (PST)
Date:   Thu, 25 Feb 2021 08:09:30 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com
Subject: Re: [PATCH 4.9.y 1/1] futex: Fix OWNER_DEAD fixup
Message-ID: <20210225080930.GB641347@dell>
References: <20210223144151.916675-1-zhengyejian1@huawei.com>
 <20210223144151.916675-2-zhengyejian1@huawei.com>
 <20210224111915.GA641347@dell>
 <09cd79ce-291a-1750-6954-ecde0a6bdfcf@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09cd79ce-291a-1750-6954-ecde0a6bdfcf@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Feb 2021, Zhengyejian (Zetta) wrote:

> 
> 
> On 2021/2/24 19:19, Lee Jones wrote:
> > On Tue, 23 Feb 2021, Zheng Yejian wrote:
> > 
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
> > > 
> > > Both Geert and DaveJ reported that the recent futex commit:
> > > 
> > >    c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> > > 
> > > introduced a problem with setting OWNER_DEAD. We set the bit on an
> > > uninitialized variable and then entirely optimize it away as a
> > > dead-store.
> > > 
> > > Move the setting of the bit to where it is more useful.
> > > 
> > > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Reported-by: Dave Jones <davej@codemonkey.org.uk>
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: Paul E. McKenney <paulmck@us.ibm.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> > > Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
> > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> > 
> > Why have you dropped my Reviewed-by?
> > 
> Really sorry. I thought that a changed patchset needs another review.
> Then I do need to append your Reviewed-by and send a "V2" patchset, Do I?

No need.  I won't hold up merging just for that.

Just bear in mind that you should apply and carry forward *-by tags
unless there have been significant/functional changes.

Reviewed-by: Lee Jones <lee.jones@linaro.org>

> > > ---
> > >   kernel/futex.c | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/kernel/futex.c b/kernel/futex.c
> > > index b65dbb5d60bb..604d1cb9839d 100644
> > > --- a/kernel/futex.c
> > > +++ b/kernel/futex.c
> > > @@ -2424,9 +2424,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
> > >   	int err = 0;
> > >   	oldowner = pi_state->owner;
> > > -	/* Owner died? */
> > > -	if (!pi_state->owner)
> > > -		newtid |= FUTEX_OWNER_DIED;
> > >   	/*
> > >   	 * We are here because either:
> > > @@ -2484,6 +2481,9 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
> > >   	}
> > >   	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
> > > +	/* Owner died? */
> > > +	if (!pi_state->owner)
> > > +		newtid |= FUTEX_OWNER_DIED;
> > >   	if (get_futex_value_locked(&uval, uaddr))
> > >   		goto handle_fault;
> > 

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
