Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29C35EC56F
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 16:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbiI0OF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 10:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiI0OF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 10:05:26 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515AB1616F0;
        Tue, 27 Sep 2022 07:05:21 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4McLtq5rghz6R4nb;
        Tue, 27 Sep 2022 22:03:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgBHmnMcAzNjiF7sBQ--.6249S3;
        Tue, 27 Sep 2022 22:05:18 +0800 (CST)
Subject: Re: [PATCH 5.10] scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw
 sectors for v3 HW"
To:     John Garry <john.garry@huawei.com>,
        Yu Kuai <yukuai1@huaweicloud.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yi.zhang@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220927130116.1013775-1-yukuai3@huawei.com>
 <a1fe584c-5001-9983-3a3d-65d3bd396642@huawei.com>
 <2bcb72eb-b9a7-8fed-f17d-3f1df4da9ee5@huaweicloud.com>
 <f50cc744-f522-259a-e670-809d65361548@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5b8cc025-0755-74c1-3df5-a95718d23861@huaweicloud.com>
Date:   Tue, 27 Sep 2022 22:05:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f50cc744-f522-259a-e670-809d65361548@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgBHmnMcAzNjiF7sBQ--.6249S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1xJrWDur4DtryrAw1xAFb_yoW8Kw47pa
        y3Ja90kFWUJF10kw47t3s2vFy8t395Jr15XF45G3yxXr98WryjqF4IqrWF9rWqkrZ2kF42
        vr4kX3s2y3yvyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, John

在 2022/09/27 21:45, John Garry 写道:
> On 27/09/2022 14:14, Yu Kuai wrote:
>> Hi, John
>>
>> 在 2022/09/27 21:06, John Garry 写道:
>>> On 27/09/2022 14:01, Yu Kuai wrote:
>>>> This reverts commit 24cd0b9bfdff126c066032b0d40ab0962d35e777.
>>>>
>>>> 1) commit 4e89dce72521 ("iommu/iova: Retry from last rb tree node if
>>>> iova search fails") tries to fix that iova allocation can fail while
>>>> there are still free space available. This is not backported to 5.10
>>>> stable.
>>>
>>> This arrived in 5.11, I think
>>>
>>>> 2) commit fce54ed02757 ("scsi: hisi_sas: Limit max hw sectors for v3
>>>> HW") fix the performance regression introduced by 1), however, this
>>>> is just a temporary solution and will cause io performance regression
>>>> because it limit max io size to PAGE_SIZE * 32(128k for 4k page_size).
>>>
>>> Did you really notice a performance regression? In what scenario? 
>>> which kernel versions?
>>
>> We are using 5.10, and test tool is fs_mark and it's doing writeback,
>> and benefits from io merge, before this patch, avgqusz is 300+, and this
>> patch will limit avgqusz to 128.
> 
> OK, so I think it's ok to revert for 5.10
> 
>>
>> I think that in any other case that io size is greater than 128k, this
>> patch will probably have defects.
> 
> However both 5.15 stable and 5.19 mainline include fce54ed02757 - it was 
> automatically backported for 5.15 stable. Please double check that.
> 
> And can you also check performance there for those kernels?

I'm pretty sure io split can decline performance, especially for HDD,
because blk-mq can't guarantee that split io can be dispatched to disk
sequentially. However, this is usually not common with proper
max_sectors_kb.

Here is an example that if max_sector_kb is 128k, performance will
drop a lot under high concurrency:

https://lore.kernel.org/all/20220408073916.1428590-1-yukuai3@huawei.com/

Here I set max_sectors_kb to 128k manually, and 1m random io performance
will drop while io concurrency increase:

| numjobs | v5.18-rc1 |
| ------- | --------- |
| 1       | 67.7      |
| 2       | 67.7      |
| 4       | 67.7      |
| 8       | 67.7      |
| 16      | 64.8      |
| 32      | 59.8      |
| 64      | 54.9      |
| 128     | 49        |
| 256     | 37.7      |
| 512     | 31.8      |

Thanks,
Kuai
> 
> The reason which we had fce54ed02757 was because 4e89dce72521 hammered 
> performance when IOMMU enabled, and at least I saw no performance 
> regression for fce54ed02757 in other scenarios.
> 
> Thanks,
> John
> 
> 
> 
> 
> 
> .
> 

