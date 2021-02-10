Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA5316938
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhBJOfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:35:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:34700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhBJOfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:35:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 334EAAED2;
        Wed, 10 Feb 2021 14:34:17 +0000 (UTC)
Subject: Re: [patch 13/14] mm, slub: better heuristic for number of cpus when
 calculating slab order
To:     Andrew Morton <akpm@linux-foundation.org>,
        aneesh.kumar@linux.ibm.com, bharata@linux.ibm.com,
        catalin.marinas@arm.com, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jannh@google.com,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vincent.guittot@linaro.org,
        will@kernel.org
References: <20210209214232.hlVJaEmRu%akpm@linux-foundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <4d33f14e-93ba-76ec-a82e-168ee2f25fe6@suse.cz>
Date:   Wed, 10 Feb 2021 15:34:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209214232.hlVJaEmRu%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/21 10:42 PM, Andrew Morton wrote:
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: mm, slub: better heuristic for number of cpus when calculating slab order
> 

...

> Link: https://lkml.kernel.org/r/20210208134108.22286-1-vbabka@suse.cz
> Fixes: 045ab8c9487b ("mm/slub: let number of online CPUs determine the slub page order")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reported-by: Mel Gorman <mgorman@techsingularity.net>
> Tested-by: Vincent Guittot <vincent.guittot@linaro.org>

As Andrew's incoming series might have been not merged yet, I will point to
Mel's Tested-by:

https://lore.kernel.org/linux-mm/20210210140712.GB3697@techsingularity.net/

Thanks, Mel!

> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/slub.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
