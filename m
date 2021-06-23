Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7F3B148B
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhFWH1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:27:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8435 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWH1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 03:27:31 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G8vpp6VhnzZky5;
        Wed, 23 Jun 2021 15:22:10 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 15:25:11 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 15:25:10 +0800
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <akpm@linux-foundation.org>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <song.bao.hua@hisilicon.com>,
        <ardb@kernel.org>, <anshuman.khandual@arm.com>,
        <stable@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Li Huafei <lihuafei1@huawei.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
 <YEDkmj6cchMPAq2h@kroah.com>
 <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
 <YEDr/lYZHew88/Ip@kroah.com>
 <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com> <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
 <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
 <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
 <YNLe4CGtOgVvTOMN@kroah.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <e47df0fd-0ddd-408b-2972-1b6d0a786f00@huawei.com>
Date:   Wed, 23 Jun 2021 15:25:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YNLe4CGtOgVvTOMN@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/6/23 15:12, Greg KH wrote:
> On Wed, Jun 23, 2021 at 02:59:59PM +0800, Kefeng Wang wrote:
>> Hi Greg,
>>
>> There are two more patches about the ZONE_DMA[32] changes,
> 
> What ZONE_DMA changes?

See the subject, [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide 
ZONE_DMA, We asked the ARM64 ZONE_DMA change backport before, link[1]
> 
>> especially the
>> second one, both them need be backported, thanks.
> 
> Backported to where?

stable 5.10

> 
>> 791ab8b2e3db - arm64: Ignore any DMA offsets in the max_zone_phys()
>> calculation
>> 2687275a5843 - arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation is
>> required
> 
> Have you tried these patches?  Where do they need to be applied to?

Yes, we tested it, without them, especially the second one, we will
meet crash when using kexec boot, also there is discussion in [2]
and [3] from Catalin.


> 
> confused,
> 
Sorry about this, should add more information, thanks.

[1] 
https://lore.kernel.org/linux-riscv/20210303073319.2215839-1-jingxiangfeng@huawei.com/
[2] 
https://lore.kernel.org/linux-devicetree/e60d643e-4879-3fc3-737d-2c145332a6d7@arm.com/
[3] 
https://lore.kernel.org/linux-arm-kernel/20201119175556.18681-1-catalin.marinas@arm.com/
> greg k-h
> .
> 
