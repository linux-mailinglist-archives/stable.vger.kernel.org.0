Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966522B8EDE
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 10:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgKSJ3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 04:29:42 -0500
Received: from muru.com ([72.249.23.125]:48710 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKSJ3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 04:29:41 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id F07E380C1;
        Thu, 19 Nov 2020 09:29:45 +0000 (UTC)
Date:   Thu, 19 Nov 2020 11:29:36 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Minchan Kim <minchan@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        sergey.senozhatsky.work@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201119092936.GI26857@atomide.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
 <20201113162529.GA2378542@google.com>
 <20201116175323.GB3805951@google.com>
 <20201117135632.GA27763@infradead.org>
 <20201117202916.GA3856507@google.com>
 <X7SBufr4GftKY9pB@jagdpanzerIV.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X7SBufr4GftKY9pB@jagdpanzerIV.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Sergey Senozhatsky <sergey.senozhatsky@gmail.com> [201118 02:07]:
> On (20/11/17 12:29), Minchan Kim wrote:
> > Yub, I remeber the discussion. 
> > https://lore.kernel.org/linux-mm/20200416203736.GB50092@google.com/
> > 
> > I wanted to remove it but 30% gain made me think again before
> > deciding to drop it.
> > Since it continue to make problems and Linux is approaching to
> > deprecate the 32bit machines, I think it would be better to drop it
> > rather than inventing weird workaround.
> > 
> > Ccing Tony since omap2plus have used it by default for just in case.

Looks like make omap2lus_defconfig is not selecting it anyways and I
never even noticed earlier:

Acked-by: Tony Lindgren <tony@atomide.com>
