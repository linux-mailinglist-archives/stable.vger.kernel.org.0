Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A190D1475B5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 01:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgAXAtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 19:49:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:57792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgAXAtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 19:49:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 844CFAD10;
        Fri, 24 Jan 2020 00:49:23 +0000 (UTC)
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Michael Lyle <mlyle@lyle.org>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        linux-block@vger.kernel.org, stable <stable@vger.kernel.org>
References: <20200123170142.98974-1-colyli@suse.de>
 <20200123170142.98974-15-colyli@suse.de>
 <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com>
 <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
 <31f7f6b4-98ea-3cf6-44cc-a9ba67484eb0@kernel.dk>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <6373da22-9dc1-9525-4048-2c533407c917@suse.de>
Date:   Fri, 24 Jan 2020 08:49:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <31f7f6b4-98ea-3cf6-44cc-a9ba67484eb0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/1/24 2:31 上午, Jens Axboe wrote:
> On 1/23/20 10:27 AM, Coly Li wrote:
>> On 2020/1/24 1:19 上午, Michael Lyle wrote:
>>> Hi Coly and Jens--
>>>
>>> One concern I have with this is that it's going to wear out
>>> limited-lifetime SSDs a -lot- faster.  Was any thought given to making
>>> this a tunable instead of just changing the behavior?  Even if we have
>>> an anecdote or two that it seems to have increased performance for
>>> some workloads, I don't expect it will have increased performance in
>>> general and it may even be costly for some workloads (it all comes
>>> down to what is more useful in the cache-- somewhat-recently readahead
>>> data, or the data that it is displacing).
>>
>> Hi Mike,
>>
>> Copied. This is good suggestion, I will do it after I back from Lunar
>> New Year vacation, and submit it with other tested patches in following
>> v5.6-rc versions.
> 
> Do you want me to just drop this patch for now from the series?
> 
Hi Jens,

OK, please drop this patch from this series. I will re-submit the patch
with sysfs interface later with other patches.

Thanks.

-- 

Coly Li
