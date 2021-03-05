Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF932E2A8
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 08:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCEHAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 02:00:10 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:45872 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEHAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 02:00:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UQXPdCN_1614927607;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQXPdCN_1614927607)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 15:00:08 +0800
Subject: Re: [PATCH 4.4.y 2/2] dm table: fix no_sg_merge iterate_devices based
 device capability checks
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
References: <161460624611368@kroah.com>
 <20210305063051.51030-1-jefflexu@linux.alibaba.com>
 <20210305063051.51030-3-jefflexu@linux.alibaba.com>
 <YEHTwKad3rP+fMIe@kroah.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <ad56928a-c377-3c6b-4009-d7a04af6c9fc@linux.alibaba.com>
Date:   Fri, 5 Mar 2021 15:00:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEHTwKad3rP+fMIe@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/21 2:46 PM, Greg KH wrote:
> On Fri, Mar 05, 2021 at 02:30:51PM +0800, Jeffle Xu wrote:
>> Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
>> device capability checks"), fix NO_SG_MERGE capability check and invert
>> logic of the corresponding iterate_devices_callout_fn so that all
>> devices' NO_SG_MERGE capabilities are properly checked.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> Fixes: 200612ec33e5 ("dm table: propagate QUEUE_FLAG_NO_SG_MERGE")
>> ---
>>  drivers/md/dm-table.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> What is the git commit id of this patch in Linus's tree?
> 
> thanks,
> 
> greg k-h
> 

The code this patch fixes, i.e., commit 200612ec33e5 ("dm table:
propagate QUEUE_FLAG_NO_SG_MERGE"), was removed since commit
2705c93742e9 ("block: kill QUEUE_FLAG_NO_SG_MERGE") in v5.1. Thus the
code base doesn't exist in the latest master branch.

-- 
Thanks,
Jeffle
