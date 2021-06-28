Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5003B5733
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 04:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhF1Can (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 22:30:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12077 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhF1Cam (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 22:30:42 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GCrzp26ZnzZkdZ;
        Mon, 28 Jun 2021 10:25:10 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 10:28:10 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 10:28:10 +0800
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Bin Meng <bmeng.cn@gmail.com>
CC:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        stable <stable@vger.kernel.org>
References: <20210627135117.28641-1-bmeng.cn@gmail.com>
 <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com>
Date:   Mon, 28 Jun 2021 10:28:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
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


On 2021/6/28 9:15, Bin Meng wrote:
> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>> Hi， sorry for the mistake，the bug is fixed by
>>
>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefeng.wang@huawei.com/
> What are we on the patch you mentioned?
>
> I don't see it applied in the linux/master.
>
> Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
> because 32-bit is broken since v5.12.

https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linux/+/c9811e379b211c67ba29fb09d6f644dd44cfcff2

it's on Palmer' riscv-next.

Hi Palmer, should I resend or could you help me to add the fixes tag?

>
> Regards,
> Bin
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
