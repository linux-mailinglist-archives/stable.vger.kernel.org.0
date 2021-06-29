Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09B03B6E16
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 08:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhF2GKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 02:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232011AbhF2GKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 02:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF01261D91;
        Tue, 29 Jun 2021 06:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624946890;
        bh=BuQ5gWlmyqWbW8ze1zM1UxibZ0wxfgu50CR4zqmNpL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DO3JhWoLenUQFj9mdNvlCWClt2w47drY+hygpNmYYNRqtv9sTCGi6jY2KUbB8ZKdE
         elJZxNpO+WMY0g1P9nEsyPdAo9efd77dp32GdKz60+UkkllMFEdnMSyIqvjte43anN
         IXIstkIO2DhfnrLjsOEy7GN+9cBMZcBFE8ipaCM4=
Date:   Tue, 29 Jun 2021 08:08:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Shi <alexs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-ID: <YNq4yJls+PKsULh0@kroah.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
 <YMrU4FRkrQ7AVo5d@kroah.com>
 <YNNMGjoMajhPNyiK@kroah.com>
 <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
 <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
 <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com>
 <YNm93fkIPrqMwHzd@kroah.com>
 <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com>
 <YNqTCV7DmYGZiZ7N@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNqTCV7DmYGZiZ7N@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 11:27:05PM -0400, Sasha Levin wrote:
> On Mon, Jun 28, 2021 at 10:12:57AM -0700, Hugh Dickins wrote:
> > On Mon, 28 Jun 2021, Greg Kroah-Hartman wrote:
> > > So could you just send a mbox of patches (or tarball), for the 4.19,
> > > 4.14, and 4.9 trees?  That would make it much easier to ensure I got
> > > them all correct.
> > 
> > At risk of irritating you, sorry, I am resisting: the more data I send
> > you, the more likely I am to mess it up in some stupid way.  Please ask
> > again and I shall, but I think your success with 5.12, 5.10, 5.4 just
> > means that you were right to take a break before 4.19, 4.14, 4.4.
> 
> I've tried following the instructions for 4.19, and that worked fine on
> my end too.
> 
> If no one objects, I can pick up 4.9-4.19 after the current set of
> kernels is released.

No objection from me, thanks!

greg k-h
