Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA624678E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgHQNnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgHQNny (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:43:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3836020786;
        Mon, 17 Aug 2020 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597671833;
        bh=GUh83C5u0StHlNrLi6t3LVZJm2hPuwAFh9tv9c0Cd3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbFDUVRdKtSMfOb6GipwF10q4gloJYmJYdEwNMlmVLCSvGcJynUy8bUT1uilOyJij
         Adnio+pb9Tu08vLBQ1lcCoS4esgC5wfk5mR5D8t7Kbhayv/gAD1Itm8pIL5g+Jq6CI
         RsBWHEuS4T4UcJ4YMuLVBQS2Z/BpOB3r9Ocie/vE=
Date:   Mon, 17 Aug 2020 15:44:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.8-stable tree
Message-ID: <20200817134412.GE359148@kroah.com>
References: <1597661043160117@kroah.com>
 <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
 <20200817131341.GA208556@kroah.com>
 <da8acd62-2312-1baf-8562-d2085c78e062@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da8acd62-2312-1baf-8562-d2085c78e062@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:21:02AM -0700, Jens Axboe wrote:
> On 8/17/20 6:13 AM, Greg KH wrote:
> > On Mon, Aug 17, 2020 at 06:10:04AM -0700, Jens Axboe wrote:
> >> On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
> >>>
> >>> The patch below does not apply to the 5.8-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git commit
> >>> id to <stable@vger.kernel.org>.
> >>
> >> Here's a 5.8 version.
> > 
> > Applied, thanks!
> > 
> > Looks like it applies to 5.7 too, want me to take this for that as well?
> 
> Heh, didn't see this email, just going through this by kernel revision.
> Either one should work, sent a specific set for that too.

Oops, it did not build on 5.7, so I still need a working backport for
that.

> BTW, for both 5.7 and 5.8, could you please queue up:
> 
> commit ebf0d100df0731901c16632f78d78d35f4123bc4
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Aug 13 09:01:38 2020 -0600
> 
>     task_work: only grab task signal lock when needed
> 
> as well, to avoid a perf regression with the TWA_SIGNAL change? Thanks!

Also now queued up, thanks.

greg k-h
