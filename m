Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C14739A
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 09:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfFPHVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 03:21:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18625 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfFPHVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 03:21:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5A8BF53647C697CF2FA8;
        Sun, 16 Jun 2019 15:21:38 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.439.0; Sun, 16 Jun
 2019 15:21:32 +0800
Subject: Re: [PATCH v3 1/2] staging: erofs: add requirements field in
 superblock
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <devel@driverdev.osuosl.org>, Chao Yu <chao@kernel.org>,
        <linux-erofs@lists.ozlabs.org>, Chao Yu <yuchao0@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <weidu.du@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Miao Xie <miaoxie@huawei.com>
References: <20190611024220.86121-1-gaoxiang25@huawei.com>
 <20190613083541.67091-1-gaoxiang25@huawei.com>
 <a4d587eb-c4f0-b9e5-7ece-1ac38c2735f3@huawei.com>
 <20190616071439.GA11880@kroah.com>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <b2608d35-1d9f-0747-ce3c-ddfd6273e865@huawei.com>
Date:   Sun, 16 Jun 2019 15:21:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190616071439.GA11880@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/6/16 15:14, Greg Kroah-Hartman wrote:
> On Sun, Jun 16, 2019 at 03:00:38PM +0800, Gao Xiang wrote:
>> Hi Greg,
>>
>> Sorry for annoying... Could you help merge these two fixes? Thanks in advance...
> 
> It was only 3 days, please give me at the very least, a week or so for
> staging patches.
> 
>> decompression inplace optimization needs these two patches and I will integrate
>> erofs decompression inplace optimization later for linux-next 5.3, and try to start 
>> making effort on moving to fs/ directory on kernel 5.4...
> 
> You can always send follow-on patches, I apply them in the correct
> order.  I will get to these next week, thanks.

OK, I was actually just afraid of the appling order. I was thinking of merging
these two patches in advance since the new series has the dependency on these patches.

Thanks,
Gao Xiang

> 
> greg k-h
> 
