Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB154945CA
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 03:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiATCWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 21:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiATCWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 21:22:12 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0F4C06161C
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 18:22:12 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id f13so3997545plg.0
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 18:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :references:subject:in-reply-to:content-transfer-encoding;
        bh=rceaFdVjTxyvongrGnOohxq0b18ZsFLz0zQ22QO1D3M=;
        b=MYd5aeMah7d/2OviOmCdGzim4oA+/yT/Msp+XE+1ULtrdOq9ziZqj8ksolzxTRnTjw
         x+6RZ0W5QC3kTI6QP54OWyjry4KNDOd8h3Anpxu4BGI6j73LmmfTOG/uhotNV8FvcpmB
         JJPCKTuU4SadDfPMmX/eHworFkYoYuRwmfBu6h14Bm1MaVMkIZRE5/hQ2PofgbthhJzp
         IZ02Msxj4aRsFc4Nj9eBAo4wbuBCpZ2WrH922OIGxCMisEaP3LRx3puA3HCZDptuVV7h
         zbNvKsvCg4mG+7xKeJiY3cQCznXoSpxFg2n3coiQlzfhCMAF0zZ2X2KjrfhsKvgopjcZ
         h1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=rceaFdVjTxyvongrGnOohxq0b18ZsFLz0zQ22QO1D3M=;
        b=XgCCdQerp71yJAAnNNDTiIKcfRax1qRKdxT80nJK2ioP/V58pQ5qtfGurZYGC62sof
         Gdyasnzs7B2z5AqdvI/JlpvsrE9AZ+vIkhdz0two8Atd52xW/Yr8zNl/1FwY0MLiYQkg
         iC7n/qCKqJ94WDoQ7vdX+S9M2Uo16OmVswQQK8BAOuNlOkt6vjsxIcBrxR0z9ZBJtKoY
         PSsoWr4XJul29q5wBTaJaVXM1M41pA6S9xZtTHis/ebivimcjUaxH12ZSAcfvjV0YhSU
         7S3YSGAT3ITCakikAaUBvwmRInZFf4A7SAfDYE50b/rfkdKLZ9uU0Y/pc4lzHcP905Mt
         IEvQ==
X-Gm-Message-State: AOAM531XndNYX22dT6F4XB2pwAwXsAo357D0ovckzZBS7s9rKw8YYF2E
        jFqozrmNdbLNwG1aspG/DodVZg==
X-Google-Smtp-Source: ABdhPJzwwn229Mu62Z8/5utsMy0q3MSItFVp2TrhLOFliAna7qv7forRojpS1kwKqm4zQ2m0fs8Mow==
X-Received: by 2002:a17:902:f54a:b0:14a:97ad:b877 with SMTP id h10-20020a170902f54a00b0014a97adb877mr26400676plf.152.1642645331817;
        Wed, 19 Jan 2022 18:22:11 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id b21sm113171pgi.51.2022.01.19.18.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 18:22:11 -0800 (PST)
Message-ID: <799c3fee-aa4d-1c64-6c14-f6c032d37196@linaro.org>
Date:   Wed, 19 Jan 2022 18:22:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
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
 <4e13ba95-815a-79a1-e521-5f794963b691@linaro.org>
Subject: Re: [PATCH] sched/fair: Fix fault in reweight_entity
In-Reply-To: <4e13ba95-815a-79a1-e521-5f794963b691@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/19/22 07:43, Tadeusz Struk wrote:
>>> Looks like after this change there is a time window, when
>>> task_struct->se.cfs_rq can be NULL. This can be exploited to trigger
>>> null-ptr-deref by calling setpriority on that task.
>> Looks like isn't good enough, either there is, in which case you explain
>> the window, or there isn't in which case what are we doing here?
> 
> There surely is something wrong, otherwise it wouldn't crash.
> I will try to narrow down the reproducer to better understand what causes
> the fault.

The race is between sched_post_fork() and setpriority(PRIO_PGRP)
The scenario is that the main process spawns 3 new threads,
which then call setpriority(PRIO_PGRP, 0, -20), wait, and exit.
For each of the new thread the copy_process() gets invoked,
which then calls sched_fork() and finally sched_post_fork().

There is a possibility that setpriority(PRIO_PGRP)->set_one_prio() will be
called for a thread in the group that is just being created by copy_process(),
and for which the sched_post_fork() has not been executed yet.
This will trigger a null pointer dereference in reweight_entity()
because it will try to access the CFS run queue pointer, which hasn't been set, 
resulting it a crash as below:

KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
CPU: 0 PID: 2392 Comm: reduced_repro Not tainted 
5.16.0-11201-gb42c5a161ea3-dirty #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
RIP: 0010:reweight_entity+0x15d/0x440
RSP: 0018:ffffc900035dfcf8 EFLAGS: 00010006
Call Trace:
<TASK>
reweight_task+0xde/0x1c0
set_load_weight+0x21c/0x2b0
set_user_nice.part.0+0x2d1/0x519
set_user_nice.cold+0x8/0xd
set_one_prio+0x24f/0x263
__do_sys_setpriority+0x2d3/0x640
__x64_sys_setpriority+0x84/0x8b
do_syscall_64+0x35/0xb0
entry_SYSCALL_64_after_hwframe+0x44/0xae
</TASK>
---[ end trace 9dc80a9d378ed00a ]---

Before the mentioned change the rq pointer has been set in sched_fork(),
which is called much earlier in copy_process() as opposed to sched_post_fork(),
before the new task is added to the thread_group.

A stripped down version of the sysbot reproducer can be found here:
https://termbin.com/axkq

I can consistently reproduce the issue with it in 2-3 runs.

The solution is either we set the pointer p->se.cfs_rq to a dummy rq in 
sched_fork(), or return from the set_one_prio() without doing anything
if the rq is NULL, as it is done in the patch.
I will update the description and resend it tomorrow.

-- 
Thanks,
Tadeusz
