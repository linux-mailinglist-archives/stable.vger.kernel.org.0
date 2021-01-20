Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BA62FD07B
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 13:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbhATMjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 07:39:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388835AbhATMIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 07:08:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8622E23339;
        Wed, 20 Jan 2021 12:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611144411;
        bh=j6xaRuX/+evv50PTBz0NflcJzFpdcyGQgGYXKX0GS9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXc3wAjB4TWuamYBWPQUOZY2c4omdr9uEBrlJ1ZRAb1uIqYqERIMbEER2O+u9VXsc
         l49aTSGH/h7oUCL9mjRd8xRWozhoXptttR4T2LWpE7AszGZpb0nTSFFfhNn1d+Pa0E
         3ujn58JhypfXnCrpmIpbcBQyv3EP+VFhis6hj2Bc=
Date:   Wed, 20 Jan 2021 13:06:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org, iommu <iommu@lists.linux-foundation.org>,
        "Mendoza-jonas, Samuel" <samjonas@amazon.com>,
        "Sironi, Filippo" <sironi@amazon.de>
Subject: Re: [PATCH] iommu/vt-d: gracefully handle DMAR units with no
 supported address widths
Message-ID: <YAgc2MX2c2N/rGDM@kroah.com>
References: <549928db2de6532117f36c9c810373c14cf76f51.camel@infradead.org>
 <5414a3e3cdbd24ba707153584d13f06ed5dbba76.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5414a3e3cdbd24ba707153584d13f06ed5dbba76.camel@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 09:42:43AM +0000, David Woodhouse wrote:
> On Thu, 2020-09-24 at 15:08 +0100, David Woodhouse wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> > 
> > Instead of bailing out completely, such a unit can still be used for
> > interrupt remapping.
> > 
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> Could we have this for stable too please, along with the trivial
> subsequent fixup. They are:
> 
> c40aaaac1018 ("iommu/vt-d: Gracefully handle DMAR units with no supported address widths")
> 9def3b1a07c4 ("iommu/vt-d: Don't dereference iommu_device if IOMMU_API is not built")
> 
> They apply fairly straightforwardly when backported; let me know if you
> want us to send patches.

What stable kernel(s) do you want this in?  The above patches are
already in 5.10.

thanks,

greg k-h
