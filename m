Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D871225D7EC
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIDLyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgIDLyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:54:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563A92151B;
        Fri,  4 Sep 2020 11:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599220440;
        bh=UFUbNY+crTB16Aj9UJWDM/p3Bdt6iU4LuDeenNyytJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uWK/hslrcFXxKa41WA5GS0MtPi7VnWb0UfSkxqGnEmVnYCQiUcHQrZZLY5wKfePtO
         UYId0ogbg6S0+dkW+SlLfYMGGjDVaex++xP4ervWYU8+P24h13EWgg/vb0d3n138jU
         d2XF/RiEH5f35Anv6kiVF0heuVV15uZLZJdwWT5E=
Date:   Fri, 4 Sep 2020 13:54:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.4] mm, page_alloc: remove unnecessary variable from
 free_pcppages_bulk
Message-ID: <20200904115422.GB2964473@kroah.com>
References: <20200902184327.12530-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902184327.12530-1-dwagner@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 08:43:27PM +0200, Daniel Wagner wrote:
> From: Mel Gorman <mgorman@techsingularity.net>
> 
> [ Upstream commit e5b31ac2ca2cd0cf6bf2fcbb708ed01466c89aaa ]
> 
> The original count is never reused so it can be removed.
> 
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [dwagner: update context]
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> Hi,
> 
> The backport commit 0c9ce43da97d ("mm, page_alloc: fix core hung in
> free_pcppages_bulk()") has the depency to this commit. It went in v4.6
> so only v4.4 is effected.

Thanks for the backport, now queued up.


greg k-h
