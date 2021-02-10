Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618B13168E7
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBJOP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhBJOOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:14:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5D1864E6F;
        Wed, 10 Feb 2021 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612966422;
        bh=RZ2FmdAptFrOuDZupTjelOGEitzwhP18gBZt9wfFvOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xidD6Gv1kzQG5upBM73ES+9dU3FGbZpedWwZRtg7PDzYC6h54FgzgdMxmuY2XVwCA
         JdZJgMN0wxMrYFml/WhNOvggCn6VUwEEdmvZG6ngBSrxguNxDzjX+1dqgfBMyszJBT
         4BT+D0MBCLgkCz4ueR/8HltZkWLD0KfRExsDuj1U=
Date:   Wed, 10 Feb 2021 15:13:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] fgraph: Initialize tracing_graph_pause at
 task creation" failed to apply to 4.14-stable tree
Message-ID: <YCPqE18/vyoZpjjS@kroah.com>
References: <161277913410730@kroah.com>
 <20210208112558.1da20239@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208112558.1da20239@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 11:25:58AM -0500, Steven Rostedt wrote:
> On Mon, 08 Feb 2021 11:12:14 +0100
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Here's the 4.14 port (should also work for 4.9 and 4.4):
> 

All now queued up, thanks.

greg k-h
