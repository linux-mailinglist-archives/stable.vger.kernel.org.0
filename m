Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087B1C2DC8
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 09:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbfJAHHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 03:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbfJAHHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 03:07:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA32215EA;
        Tue,  1 Oct 2019 07:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569913660;
        bh=W7DnxrQJnaB/Vyz05qZnyM11wdUw87JS7sJFfJAQ/tQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j5l9vYSp2Ru3Vtf5nstKyAitckbXEBnP9u3svYKeL12Uy8PFqvru9rYLE1SQxbaHv
         hXltbDuMrL1pR1PqYyA0LpG5C9VE4V3H4BPzudam+SRAGKewmsR/ZBPYC/iNxKAzLD
         pYFrxfFYfv/aaIF19sFqzvFgT/fH8LCMmh5Hu3g8=
Date:   Tue, 1 Oct 2019 09:07:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: 5.3.3??? [was Re: Linux 5.3.2]
Message-ID: <20191001070738.GC2893807@kroah.com>
References: <20191001070457.GA2893807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001070457.GA2893807@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 09:04:57AM +0200, Greg KH wrote:
> I'm announcing the release of the 5.3.2 kernel.
> 
> All users of the 5.3 kernel series must upgrade.

Ok, I messed up this morning and typed "5.3" instead of "5.2" in my
scripts and an "empty" 5.3.3 kernel got released.  Well kind of, it got
checked into git, but there wasn't anything to release so things got a
bit confused.

So just consider 5.3.3 a "nothing to see here, ignore the man who forgot
to release kernels _after_ coffee and not before" type of release.

5.3.4 will be the _next_ release after this one, sorry for any
confusion.

ugh,

greg k-h
