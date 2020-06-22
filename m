Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21F5203ECD
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 20:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgFVSJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 14:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgFVSJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 14:09:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F4820656;
        Mon, 22 Jun 2020 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592849372;
        bh=Jq8vaaUbFuYw2DV1bqXPG2V45A/VDgMF+mcJzIgz+ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NtniSBtaw9penASNwUrJzMpkWqwr1z9c2cfEUe32/xmvi2I7XzpeaMa7ys5UVJrD7
         Rn2alVG0jnEut6MKA0p6IankdTMbQjCXAsm3C1xan/iul6l/NCT+WG3qZRiQhRGdqE
         FeyRfEc2NlhDAHyrbckof7/3GSmT4OBzCst3wsEQ=
Date:   Mon, 22 Jun 2020 20:09:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     xiaoguang.wang@linux.alibaba.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: add memory barrier to
 synchronize io_kiocb's result" failed to apply to 5.7-stable tree
Message-ID: <20200622180926.GA2083145@kroah.com>
References: <15928481127127@kroah.com>
 <436198de-3cba-5587-2f0f-a92185d9ee6f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <436198de-3cba-5587-2f0f-a92185d9ee6f@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 12:02:26PM -0600, Jens Axboe wrote:
> On 6/22/20 11:48 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I took a look at the queue, and here's this one and the next two you
> reported that didn't apply.
> 
> There's also a few more, I grabbed them as well. So could you just
> queue up these 6 for the next 5.7-stable? Thanks!

I will be glad to, thanks, but what is the git commit ids of them in
Linus's tree?  I need to put that in the changelog body...

thanks,

greg k-h
