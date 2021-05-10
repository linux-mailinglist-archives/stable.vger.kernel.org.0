Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB13779A5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 03:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhEJBNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 21:13:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2606 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhEJBNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 21:13:31 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fdjdz0tPBzlcpf;
        Mon, 10 May 2021 09:10:15 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Mon, 10 May 2021
 09:12:22 +0800
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To:     Marc Zyngier <maz@kernel.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>
CC:     <jasowang@redhat.com>, <mst@redhat.com>,
        <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <cohuck@redhat.com>,
        <stable@vger.kernel.org>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <8735uxvajh.wl-maz@kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <cfb68374-a7bf-1eb4-86cf-77c57f7fe9e5@hisilicon.com>
Date:   Mon, 10 May 2021 09:12:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8735uxvajh.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 2021/5/8 17:29, Marc Zyngier wrote:
> On Sat, 08 May 2021 08:11:52 +0100,
> Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>
>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>
>> The reverted commit may cause VM freeze on arm64 platform.
>> Because on arm64 platform, stop a consumer will suspend the VM,
>> the VM will freeze without a start consumer
> 
> It also unconditionally calls del_consumer on the producer, which
> isn't exactly expected.
> 
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> 
> Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Thanks for the tag, it works with this patch, So:
Tested-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

I shall invite you to have a drink for the quick debug.
Anyway, thank you again.

Shaokun

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Fixes: a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
> Link: https://lore.kernel.org/r/3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com
> Cc: stable@vger.kernel.org
> 
> Thanks,
> 
> 	M.
> 
