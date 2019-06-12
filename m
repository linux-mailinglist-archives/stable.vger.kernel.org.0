Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B44E42413
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 13:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408287AbfFLLe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 07:34:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406406AbfFLLe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 07:34:29 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BF6BF666E464925F7254;
        Wed, 12 Jun 2019 19:34:26 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.209) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 12 Jun
 2019 19:34:17 +0800
Subject: Re: [PATCH v2] sched/core: add __sched tag for io_schedule()
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        <stable@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
        <koujilong@huawei.com>
References: <20190531082912.80724-1-gaoxiang25@huawei.com>
 <20190603091338.2695-1-gaoxiang25@huawei.com>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <2c77fa8f-b93a-c4d6-f946-c3867a18af27@huawei.com>
Date:   Wed, 12 Jun 2019 19:34:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190603091338.2695-1-gaoxiang25@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Friendly ping...

Thanks,
Gao Xiang

On 2019/6/3 17:13, Gao Xiang wrote:
> non-inline io_schedule() was introduced in
> commit 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")
> Keep in line with io_schedule_timeout, Otherwise
> "/proc/<pid>/wchan" will report io_schedule()
> rather than its callers when waiting io.
> 
> Reported-by: Jilong Kou <koujilong@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Fixes: 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")
> Cc: <stable@vger.kernel.org> # 4.11+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> ---
> change log v2:
>  - add missing tags
> 
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 874c427742a9..4d5962232a55 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5123,7 +5123,7 @@ long __sched io_schedule_timeout(long timeout)
>  }
>  EXPORT_SYMBOL(io_schedule_timeout);
>  
> -void io_schedule(void)
> +void __sched io_schedule(void)
>  {
>  	int token;
>  
> 
