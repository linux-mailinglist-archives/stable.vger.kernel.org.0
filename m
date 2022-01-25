Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8249BBAC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiAYS7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiAYS7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 13:59:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB98C06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:59:16 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h23so18981712pgk.11
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :references:subject:in-reply-to:content-transfer-encoding;
        bh=eEBhYECc456yS/ubFRrgpFaPneFUr70Aki0nZIzi2v0=;
        b=x0TRBh+GiHpUMqToWed0UOGJ2NQGtQo4WXEDTzRWlkYuQz0ALrjg3nODcoJ5M1a5jX
         dq6SYVSHHyQqScnmjiAVNeFSmu4aFUbAM9TjKZia5s19O4qlTWmBzx3hKZsabAAE69qB
         xjMrjz6oeBpBEM0jixn6bLHfBaelQP7x6/zbCcYHypjLLez6iRAXaB9w7fD1dwY0FTwb
         00m+aMOxtkGSVxQsejLATKnfw8KlABX9JueClxKE4Dg2UhfTYUrHoEymZ3QdBBQ89LqV
         rY0r34s05HDgMpDHXUYjtPSV7FSEVrxMvgX7NJg4hY0JTjhtisSmbfszeDWWmjJa1nZs
         LJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=eEBhYECc456yS/ubFRrgpFaPneFUr70Aki0nZIzi2v0=;
        b=j9kT1cXuKw0dXhl9RGTmUyERNCGWSogfFqBX4l3yPSkGckHzZ2fV3SMJg4bf6cRGI0
         hMAQ6szG2XKHi3BHARSNZXYBOuSKjdXhDuCW9du6eNcCLPCCIRWRNjg5IxzuUXCpx5Kh
         cLiYfCWXNHCppNF4Z+82aeTdwHNE0zu6MlvswURsRBxkALAHGlYSbXS608H3kKEN3BCd
         cR8Jukjj7eYlEoQK491Iziw4ELH0Cv6H5U78jFqnJYkxXvyBlzB2w9+XyTeuYHI6yoE+
         2rb4wtvhR85fJfN0M0dutZFBJ0mdZ3PaoLK19cWTAaDaTWBdCPPh17ampFJgJJLgmY23
         DMgQ==
X-Gm-Message-State: AOAM533NdBm7M17YPH2lZKO/6Kzyf7Fau7WXwZiIEwv/2099+ZS86JM1
        yXeVFdqxMxUg9ymczqSUVLoFKw==
X-Google-Smtp-Source: ABdhPJxx7WltL1UcIHI6/h9J6KiGS0OaoKUtJdM3TfSlh/5sZQOroyKDX7tHKzr/UQa79HMUoMTqXQ==
X-Received: by 2002:a05:6a00:10d5:b0:4bc:a0eb:c6a0 with SMTP id d21-20020a056a0010d500b004bca0ebc6a0mr19717944pfu.70.1643137156498;
        Tue, 25 Jan 2022 10:59:16 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id c8sm22661349pfl.122.2022.01.25.10.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 10:59:16 -0800 (PST)
Message-ID: <8ab3272f-38b3-b7e9-abab-72a03ec0c872@linaro.org>
Date:   Tue, 25 Jan 2022 10:59:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     peterz@infradead.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
References: <20220120200139.118978-1-tadeusz.struk@linaro.org>
 <20220125011804.mhlhdenbjluzqkgf@oracle.com>
 <CAKfTPtB7UvUG3C_xiHL-V6eDfDOAkpzFWa0_QQeeRAQG7PovXQ@mail.gmail.com>
 <8eaaffe1-f6aa-4d8f-bbc7-0a57002d1729@linaro.org>
Subject: Re: [PATCH v2] sched/fair: Fix fault in reweight_entity
In-Reply-To: <8eaaffe1-f6aa-4d8f-bbc7-0a57002d1729@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/22 10:30, Tadeusz Struk wrote:
> On 1/25/22 01:14, Vincent Guittot wrote:
>> Could we use :
>> set_load_weight(p, !(p->__state & TASK_NEW));
>> instead of
>> set_load_weight(p, true);
>> in set_user_nice and __setscheduler_params.
> 
> Wouldn't that require READ_ONCE() and rmb() after the read?

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848eaa0efe0e..3d7ede06b971 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6921,7 +6921,7 @@ void set_user_nice(struct task_struct *p, long nice)
                 put_prev_task(rq, p);

         p->static_prio = NICE_TO_PRIO(nice);
-       set_load_weight(p, true);
+       set_load_weight(p, !(READ_ONCE(p->__state) & TASK_NEW));
         old_prio = p->prio;
         p->prio = effective_prio(p);

That works for me. I will send a new version soon.

-- 
Thanks,
Tadeusz
