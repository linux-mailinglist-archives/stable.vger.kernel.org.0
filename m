Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA3A9C00A
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 22:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfHXUXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 16:23:11 -0400
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:60210 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfHXUXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Aug 2019 16:23:11 -0400
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
To:     Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>
CC:     Greg KH <greg@kroah.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>
References: <20190817004726.2530670-1-guro@fb.com>
 <20190817063616.GA11747@kroah.com> <20190817191518.GB11125@castle>
 <20190824125750.da9f0aac47cc0a362208f9ff@linux-foundation.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <a082485b-8241-e73d-df09-5c878d181ddc@mageia.org>
Date:   Sat, 24 Aug 2019 23:23:07 +0300
MIME-Version: 1.0
In-Reply-To: <20190824125750.da9f0aac47cc0a362208f9ff@linux-foundation.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0213.5D619CAE.006D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.194
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 24-08-2019 kl. 22:57, skrev Andrew Morton:
> On Sat, 17 Aug 2019 19:15:23 +0000 Roman Gushchin <guro@fb.com> wrote:
> 
>>>> Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
>>>> Signed-off-by: Roman Gushchin <guro@fb.com>
>>>> Cc: Yafang Shao <laoar.shao@gmail.com>
>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>> ---
>>>>   mm/memcontrol.c | 8 +++-----
>>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> <formletter>
>>>
>>> This is not the correct way to submit patches for inclusion in the
>>> stable kernel tree.  Please read:
>>>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>> for how to do this properly.
>>
>> Oh, I'm sorry, will read and follow next time. Thanks!
> 
> 766a4c19d880 is not present in 5.2 so no -stable backport is needed, yes?
> 

Unfortunately it got added in 5.2.7, so backport is needed.

--
Thomas

