Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9132DCCC0
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 07:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLQGwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 01:52:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9460 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgLQGwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 01:52:43 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CxN2B4G3BzhrYm;
        Thu, 17 Dec 2020 14:51:30 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.201) with Microsoft SMTP Server (TLS) id 14.3.498.0; Thu, 17 Dec
 2020 14:51:57 +0800
Subject: Re: [PATCH] f2fs: fix out-of-repair __setattr_copy()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <jaegeuk@kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <chao@kernel.org>,
        <stable@vger.kernel.org>
References: <20201216091523.21411-1-yuchao0@huawei.com>
 <X9nXCdp1ssMHKdNI@kroah.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <a8291621-e472-5b00-d2b3-8d8016386e47@huawei.com>
Date:   Thu, 17 Dec 2020 14:51:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X9nXCdp1ssMHKdNI@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/12/16 17:44, Greg KH wrote:
> On Wed, Dec 16, 2020 at 05:15:23PM +0800, Chao Yu wrote:
>> __setattr_copy() was copied from setattr_copy() in fs/attr.c, there is
>> two missing patches doesn't cover this inner function, fix it.
>>
>> Commit 7fa294c8991c ("userns: Allow chown and setgid preservation")
>> Commit 23adbe12ef7d ("fs,userns: Change inode_capable to capable_wrt_inode_uidgid")
> 
> Are these lines supposed to be "Fixes:" instead of "Commit "?

IMO, the issue was introduced when f2fs module was added, and above two commits
missed to cover f2fs module... so I guess we can add Fixes line as below?

Fixes: fbfa2cc58d53 ("f2fs: add file operations")

Thanks,

> 
> thanks,
> 
> greg k-h
> .
> 
