Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5C13B21FE
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhFWUtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 16:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWUtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 16:49:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D662C61002;
        Wed, 23 Jun 2021 20:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624481203;
        bh=4elHkddQNSTtf3/EahMUhPcHJCtTOoBuHXJR0Zhw6Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E/z6BpMD/VRV6xZL3tulA0Bf0JOT2KHrQMSRR+7uHVNqjWJoKJE+rwVnkbZq/H/Hr
         f15xIWZrTvDGfLgBZglSd2IfijkjQkhkcH/dp1TkczlLEL56Sv2N3pWvygxhAP48F0
         YjC9qpkXXYt84GFQgu9Btg9KOdCzV/yzIKzjmZVw=
Date:   Wed, 23 Jun 2021 13:46:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-Id: <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
In-Reply-To: <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
        <YMrU4FRkrQ7AVo5d@kroah.com>
        <YNNMGjoMajhPNyiK@kroah.com>
        <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Jun 2021 09:44:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> > Any word on this?
> 
> I have a "matrix" of what's needed ready, but I'm still waiting on
> "I expect some more to follow in a few days time (thanks Andrew)":
> I believe akpm does still intend to send them in to Linus for 5.13
> this week, but they've not gone yet.

I'm planning on sending these:

mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch

Linuswards tomorrow.  Is that OK?
