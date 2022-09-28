Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D11A5ED2AE
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiI1Bfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiI1Bfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:35:38 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF4E11264B;
        Tue, 27 Sep 2022 18:35:35 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4McfCb28yNzl6Mx;
        Wed, 28 Sep 2022 09:33:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgD3SXPipDNjDYkFBg--.56693S3;
        Wed, 28 Sep 2022 09:35:32 +0800 (CST)
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
 <5b8cc025-0755-74c1-3df5-a95718d23861@huaweicloud.com>
 <f24d0eb1-a578-2221-c8da-17ddbd35e96d@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4734dd2d-8a32-98b5-3fda-9def720724c9@huaweicloud.com>
Date:   Wed, 28 Sep 2022 09:35:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f24d0eb1-a578-2221-c8da-17ddbd35e96d@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgD3SXPipDNjDYkFBg--.56693S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4rCFWxAFyrGw15Jw4fKrg_yoW8tr1Upa
        yrJ3WUtryUJr1fGw47K3yUXFy0qr95Jw1UJFW5GF4xAr4UGr1jqF4UXrWFgrWUCr48GF1j
        vr1UXr1qvrWktrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, John

在 2022/09/27 23:54, John Garry 写道:
> On 27/09/2022 15:05, Yu Kuai wrote:
>>>
>>> However both 5.15 stable and 5.19 mainline include fce54ed02757 - it 
>>> was automatically backported for 5.15 stable. Please double check that.
>>>
>>> And can you also check performance there for those kernels?
>>
>> I'm pretty sure io split can decline performance, especially for HDD,
>> because blk-mq can't guarantee that split io can be dispatched to disk
>> sequentially. However, this is usually not common with proper
>> max_sectors_kb.
>>
>> Here is an example that if max_sector_kb is 128k, performance will
>> drop a lot under high concurrency:
>>
>> https://lore.kernel.org/all/20220408073916.1428590-1-yukuai3@huawei.com/
>>
>> Here I set max_sectors_kb to 128k manually, and 1m random io performance
>> will drop while io concurrency increase:
>>
>> | numjobs | v5.18-rc1 |
>> | ------- | --------- |
>> | 1       | 67.7      |
>> | 2       | 67.7      |
>> | 4       | 67.7      |
>> | 8       | 67.7      |
>> | 16      | 64.8      |
>> | 32      | 59.8      |
>> | 64      | 54.9      |
>> | 128     | 49        |
>> | 256     | 37.7      |
>> | 512     | 31.8      |
> 
> Commit fce54ed02757 was to circumvent a terrible performance hit for 
> IOMMU enabled from 4e89dce72521 - have you ever tested with IOMMU enabled?

I understand that fce54ed02757 fix a terrible performance regression,
and I'm not familiar with IOMMU and I never test that.
> 
> If fce54ed02757 really does cause a performance regression in some 
> scenarios, then we can consider reverting it from any stable kernel and 
> also backporting [0] when it is included in Linus' kernel

That sounds good.

For 5.10 stable, I think it's ok to revert it for now, and if someone
cares about the problem 4e89dce72521 fixed, they can try to backport it
together with follow up patches.

Thanks,
Kuai

> 
> [0] 
> https://lore.kernel.org/linux-iommu/495de02c-59ce-917f-1cb4-5425a37063ed@huawei.com/T/#m6a655d596fdf30e4e8b90100e16f75ae5d67341a 
> 
> 
> thanks,
> John
> .
> 

