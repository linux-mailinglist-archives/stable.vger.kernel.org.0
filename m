Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F02145EB9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 23:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAVWnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 17:43:35 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:60922 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgAVWne (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 17:43:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0ToN07GK_1579733009;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0ToN07GK_1579733009)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Jan 2020 06:43:32 +0800
Subject: Re: [PATCH] mm: move_pages: report the number of non-attempted pages
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mhocko@suse.com, richardw.yang@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1579721990-18672-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200122140547.92940695cc47ccb7b7be7d44@linux-foundation.org>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <839e0184-59bd-669f-1c13-d9e83b95b274@linux.alibaba.com>
Date:   Wed, 22 Jan 2020 14:43:20 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200122140547.92940695cc47ccb7b7be7d44@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/22/20 2:05 PM, Andrew Morton wrote:
> On Thu, 23 Jan 2020 03:39:50 +0800 Yang Shi <yang.shi@linux.alibaba.com> wrote:
>
>> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>> the semantic of move_pages() was changed to return the number of
>> non-migrated pages (failed to migration) and the call would be aborted
>> immediately if migrate_pages() returns positive value.  But it didn't
>> report the number of pages that we even haven't attempted to migrate.
>> So, fix it by including non-attempted pages in the return value.
>>
>> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>> Suggested-by: Michal Hocko <mhocko@suse.com>
>> Cc: Wei Yang <richardw.yang@linux.intel.com>
>> Cc: <stable@vger.kernel.org>    [4.17+]
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> ---
>> The patch is based off Wei Yang's cleanup patchset:
>> https://lore.kernel.org/linux-mm/20200122011647.13636-1-richardw.yang@linux.intel.com/T/#t
> Can you please redo this so it is applicable to current mainline?  That
> will make it more easily backportable and this fix is higher priority
> than a set of cleanups.

Sure.

