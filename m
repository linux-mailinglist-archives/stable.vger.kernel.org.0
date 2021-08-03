Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE383DEF21
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 15:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhHCNbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 09:31:37 -0400
Received: from foss.arm.com ([217.140.110.172]:50174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236344AbhHCNbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 09:31:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDDA611FB;
        Tue,  3 Aug 2021 06:31:25 -0700 (PDT)
Received: from [10.57.9.114] (unknown [10.57.9.114])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FEB73F70D;
        Tue,  3 Aug 2021 06:31:20 -0700 (PDT)
Subject: Re: [PATCH v3] PM: EM: Increase energy calculation precision
To:     linux-kernel@vger.kernel.org, rjw@rjwysocki.net
Cc:     Chris.Redpath@arm.com, dietmar.eggemann@arm.com,
        morten.rasmussen@arm.com, qperret@google.com,
        linux-pm@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org,
        vincent.guittot@linaro.org, mingo@redhat.com,
        juri.lelli@redhat.com, rostedt@goodmis.org, segall@google.com,
        mgorman@suse.de, bristot@redhat.com, CCj.Yeh@mediatek.com
References: <20210803102744.23654-1-lukasz.luba@arm.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <4e6b02fb-b421-860b-4a07-ed6cccdc1570@arm.com>
Date:   Tue, 3 Aug 2021 14:31:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210803102744.23654-1-lukasz.luba@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rafael,

On 8/3/21 11:27 AM, Lukasz Luba wrote:

[snip]

> 
> Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
> Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> ---
> 
> v3 changes:
> - adjusted patch description according to Dietmar's comments
> - added Dietmar's review tag
> - added one empty line in the code to separate them
> 
>   include/linux/energy_model.h | 16 ++++++++++++++++
>   kernel/power/energy_model.c  |  4 +++-
>   2 files changed, 19 insertions(+), 1 deletion(-)
> 

Could you take this patch via your PM tree, please?

Regards,
Lukasz
