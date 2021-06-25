Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE1E3B413A
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFYKOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFYKOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:14:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66FF661436;
        Fri, 25 Jun 2021 10:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624615923;
        bh=s/tMNUKPpbYxwGfPp48p5dt7BLtDhrB7xuMtMJ+BFY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snsX4d0EYNaYoHr6LfiAL9L1CCqpRpLAWmc9g1DGOHuJlw7nkdArEe4O+t2Yvp/lc
         NoGyEt+FWwqqUm9lwiNJVG1uM1TXRu6WUzIUxOAvrg6/2dTLFZLoXY3ANfFOkxNKrm
         ikhBVez6grbcVaD8J2GEr4tN81qldtgq5vTy8Jcw=
Date:   Fri, 25 Jun 2021 12:12:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Jankowski <shasta@toxcorp.com>
Cc:     sashal@kernel.org, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Backporting 3a7956e25e1d to LTS kernels?
Message-ID: <YNWr8AmqCNEDd7ec@kroah.com>
References: <1c3c181f-514b-f30a-a29a-1f3dd01e2d09@toxcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c3c181f-514b-f30a-a29a-1f3dd01e2d09@toxcorp.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 24, 2021 at 04:03:13AM +0200, Jakub Jankowski wrote:
> Hi,
> 
> We've recently hit this on 5.4.124:
>   WARNING: CPU: 5 PID: 35 at kernel/kthread.c:75
> kthread_is_per_cpu+0x21/0x30
> 
> After some digging, I figured out that this should be fixed by commit
> 3a7956e25e1d ("kthread: Fix PF_KTHREAD vs to_kthread() race") in mainline.
> It Fixes: ac687e6e8c26 ("kthread: Extract KTHREAD_IS_PER_CPU")
> 
> 3a7956e25e1d has been backported to 5.12.x and 5.11.x:
> - 5.12.4:  as 163dd7fa459faebe055bcbebf9e088bae04f8e33
> - 5.11.21: as 42e4caa93282ade6a143ff320d71062874dd3a5a
> 
> Makes sense, as ac687e6e8c26 originally landed in 5.11.
> 
> But it appears that since then ac687e6e8c26 has also been backported to LTS
> trees:
> - 5.10.14:  as b20475a80b4bd2c7bc720c3a9a8337c36b20dd8c
> - 5.4.96:   as 5b1e4fc2984eab30c5fffbf2bd1f016577cadab6
> - 4.19.174: as fbad32181af9c8c76698b16115c28a493c26a2ee
> - 4.14.220: as a9b2e4a94eee352e0b3e863045e7379d83131ee2
> 
> Maybe those trees could use a backport of 3a7956e25e1d as well then?

I would love to take a copy to those older trees, but the patch does not
apply to those trees.  Can you please provide a working backport that
you have tested and we will be glad to take it.

thanks,

greg k-h
