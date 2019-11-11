Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE800F78DA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 17:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfKKQen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 11:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfKKQem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 11:34:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBAB120679;
        Mon, 11 Nov 2019 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573490082;
        bh=71g3I8FN9cKyEIsTndR2DMxU6WI8XxUlHgrraLIGuIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RG0jimVqcUHNqvIGSi0ZuhfVzx3U/k5T+fSzVjs169asXkuXgHPGiSEIKIiu87KzV
         1NcMwuP43uXMR93i3orZiBpWHQ9idYHFO9DepuS1z/wgpebwepoiU+Sy+OJs/DSL9E
         /Pjwt2k/i97uJKWLfBa8VFDvgXgt160ihfoeIfW8=
Date:   Mon, 11 Nov 2019 17:34:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, kernel-team@fb.com,
        Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Dennis Zhou <dennis@kernel.org>,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH block/for-linus] cgroup,writeback: don't switch wbs
 immediately on dead wbs if the memcg is dead
Message-ID: <20191111163437.GC1017642@kroah.com>
References: <20191108201829.GA3728460@devbig004.ftw2.facebook.com>
 <20191111131544.GJ1396@dhcp22.suse.cz>
 <20191111161816.GA4163745@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111161816.GA4163745@devbig004.ftw2.facebook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 08:18:16AM -0800, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Nov 11, 2019 at 02:15:44PM +0100, Michal Hocko wrote:
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Dennis Zhou <dennis@kernel.org>
> > > Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > > Fixes: e8a7abf5a5bd ("writeback: disassociate inodes from dying bdi_writebacks")
> > 
> > Is this a stable material?
> 
> c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has
> no dirty pages") likely addresses larger part of the problem, but yeah
> it prolly makes sense to backport both for -stable.
> 
> Greg, Sasha, can you pick the following two commits for -stable?
> 
> * c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has
>   no dirty pages")
> 
> * 65de03e25138 ("cgroup,writeback: don't switch wbs immediately on
>   dead wbs if the memcg is dead")
> 
> Both are fixes for e8a7abf5a5bd ("writeback: disassociate inodes from
> dying bdi_writebacks") - v4.2+.

Now queued up, thanks.

greg k-h
