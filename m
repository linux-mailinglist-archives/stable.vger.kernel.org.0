Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73607301FD2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 02:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbhAYBJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 20:09:16 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11580 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbhAYBHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 20:07:51 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DPBVM3GdmzMPRl;
        Mon, 25 Jan 2021 09:04:59 +0800 (CST)
Received: from [10.174.176.185] (10.174.176.185) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 09:05:48 +0800
Subject: Re: [PATCH 3/4] ubifs: Update directory size when creating whiteouts
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>
CC:     <david@sigma-star.at>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210122212229.17072-1-richard@nod.at>
 <20210122212229.17072-4-richard@nod.at>
 <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com>
Message-ID: <cca6ac4f-4739-76be-9b48-b3643017a556@huawei.com>
Date:   Mon, 25 Jan 2021 09:05:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/1/23 10:45, Zhihao Cheng 写道:

>> @@ -430,6 +433,7 @@ static int do_tmpfile(struct inode *dir, struct 
>> dentry *dentry,
>>       return 0;
>>   out_cancel:
Still one question:
> Does this need a judgment? Like this,
> if (whiteout)
>      dir->i_size -= sz_change;

>> +    dir->i_size -= sz_change;
>>       mutex_unlock(&dir_ui->ui_mutex);
>>   out_inode:
>>       make_bad_inode(inode);
>>
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/

