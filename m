Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DA83D2613
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhGVOFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhGVOFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5257B60FEE;
        Thu, 22 Jul 2021 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626965146;
        bh=S03Xg6uUDS5hVTl6X01PXyQ/wJmKnsYe4Vq23FhqMa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFKAGO7l7qiwNE89EODjGCnYtdbqgy97lkxOibP7xe1+xD1io8L4UzrbMNLNXV8Vh
         LsauhuqYIuVqINo/Sh9a/JJooYNr4fY2wYkgfhFZkj3uXnf85RDf2s3fxzl1btMKZO
         dDbNK5c6qFM8CTBR9id/NUuh+ef2Cp+JEbE5yCnc=
Date:   Thu, 22 Jul 2021 16:45:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm writecache: return the exact table
 values that were set" failed to apply to 4.19-stable tree
Message-ID: <YPmEmJLSjMCwhC6T@kroah.com>
References: <1614606337101246@kroah.com>
 <alpine.LRH.2.02.2107191118460.17791@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2107191118460.17791@file01.intranet.prod.int.rdu2.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 11:20:10AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 1 Mar 2021, gregkh@linuxfoundation.org wrote:
> 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi
> 
> This is backport of the patch 054bee16163df023e2589db09fd27d81f7ad9e72 for
> the stable branches 4.19 and 5.4.

Now queued up, thanks.

greg k-h
