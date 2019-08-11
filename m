Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A138927C
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfHKQKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 12:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfHKQKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Aug 2019 12:10:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C96920880;
        Sun, 11 Aug 2019 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565539802;
        bh=eII2pVSZ+v6pNbEDA2IZCkWoJkwp8c2tsV6oyjwz/A0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nknZt1eGhkePO1C4OhRRxC8s2VA6Qyyt1Akqj+WCKDcMRrykvcQ3x7P3+1GMHJhKc
         wBTqI3E003O1f7Tdw3gaR6BggHGzREbkR5j3Do4EOtt+/pjzKPjY9ZezCSA18beg8q
         bPK3B0TJ6d41OSf7CocTPVahlKjM+yre7zsX8LNM=
Date:   Sun, 11 Aug 2019 18:09:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     alexandru.ardelean@analog.com, axboe@kernel.dk, pflin@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bcache: Revert "bcache: use
 sysfs_match_string() instead of" failed to apply to 5.2-stable tree
Message-ID: <20190811160959.GA8117@kroah.com>
References: <156553570618483@kroah.com>
 <81d2423d-74dd-50ba-4a33-05306a1b13dd@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81d2423d-74dd-50ba-4a33-05306a1b13dd@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 11, 2019 at 11:41:57PM +0800, Coly Li wrote:
> On 2019/8/11 11:01 下午, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.2-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> I will post a rebased patch for the 5.2-stable tree.

Is it really needed?

I ask because in the patch it says:

> > This bug was introduced in Linux v5.2, so this fix only applies to
> > Linux v5.2 is enough for stable tree maintainer.
> > 
> > Fixes: 89e0341af082 ("bcache: use sysfs_match_string() instead of __sysfs_match_string()")

But commit 89e0341af082 showed up in 5.3-rc1, not 5.2.

So why is this needed in 5.2.y?

thanks,

greg k-h
