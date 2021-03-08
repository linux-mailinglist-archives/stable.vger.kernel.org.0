Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022E43305CA
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 03:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhCHCGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 21:06:05 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:60367 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233659AbhCHCFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 21:05:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UQodk.4_1615169148;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQodk.4_1615169148)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Mar 2021 10:05:48 +0800
Subject: Re: [PATCH 5.4.y 3/4] dm table: fix DAX iterate_devices based device
 capability checks
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
 <20210305065722.73504-4-jefflexu@linux.alibaba.com>
 <YETr2MwFMtHqymM3@kroah.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <8106f450-6769-a6ee-829c-b6454a84d1b5@linux.alibaba.com>
Date:   Mon, 8 Mar 2021 10:05:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YETr2MwFMtHqymM3@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/7/21 11:06 PM, Greg KH wrote:
> On Fri, Mar 05, 2021 at 02:57:21PM +0800, Jeffle Xu wrote:
>> commit 57ba3e506c30a84b1ba1dd77ddd9f2be9d472e98 upstream.
> 
> There is no such git id "upstream" :(
> 
> Please fix up all of these series with the needed information on the
> non-upstream patch, and make sure you have the correct git commit ids on
> your patches.
> 

Sorry, it shall be 5b0fab508992c2e120971da658ce80027acbc405. I will
correct all these for all 4.9~5.4 in  the next version.

-- 
Thanks,
Jeffle
