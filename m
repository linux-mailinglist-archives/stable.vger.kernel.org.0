Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0332B5BAE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgKQJVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:21:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7634 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQJVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 04:21:35 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cb0mk721kz15LrY;
        Tue, 17 Nov 2020 17:21:10 +0800 (CST)
Received: from [10.174.176.185] (10.174.176.185) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 17 Nov 2020 17:21:19 +0800
Subject: Re: [PATCH] ubifs: wbuf: Don't leak kernel memory to flash
To:     Richard Weinberger <richard.weinberger@gmail.com>
CC:     Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20201116210530.26230-1-richard@nod.at>
 <bfea268f-b5c2-5467-7b17-5eef7b0269ce@huawei.com>
 <CAFLxGvy4_H0rn085j9=o2kW2X0rHcRJVMSAbp8OyYVVFhTcXpg@mail.gmail.com>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <64125c57-6165-9501-ccb7-b87746b7fe04@huawei.com>
Date:   Tue, 17 Nov 2020 17:21:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFLxGvy4_H0rn085j9=o2kW2X0rHcRJVMSAbp8OyYVVFhTcXpg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2020/11/17 16:43, Richard Weinberger 写道:
> On Tue, Nov 17, 2020 at 2:28 AM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
>>
>> Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> Thanks for reviewing, highly appreciated!
> 
You're welcome. Actually I've been following the linux-mtd. It's just 
that this patch isn't complicated, so I checked it. :-)
