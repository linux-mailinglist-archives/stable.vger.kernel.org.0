Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34F43B1CF5
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhFWPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWPAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 11:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8847B6102A;
        Wed, 23 Jun 2021 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624460317;
        bh=7Ds2sG6slXfJSeVWMuN509AJc0qtEWR236Vv3d2JCOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yDofAbD27PPzij0C2fRikdz5w7O5cYoUftWJwE3qevEcpSYa98k/CiCGnGoT3q5Oh
         bcGfixD5G/FZ/vC7Fw3dCf+yjplukHj9M5l2vWLyKj8KK5GCT+Pq5LO2ybIq18fA3I
         0s8oks/89vsGW0wZ62oXbXOe2hr70u7R0ppMZeiA=
Date:   Wed, 23 Jun 2021 16:58:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-ID: <YNNMGjoMajhPNyiK@kroah.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
 <YMrU4FRkrQ7AVo5d@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMrU4FRkrQ7AVo5d@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 17, 2021 at 06:51:44AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 16, 2021 at 04:02:32PM -0700, Hugh Dickins wrote:
> > Hi Greg,
> > 
> > Linus has taken in a group of mm/thp commits Cc stable today:
> > 
> > 504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
> > 22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
> > 31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
> > 494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
> > 732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
> > 3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
> > 99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
> > ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
> > 
> > and I expect some more to follow in a few days time (thanks Andrew).
> > 
> > No problem with the commits themselves, but I'm aware that some of them
> > have dependencies on other commits not yet in stable, which I have to
> > sort out for you now.
> > 
> > I'd prefer to avoid a deluge of "does not apply" messages, so ask you
> > please to hold off trying to merge these into stable trees for a few days:
> > I'll get back to you with what's needed for them to apply.
> 
> Not a problem, thanks for the heads up, I'll restrain from running my
> scripts on the above patches until you say it's safe to :)

Any word on this?

thanks,

greg k-h
