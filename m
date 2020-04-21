Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD31B2358
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 11:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDUJzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 05:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDUJzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 05:55:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD5B72087E;
        Tue, 21 Apr 2020 09:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587462909;
        bh=FZ9U1sHwACWJLucYFvYtgX4rkNBlBvKwA1XlaiDJta4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkod+Tv4kDm15b1S4NCg1mBJxgMIUVYuYATbC0XpOAwmIcJYP1NZUXtH5X5MG+/27
         L+5O7YURpOcYUWR3IkuFDugStLhjarHu4zH+wxIcMrZci5u5Zfyzwh23cZMxYIgKs0
         0Oim3LVDurEFuqO2ytZmoXG0jvPHImh8RvyTFYAM=
Date:   Tue, 21 Apr 2020 11:55:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     yangx.jy@cn.fujitsu.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix the race between registering
 'snapshot' event" failed to apply to 4.9-stable tree
Message-ID: <20200421095507.GA727481@kroah.com>
References: <1587206393189190@kroah.com>
 <20200420165827.59308521@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420165827.59308521@gandalf.local.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 04:58:27PM -0400, Steven Rostedt wrote:
> On Sat, 18 Apr 2020 12:39:53 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> 
> The below should apply and work for 4.9 and 4.4.

Thanks, now queued up.

greg k-h
