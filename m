Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA24E6D789C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbjDEJlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbjDEJlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:41:52 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECFC1701;
        Wed,  5 Apr 2023 02:41:47 -0700 (PDT)
Received: from frapeml500002.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Ps03454rbz6J76F;
        Wed,  5 Apr 2023 17:39:44 +0800 (CST)
Received: from [10.81.203.211] (10.81.203.211) by
 frapeml500002.china.huawei.com (7.182.85.205) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 5 Apr 2023 11:41:43 +0200
Message-ID: <539e9035-2673-a51b-c40c-5e5b5e79056c@huawei.com>
Date:   Wed, 5 Apr 2023 11:41:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kelsey Steele <kelseysteele@linux.microsoft.com>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>, <decui@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <iommu@lists.linux.dev>,
        <robin.murphy@arm.com>, <dexuan.linux@gmail.com>,
        <tyler.hicks@microsoft.com>
References: <20230404183150.381314754@linuxfoundation.org>
 <20230405003549.GA21326@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <2023040503-perkiness-nutty-f8f4@gregkh>
From:   Petr Tesarik <petr.tesarik.ext@huawei.com>
In-Reply-To: <2023040503-perkiness-nutty-f8f4@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.203.211]
X-ClientProxiedBy: frapeml100003.china.huawei.com (7.182.85.60) To
 frapeml500002.china.huawei.com (7.182.85.205)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.7 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/2023 11:30 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 04, 2023 at 05:35:49PM -0700, Kelsey Steele wrote:
>> On Tue, Apr 04, 2023 at 08:32:15PM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.23 release.
>>> There are 179 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Hi Greg, 
>>
>> 6.1.23-rc2 is failing to boot on x86 WSL. A bisect leads to commit
>> c2f05366b687 ("swiotlb: fix slot alignment checks") being the problem
>> and reverting this patch puts everything back in a working state.
>>
>> There's a report from Dexuan who also encountered this error on a Linux
>> VM on Hyper-V:
>>
>> https://lore.kernel.org/all/CAA42JLa1y9jJ7BgQvXeUYQh-K2mDNHd2BYZ4iZUz33r5zY7oAQ@mail.gmail.com/
>>
>> Adding a chunk of my log below which shows errors occuring from the hv_strvsc driver.
> 
> Is this also a problem on 6.2-rc1, and Linus's tree?

Yes, unfortunately.

Petr T

