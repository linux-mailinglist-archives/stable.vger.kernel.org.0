Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DACD3E2D62
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242844AbhHFPOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 11:14:21 -0400
Received: from foss.arm.com ([217.140.110.172]:34680 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234841AbhHFPOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 11:14:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C96DF1042;
        Fri,  6 Aug 2021 08:14:03 -0700 (PDT)
Received: from [10.57.9.90] (unknown [10.57.9.90])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F3773F66F;
        Fri,  6 Aug 2021 08:13:59 -0700 (PDT)
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
 <c23f8fac-4515-5891-0778-18e65eeb7087@arm.com>
 <CAJZ5v0iB_vbbqzee6HSoLbVwVBWMmpvHWLZ_5_neWWqXr1JqoQ@mail.gmail.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <fca3c5a9-a756-da87-698a-584effec8488@arm.com>
Date:   Fri, 6 Aug 2021 16:13:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0iB_vbbqzee6HSoLbVwVBWMmpvHWLZ_5_neWWqXr1JqoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/6/21 2:32 PM, Rafael J. Wysocki wrote:

[snip]

> 
> OK, applied as 5.15 material.

Thank you Rafael!

> 
> However, since I'm on vacation next week, it will show up in
> linux-next after -rc6.

No worries. Have a nice vacation!
