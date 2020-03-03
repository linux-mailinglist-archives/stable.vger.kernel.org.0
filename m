Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2981178267
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgCCS1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:27:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgCCS1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:27:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AC7620842;
        Tue,  3 Mar 2020 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583260051;
        bh=ihTn+A5qhv34UfkP7MFcwfri7GGNMdIPilush6r1irU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/7Mr9lbWrQO9ZnvD1zb7t/uQI1o2RiE3NSipvR9GCqykjM6aZbbNEaiqJwaaWh42
         0aDwGseIxwmuj+6L+gtONHxIJzOYGZoNe/Ky9MWgtVfGNgFj+sRbjq70imkjrLDFPt
         AdIMnb3g6c7pfZCPO9KVQ6z4U5pVMXL96sQp2hEI=
Date:   Tue, 3 Mar 2020 19:27:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Patch "padata: always acquire cpu_hotplug_lock before
 pinst->lock" has been added to the 4.4-stable tree
Message-ID: <20200303182729.GB1053759@kroah.com>
References: <1583253273103220@kroah.com>
 <57b3012d-7692-de3d-7cb2-3004599563d0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b3012d-7692-de3d-7cb2-3004599563d0@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 01:18:44PM -0500, Daniel Jordan wrote:
> On 3/3/20 11:34 AM, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      padata: always acquire cpu_hotplug_lock before pinst->lock
> > 
> > to the 4.4-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       padata-always-acquire-cpu_hotplug_lock-before-pinst-lock.patch
> > and it can be found in the queue-4.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> >  From 38228e8848cd7dd86ccb90406af32de0cad24be3 Mon Sep 17 00:00:00 2001
> > From: Daniel Jordan <daniel.m.jordan@oracle.com>
> > Date: Tue, 3 Dec 2019 14:31:11 -0500
> > Subject: padata: always acquire cpu_hotplug_lock before pinst->lock
> > 
> > From: Daniel Jordan <daniel.m.jordan@oracle.com>
> > 
> > commit 38228e8848cd7dd86ccb90406af32de0cad24be3 upstream.
> 
> Hi, can this please be removed from all stable trees?  I guess this made its way back in after Sasha removed it before.  Justification is at
> 
> https://lkml.kernel.org/r/20200222000045.cl45vclfhvkjursm@ca-dmjordan1.us.oracle.com

Oops, sorry about that.  Will go drop that from everywhere right now.

greg k-h
