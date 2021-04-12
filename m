Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E51935BAA9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 09:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhDLHPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 03:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhDLHPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 03:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A2D2610CA;
        Mon, 12 Apr 2021 07:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618211694;
        bh=dH3Q6JUQHQmYdiiCS7K8POTE6TBa9uj5FsWxOsaxTe0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wsulJONndGpyokxy2s8CimxcJaqAgZJqcsZd4XdNwXl5VoVXxPGIGJJpgChyADU3+
         2XA8NCvWKiS3tPdsbwM3aklKtmzR7ZAWMFtab1VxqA81w7YTZMFtONFDVDcGKY8Q9s
         hl5v5tVy7bFwLB8CRt5J4qF6D/CpfHR+vANMeo0k=
Date:   Mon, 12 Apr 2021 09:14:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chen si <cici.cs@alibaba-inc.com>,
        Baoyou Xie <baoyou.xie@aliyun.com>,
        Zijiang Huang <zijiang.hzj@alibaba-inc.com>
Subject: Re: [RESEND PATCH 4.9] mm: add cond_resched() in gather_pte_stats()
Message-ID: <YHPzbDbNgvtIizAi@kroah.com>
References: <20210412035857.82868-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412035857.82868-1-wenyang@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 11:58:57AM +0800, Wen Yang wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> commit a66c0410b97c07a5708881198528ce724f7a3226 upstream.
> 
> The other pagetable walks in task_mmu.c have a cond_resched() after
> walking their ptes: add a cond_resched() in gather_pte_stats() too, for
> reading /proc/<id>/numa_maps.  Only pagemap_pmd_range() has a
> cond_resched() in its (unusually expensive) pmd_trans_huge case: more
> should probably be added, but leave them unchanged for now.
> 
> Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052157400.13021@eggly.anvils
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@vger.kernel.org> # 4.9.x
> Reported-by: Chen si <cici.cs@alibaba-inc.com>
> Signed-off-by: Baoyou Xie <baoyou.xie@aliyun.com>
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> Signed-off-by: Zijiang Huang <zijiang.hzj@alibaba-inc.com>
> ---
>  fs/proc/task_mmu.c | 1 +
>  1 file changed, 1 insertion(+)

Now queued up, thanks.

greg k-h
