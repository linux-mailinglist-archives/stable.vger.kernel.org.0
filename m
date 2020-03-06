Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A01B17BC9E
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCFMTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:19:25 -0500
Received: from foss.arm.com ([217.140.110.172]:60510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgCFMTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 07:19:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93F6D31B;
        Fri,  6 Mar 2020 04:19:24 -0800 (PST)
Received: from [192.168.0.7] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D1943F6C4;
        Fri,  6 Mar 2020 04:19:22 -0800 (PST)
Subject: Re: [PATCH] sched/fair: fix enqueue_task_fair warning
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "# v4 . 16+" <stable@vger.kernel.org>
References: <20200305172921.22743-1-vincent.guittot@linaro.org>
 <e31aa232-bc7e-a7b9-5b6a-a1131ac88164@arm.com>
 <CAKfTPtAqg+CGNBHF53dXp4BcmtucgW4k4skQ1x1jxuyo0PDaMg@mail.gmail.com>
 <CAKfTPtB8YrVd=DjPXCs589wCJWT_Jo_dyLQ4WMdEKPTAt5GRvw@mail.gmail.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <73cc2b4b-9803-32ff-dc01-adbe4f8ba149@arm.com>
Date:   Fri, 6 Mar 2020 13:19:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAKfTPtB8YrVd=DjPXCs589wCJWT_Jo_dyLQ4WMdEKPTAt5GRvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/03/2020 13:07, Vincent Guittot wrote:
> On Fri, 6 Mar 2020 at 10:12, Vincent Guittot <vincent.guittot@linaro.org> wrote:
>>
>> On Thu, 5 Mar 2020 at 20:07, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>>>
>>> On 05/03/2020 18:29, Vincent Guittot wrote:

[...]

> If it's fine for you, I'm going to add this in a new version of the patch

Yes, please do.

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

[...]

>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index e9fd5379bb7e..5e03be046aba 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -4627,11 +4627,17 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>>>                         break;
>>>         }
>>>
>>> -       assert_list_leaf_cfs_rq(rq);
>>> -
>>>         if (!se)
>>>                 add_nr_running(rq, task_delta);
>>>
> 
> will add similar comment  as for enqueue_task_fair

Sounds good.

[...]
