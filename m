Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F09422DF6F
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 15:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgGZNKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 09:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGZNKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jul 2020 09:10:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483B820714;
        Sun, 26 Jul 2020 13:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595769037;
        bh=ayUpVQk8ZsLsvjZoIjUZ6yNGeOkt4pSfgYTny10ZxuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F5VLAukEUGp+GQxx+sOVQ6fdeMs6gxJsgyBFljZ6yIAyVky3ctSGDAIWkyjke6Csu
         lB17QejylBaP4FkslEo0arvYKg5aNa9F84GWytaqOWKbP48BbifcgA9XfRDdwBcXsh
         YPh27PBJniDsdCjQE5wDC59O4Quv9nyxtpw+2rV0=
Date:   Sun, 26 Jul 2020 15:10:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Patch "btrfs: qgroup: fix data leak caused by race between
 writeback and truncate" has been added to the 4.14-stable tree
Message-ID: <20200726131035.GA1640701@kroah.com>
References: <15957672628285@kroah.com>
 <3b1eaf71-0b54-ae4d-0fd5-26103ee8ff3d@suse.com>
 <64ba52d0-04e6-63a8-28f8-36345a708b20@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64ba52d0-04e6-63a8-28f8-36345a708b20@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 26, 2020 at 08:54:29PM +0800, Qu Wenruo wrote:
> 
> 
> On 2020/7/26 下午8:51, Qu Wenruo wrote:
> > 
> > 
> > On 2020/7/26 下午8:41, gregkh@linuxfoundation.org wrote:
> >>
> >> This is a note to let you know that I've just added the patch titled
> >>
> >>     btrfs: qgroup: fix data leak caused by race between writeback and truncate
> >>
> >> to the 4.14-stable tree which can be found at:
> >>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >>
> >> The filename of the patch is:
> >>      btrfs-qgroup-fix-data-leak-caused-by-race-between-writeback-and-truncate.patch
> >> and it can be found in the queue-4.14 subdirectory.
> >>
> >> If you, or anyone else, feels it should not be added to the stable tree,
> >> please let <stable@vger.kernel.org> know about it.
> > 
> > Please don't merge this patch for any of the stable branches.
> > 
> > This patch needs one unmerged patch ("btrfs: change timing for qgroup
> > reserved space for ordered extents to fix reserved space leak", already
> > in maintainer's tree) as prerequisite.
> 
> Also add btrfs mail list to the discssusion.
> 
> > 
> > The behavior without that patch could be problematic.
> > 
> > I should have noticed this earlier.

No problem, now dropped from all stable queues.

greg k-h
