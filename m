Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99908246776
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgHQNkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbgHQNkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:40:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC0F5204FD;
        Mon, 17 Aug 2020 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597671632;
        bh=RoZpMsI/2xHrDM4tX8GvJOw8tbK+iazEiBogxxGj934=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tObDIMKIACGR0TqMYACpe7m1pp71zQAmmEgqOnT0TYUUYKToI3tj5MIZwejBrd3Dm
         HImuspwO16DWts/859YCAZgKt8b97Q820Y1M1xHFCRC+2//vFl1gHCDvlRd9jaMw9u
         5w4BDbdPz9Nemw5ldblNNZVENdC+YTkeDPBFECGQ=
Date:   Mon, 17 Aug 2020 15:40:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hgy5945@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix NULL pointer dereference in
 loop_rw_iter()" failed to apply to 5.7-stable tree
Message-ID: <20200817134051.GC359148@kroah.com>
References: <1597661020166103@kroah.com>
 <41fb1027-374f-1e9c-2ff7-6e1e008c7d40@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41fb1027-374f-1e9c-2ff7-6e1e008c7d40@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:16:23AM -0700, Jens Axboe wrote:
> On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's one that works.

Applied, thanks.

greg k-h
