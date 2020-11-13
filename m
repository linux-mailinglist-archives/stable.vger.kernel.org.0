Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131932B205C
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 17:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKMQZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 11:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgKMQZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 11:25:38 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7123EC0613D1;
        Fri, 13 Nov 2020 08:25:38 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c66so8045829pfa.4;
        Fri, 13 Nov 2020 08:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MnQ23HCE0ZI7qhFXn6nl37F0XxyVN9I61UA+Y02bRi8=;
        b=lwHPFmdEWRvcdri67q/6P2FbJENUCnCnPl8sdwmtlDeJ1JXCKfT/6wEudf3CYb9+S1
         0scBTx6ykcEoSBUCbLFzZVLJiJYcxpwE2VECv5KPea1B6YMbg4SIYMlqffdKPO3jjL74
         a5Q+MHdbniSkaZZwWle6qR8Tlx6Q7d9DsTBU5KINBjJR8Y0XCsZW+e8YtwMU+CoU6ACf
         cTOmhMkldrbsEZ1aI4Or9hIveA6kti+3wJe3FUT7w2nEMZP0I6tgYuO3pzMeluD7m99Z
         WbycrDv+DXOzkbsYHecxKzfVOOocCcXr4UHxobvgCVeZWYaKB7AMz5OvSbUVQ0ybWAau
         HzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MnQ23HCE0ZI7qhFXn6nl37F0XxyVN9I61UA+Y02bRi8=;
        b=TMwND+ZGni0yPrI0USHfh4H04vsygct8Irw0PddGCVtPs0PxCahWQS4Fzn9k9uYRkt
         XAJgJsWYrk5ySf2D5yCXykXA4QiTu2aLvXfecn1bo/AKlMu6uoeHzE1ukqahtc5b7E4q
         6+8hpstuAOIowiQE8eLNJYdAJIVxseSyYhN3cE5VZ+6+bPdi9a2P8wTxyyjuLob7ecsd
         NEymFwiASG4czMnmk29Ss2WvKwfbFogbf1vcnVAioL+3biz7KKk1rp2fml6PW5IvKrtK
         Xe4KRpx6d7iriGOB1idH9Z8vl5JcCVxA+NDZ6E8CSjpuVwJRYwCp9xoySA2JOr4BArCi
         kROQ==
X-Gm-Message-State: AOAM533B3ufmHb6Dwpjhkg2jbvvTqSPOuXZonFmwa9Vk5m2NbDcAWpVr
        uxj/6LjakPw7mS0R42hnMyXQ4CJqfbs=
X-Google-Smtp-Source: ABdhPJz+FPzyF4yVbx++2H21xVfP1XR4cB7Li4tsy6vuvvX+vAmSDkShcU+ZR5QhQTk5cPovnPB0tg==
X-Received: by 2002:a17:90b:784:: with SMTP id l4mr3906651pjz.56.1605284733023;
        Fri, 13 Nov 2020 08:25:33 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id e10sm9993725pfh.38.2020.11.13.08.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:25:31 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 13 Nov 2020 08:25:29 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201113162529.GA2378542@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 02:49:19PM -0800, Andrew Morton wrote:
> On Thu, 12 Nov 2020 12:01:01 -0800 Minchan Kim <minchan@kernel.org> wrote:
> 
> > 
> > On Sat, Nov 07, 2020 at 12:39:39AM -0800, Minchan Kim wrote:
> > > Hi Andrew,
> > > 
> > > On Fri, Nov 06, 2020 at 05:59:33PM -0800, Andrew Morton wrote:
> > > > On Thu,  5 Nov 2020 09:02:49 -0800 Minchan Kim <minchan@kernel.org> wrote:
> > > > 
> > > > > This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> > > > > 
> > > > > While I was doing zram testing, I found sometimes decompression failed
> > > > > since the compression buffer was corrupted. With investigation,
> > > > > I found below commit calls cond_resched unconditionally so it could
> > > > > make a problem in atomic context if the task is reschedule.
> > > > > 
> > > > > Revert the original commit for now.
> >
> > How should we proceed this problem?
> >
> 
> (top-posting repaired - please don't).
> 
> Well, we don't want to reintroduce the softlockup reports which
> e47110e90584a2 fixed, and we certainly don't want to do that on behalf
> of code which is using the unmap_kernel_range() interface incorrectly.
> 
> So I suggest either
> 
> a) make zs_unmap_object() stop doing the unmapping from atomic context or

It's not easy since the path already hold several spin_locks as well as
per-cpu context. I could pursuit the direction but it takes several
steps to change entire locking scheme in the zsmalloc, which will
take time(we couldn't leave zsmalloc broken until then) and hard to
land on stable tree.

> 
> b) figure out whether the vmalloc unmap code is *truly* unsafe from
>    atomic context - perhaps it is only unsafe from interrupt context,
>    in which case we can rework the vmalloc.c checks to reflect this, or

I don't get the point. I assume your suggestion would be "let's make the
vunmap code atomic context safe" but how could it solve this problem?
     
The point from e47110e90584a2 was softlockup could be triggered if
vunamp deal with large mapping so need *explict reschedule* point
for CONFIG_PREEMPT_VOLUNTARY. However, CONFIG_PREEMPT_VOLUNTARY
doesn't consider peempt count so even though we could make vunamp
atomic safe to make a call under spin_lock:

spin_lock(&A);
vunmap
  vunmap_pmd_range
    cond_resched <- bang
 
Below options would have same problem, too.
Let me know if I misunderstand something.

> 
> c) make the vfree code callable from all contexts.  Which is by far
>    the preferred solution, but may be tough.
> 
> 
> Or maybe not so tough - if the only problem in the vmalloc code is the
> use of mutex_trylock() from irqs then it may be as simple as switching
> to old-style semaphores and using down_trylock(), which I think is
> irq-safe.
> 
> However old-style semaphores are deprecated.  A hackyish approach might
> be to use an rwsem always in down_write mode and use
> down_write_trylock(), which I think is also callable from interrrupt
> context.
> 
> But I have a feeling that there are other reasons why vfree shouldn't
> be called from atomic context, apart from the mutex_trylock-in-irq
> issue.
