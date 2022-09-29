Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C45EEC3E
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiI2C5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 22:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiI2C5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 22:57:54 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2796A11E945;
        Wed, 28 Sep 2022 19:57:50 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MdJ011pkDzl4Lx;
        Thu, 29 Sep 2022 10:56:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgC3VW+pCTVjH9E7Bg--.34168S3;
        Thu, 29 Sep 2022 10:57:47 +0800 (CST)
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
 <4734dd2d-8a32-98b5-3fda-9def720724c9@huaweicloud.com>
 <c618db25-89ed-8814-b825-50655236a92d@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <21d07b22-c3bc-6def-0298-ac76e8d92223@huaweicloud.com>
Date:   Thu, 29 Sep 2022 10:57:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c618db25-89ed-8814-b825-50655236a92d@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgC3VW+pCTVjH9E7Bg--.34168S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF43Cw1fuw17Zr1xZw4DCFg_yoW8tw48pa
        yrJ3Z8KryUJF1rJw47K3yUXa48trZ5Jw1UXF45GF4xAr4Dtr1jqF4UXrWFgryDCw4xGryj
        vryUX3srZrW8trJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

在 2022/09/28 15:36, John Garry 写道:
> On 28/09/2022 02:35, Yu Kuai wrote:
>>>>> However both 5.15 stable and 5.19 mainline include fce54ed02757 - 
>>>>> it was automatically backported for 5.15 stable. Please double 
>>>>> check that.
>>>>>
>>>>> And can you also check performance there for those kernels?
>>>>
>>>> I'm pretty sure io split can decline performance, especially for HDD,
>>>> because blk-mq can't guarantee that split io can be dispatched to disk
>>>> sequentially. However, this is usually not common with proper
>>>> max_sectors_kb.
>>>>
>>>> Here is an example that if max_sector_kb is 128k, performance will
>>>> drop a lot under high concurrency:
>>>>
>>>> https://lore.kernel.org/all/20220408073916.1428590-1-yukuai3@huawei.com/ 
>>>>
> 
> This never got merged in any form, right?

Yes.

> 
>>>>
>>>> Here I set max_sectors_kb to 128k manually, and 1m random io 
>>>> performance
>>>> will drop while io concurrency increase:
>>>>
>>>> | numjobs | v5.18-rc1 |
>>>> | ------- | --------- |
>>>> | 1       | 67.7      |
>>>> | 2       | 67.7      |
>>>> | 4       | 67.7      |
>>>> | 8       | 67.7      |
>>>> | 16      | 64.8      |
>>>> | 32      | 59.8      |
>>>> | 64      | 54.9      |
>>>> | 128     | 49        |
>>>> | 256     | 37.7      |
>>>> | 512     | 31.8      |
>>>
>>> Commit fce54ed02757 was to circumvent a terrible performance hit for 
>>> IOMMU enabled from 4e89dce72521 - have you ever tested with IOMMU 
>>> enabled?
>>
>> I understand that fce54ed02757 fix a terrible performance regression,
>> and I'm not familiar with IOMMU and I never test that.
>>>
>>> If fce54ed02757 really does cause a performance regression in some 
>>> scenarios, then we can consider reverting it from any stable kernel 
>>> and also backporting [0] when it is included in Linus' kernel
>>
>> That sounds good.
>>
>> For 5.10 stable, I think it's ok to revert it for now, and if someone
>> cares about the problem 4e89dce72521 fixed, they can try to backport it
>> together with follow up patches.
> 
> For 5.10 stable revert only,
> 
> Reviewed-by: John Garry <john.garry@huawei.com>

Thanks for the review!

Kuai
> 
> Thanks,
> John
> .
> 

