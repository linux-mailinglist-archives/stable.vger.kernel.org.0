Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D5532E40C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 09:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEI6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 03:58:05 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:56360 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhCEI5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 03:57:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UQXTKE3_1614934655;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQXTKE3_1614934655)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 16:57:36 +0800
Subject: Re: [PATCH 5.4.y 2/4] dm table: fix partial completion
 iterate_devices based device capability checks
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
 <20210305065722.73504-3-jefflexu@linux.alibaba.com>
 <YEHve5QkPuimNnnY@kroah.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <641a897a-d860-9de0-7d67-a1546a449ea2@linux.alibaba.com>
Date:   Fri, 5 Mar 2021 16:57:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEHve5QkPuimNnnY@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/21 4:44 PM, Greg KH wrote:
> On Fri, Mar 05, 2021 at 02:57:20PM +0800, Jeffle Xu wrote:
>> Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
>> device capability checks"), fix partial completion capability check and
>> invert logic of the corresponding iterate_devices_callout_fn so that all
>> devices' partial completion capabilities are properly checked.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> Fixes: 22c11858e800 ("dm: introduce DM_TYPE_NVME_BIO_BASED")
>> ---
>>  drivers/md/dm-table.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Why isn't this a commit in Linus's tree?  That needs to be really really
> explicitly documented here.


Sorry, as I stated in the reply in the patch set for 4.19. (The replying
mail doesn't appear in the archive yet, so I just copy the content here
in the quotation format.)

> Similarly, the code this patch fixes, i.e., commit 22c11858e800 ("dm:
> introduce DM_TYPE_NVME_BIO_BASED"), was removed since commit
> 9c37de297f65 ("dm: remove special-casing of bio-based immutable
> singleton target on NVMe") in v5.10. Thus the code base doesn't exist in
> the latest master branch.
> 
> It needs Mike's review.


I could update the commit log and document all the information once Mike
has reviewed.

-- 
Thanks,
Jeffle
