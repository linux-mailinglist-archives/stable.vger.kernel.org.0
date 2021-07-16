Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72F3CB07C
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 03:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGPBkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 21:40:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15025 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhGPBkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 21:40:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GQv0J4ldbzZndc;
        Fri, 16 Jul 2021 09:33:52 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 09:37:11 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 09:37:10 +0800
Subject: Re: [PATCH 5.4 031/122] net: moxa: Use
 devm_platform_get_and_ioremap_resource()
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin" <sashal@kernel.org>
References: <20210715182448.393443551@linuxfoundation.org>
 <20210715182456.876823976@linuxfoundation.org>
 <CADVatmNj+HSarEpuYdKsZaNyrOgyXfJw7u9LJxa2RSBf8iXnHQ@mail.gmail.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <f1410523-2498-9a71-4918-d14bfde40792@huawei.com>
Date:   Fri, 16 Jul 2021 09:37:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CADVatmNj+HSarEpuYdKsZaNyrOgyXfJw7u9LJxa2RSBf8iXnHQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2021/7/16 5:26, Sudip Mukherjee wrote:
> Hi Greg,
>
> On Thu, Jul 15, 2021 at 7:44 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> From: Yang Yingliang <yangyingliang@huawei.com>
>>
>> [ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]
> arm moxart_defconfig build fails with the error:
> drivers/net/ethernet/moxa/moxart_ether.c:483:22: error: implicit
> declaration of function 'devm_platform_get_and_ioremap_resource'; did
> you mean 'devm_platform_ioremap_resource'?
> [-Werror=implicit-function-declaration]

devm_platform_get_and_ioremap_resource() is introduced in v5.7-rc1, I can
send a patch for stable-5.4.

Thanks,
Yang

>
> Reverting this patch fixes the build.
>
>
