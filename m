Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE689690
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 07:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfHLFEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 01:04:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:40092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbfHLFEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 01:04:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA61DAF23;
        Mon, 12 Aug 2019 05:04:31 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] bcache: Revert "bcache: use
 sysfs_match_string() instead of" failed to apply to 5.2-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     alexandru.ardelean@analog.com, axboe@kernel.dk, pflin@suse.com,
        stable@vger.kernel.org
References: <156553570618483@kroah.com>
 <81d2423d-74dd-50ba-4a33-05306a1b13dd@suse.de>
 <20190811160959.GA8117@kroah.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <005a245a-1ac5-f5f5-506c-995c003e5912@suse.de>
Date:   Mon, 12 Aug 2019 13:04:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811160959.GA8117@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/8/12 12:09 上午, Greg KH wrote:
> On Sun, Aug 11, 2019 at 11:41:57PM +0800, Coly Li wrote:
>> On 2019/8/11 11:01 下午, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.2-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>> I will post a rebased patch for the 5.2-stable tree.
> 
> Is it really needed?
> 
> I ask because in the patch it says:
> 
>>> This bug was introduced in Linux v5.2, so this fix only applies to
>>> Linux v5.2 is enough for stable tree maintainer.
>>>
>>> Fixes: 89e0341af082 ("bcache: use sysfs_match_string() instead of __sysfs_match_string()")

Hi Greg,

> 
> But commit 89e0341af082 showed up in 5.3-rc1, not 5.2.
> 
> So why is this needed in 5.2.y?

Indeed I was not sure which version this patch was merged, so I ran,
> git describe 89e0341af082
v5.2-rc4-245-g89e0341af082

It seems I use git in an incorrect way. After check man git-describe I
see '--contains' should be added (to find a tag which after/contains the
commit),
> git describe --contains 89e0341af082
v5.3-rc1~164^2~57

Yes, the fixing bug is from v5.3-rc1. Please ignore the noise....

Thanks.

-- 

Coly Li
