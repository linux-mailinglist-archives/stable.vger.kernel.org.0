Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657FEC993B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfJCHw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbfJCHw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 03:52:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3D8421D71;
        Thu,  3 Oct 2019 07:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570089175;
        bh=PmPfpG6KlOmdhQf8IYZZ7J9WnRHj46Z1GrxHNNJQq5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VzDsgk5NjhV+58tn9RwDtArTtygBBSIreYahcTP+doILttCWQHgt1vlkrtjblojKw
         dFS6X3Wpst40JzdBeTDwgdf6cB8TElDyO01xpBEpF+fUnGKJt8Jr1jBBTwwjxRhie8
         Gw/QHG+QTzEK/spnsVw1H9yri6lHk+wl4pJGFXzQ=
Date:   Thu, 3 Oct 2019 09:52:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     ming.lei@redhat.com, axboe@kernel.dk, bvanassche@acm.org,
        emilne@redhat.com, hare@suse.com, hch@lst.de, snitzer@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: implement .cleanup_rq callback"
 failed to apply to 4.19-stable tree
Message-ID: <20191003075252.GA1848078@kroah.com>
References: <1569949365193105@kroah.com>
 <20191001235509.GG17454@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001235509.GG17454@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 07:55:09PM -0400, Sasha Levin wrote:
> On Tue, Oct 01, 2019 at 07:02:45PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I saw that it was also dropped from 5.3/5.2 for build errors. To resolve
> those I took 226b4fc75c78 ("blk-mq: add callback of .cleanup_rq") which
> is also tagged for stable.
> 
> For 4.19 there were some context changes due to the removal of the
> legacy IO code (6a23e05c2fe3c ("dm: remove legacy request-based IO
> path") et al).

Ah, I missed that dependancy, thanks for fixing this all up.

greg k-h
