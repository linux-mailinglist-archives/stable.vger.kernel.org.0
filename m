Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D9BBF478
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfIZNxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 09:53:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48926 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726094AbfIZNxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 09:53:05 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2847842E9EEBD0B1E28C;
        Thu, 26 Sep 2019 21:53:03 +0800 (CST)
Received: from [127.0.0.1] (10.177.219.49) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 26 Sep 2019
 21:52:57 +0800
Subject: Re: [PATCH v4] block: fix null pointer dereference in
 blk_mq_rq_timed_out()
To:     Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        "Bart Van Assche" <bvanassche@acm.org>, <stable@vger.kernel.org>
References: <20190925122025.31246-1-yuyufen@huawei.com>
 <9fda0509-0ee5-9f9d-8a37-2d33a097d1bd@kernel.dk>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <e910ae23-2daa-1371-fc1e-16988e6e7783@huawei.com>
Date:   Thu, 26 Sep 2019 21:52:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <9fda0509-0ee5-9f9d-8a37-2d33a097d1bd@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.219.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/9/26 18:04, Jens Axboe wrote:
> On 9/25/19 2:20 PM, Yufen Yu wrote:
>> diff --git a/block/blk.h b/block/blk.h
>> index ed347f7a97b1..de258e7b9db8 100644
>> --- a/block/blk.h
>> +++ b/block/blk.h
>> @@ -30,6 +30,7 @@ struct blk_flush_queue {
>>    	 */
>>    	struct request		*orig_rq;
>>    	spinlock_t		mq_flush_lock;
>> +	blk_status_t 		rq_status;
>>    };
> Patch looks fine to me, but you should move rq_status to after the
> flush_running_idx member of struct blk_flush_queue, since then it'll
> fill a padding hole instead of adding new ones.
>

Thanks for you good suggestion.

Thanks,
Yufen

