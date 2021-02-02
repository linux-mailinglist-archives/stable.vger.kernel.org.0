Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0795E30BF03
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhBBNFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:05:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhBBNFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:05:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E043E64F45;
        Tue,  2 Feb 2021 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612271077;
        bh=qcyCNfGec4QKmfxHQgXt+lSM8xFm80bHhlhz/RrANj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LF+qjRX8V9QGLOM6Q5hpUi6RbE50OFmF7QTaKnZaFUbwHw4/lt48Qhy12r36cLOxk
         +ZR/2OT8hJd3HfXYitlo3IuLOYTqCr6kYj6RhmgJfN/XHH775dQ0aQIi+Oe7rIh8rd
         S4lw8bQdvvU1FifpfSb66LT2HFZ7e7v6HeeXuqNQ=
Date:   Tue, 2 Feb 2021 14:04:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Filippo Sironi <sironi@amazon.de>
Cc:     stable@vger.kernel.org, samjonas@amazon.com, dwmw@amazon.co.uk,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/2 for Linux 5.4] iommu/vt-d: Gracefully handle DMAR
 units with no supported address widths
Message-ID: <YBlN4JmzxKrt6O9G@kroah.com>
References: <20210202000009.31392-1-sironi@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202000009.31392-1-sironi@amazon.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 01:00:08AM +0100, Filippo Sironi wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> commit c40aaaac1018ff1382f2d35df5129a6bcea3df6b upstream.
> 
> Instead of bailing out completely, such a unit can still be used for
> interrupt remapping.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Link: https://lore.kernel.org/linux-iommu/549928db2de6532117f36c9c810373c14cf76f51.camel@infradead.org/
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> [ context change due to moving drivers/iommu/dmar.c to
>   drivers/iommu/intel/dmar.c ]
> Signed-off-by: Filippo Sironi <sironi@amazon.de>
> ---
>  drivers/iommu/dmar.c | 44 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 14 deletions(-)

All of these now queued up, thanks!

greg k-h
