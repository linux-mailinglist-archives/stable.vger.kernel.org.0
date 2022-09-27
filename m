Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9765EC3F1
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiI0NOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 09:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiI0NOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 09:14:44 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A435F269;
        Tue, 27 Sep 2022 06:14:35 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4McKmG2b2pz6R52Z;
        Tue, 27 Sep 2022 21:12:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgDHY2049zJjfovqBQ--.43343S3;
        Tue, 27 Sep 2022 21:14:33 +0800 (CST)
Subject: Re: [PATCH 5.10] scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw
 sectors for v3 HW"
To:     John Garry <john.garry@huawei.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yukuai1@huaweicloud.com,
        yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20220927130116.1013775-1-yukuai3@huawei.com>
 <a1fe584c-5001-9983-3a3d-65d3bd396642@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2bcb72eb-b9a7-8fed-f17d-3f1df4da9ee5@huaweicloud.com>
Date:   Tue, 27 Sep 2022 21:14:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a1fe584c-5001-9983-3a3d-65d3bd396642@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgDHY2049zJjfovqBQ--.43343S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCrWxGr4UGFyUtr15trW8WFg_yoW5CF45pF
        WkJayFvrWDCF48Gw47Wr4xZrWFq3y8Xw1YqFyYya48Cr45GryqqF4UZr1SgFZ5Crs5JF1j
        vr4qgryq9a1UZrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, John

在 2022/09/27 21:06, John Garry 写道:
> On 27/09/2022 14:01, Yu Kuai wrote:
>> This reverts commit 24cd0b9bfdff126c066032b0d40ab0962d35e777.
>>
>> 1) commit 4e89dce72521 ("iommu/iova: Retry from last rb tree node if
>> iova search fails") tries to fix that iova allocation can fail while
>> there are still free space available. This is not backported to 5.10
>> stable.
> 
> This arrived in 5.11, I think
> 
>> 2) commit fce54ed02757 ("scsi: hisi_sas: Limit max hw sectors for v3
>> HW") fix the performance regression introduced by 1), however, this
>> is just a temporary solution and will cause io performance regression
>> because it limit max io size to PAGE_SIZE * 32(128k for 4k page_size).
> 
> Did you really notice a performance regression? In what scenario? which 
> kernel versions?

We are using 5.10, and test tool is fs_mark and it's doing writeback,
and benefits from io merge, before this patch, avgqusz is 300+, and this
patch will limit avgqusz to 128.

I think that in any other case that io size is greater than 128k, this
patch will probably have defects.

Thanks,
Kuai
> 
>> 3) John Garry posted a patchset to fix the problem.
>> 4) The temporary solution is reverted.
>>
> 
> 
>> It's weird that the patch in 2) is backported to 5.10 stable alone,
>> while the right thing to do is to backport them all together.
> 
> I would tend to agree. I did not notice fce54ed02757 backported at all. 
> But I did consider backporting it to address 4e89dce72521. Anyway, the 
> proper solution is merged for 6.0 in 4cbfca5f7750 ("scsi: 
> scsi_transport_sas: cap shost opt_sectors according to DMA optimal 
> limit") and I have a revert of "scsi: hisi_sas: Limit max hw sectors for 
> v3 HW" queued for 6.1, but I would not plan on reverting for stable.
> 
> Please let me know if any issue here.
> 
> Thanks,
> John
> 
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 -------
>>   1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c 
>> b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> index dfe7e6370d84..cd41dc061d87 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> @@ -2738,7 +2738,6 @@ static int slave_configure_v3_hw(struct 
>> scsi_device *sdev)
>>       struct hisi_hba *hisi_hba = shost_priv(shost);
>>       struct device *dev = hisi_hba->dev;
>>       int ret = sas_slave_configure(sdev);
>> -    unsigned int max_sectors;
>>       if (ret)
>>           return ret;
>> @@ -2756,12 +2755,6 @@ static int slave_configure_v3_hw(struct 
>> scsi_device *sdev)
>>           }
>>       }
>> -    /* Set according to IOMMU IOVA caching limit */
>> -    max_sectors = min_t(size_t, 
>> queue_max_hw_sectors(sdev->request_queue),
>> -                (PAGE_SIZE * 32) >> SECTOR_SHIFT);
>> -
>> -    blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
>> -
>>       return 0;
>>   }
> 
> .
> 

