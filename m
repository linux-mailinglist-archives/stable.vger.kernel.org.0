Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA7721354F
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 09:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgGCHn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 03:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgGCHn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 03:43:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194B7C08C5DD
        for <stable@vger.kernel.org>; Fri,  3 Jul 2020 00:43:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so14706557pge.12
        for <stable@vger.kernel.org>; Fri, 03 Jul 2020 00:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YMA1iG2DR+aP68KXSdCOsvrFA0oomq7Nb72Iy6OynAc=;
        b=eOjpfDnUhW2ER3jbX+CxmRW1kTHS4ha9+B04YjM9WkSWY+zXrVbJT2nho+GrVniC88
         BnCjbPqTEu6VpWFtFGMj8bLBasFsETuYhAbwBNQCzQFS7/Vb+t1pLMbXFG835Zj+IsRL
         0W4UyF6ZzUUbTTsMtdXLYyxRplXcQDfKVICAn/Few/slDEK1DkowMQLsI/xXyPvDgh5c
         l5elsPzMyrdTcr9fRdsfHJcByOUqB70ZECB//QgmXcR/LBlYIPBy314lkiaUv/SDGmeh
         hiuDlBOP9XLlVd7AXYw11Cei7ORRt06qDlfLL14hhhgAbJmIEOQbm9V+1tOSQeCRD51I
         TVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YMA1iG2DR+aP68KXSdCOsvrFA0oomq7Nb72Iy6OynAc=;
        b=O8hewSRMoIerTNwADDwxT2R5O0RAtdziu7JKNBdDRr8+xz38HD/Ajh5/H2RJtRz/ST
         SNcRqKTRnXpIf5TpNolICIYR11t1DuDe+R5M2/ezj3qUb0jjDQhyc+xRKWGIko3VoBjZ
         sFLfSD8nB6nJdRomdHhwaTJDSlokOqU36qkyxg1EK5Nn4pz3m+Qxho3OohkThWRTB7dL
         1YLVoRNSrfxqN1pzbgbMTMMPBRf7r0qAJyEIELD0XDAiHvalLj3WNK2kd/BKQwCC+hdT
         qKFnIjpU5SgQOTCZTHcHBXbNf0PvTLGekvveyKr2jT29dNLeUmoLH27jiDkIeir3iaJX
         uhnQ==
X-Gm-Message-State: AOAM5319BBkqAaGu+bqeqfhQL1QkOR89J4BUJDY4i5BCnrTwBp14cYSz
        lNuaLrYMIUrUEaDnwyKjB/KWTRZIUVY=
X-Google-Smtp-Source: ABdhPJxs34VyOJKNvK67gXc9kQBjJa6obMlUr6G9NDi43bUnL4tffZoy9+osusLsDh0iM0haQ0giAQ==
X-Received: by 2002:a65:63c4:: with SMTP id n4mr15600593pgv.230.1593762236641;
        Fri, 03 Jul 2020 00:43:56 -0700 (PDT)
Received: from localhost ([122.172.40.201])
        by smtp.gmail.com with ESMTPSA id 73sm10987491pfy.24.2020.07.03.00.43.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:43:55 -0700 (PDT)
Date:   Fri, 3 Jul 2020 13:13:54 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [FOR-STABLE-3.9+] sched/rt: Show the 'sched_rr_timeslice'
 SCHED_RR timeslice tuning knob in milliseconds
Message-ID: <20200703074354.btmylgn5mxhbxywc@vireshk-i7>
References: <ffdfb849a11b9cd66e0aded2161869e36aec7fc0.1593757471.git.viresh.kumar@linaro.org>
 <20200703074025.GA2390868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703074025.GA2390868@kroah.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03-07-20, 09:40, Greg KH wrote:
> On Fri, Jul 03, 2020 at 12:54:04PM +0530, Viresh Kumar wrote:
> > From: Shile Zhang <shile.zhang@nokia.com>
> > 
> > We added the 'sched_rr_timeslice_ms' SCHED_RR tuning knob in this commit:
> > 
> >   ce0dbbbb30ae ("sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice")
> > 
> > ... which name suggests to users that it's in milliseconds, while in reality
> > it's being set in milliseconds but the result is shown in jiffies.
> > 
> > This is obviously confusing when HZ is not 1000, it makes it appear like the
> > value set failed, such as HZ=100:
> > 
> >   root# echo 100 > /proc/sys/kernel/sched_rr_timeslice_ms
> >   root# cat /proc/sys/kernel/sched_rr_timeslice_ms
> >   10
> > 
> > Fix this to be milliseconds all around.
> > 
> > Cc: <stable@vger.kernel.org> # v3.9+
> > Signed-off-by: Shile Zhang <shile.zhang@nokia.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Link: http://lkml.kernel.org/r/1485612049-20923-1-git-send-email-shile.zhang@nokia.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> What is the git commit id of this patch in Linus's tree?

I am really sorry for missing the only thing I was required to do :(

commit 975e155ed8732cb81f55c021c441ae662dd040b5 upstream.

-- 
viresh
