Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E130A493D76
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355864AbiASPnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 10:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355836AbiASPnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 10:43:25 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F7EC06161C
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 07:43:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so1817691pju.2
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 07:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=53cNgccwu9x9Cm08nPp6ZXfeb4MexT+F3e1jmMAvo+0=;
        b=ZnbfZdtrXlDdROZR3VB9P8kHwkJ8JoLEB1jJI81NodHV0ZMJouA3lUhceDmHgimyYH
         Cs698LS1FB9Zurj8tqf8CBkNca4Sq1w9NCGmuxj0QPIXQTYCnB4fV+vWteAqkXlsnPGK
         wrVqK7cRLRtxgYVEAv/BEuDztO84EycdqwZ7ykkVDAHgbzrWT3YqLFx6Cf9iSnvAHpt9
         s20s1WqRfwBXdRIHcwkZdAe6cDbBcfrOORahnxoRlBu7GtftINo8WS4wPawfvU4azpiX
         wAoGfbsVIQeZpBVG8wajMR3YT896qRHgiPK56RdRrgdIaJ214j0fVJ6MA2aYdvPqdwzN
         Dz1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=53cNgccwu9x9Cm08nPp6ZXfeb4MexT+F3e1jmMAvo+0=;
        b=Aug9H0+bJIGcmt1yBd40P0P5yTEOLkL3RWwaeN5M675drONl39CXuaX3uA66nbKHjs
         PMpwsiLgPh8ZwWYr8iZn8wkuS4uq+cdyr2NhJTiuOZS81UP2Azk8zC2dslICn6PnJnPE
         XwFApLZMxiNEAOcqjdIo4aV+KmiuARDzopSliPuRV0w7NIfbr6MRkPzDRz5W2d6romFL
         gy2hjfc3U9MMs/fL1QEdUJMgtJpSGwphTOpt7xQEfOivEPwpoTbw+BlcuUtIr3kp8iyQ
         bsQXz41Zu5Lf25nS/4Z+i+M8zAsA3aifgL1IalOoFnC9v5fzEUdHTNg3kHAEp3Bw223i
         kbWg==
X-Gm-Message-State: AOAM532L1uZzXCWImetf/S8Kw3qZtshF20YtUi3dTp4vxiL3MWhkJ0s+
        ORst2se4PGnklXw5Lxgngxs0ow==
X-Google-Smtp-Source: ABdhPJzZ3X5cu1E7d552V+nPfhq7FeuqWMQJ62DP+ZAbXkWnIHVAhC1iu/lsqw6xlH2BP3WTf7yR6g==
X-Received: by 2002:a17:90a:d3c8:: with SMTP id d8mr4980055pjw.189.1642607004807;
        Wed, 19 Jan 2022 07:43:24 -0800 (PST)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id y16sm76086pfl.128.2022.01.19.07.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 07:43:24 -0800 (PST)
Message-ID: <4e13ba95-815a-79a1-e521-5f794963b691@linaro.org>
Date:   Wed, 19 Jan 2022 07:43:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@redhat.com, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220119012417.299060-1-tadeusz.struk@linaro.org>
 <YefalbN+ApgkQ6zn@hirez.programming.kicks-ass.net>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] sched/fair: Fix fault in reweight_entity
In-Reply-To: <YefalbN+ApgkQ6zn@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/19/22 01:32, Peter Zijlstra wrote:
> On Tue, Jan 18, 2022 at 05:24:17PM -0800, Tadeusz Struk wrote:
>> Syzbot found a GPF in reweight_entity. This has been bisected to commit
>> c85c6fadbef0 ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> That's a stable commit, the real commit is 4ef0c5c6b5ba1f38f0ea1cedad0cad722f00c14a

This is what syzbot bisected it to. I will reference the original commit in the
next version.

> 
>> Looks like after this change there is a time window, when
>> task_struct->se.cfs_rq can be NULL. This can be exploited to trigger
>> null-ptr-deref by calling setpriority on that task.
> Looks like isn't good enough, either there is, in which case you explain
> the window, or there isn't in which case what are we doing here?

There surely is something wrong, otherwise it wouldn't crash.
I will try to narrow down the reproducer to better understand what causes
the fault.

-- 
Thanks,
Tadeusz
