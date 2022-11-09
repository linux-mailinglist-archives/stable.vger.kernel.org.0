Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0FA6222E4
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 04:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiKID6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 22:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKID6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 22:58:02 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BB017A8A;
        Tue,  8 Nov 2022 19:58:00 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N6WM603ZLzHqW3;
        Wed,  9 Nov 2022 11:54:58 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 11:57:58 +0800
Message-ID: <1f43c4a4-ee6b-f760-b7a8-c2651f077596@huawei.com>
Date:   Wed, 9 Nov 2022 11:57:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Qi Zheng <zhengqi.arch@bytedance.com>, <dvyukov@google.com>,
        <willy@infradead.org>, <akinobu.mita@gmail.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <Y2kxrerISWIxQsFO@nvidia.com>
 <20221108035232.87180-1-zhengqi.arch@bytedance.com>
 <65863340-b32f-a2fe-67ae-f1079b19eee4@huawei.com>
 <70dfbac1-4c84-9567-30be-1e2594157e62@bytedance.com>
 <e644e4bf-f1e0-3e22-7773-62f38f9b8963@huawei.com>
 <Y2pF4x4gsKjaHJaE@nvidia.com>
From:   Wei Yongjun <weiyongjun1@huawei.com>
In-Reply-To: <Y2pF4x4gsKjaHJaE@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/11/8 20:04, Jason Gunthorpe wrote:
> On Tue, Nov 08, 2022 at 05:32:52PM +0800, Wei Yongjun wrote:
>>> So you want to set/clear this no_warn attr through the procfs or sysfs
>>> interface, so that you can easily disable/enable the slab/page fault
>>> warning message from the user mode. Right?
>>
>> Yes, just like:
>>
>> echo 1 > /sys/kernel/debug/failslab/no_warn  #disable message
>> echo 0 > /sys/kernel/debug/failslab/no_warn  #enable message
> 
> You can already do that:
> 
>  echo 0 > /sys/kernel/debug/failslab/verbose  #disable message

Got it, thanks.

Wei Yongjun

