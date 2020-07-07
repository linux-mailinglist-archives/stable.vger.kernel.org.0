Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122AC216DFF
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGGNp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgGGNp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 09:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34AF420658;
        Tue,  7 Jul 2020 13:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594129527;
        bh=HUsK0OOL9/x0OvnFTULeY9DJ47/h02qMoAHDOdJ6mho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6Z6aXSp331BSAP2ToKxVMDtiSYRvCtGAxE/LVx8bIWNAGSWGkRLoNG3g3rT9Xmj2
         bioRTYIRcqMX71Q1idCtjPg+uvou7+i9WTVuN/V9miPDhOtHP7v6EQVOApOKKmlVEX
         2tyvy8wMNKHWlZ/mt44fBCHeoP9wZAiEx/uYXPik=
Date:   Tue, 7 Jul 2020 15:45:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, liwang@redhat.com, mgorman@techsingularity.net,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm, compaction: make capture control
 handling safe wrt" failed to apply to 5.4-stable tree
Message-ID: <20200707134525.GA3726233@kroah.com>
References: <15934288599599@kroah.com>
 <81da3715-b6f4-501f-703c-636982a9be42@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81da3715-b6f4-501f-703c-636982a9be42@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 08:21:24PM +0200, Vlastimil Babka wrote:
> On 6/29/20 1:07 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi, please simply cherrypick commit 6467552ca64c ("mm, compaction: fully assume
> capture is not NULL in compact_zone_order()") first and then cherrypicking
> b9e20f0da1f5c9c68689450a8cb436c9486434c8 will apply cleanly.

Thanks, that worked!

greg k-h
