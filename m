Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB461C4008
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgEDQgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbgEDQgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 12:36:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20567206D9;
        Mon,  4 May 2020 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588610196;
        bh=YNlWgAZJRXIoc0VJyXhyIrogVAxubPmHx6eKXOGPvqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LLDmS4K2iSU86qu3TzP/Vdi2F0kjIyhbFsv18YIXTc9NOjbs71DcFxoVrOsKvJkwX
         f544Rmr5zomSnnBsFZzTt+Trwz2GtRpW60BjYshKmNclPSh+ppaRUb+UxVJZwMWxEX
         owBsN4+JnuklOkUNf5sauA9zHWp451pHoX/v4epQ=
Date:   Mon, 4 May 2020 18:36:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     bugs@claycon.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: statx must grab the file table
 for valid fd" failed to apply to 5.6-stable tree
Message-ID: <20200504163632.GA2724164@kroah.com>
References: <1588586161159248@kroah.com>
 <a4390838-d86d-2b0e-ec18-12ee0b74ab7f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4390838-d86d-2b0e-ec18-12ee0b74ab7f@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 07:46:56AM -0600, Jens Axboe wrote:
> On 5/4/20 3:56 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's a 5.6 backport.

Thanks, now queued up.

greg k-h
