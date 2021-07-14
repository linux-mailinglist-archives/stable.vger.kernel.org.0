Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228D13C854F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhGNNba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 09:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231485AbhGNNb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 09:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7998D613B7;
        Wed, 14 Jul 2021 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626269317;
        bh=Z/6L0/JrfCIqbWBfUMjeG9CNHjHoZFpn+TnTg5lq2O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYIhs9CmmepaNJ8nLG4+5qEMQQX4b7fxtUqpUS4fS42a6lyq7HDbZ7Tp3B4pqIM7c
         ma3b+uJBCPS7hUfLSZZ55uKUCQhZ+B+hl6qUU+dygZyB9mUST54z6SzS0hBWusXDAV
         iCIodqV+ICnYaeI24ZLYI8Y+s0Lrnn8N0IpBACeg=
Date:   Wed, 14 Jul 2021 15:28:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jann Horn <jannh@google.com>,
        Youquan Song <youquan.song@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 768/800] hugetlb: address ref count racing in
 prep_compound_gigantic_page
Message-ID: <YO7mg+XT8Ta3iOE8@kroah.com>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712061048.520052935@linuxfoundation.org>
 <96dcbea1-0b68-47f2-8954-fa36b61fdb0f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96dcbea1-0b68-47f2-8954-fa36b61fdb0f@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 02:38:26PM -0700, Mike Kravetz wrote:
> On 7/11/21 11:13 PM, Greg Kroah-Hartman wrote:
> > From: Mike Kravetz <mike.kravetz@oracle.com>
> > 
> > [ Upstream commit 7118fc2906e2925d7edb5ed9c8a57f2a5f23b849 ]
> > 
> 
> Please do not add or the requisite patch to stable tree.
> 
> Although this is a real potential issue, it was only found during code
> inspection.  It has existed for more than 10 years and I am unaware of
> anyone hitting this in actual use.  In addition, this proposed fix will
> likely be updated/simplified based on more discussions.

Now dropped from all queues, thanks.

greg k-h
