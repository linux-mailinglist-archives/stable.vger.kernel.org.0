Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B753E11C7
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbhHEKAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 06:00:17 -0400
Received: from foss.arm.com ([217.140.110.172]:42106 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239980AbhHEKAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 06:00:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 373706D;
        Thu,  5 Aug 2021 03:00:03 -0700 (PDT)
Received: from [10.57.6.87] (unknown [10.57.6.87])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BE503F719;
        Thu,  5 Aug 2021 02:59:59 -0700 (PDT)
Subject: Re: [PATCH v3] PM: EM: Increase energy calculation precision
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Chris Redpath <Chris.Redpath@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@google.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, segall@google.com,
        Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        CCj.Yeh@mediatek.com
References: <20210803102744.23654-1-lukasz.luba@arm.com>
 <4e6b02fb-b421-860b-4a07-ed6cccdc1570@arm.com>
 <CAJZ5v0hgpM+ErHMTYLFFasvn=Ptc0MyaaFn=HSxOcGcDcBwMVg@mail.gmail.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <c23f8fac-4515-5891-0778-18e65eeb7087@arm.com>
Date:   Thu, 5 Aug 2021 10:59:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0hgpM+ErHMTYLFFasvn=Ptc0MyaaFn=HSxOcGcDcBwMVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/4/21 7:10 PM, Rafael J. Wysocki wrote:
> On Tue, Aug 3, 2021 at 3:31 PM Lukasz Luba <lukasz.luba@arm.com> wrote:
>>
>> Hi Rafael,
>>
>> On 8/3/21 11:27 AM, Lukasz Luba wrote:
>>
>> [snip]
>>
>>>
>>> Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
>>> Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
>>> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
>>> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
>>> ---
>>>
>>> v3 changes:
>>> - adjusted patch description according to Dietmar's comments
>>> - added Dietmar's review tag
>>> - added one empty line in the code to separate them
>>>
>>>    include/linux/energy_model.h | 16 ++++++++++++++++
>>>    kernel/power/energy_model.c  |  4 +++-
>>>    2 files changed, 19 insertions(+), 1 deletion(-)
>>>
>>
>> Could you take this patch via your PM tree, please?
> 
> I can do that, but do you want a Cc:stable tag on it?
> 

No, thank you. I'll prepare a dedicated patches and send them after this
patch gets a proper commit ID. I've done similar things recently with
some thermal stuff and different stable versions [1].

Please take this patch. I will handle the stable testing, preparation
separately.

Regards,
Lukasz

[1] https://lore.kernel.org/lkml/20210514104916.19975-1-lukasz.luba@arm.com/
