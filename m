Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C484982AF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiAXOtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:49:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52758 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiAXOtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:49:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A93DB810B2
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD52C340E7;
        Mon, 24 Jan 2022 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643035751;
        bh=DqzlwRf0uEAjRthd1qzLAsY5I0b/pGUv5r5Jk88d+UY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LIRJto3o40Kffd11Y7KPKHkz5FAi15i2aewNGTJKsjFwwgWu5hSt+6kr8lIM+CaV/
         Wapq709ISaIJJyiBsmYP/sD6t6ceuTv07v4V73ZfejCjZ68oKQJ710PEJWC6HQNvbh
         uliqGI/Lz/rLCyI6u8RmQDkiGMdeYqq5zlefvsQs=
Date:   Mon, 24 Jan 2022 15:49:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     john.p.donnelly@oracle.com
Cc:     bhe@redhat.com, 42.hyeyoo@gmail.com, David.Laight@aculab.com,
        akpm@linux-foundation.org, bp@alien8.de, cl@linux.com,
        david@redhat.com, hch@lst.de, iamjoonsoo.kim@lge.com,
        m.szyprowski@samsung.com, penberg@kernel.org, rientjes@google.com,
        robin.murphy@arm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] dma/pool: create dma atomic pool only if
 dma zone has managed" failed to apply to 5.4-stable tree
Message-ID: <Ye68ZHq02pB59PF/@kroah.com>
References: <164294819620733@kroah.com>
 <d9eec78f-e0e8-cc6d-ffe4-fbd31c8bb6a9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9eec78f-e0e8-cc6d-ffe4-fbd31c8bb6a9@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 08:37:43AM -0600, john.p.donnelly@oracle.com wrote:
> On 1/23/22 8:29 AM, gregkh@linuxfoundation.org wrote:
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
> 
> Hi,
> 
> 
> FWIIW :
> 
> We picked up the suspect "Fixes"  commit :
> 
> 2020-10-01 | x86/kdump: Always reserve the low 1M when the crashkernel
> option is specified
> 
> In an LTS update:  5.4.68,  and I do not see the issue reported in the
> summary :  "DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
> " , when a kdump is invoked. We test kdump quite regularly on a variety of
> platforms.

That commit was in 5.4.69, not .68.  Or am I confused here?

that is why the 5.4 FAILED email was sent.

thanks,

greg k-h
