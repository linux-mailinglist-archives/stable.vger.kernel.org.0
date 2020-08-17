Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAD246778
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHQNll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbgHQNk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:40:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23C53204FD;
        Mon, 17 Aug 2020 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597671656;
        bh=iUhCLCq/jQBX5uUOhIAeqWxu1Jf/BpJTJ+Zo8Sbd2tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CrkGD7/NAfOZSjfVgvVUg/i9P4JXrOjYf0QKu0FIuVVamJ1Gun9isYbuBGev7KqEu
         tZmFidlHL8uzcXrX1XUtXKVGDvbuSjE0tYBaPre0l4fdaUItPMhlfiiO6hYPPFCFoJ
         KZW49A1d0lFoQw72E/jrKWxXHnPwJM8T//2y+aSU=
Date:   Mon, 17 Aug 2020 15:41:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hgy5945@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix NULL pointer dereference in
 loop_rw_iter()" failed to apply to 5.4-stable tree
Message-ID: <20200817134116.GD359148@kroah.com>
References: <159766102242127@kroah.com>
 <4b16e8bd-c08e-b81d-bc6d-51e5d59fc30d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b16e8bd-c08e-b81d-bc6d-51e5d59fc30d@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:25:10AM -0700, Jens Axboe wrote:
> On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> 5.4 version:

Applied, thanks.

greg k-h
