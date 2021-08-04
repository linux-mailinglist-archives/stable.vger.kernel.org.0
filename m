Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929BC3DFADE
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 07:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhHDFDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 01:03:19 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12443 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhHDFDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 01:03:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gfffm4sVzzcfZ0;
        Wed,  4 Aug 2021 12:59:28 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 13:03:02 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 13:03:01 +0800
Subject: Re: [PATCH v2] lib: Use PFN_PHYS() in devmem_is_allowed()
To:     Palmer Dabbelt <palmerdabbelt@google.com>
CC:     <wangliang101@huawei.com>, <mcgrof@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, <linux@armlinux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>,
        <wangle6@huawei.com>, <kepler.chenxin@huawei.com>,
        <nixiaoming@huawei.com>
References: <mhng-e101fb5a-2f16-45a0-8436-454ac2bf4223@palmerdabbelt-glaptop>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <4c0ec8b2-6b9c-d8da-dd84-29937c968636@huawei.com>
Date:   Wed, 4 Aug 2021 13:03:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <mhng-e101fb5a-2f16-45a0-8436-454ac2bf4223@palmerdabbelt-glaptop>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/8/4 8:20, Palmer Dabbelt wrote:
> On Fri, 30 Jul 2021 00:04:05 PDT (-0700), wangkefeng.wang@huawei.com 
> wrote:
>>
>> On 2021/7/30 14:49, Liang Wang wrote:
>>> The physical address may exceed 32 bits on ARM(when ARM_LPAE enabled),
>>> use PFN_PHYS() in devmem_is_allowed(), or the physical address may
>>> overflow and be truncated.
>>>
>>> This bug was initially introduced from v2.6.37, and the function was 
>>> moved
>>> to lib when v5.10.
>>>
>>> Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by 
>>> disabling access to RAM via /dev/mem")
>>> Fixes: 527701eda5f1 ("lib: Add a generic version of 
>>> devmem_is_allowed()")
>>> Cc: stable@vger.kernel.org # v2.6.37
>>> Signed-off-by: Liang Wang <wangliang101@huawei.com>
>> Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>> v2: update subject and changelog
>>>   lib/devmem_is_allowed.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
...
> Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
>
> I only see the reply so I'm assuming this is going in through some 
> other tree, but LMK if you want it via the RISC-V tree as IIRC we're 
> using it too.

Hi Palmer,  there is a v3 with changelog updated,

https://lore.kernel.org/lkml/20210731025057.78825-1-wangliang101@huawei.com/


>
> Thanks!
> .
>
