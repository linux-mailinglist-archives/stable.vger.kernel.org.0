Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4702A605E
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgKDJOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:32942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgKDJON (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:14:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 224172224E;
        Wed,  4 Nov 2020 09:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604481252;
        bh=wG1/JDI8xT4zJlsqsWfdpIKDyQMh51fQnza8PVfD7oY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWEFJfU3rJwptMPN65SjnI7zdye+ybbgV1pdDgImp2EnNmlupsZAst8/bhx0V4iFm
         KPiHVWTWdpIyu97j8qesPt3aX7nE7yQsCbYaH9Pk8VUfCJHDfetTDuoqetQp5+9n4S
         QTt32tzAx7CV60Htl+wfO64h5ZC6is3kA4s0ilD0=
Date:   Wed, 4 Nov 2020 10:15:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone reset all tracing
Message-ID: <20201104091502.GA1646828@kroah.com>
References: <16044134474538@kroah.com>
 <20201104052914.156163-1-damien.lemoal@wdc.com>
 <20201104091015.GD1588160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104091015.GD1588160@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 10:10:15AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 04, 2020 at 02:29:14PM +0900, Damien Le Moal wrote:
> > commit f9c9104288da543cd64f186f9e2fba389f415630 upstream.
> > 
> > In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector is
> > ignored and the operation is applied to all sequential zones. For these
> > commands, tracing the effect of the command using the command sector to
> > determine the target zone is thus incorrect.
> > 
> > Fix null_zone_mgmt() zone condition tracing in the case of
> > REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that are
> > not already empty.
> > 
> > Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")
> > Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >  drivers/block/null_blk_zoned.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> Now queued up, thanks.

Wait, no, I'll delay this one until the next round as it's not fixing
something introduced in this -rc series.

thanks,

greg k-h
