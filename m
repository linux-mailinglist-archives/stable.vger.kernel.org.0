Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C281E21E5FA
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 04:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGNCzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 22:55:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbgGNCzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 22:55:23 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 89A717A3699D5D2F4C80;
        Tue, 14 Jul 2020 10:55:20 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.211) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Jul 2020
 10:55:17 +0800
Subject: Re: [PATCH 4.19] IB/umem: fix reference count leak in
 ib_umem_odp_get()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <sashal@kernel.org>
References: <20200619160307.1601016-1-yangyingliang@huawei.com>
 <20200713145226.GA3767483@kroah.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5c32631b-c35d-7858-d393-8c1d8ac5e1aa@huawei.com>
Date:   Tue, 14 Jul 2020 10:55:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200713145226.GA3767483@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.211]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/7/13 22:52, Greg KH wrote:
> On Fri, Jun 19, 2020 at 04:03:07PM +0000, Yang Yingliang wrote:
>> Add missing mmput() on error path to avoid ref-count leak.
>>
>> This problem has already been resolved in mainline by
>> f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
>>
>> Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/infiniband/core/umem_odp.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
> We need an ack by the owner/maintainer of this code, please get the IB
> developers/maintainers to do that first.

OK， I will send a new patch.

>
> Any reason why you didn't cc: them also?
>
> thanks,
>
> greg k-h
> .

