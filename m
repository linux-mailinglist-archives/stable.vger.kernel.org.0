Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81954904C1
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfHPPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 11:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfHPPhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 11:37:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB9C206C2;
        Fri, 16 Aug 2019 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565969824;
        bh=kYsRNvUcZJi1BMnvwFxacHUuoFSvOeDQvMDXJMijmUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZcUYg6sBtx+RSBNq6z2/xnM6DizTYqHhw94k5ER8dbuNRzL7jdsWdHQocNMo12qRE
         EAGUOLAryWtKdvj/k5XIkBHsZfwOHqrLUIl3iEWth/PTgdjozhhWOfoyO54J/rOZpG
         +HFO/R10U527DDPnNyTfG2oJCRASACeHXfQCbuuM=
Date:   Fri, 16 Aug 2019 17:37:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     akpm@linux-foundation.org, cai@lca.pw, hannes@cmpxchg.org,
        mhocko@suse.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/memcontrol.c: fix use after free in
 mem_cgroup_iter()" failed to apply to 4.14-stable tree
Message-ID: <20190816153702.GA9558@kroah.com>
References: <156594986715496@kroah.com>
 <1565953640.26404.4.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565953640.26404.4.camel@mtkswgap22>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 07:07:20PM +0800, Miles Chen wrote:
> On Fri, 2019-08-16 at 12:04 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Hi Greg,
> 
> Below this the backport for 4.14

This backport, and the other 2, are all line-wrapped and the patch is
corrupted and can not be applied :(

Can you fix up and resend?  I can take an attachment if that is what is
needed here.

thanks,

greg k-h
