Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DDB2D78C9
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391208AbgLKPFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406549AbgLKPFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:05:13 -0500
Date:   Fri, 11 Dec 2020 15:46:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607697921;
        bh=U/iXc5Empa2K5pPImlDeKH/1IIdXnfFqxvsSKgiefmE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=vU5g3MeGvLjhlq12Ddn87X3o/qqLr6xSnovNKl8CItwrGbRs58ZVj142RueoDjai3
         XFILMA1dTsk7Gqy/f4swFc6BxA5LYaf4bek1AsgjvIUl/PJaywH0DUF3nMQo9NDG+X
         kkm9lsld6husknZxj3kOkKy0QxsEaoTTfAS8arFY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.9-stable tree
Message-ID: <X9OGR2GraEllyRJZ@kroah.com>
References: <160750482613828@kroah.com>
 <X9JgaCe2gGRdSNot@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9JgaCe2gGRdSNot@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 09:52:40AM -0800, Minchan Kim wrote:
> On Wed, Dec 09, 2020 at 10:07:06AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan@kernel.org>
> > Date: Sat, 5 Dec 2020 22:14:51 -0800
> > Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
> 
> original commit id is e91d8d78237de8d7120c320b3645b7100848f24d and this
> is backport patch for v5.9.
> If it has a problem to apply, let me know.

Now queued up, thanks.

greg k-h
