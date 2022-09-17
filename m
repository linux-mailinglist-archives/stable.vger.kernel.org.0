Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2252E5BB578
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 04:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIQCEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 22:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIQCEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 22:04:10 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BEABC803;
        Fri, 16 Sep 2022 19:04:09 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MTvK20ZqczlVrY;
        Sat, 17 Sep 2022 10:00:06 +0800 (CST)
Received: from kwepemm600020.china.huawei.com (7.193.23.147) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 10:04:07 +0800
Received: from [127.0.0.1] (10.174.178.94) by kwepemm600020.china.huawei.com
 (7.193.23.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 10:04:06 +0800
Message-ID: <23826ddf-387e-ec0d-7c32-99424d6d0769@huawei.com>
Date:   Sat, 17 Sep 2022 10:04:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 4.19 00/79] 4.19.257-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>
References: <20220913140348.835121645@linuxfoundation.org>
Content-Language: en-US
From:   zhouzhixiu <zhouzhixiu@huawei.com>
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.94]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600020.china.huawei.com (7.193.23.147)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022/9/13 22:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.257-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

> Tested on arm64 and x86 for 4.19.257-rc1,
>
> Kernel repo:https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-4.19.y
> Version: 4.19.257-rc1
> Commit: 74af49d445c5d4d9229853d0904d47baafc57359
> Compiler: gcc version 7.3.0 (GCC)
>
> arm64:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 8947
> passed: 8947
> failed: 0
> timeout: 0
> --------------------------------------------------------------------
>
> x86:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 8947
> passed: 8947
> failed: 0
> timeout: 0
> --------------------------------------------------------------------
> Tested-by: Hulk Robot <hulkrobot@huawei.com>


