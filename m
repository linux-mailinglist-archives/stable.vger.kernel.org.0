Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285E93CF7B4
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 12:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhGTJkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 05:40:21 -0400
Received: from foss.arm.com ([217.140.110.172]:55304 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236690AbhGTJjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 05:39:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1FD36D;
        Tue, 20 Jul 2021 03:18:41 -0700 (PDT)
Received: from [10.57.6.251] (unknown [10.57.6.251])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AD943F73D;
        Tue, 20 Jul 2021 03:18:38 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] PM: EM: Increase energy calculation precision
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Chris.Redpath@arm.com,
        dietmar.eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, vincent.guittot@linaro.org,
        mingo@redhat.com, juri.lelli@redhat.com, rostedt@goodmis.org,
        segall@google.com, mgorman@suse.de, bristot@redhat.com,
        CCj.Yeh@mediatek.com
References: <20210720094153.31097-1-lukasz.luba@arm.com>
 <20210720094153.31097-2-lukasz.luba@arm.com> <YPabR/dfllPVZbzu@kroah.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <3578f5dc-fc6c-da1d-9bf5-092522a35f97@arm.com>
Date:   Tue, 20 Jul 2021 11:18:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <YPabR/dfllPVZbzu@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 7/20/21 10:45 AM, Greg KH wrote:
> On Tue, Jul 20, 2021 at 10:41:53AM +0100, Lukasz Luba wrote:

[snip]

>>
>> Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
>> Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
>> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
>> ---
>>   include/linux/energy_model.h | 16 ++++++++++++++++
>>   kernel/power/energy_model.c  |  3 ++-
>>   2 files changed, 18 insertions(+), 1 deletion(-)
>>
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 

I shouldn't have sent to CC -stable for now.
I will create and send a dedicated patch for stable
with proper commit ID after it's merged (like I did last time).
We are heading to stable 5.4+ (so the Android could get it).

Regards,
Lukasz
