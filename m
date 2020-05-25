Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771C11E1563
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390801AbgEYUzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbgEYUzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 16:55:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 567A02065F;
        Mon, 25 May 2020 20:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440149;
        bh=n5H4ja8aDw+BQtvjhFS0ngEeQKrVUOPjosJWZ9eqlNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPTR6OB7FP8R4aHL6f5hc3SsIju4iFvPW/xqglj0k+612KRawzQccLcNvKkqKyGxZ
         l41ICVIjafpGBWanTVMoqNdcYRecXwuY+YSFRBmIJokJ9JdgSVOzfpH8DS/wlqZ0k/
         CSnijBj4Iqy9j8cNBUG14t8eeiEbMfWs5RXkNGd4=
Date:   Mon, 25 May 2020 16:55:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Phil Auld <pauld@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix enqueue_task_fair()
 warning some more" failed to apply to 5.6-stable tree
Message-ID: <20200525205548.GE33628@sasha-vm>
References: <1590417756152233@kroah.com>
 <CAKfTPtCdYVG3KbE4RixXYMEv=yQNu5zMutS7bTk4dAHqSxhs7A@mail.gmail.com>
 <20200525154918.GB1039448@kroah.com>
 <CAKfTPtCCegv884Rd03hB9doLM8_JSFY=tg7dFaWgOYsGLYjNEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKfTPtCCegv884Rd03hB9doLM8_JSFY=tg7dFaWgOYsGLYjNEg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 05:55:03PM +0200, Vincent Guittot wrote:
>On Mon, 25 May 2020 at 17:49, gregkh@linuxfoundation.org
><gregkh@linuxfoundation.org> wrote:
>>
>> On Mon, May 25, 2020 at 05:41:36PM +0200, Vincent Guittot wrote:
>> > On Mon, 25 May 2020 at 16:42, <gregkh@linuxfoundation.org> wrote:
>> > >
>> > >
>> > > The patch below does not apply to the 5.6-stable tree.
>> > > If someone wants it applied there, or to any other stable or longterm
>> > > tree, then please email the backport, including the original git commit
>> > > id to <stable@vger.kernel.org>.
>> >
>> > This patch applies on top of
>> > commit 6d4d22468dae ("sched/fair: Reorder enqueue/dequeue_task_fair path")
>>
>> That applies, but:
>>
>> > commit 5ab297bab984 ("sched/fair: Fix reordering of
>> > enqueue/dequeue_task_fair()")
>>
>> That one does not.
>>
>> Can you make a backported patch series of these that I can apply easily?
>
>I tested the cherry-pick of the 2 commits above on top of v5.6.14 and
>there were applying without error. Should I use another tag ?

That worked for me, I've queued it up.

-- 
Thanks,
Sasha
