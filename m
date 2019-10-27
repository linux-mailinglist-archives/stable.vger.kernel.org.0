Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333F7E6559
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 21:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfJ0U0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 16:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfJ0U0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 16:26:36 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2850820873;
        Sun, 27 Oct 2019 20:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572207995;
        bh=Rwb1pj635KRmlt4TBmBNPKa3CaofXK57ie1o+cjkfwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PhemGU84mwdsXFI79jSqDtNPHeyceT9/uLGrlBbrYvyBi/nHdkvdTFpKfF3TVa9hR
         9ReLegb5zq3efSvFe7KGb3Uq9Ea6IDn8uoeQ2WtB3slSwLcg7ElraP2DIN2rOyLpSO
         GAaWLWKmS3m2uvm9OAPfoPxK5SjqidhSjBq2+6gY=
Date:   Sun, 27 Oct 2019 21:26:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     zeba.hrvoje@gmail.com, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for
 sockets" failed to apply to 5.3-stable tree
Message-ID: <20191027202633.GA2608793@kroah.com>
References: <1572191635100175@kroah.com>
 <da7d616b-a7e1-5cf5-5b38-75ecf8843ccb@kernel.dk>
 <20191027200020.GB2587661@kroah.com>
 <b9a4a9f8-2588-b13e-b010-916895d7a8dc@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9a4a9f8-2588-b13e-b010-916895d7a8dc@kernel.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 02:22:06PM -0600, Jens Axboe wrote:
> On 10/27/19 2:00 PM, Greg KH wrote:
> > On Sun, Oct 27, 2019 at 12:58:14PM -0600, Jens Axboe wrote:
> >> On 10/27/19 9:53 AM, gregkh@linuxfoundation.org wrote:
> >>>
> >>> The patch below does not apply to the 5.3-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git commit
> >>> id to <stable@vger.kernel.org>.
> >>
> >> I can fix this up, but I probably need to see Sasha's queue first for
> >> the io_uring patches. I need to base it against that.
> > 
> > Ok, wait for the next 5.3.y release in a few days and send stuff off of
> > that if you can.
> 
> Is there no "current" or similar tree to work of off? Would be a shame
> to miss the next one, especially since the newer fixes are already in.

I'm about to push out the -rcs right now.  You can base off of that and
send me the patch and I'll add it, or just wait a few days, either is
fine.

thanks,

greg k-h
