Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342483AEC97
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUPjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFUPjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 11:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 658C061042;
        Mon, 21 Jun 2021 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624289845;
        bh=FoHJBy/l5RXLmDm4s1/DQJqpTj/A3BVkD5eDbx/YGks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKtRsuENmaNiEbTyJlzn0KZq3NQmcOVxcAz9WOlupsAP0H6j9yJewtv9y8nerJm3F
         GOsHsrv4saCrJxWEQf0Tei8b/KenaR0mQsMxq3k/0Xym4ZyUJud3RrStuSUDRJ9Mq5
         jj7do9v0xlAl4hAWxZK/UukalU6GgzoccTTNpIu8=
Date:   Mon, 21 Jun 2021 17:37:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Do not stop recording comms if
 the trace file is" failed to apply to 4.9-stable tree
Message-ID: <YNCyM+Mm7WaMvRac@kroah.com>
References: <1624272081106153@kroah.com>
 <20210621112856.05268850@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621112856.05268850@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 11:28:56AM -0400, Steven Rostedt wrote:
> On Mon, 21 Jun 2021 12:41:21 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> 
> The following should apply to both 4.9 and 4.4.

Now applied, thanks.

greg k-h
