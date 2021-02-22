Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46CB3214FC
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBVLXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:23:30 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12987 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhBVLX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 06:23:29 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DkfrS6ptCzjRDw;
        Mon, 22 Feb 2021 19:21:12 +0800 (CST)
Received: from [10.67.110.218] (10.67.110.218) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 19:22:39 +0800
Subject: Re: [PATCH 1/1] futex: Fix OWNER_DEAD fixup
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <judy.chenhui@huawei.com>,
        <zhangjinhao2@huawei.com>, <lee.jones@linaro.org>,
        <tglx@linutronix.de>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
 <20210222040618.2911498-2-zhengyejian1@huawei.com>
 <YDOElnMczO92t4Ee@kroah.com>
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Message-ID: <95b7b822-fba3-96b8-f336-cb3a8efe717c@huawei.com>
Date:   Mon, 22 Feb 2021 19:22:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDOElnMczO92t4Ee@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/2/22 18:16, Greg KH wrote:
> On Mon, Feb 22, 2021 at 12:06:18PM +0800, Zheng Yejian wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
> 
> Why is this not also needed in 4.9.y?  If so, please also provide a
> backport there so I can apply this one too.
> 

I've sent a backport for 4.9.y, please review it.
Thanks~
