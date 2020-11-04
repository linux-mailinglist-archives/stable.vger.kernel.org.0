Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B7E2A5C1F
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 02:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgKDBpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 20:45:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7138 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgKDBpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 20:45:01 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CQqGJ6pKyz15Qjc;
        Wed,  4 Nov 2020 09:44:56 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 4 Nov 2020
 09:44:56 +0800
Subject: Re: [PATCH 1/4] erofs: fix setting up pcluster for temporary pages
To:     Gao Xiang <hsiangkao@redhat.com>
CC:     Gao Xiang <hsiangkao@aol.com>, <linux-erofs@lists.ozlabs.org>,
        Chao Yu <chao@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20201022145724.27284-1-hsiangkao.ref@aol.com>
 <20201022145724.27284-1-hsiangkao@aol.com>
 <f1f24a38-97f7-e9cf-03c8-2c95814b98a3@huawei.com>
 <20201104011130.GA982972@xiangao.remote.csb>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <e4cbe373-ca69-5f95-99c7-422375c58e4e@huawei.com>
Date:   Wed, 4 Nov 2020 09:44:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201104011130.GA982972@xiangao.remote.csb>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/4 9:11, Gao Xiang wrote:
> On Wed, Nov 04, 2020 at 09:05:56AM +0800, Chao Yu wrote:
>> On 2020/10/22 22:57, Gao Xiang wrote:
>>> From: Gao Xiang <hsiangkao@redhat.com>
>>>
>>> pcluster should be only set up for all managed pages instead of
>>> temporary pages. Since it currently uses page->mapping to identify,
>>> the impact is minor for now.
>>>
>>> Fixes: 5ddcee1f3a1c ("erofs: get rid of __stagingpage_alloc helper")
>>> Cc: <stable@vger.kernel.org> # 5.5+
>>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>>
>> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> 
> Thanks, I've also added a note to the commit message like this,
> "
> [ Update: Vladimir reported the kernel log becomes polluted
>    because PAGE_FLAGS_CHECK_AT_FREE flag(s) set if the page
>    allocation debug option is enabled. ]
> "
> Will apply all of this to -fixes branch.

Thanks for noticing that, looks fine to me.

Thanks,

> 
> Thanks,
> Gao Xiang
> 
>>
>> Thanks,
>>
> 
> .
> 
