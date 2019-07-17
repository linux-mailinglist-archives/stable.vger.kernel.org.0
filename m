Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281356B7B6
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGQHzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 03:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfGQHzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 03:55:09 -0400
Received: from localhost (unknown [113.157.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27DC2077C;
        Wed, 17 Jul 2019 07:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563350109;
        bh=Za+2Z/KvbFxy7TAfDN86HVciROQnNMDwUAxkAE548iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gPA2brW/gUgNjPQkKr4q84B5qjQIS048StG5wruBzelsrVEalzqDau7MnLX4HoBaa
         kcqrEX59baIvYd9lDujDt3bg7wzV24NbMuc5I7469eF4/G80P19fz9AkEofT/C+88a
         RQOtxDU4o5Hr6TrrSeigxLLig09+kEn4RKGxj1uI=
Date:   Wed, 17 Jul 2019 16:55:07 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaolin Zhang <xiaolin.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gvt: fix incorrect cache entry for guest page
 mapping
Message-ID: <20190717075507.GA14238@kroah.com>
References: <1563378987-21880-1-git-send-email-xiaolin.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563378987-21880-1-git-send-email-xiaolin.zhang@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 11:56:27PM +0800, Xiaolin Zhang wrote:
> GPU hang observed during the guest OCL conformance test which is caused
> by THP GTT feature used durning the test.
> 
> It was observed the same GFN with different size (4K and 2M) requested
> from the guest in GVT. So during the guest page dma map stage, it is
> required to unmap first with orginal size and then remap again with
> requested size.
> 
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
