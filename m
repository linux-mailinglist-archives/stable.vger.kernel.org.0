Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B60246729
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHQNOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgHQNNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:13:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D34362072E;
        Mon, 17 Aug 2020 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597670002;
        bh=LCxTuYKWk/XM6BH70cHWR54wLZYihFTer3AJjdhVwYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=znnZDzPLLhsEYJAK4fS38pv+JnCunHUgNtGQZZzzxoZdxUdmLXWEd7bjNDqIrCQWl
         LEyechiYGtmPSokLEkZbtOeny8K+honqNDRXNScTD+eWAF2dLaEzToNMzcTECNCNzt
         K3DLEQQY9ST+6kvtURpAJPxwt83U5DGA9uZk3VSU=
Date:   Mon, 17 Aug 2020 15:13:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.8-stable tree
Message-ID: <20200817131341.GA208556@kroah.com>
References: <1597661043160117@kroah.com>
 <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:10:04AM -0700, Jens Axboe wrote:
> On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.8-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's a 5.8 version.

Applied, thanks!

Looks like it applies to 5.7 too, want me to take this for that as well?

greg k-h
