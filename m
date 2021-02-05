Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55B31073E
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhBEI6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhBEI6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 03:58:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B3464EE2;
        Fri,  5 Feb 2021 08:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612515444;
        bh=EYKAwGZjLnRGggGIs+DStlDcjob45CSYVETzrS0nvbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Me9GXoD8VbsXVwOKGUJf113xxEi8OfjfFZ0Q2vPWTvHEbUQMSi/jCng9nxevqYIP
         Auuhd5+U1iLd9XJQSDfrIc8ewIxI8bicKVwNFhcB2WURzfhgkZe+QhPyZ0QtSOjjgI
         LQLmDBBUXIaBdVyiJkODCAKhFLQv24f9tXDM+cus=
Date:   Fri, 5 Feb 2021 09:57:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     edumazet@google.com, kuba@kernel.org, syzkaller@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net_sched: gen_estimator: support large
 ewma log" failed to apply to 5.4-stable tree
Message-ID: <YB0IcW4LOlclyFSI@kroah.com>
References: <1611587765159215@kroah.com>
 <YBwhocDeX7VbVXHH@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBwhocDeX7VbVXHH@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 04:32:33PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 25, 2021 at 04:16:05PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.19-stable and 4.14-stable.

Now applied, thanks!

greg k-h
