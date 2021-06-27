Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFA13B5480
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 19:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhF0RZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 13:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhF0RZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 13:25:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE1BC061574
        for <stable@vger.kernel.org>; Sun, 27 Jun 2021 10:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R1asb7c7nJ7TSUgkjqU8c5HOACW50hgn0I0kEfQNXQ0=; b=iTJUqSzObAb6lhBlCXNcYRa2Z4
        HGxpNhMWk3VSFJcUc8UIy2WfU2Hh91d7w8oO2YbBeDDU9WRHPwKzeyKd3UGYVecp3E4Ys1MXky1u1
        TUFleqH77KT4S6nj5DspbN6/14vRw2P2VeWMnwpcSWUb9rK5f68V1TcrEvaTZ+E+V6Cd081e7Cxiq
        uABv2Ko3XPtVQtCMbtGjumaq7BhQIwj6zOUIPEFUlZOkwT8czj7bKfHiLfux/4U9BeKjkjRRlXwhJ
        Zlf0oL1MMvxR0Fm/KMA2pKpSZoFQKWOY06Sx8sRnMPW3j7x1cLlYn/jQFaXe5Ht8eB3R9YHy928vo
        9CyZ5kaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lxYUf-0026n4-0M; Sun, 27 Jun 2021 17:22:57 +0000
Date:   Sun, 27 Jun 2021 18:22:52 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jeff Layton <jlayton@kernel.org>, stable@vger.kernel.org,
        dhowells@redhat.com, Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] ceph: fix test for whether we can skip read when writing
 beyond EOF
Message-ID: <YNiz7JNKy50MzCYR@casper.infradead.org>
References: <20210625175951.90347-1-jlayton@kernel.org>
 <YNiJsmqZRDlFdnIa@kroah.com>
 <460106c8619ce7575f84f6fb387453b31204185d.camel@kernel.org>
 <YNihGOegQtLR3Adf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNihGOegQtLR3Adf@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 27, 2021 at 06:02:32PM +0200, Greg KH wrote:
> On Sun, Jun 27, 2021 at 11:41:45AM -0400, Jeff Layton wrote:
> > On Sun, 2021-06-27 at 16:22 +0200, Greg KH wrote:
> > > On Fri, Jun 25, 2021 at 01:59:51PM -0400, Jeff Layton wrote:
> > > > commit 827a746f405d upstream.
> > > 
> > > No it is not :(
> > > 
> > > Please fix this up and resend it with the correct git id.
> > > 
> > > thanks,
> > > 
> > 
> > Are you sure?
> > 
> >     $ git log --oneline origin/master -- fs/netfs
> >     827a746f405d (tag: netfs-fixes-20210621, dhowells/afs-fixes) netfs: fix test for whether we can skip read when writing beyond EOF
> > 
> > "origin" is Linus' tree. I'm not sure what I'm doing wrong otherwise.
> 
> Commit 827a746f405d ("netfs: fix test for whether we can skip read when
> writing beyond EOF") is just that, yes.
> 
> That does not match with the subject line here, or the patch itself.
> 
> So I do not understand what you are trying to do here...

That was in the original message:

> This bug was originally in ceph, and then got replicated in the new
> netfs helper code in v5.13. This patch is a backport of the netfs patch
> for ceph. It should be applied to 5.10.y - 5.12.y.

ie the code got moved from ceph to netfs upstream, and this is a
backport from netfs to ceph.
