Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218749119E
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfHQP1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 11:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfHQP1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Aug 2019 11:27:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 817DA21EF2;
        Sat, 17 Aug 2019 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566055667;
        bh=68rFPdqHoDjgyU7ECWn8Pfbz/kAS8Diz2JA1tx5TOeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kGCKaqfZcZ+zHY/2ayC/WYoj9vh/SYzHhtk3pYeNirAtFVY/Kd/XXrwjEGyrYZJC5
         +urfU+lkCCw3cC1tpQ3y0lvg2wZJSyGre/xMzy/4gv6uKN6jQScmulpZE89ZDdE0X9
         9FnFo3n6ZVKvKz8rYuG3AK3BwFuBwYdlj25PR1Cw=
Date:   Sat, 17 Aug 2019 17:27:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     akpm@linux-foundation.org, cai@lca.pw, hannes@cmpxchg.org,
        mhocko@suse.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/memcontrol.c: fix use after free in
 mem_cgroup_iter()" failed to apply to 4.14-stable tree
Message-ID: <20190817152744.GA16493@kroah.com>
References: <156594986715496@kroah.com>
 <1565953640.26404.4.camel@mtkswgap22>
 <20190816153702.GA9558@kroah.com>
 <1566054818.26404.11.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566054818.26404.11.camel@mtkswgap22>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 11:13:38PM +0800, Miles Chen wrote:
> On Fri, 2019-08-16 at 17:37 +0200, Greg KH wrote:
> > On Fri, Aug 16, 2019 at 07:07:20PM +0800, Miles Chen wrote:
> > > On Fri, 2019-08-16 at 12:04 +0200, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 4.14-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > Hi Greg,
> > > 
> > > Below this the backport for 4.14
> > 
> > This backport, and the other 2, are all line-wrapped and the patch is
> > corrupted and can not be applied :(
> 
> Sorry for that.
> > 
> > Can you fix up and resend?  I can take an attachment if that is what is
> > needed here.
> 
> No problem. The backport patches are attached in this email.

This didn't apply either.  So I tried doing it "by hand" and it looks
like you are not making these against the latest 4.14.y release (and
other releases.)  The difference is in a commit that showed up in
4.14.58, which was released July 2018.

I'll take these as I've already fixed them up, but in the future, please
make them against the latest version of the stable trees, not the
"original" release that happened many years ago.

thanks,

greg k-h
