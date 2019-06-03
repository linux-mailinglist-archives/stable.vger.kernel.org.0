Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1135732761
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 06:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfFCEZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 00:25:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18069 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbfFCEZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 00:25:16 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B75B932B97CFF4679957;
        Mon,  3 Jun 2019 12:25:14 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 3 Jun 2019
 12:25:09 +0800
Subject: Re: [PATCH] sched/core: add __sched tag for io_schedule()
To:     Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>, <stable@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>, <koujilong@huawei.com>
References: <20190531082912.80724-1-gaoxiang25@huawei.com>
 <20190531143759.GD374014@devbig004.ftw2.facebook.com>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <b95526a4-33cc-12df-020c-011d67ca797b@huawei.com>
Date:   Mon, 3 Jun 2019 12:25:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190531143759.GD374014@devbig004.ftw2.facebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/5/31 22:37, Tejun Heo wrote:
> On Fri, May 31, 2019 at 04:29:12PM +0800, Gao Xiang wrote:
>> non-inline io_schedule() was introduced in
>> commit 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")
>> Keep in line with io_schedule_timeout, Otherwise
>> "/proc/<pid>/wchan" will report io_schedule()
>> rather than its callers when waiting io.
>>
>> Reported-by: Jilong Kou <koujilong@huawei.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Cc: <stable@vger.kernel.org> # 4.11+

Thanks Tejun. This patch will be needed for io performance analysis
since we found that Android systrace tool cannot show the callers of
iowait raised from io_schedule() on linux-4.14 LTS kernel.

Hi Andrew, could you kindly take this patch?

Thanks,
Gao Xiang

> 
> Thanks.
> 
