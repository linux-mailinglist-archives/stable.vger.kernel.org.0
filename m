Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA649D660
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 00:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiAZXvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 18:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiAZXu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 18:50:59 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9321AC06173B
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 15:50:59 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c9so972862plg.11
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 15:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=cBxJNeicoRzjXh+eEmDsU4Z8ycQDuwzwWKSyLyKYjXU=;
        b=WDTTt0fddCEhZQRAz+lyxdMB8Et0DAN1Bv3xBNQXrslbekeFaKcxFedz7j7v9I5ObM
         VgdLgPgxv5ZWO48+/hYqObsjQwiomzjtOveQ5BcOli0h0QH9he40zBt765mxWC0Czy3W
         g86g/debboCyRaCX18VAlylAtTIs9gKZarTr12u3LjIr/cqAHsF3V6WVBwMg1a92O9hr
         0BEME9fAn9moT4q7Bg4V0+lFIJExTI8c21dH66vjwtOml+7uRRs8rIsRXQJC2hS3BYhJ
         CejyYws0tGz/b6cFq6pPPYeKR7gNGzH2wTbbAVDbtJNjOVkHYd8dpPcAwaOXkORXMTRN
         0AfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=cBxJNeicoRzjXh+eEmDsU4Z8ycQDuwzwWKSyLyKYjXU=;
        b=sZjPj4ZcB5VCzuYZt8GNwigOWuRm/GKKk0oq3GeXMFXErtM2P2YD0AOz0uC3KADJzq
         fojr73i152BFiCHtJNTJ19H20jlnggONWMPm8/NBAYcDPn6S91nE9EUH5aU223/P00c/
         c/h8ZYz8wF66PY4z75UrNkUnLpyFxrccEpLiTy8uSIx9ZTgbsd9n+gEUCTRnsdrMB6l8
         RINTyGP9wjZ7sNMLpUZh3nQDuKbkRFawacTwFfR0FESCjtMslhCXV2TVdFHFc8gMSErb
         IG23YqFDGNUk7yD1L1kUj3GtOShzz0sUuCR4qGC/ZGj1HYDjhFujSFeqhpzO+Xdwnr/z
         Ej+Q==
X-Gm-Message-State: AOAM532a9AlCtTbOvVZFVgXJYB1jga6+tmS9wT8FLexdJ6zLMD+nRT6G
        jXVCe3XQNuqZHXsbthWhvT7KLA==
X-Google-Smtp-Source: ABdhPJykrJ2uOm8OEbe0IzU4Bthtxc99KDRuTVbvLsgTgp6ISyZ9HrqIrN5a+OcWk6ZkhecwMja/zA==
X-Received: by 2002:a17:902:ea0b:: with SMTP id s11mr1274542plg.133.1643241058942;
        Wed, 26 Jan 2022 15:50:58 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id s7sm3381389pfu.133.2022.01.26.15.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 15:50:58 -0800 (PST)
Message-ID: <a4eccced-44d9-d5ae-27b3-5b2832d22561@linaro.org>
Date:   Wed, 26 Jan 2022 15:50:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>, peterz@infradead.org
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
References: <20220125193403.778497-1-tadeusz.struk@linaro.org>
 <bb01425b-0f6a-e69f-c24b-567821c1472f@arm.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v3] sched/fair: Fix fault in reweight_entity
In-Reply-To: <bb01425b-0f6a-e69f-c24b-567821c1472f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/22 05:53, Dietmar Eggemann wrote:
> Can we then not get rid of `bool update_load` parameter of
> set_load_weight() completely?
> 
> @@ -1214,8 +1214,9 @@ int tg_nop(struct task_group *tg, void *data)
>   }
>   #endif
>   
> -static void set_load_weight(struct task_struct *p, bool update_load)
> +static void set_load_weight(struct task_struct *p)
>   {
> +       int task_new = READ_ONCE(p->__state) & TASK_NEW;
>          int prio = p->static_prio - MAX_RT_PRIO;
>          struct load_weight *load = &p->se.load;
>   
> @@ -1232,7 +1233,7 @@ static void set_load_weight(struct task_struct *p, bool update_load)
>           * SCHED_OTHER tasks have to update their load when changing their
>           * weight
>           */
> -       if (update_load && p->sched_class == &fair_sched_class) {
> +       if (!task_new && p->sched_class == &fair_sched_class) {
>                  reweight_task(p, prio);
>          } else {
>                  load->weight = scale_load(sched_prio_to_weight[prio]);

That will also work. Let's agree on the best way to fix it.
Peter, what's your preference?

-- 
Thanks,
Tadeusz
