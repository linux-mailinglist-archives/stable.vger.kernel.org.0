Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A34D2351BB
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 12:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgHAKjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 06:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbgHAKjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 06:39:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A19D20716;
        Sat,  1 Aug 2020 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596278389;
        bh=8JWYD2B56ttQ/lSxpkTyxarsszxMaxxbKAQy93JeM0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CB5II3wn+ExyyEU1lzPl8SApBFWJynzbFgq3vRBGO2VpMBE0H7qj51qImOtHK1+p9
         W0tEI9cuKs5va0kqSbIOOqsArdsVOH95Hjq/P89rdnYIGBGumj4a4kcyaKQStGlbRo
         O7/QoPCLEf8Ak1br033trGeJpLhzQDp92Mcj48yc=
Date:   Sat, 1 Aug 2020 12:39:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Josef Bacik <josef@toxicpanda.com>,
        Robert Stupp <snazy@gmx.de>, Minchan Kim <minchan@kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: Don't bother dropping mmap_sem for zero size
 readahead
Message-ID: <20200801103933.GE3046974@kroah.com>
References: <20200212101356.30759-1-jack@suse.cz>
 <20200730113435.2280-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730113435.2280-1-sjpark@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 01:34:35PM +0200, SeongJae Park wrote:
> Hello,
> 
> 
> The commit fixed by this patch[1] was merged in v5.1 and this patch was merged
> in the mainline in v5.7 (5c72feee3e45b40a3c96c7145ec422899d0e8964).  Thus, the
> issue affects [v5.1, v5.6].  I was also able to reproduce the issue and confirm
> the fix works on v5.4 based kernels.
> 
> However, I couldn't find this fix in neither latest stable/linux-5.4.y, nor
> stable-queue/master.  Could you please put this patch in the queue?
> 
> [1] https://lore.kernel.org/linux-mm/20200212101356.30759-1-jack@suse.cz/

Now queued up, thanks.

greg k-h
