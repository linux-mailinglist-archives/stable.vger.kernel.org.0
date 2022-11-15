Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8F6290D1
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 04:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiKODeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 22:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiKODeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 22:34:16 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C71A62FF;
        Mon, 14 Nov 2022 19:34:15 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NBBbq4bBNzHvrm;
        Tue, 15 Nov 2022 11:33:43 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 11:34:12 +0800
Message-ID: <f0136268-63d4-66ec-98fe-b7584b388906@huawei.com>
Date:   Tue, 15 Nov 2022 11:34:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>, Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20221114124448.729235104@linuxfoundation.org>
 <CA+G9fYvdqK23zAa+=-x29Hq7BGVd2pN1_1XOp5U1X-GUWM4MAA@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CA+G9fYvdqK23zAa+=-x29Hq7BGVd2pN1_1XOp5U1X-GUWM4MAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/11/15 10:56, Naresh Kamboju wrote:
> On Mon, 14 Nov 2022 at 18:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.79 release.
>> There are 131 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> As others reported,
> arm: allmodconfig  failed [1] due to following warnings / errors.
> 
> drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
> drivers/net/ethernet/mediatek/mtk_star_emac.c:980:22: error: 'struct
> mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
>    980 |  napi_disable(&priv->rx_napi);
>        |                      ^~~~~~~
>        |                      napi
> drivers/net/ethernet/mediatek/mtk_star_emac.c:981:22: error: 'struct
> mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
>    981 |  napi_disable(&priv->tx_napi);
>        |                      ^~~~~~~
>        |                      napi
> 
> 
> ---
> net: ethernet: mtk-star-emac: disable napi when connect and start PHY
> failed in mtk_star_enable()
> [ Upstream commit b0c09c7f08c2467b2089bdf4adb2fbbc2464f4a8 ]
> 
> 
> [1] https://builds.tuxbuild.com/2HXmwUDUvmWI1Uc7zsdXNcsTqW1/
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

Yes ,For stable-5.10, commit 0a8bd81fd6aaace14979152e0540da8ff158a00a
("net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs")
is not merged. So, please use napi_disable(&priv->napi) instead of
napi_disable(&priv->rx_napi) and napi_disable(&priv->tx_napi).
