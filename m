Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194BD40DC30
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbhIPODS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 10:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238360AbhIPOC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 10:02:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4039861130;
        Thu, 16 Sep 2021 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631800895;
        bh=UqJZn7s7Nc96HNxEtmgaDvVeJTHvdnDW6Ev9nOFf3Cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Czjffm6DkvdMZQxUCrS6u82Dwxi/lSh3YVh80TJapUivAOevD80G+oChAZdnnhmvc
         NX18Edlq6ljWpn8dZo2JXCsTRRNO8sz7H+K1bR6KLIbMOiS0yN261LFeyC3Itf2dH2
         vBT9pq13DGbXH8ePdJrnjkvgcuA9Kbplk1ewgnxg=
Date:   Thu, 16 Sep 2021 16:01:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     qiang.zhang@windriver.com, bristot@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing/osnoise: Fix missed
 cpus_read_unlock() in" failed to apply to 5.14-stable tree
Message-ID: <YUNOPbkKKO1UBUu1@kroah.com>
References: <1631709430188167@kroah.com>
 <20210915101231.71bf18dd@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915101231.71bf18dd@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 10:12:31AM -0400, Steven Rostedt wrote:
> On Wed, 15 Sep 2021 14:37:10 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> >  
> >  	cpus_read_unlock();
> >  
> > -	return 0;
> > +	return retval;
> >  }
> >  
> 
> The issue was that the latest kernel uses cpu_read_unlock() instead of
> put_online_cpus(), other than that, it was trivial to fix.
> 
> Below should apply cleanly to 5.14.

Now queued up, thanks.

greg k-h
