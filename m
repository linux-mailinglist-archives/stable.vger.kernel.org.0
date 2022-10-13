Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105F95FD55D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 09:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJMHHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 03:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJMHHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 03:07:51 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407C6E52F3;
        Thu, 13 Oct 2022 00:07:50 -0700 (PDT)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mp0tC2wMyz6H74g;
        Thu, 13 Oct 2022 15:06:11 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 09:07:46 +0200
Received: from [10.126.172.19] (10.126.172.19) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 08:07:45 +0100
Message-ID: <4ffc662d-5c73-5047-81d5-ad78ca3a7d7e@huawei.com>
Date:   Thu, 13 Oct 2022 08:07:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH AUTOSEL 5.15 10/47] iommu/arm-smmu-v3: Make default domain
 type of HiSilicon PTT device to identity
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Yicong Yang <yangyicong@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        <joro@8bytes.org>, <robin.murphy@arm.com>,
        <baolu.lu@linux.intel.com>, <jgg@ziepe.ca>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <christophe.jaillet@wanadoo.fr>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>
References: <20221013002124.1894077-1-sashal@kernel.org>
 <20221013002124.1894077-10-sashal@kernel.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20221013002124.1894077-10-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.172.19]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/10/2022 01:20, Sasha Levin wrote:
> From: Yicong Yang<yangyicong@hisilicon.com>
> 
> [ Upstream commit 24b6c7798a0122012ca848ea0d25e973334266b0 ]
> 
> The DMA operations of HiSilicon PTT device can only work properly with
> identical mappings. So add a quirk for the device to force the domain
> as passthrough.
> 
> Acked-by: Will Deacon<will@kernel.org>
> Signed-off-by: Yicong Yang<yangyicong@hisilicon.com>
> Reviewed-by: John Garry<john.garry@huawei.com>
> Link:https://lore.kernel.org/r/20220816114414.4092-2-yangyicong@huawei.com
> Signed-off-by: Mathieu Poirier<mathieu.poirier@linaro.org>
> Signed-off-by: Sasha Levin<sashal@kernel.org>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)

I don't think that this commit should be backported to any stable tree. 
It's only required for a new driver.

Thanks,
John
