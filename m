Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BE5214CC6
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 15:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGENan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 09:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgGENam (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jul 2020 09:30:42 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F89220771;
        Sun,  5 Jul 2020 13:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593955842;
        bh=uZhavRfS83kzq/SUf4yegabPSTT9sCmTWgMYRuGVoLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RfX9f/ChfM6YRkPguNwad1Lr9jG7JWtUIbsIMF/4JvPOAukTE7pX9UWjGZOW6aaqZ
         DaauDysuYpJe5bVVpoHd7oAeHV1vG5phWlBSHVV3tkATQxwSbjI6nOGksYdKdZKe6u
         yGnmAPa/NhR4kyybxjc35qNv42tNeLMoqmwrW3ig=
Date:   Sun, 5 Jul 2020 09:30:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [FOR-STABLE-3.9+] sched/rt: Show the 'sched_rr_timeslice'
 SCHED_RR timeslice tuning knob in milliseconds
Message-ID: <20200705133041.GI2722994@sasha-vm>
References: <ffdfb849a11b9cd66e0aded2161869e36aec7fc0.1593757471.git.viresh.kumar@linaro.org>
 <20200703074025.GA2390868@kroah.com>
 <20200703074354.btmylgn5mxhbxywc@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200703074354.btmylgn5mxhbxywc@vireshk-i7>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 01:13:54PM +0530, Viresh Kumar wrote:
>On 03-07-20, 09:40, Greg KH wrote:
>> On Fri, Jul 03, 2020 at 12:54:04PM +0530, Viresh Kumar wrote:
>> > From: Shile Zhang <shile.zhang@nokia.com>
>> >
>> > We added the 'sched_rr_timeslice_ms' SCHED_RR tuning knob in this commit:
>> >
>> >   ce0dbbbb30ae ("sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice")
>> >
>> > ... which name suggests to users that it's in milliseconds, while in reality
>> > it's being set in milliseconds but the result is shown in jiffies.
>> >
>> > This is obviously confusing when HZ is not 1000, it makes it appear like the
>> > value set failed, such as HZ=100:
>> >
>> >   root# echo 100 > /proc/sys/kernel/sched_rr_timeslice_ms
>> >   root# cat /proc/sys/kernel/sched_rr_timeslice_ms
>> >   10
>> >
>> > Fix this to be milliseconds all around.
>> >
>> > Cc: <stable@vger.kernel.org> # v3.9+
>> > Signed-off-by: Shile Zhang <shile.zhang@nokia.com>
>> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> > Cc: Mike Galbraith <efault@gmx.de>
>> > Cc: Peter Zijlstra <peterz@infradead.org>
>> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > Link: http://lkml.kernel.org/r/1485612049-20923-1-git-send-email-shile.zhang@nokia.com
>> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> What is the git commit id of this patch in Linus's tree?
>
>I am really sorry for missing the only thing I was required to do :(
>
>commit 975e155ed8732cb81f55c021c441ae662dd040b5 upstream.

I've queued it for 4.9 and 4.4.

-- 
Thanks,
Sasha
