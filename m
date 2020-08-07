Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8074623F1BA
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgHGRKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 13:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGRKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 13:10:04 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D292086A;
        Fri,  7 Aug 2020 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596820204;
        bh=rgL9ZNm0dRaXWXT9kjVHI0taoZ2nlw6y+hXYboEvtqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uUOZ9qiRl9bDEe5ANnN3bNK4uwqlHEiSiAF44VLPa5vDqCbc0qPMVtJtki5dURfDY
         KBD31xIB2ZW6JrumI28ev7JJ8O3OAQEhDjeGhsAJKsg13i55zIR2g1neUFioQ6pAO9
         V4K5uYwRZh3MnG7hD9eEYhWyAUSIzHVWD1Jwsjuo=
Date:   Fri, 7 Aug 2020 10:10:01 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Eric Deal <eric.deal@wdc.com>, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix get_max_io_size()
Message-ID: <20200807171001.GA4155677@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200806215837.3968445-1-kbusch@kernel.org>
 <88d4db76-b912-8987-cfac-a2b926fbfe3d@acm.org>
 <c2275412-5106-e0a3-63db-a7b0ceedd1d3@acm.org>
 <20200807032437.GC3797376@dhcp-10-100-145-180.wdl.wdc.com>
 <60baf63a-6264-812e-15e6-b0a28b07329f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60baf63a-6264-812e-15e6-b0a28b07329f@acm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 07:18:49AM -0700, Bart Van Assche wrote:
> Hi Keith,
> 
> How about replacing your patch with the (untested) patch below?


I believe that should be fine, but I broke the kernel last time I did
something like that. I still think it was from incorrect queue_limits,
but Linus disagreed.

 * http://lkml.iu.edu/hypermail/linux/kernel/1601.2/03994.html
