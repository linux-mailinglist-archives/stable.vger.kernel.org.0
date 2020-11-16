Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5EA2B4ADE
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbgKPQXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732025AbgKPQXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 11:23:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC50221F8;
        Mon, 16 Nov 2020 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605543820;
        bh=uzHRvdosTX1T/AdsKmL4ejNLCnp/tqT+pu9FhT+QMDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BKv6PIXgH1fBAcbfdUKgYXiOld7SiHoAZ1gVE/G3qsWQNv5OdiwvbTfQTGLAsYzuO
         yte7odvxz8m/P/fEPuxFV4lE0TaCLvC70zNlr69F0w4dZWTsr8Ua/is01KOQvtotz7
         7m3t4qjo6bj12ZjC93dXcOwiGYcDCLKcwCjWdDsE=
Date:   Mon, 16 Nov 2020 17:24:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dsterba@suse.com, josef@toxicpanda.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix potential overflow in
 cluster_pages_for_defrag on" failed to apply to 5.4-stable tree
Message-ID: <X7KnvoydnKnjD+B/@kroah.com>
References: <160554176663142@kroah.com>
 <20201116160121.GE29991@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116160121.GE29991@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 04:01:21PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 16, 2020 at 04:49:26PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Patch below generated against 5.4.67

Thanks, that worked, also seems to work for 4.19.y

