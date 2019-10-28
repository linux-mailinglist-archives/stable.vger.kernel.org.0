Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5DE6E69
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 09:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbfJ1IpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 04:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731611AbfJ1IpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 04:45:00 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7DBB20717;
        Mon, 28 Oct 2019 08:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572252300;
        bh=dZ6FLCsQxObMJCgR5PzcGKpgiqh8ZNo3SCLPQXysdP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hl1Grj6N/ezbgF5xVfO+XwWfUGLDX+0dHLihGTyC2lDIsniCvcfObGldllfFzrp3e
         gbqDhV9lKOLsopBaF+GYhhN0lqY7yAyycj2Hyz0vrtjxAsfAPei4XGP0YXQ1HvVK88
         Yv0WcQxo/tunXGvZ9w3pCOhyjuybXDklMcrcKtps=
Date:   Mon, 28 Oct 2019 04:44:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     david@redhat.com, akpm@linux-foundation.org, mhocko@kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/memory-failure.c: don't access
 uninitialized memmaps in" failed to apply to 4.14-stable tree
Message-ID: <20191028084457.GJ1560@sasha-vm>
References: <1572183691251118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1572183691251118@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 02:41:31PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 96c804a6ae8c59a9092b3d5dd581198472063184 Mon Sep 17 00:00:00 2001
>From: David Hildenbrand <david@redhat.com>
>Date: Fri, 18 Oct 2019 20:19:23 -0700
>Subject: [PATCH] mm/memory-failure.c: don't access uninitialized memmaps in
> memory_failure()
>
>We should check for pfn_to_online_page() to not access uninitialized
>memmaps.  Reshuffle the code so we don't have to duplicate the error
>message.
>
>Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
>Signed-off-by: David Hildenbrand <david@redhat.com>
>Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
>Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>Cc: Michal Hocko <mhocko@kernel.org>
>Cc: <stable@vger.kernel.org>	[4.13+]
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I took in 83b57531c58f4 ("mm/memory_failure: Remove unused trapno from
memory_failure") for 4.14 to address this.

-- 
Thanks,
Sasha
