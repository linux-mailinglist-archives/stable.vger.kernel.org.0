Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D8A2466F1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgHQNFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbgHQNFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:05:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9512072E;
        Mon, 17 Aug 2020 13:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597669554;
        bh=+ZYtlx6dfKIxNNdJVY9BrmOr9qggJF5xvpf/b14eng4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hlUAZWjDPnt+iHF6ErbcptLvZ6XGKdw/Lqi13ywQV+9u3WudUzHQt5D/OEsRtpg7U
         ryZmB48+Vrcl/kR73ITteqUa5UKREA+TfWMswgjuaD4TZwQyLGJNMrkFtRu7a3S+Lt
         RtUT3N4dRzlohHHphaBHZsDLnivlvvOiT4lnxbXM=
Date:   Mon, 17 Aug 2020 15:06:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hgy5945@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: Fix NULL pointer dereference in
 loop_rw_iter()" failed to apply to 5.8-stable tree
Message-ID: <20200817130613.GA183753@kroah.com>
References: <159766101814319@kroah.com>
 <cf6893f4-2a0a-0e3b-f0e5-85cf583e1e83@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf6893f4-2a0a-0e3b-f0e5-85cf583e1e83@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 05:54:47AM -0700, Jens Axboe wrote:
> On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.8-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> 5.8 version:

Now queued up, thanks!

greg k-h
