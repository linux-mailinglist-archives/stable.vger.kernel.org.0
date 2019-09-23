Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC45BADE5
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 08:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389221AbfIWGha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 02:37:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2767 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387519AbfIWGha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 02:37:30 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D2076DFBD19C901C3FED;
        Mon, 23 Sep 2019 14:37:28 +0800 (CST)
Received: from [127.0.0.1] (10.177.219.49) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Sep 2019
 14:37:27 +0800
Subject: Re: [PATCH v3] block: fix null pointer dereference in
 blk_mq_rq_timed_out()
To:     Bart Van Assche <bvanassche@acm.org>, <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <ming.lei@redhat.com>,
        <hch@infradead.org>, <keith.busch@intel.com>,
        <stable@vger.kernel.org>
References: <20190920113404.48567-1-yuyufen@huawei.com>
 <011d9eae-d4c3-db6d-355b-6780fc18b06e@acm.org>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <6348d7e7-5783-466f-cee1-64e9a81651d9@huawei.com>
Date:   Mon, 23 Sep 2019 14:37:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <011d9eae-d4c3-db6d-355b-6780fc18b06e@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.219.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/9/21 23:57, Bart Van Assche wrote:
> On 9/20/19 4:34 AM, Yufen Yu wrote:
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Keith Busch <keith.busch@intel.com>
>> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>
> Have you considered to add Fixes: and Cc: stable tags to this patch?

No matter whether we have merged commit 12f5b93145,
the bug always exist in earlier version. So, I am not sure it
is suitable to add 'Fixes:'.

Since the resolution of this patch is based on commit 12f5b93145
("blk-mq: Remove generation seqeunce"), I think it will be ok to CC 
stable for v4.18+.

Cc: stable@vger.kernel.org # v4.18+

Thanks,
Yufen




