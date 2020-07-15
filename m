Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7332208A1
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 11:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgGOJY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 05:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbgGOJY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 05:24:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5262064B;
        Wed, 15 Jul 2020 09:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594805096;
        bh=lQ6hiRNitg1GZKtOIjjCsxsCd+Fn/q4LEgPLitx5eNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oBaNwzBsh7kmGxjdLvriXApi8/YqKJuouaWWFeL42spwDvlFSadiemrxqDlpYUm8R
         LY544wAtp/bbSB0xDIaU7/myaNVNnuA8LszLVwbA22sZpV0WvX46fArbCakohEuMH6
         J92A0M8cim9ma+a4eEcu5ruFvB8YIz0YNdmblfTU=
Date:   Wed, 15 Jul 2020 11:24:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 026/109] drm/sun4i: mixer: Call of_dma_configure if
 theres an IOMMU
Message-ID: <20200715092453.GD2722864@kroah.com>
References: <20200714184105.507384017@linuxfoundation.org>
 <20200714184106.782410654@linuxfoundation.org>
 <CAGb2v65ecm+9iK7GY6xKUHNhjdDimcL8Kd6eg-yX_nOm5rMZjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v65ecm+9iK7GY6xKUHNhjdDimcL8Kd6eg-yX_nOm5rMZjA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 10:22:13AM +0800, Chen-Yu Tsai wrote:
> Hi Greg,
> 
> On Wed, Jul 15, 2020 at 3:11 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Maxime Ripard <maxime@cerno.tech>
> >
> > [ Upstream commit 842ec61f4006a6477a9deaedd69131e9f46e4cb5 ]
> >
> > The main DRM device is actually a virtual device so it doesn't have the
> > iommus property, which is instead on the DMA masters, in this case the
> > mixers.
> 
> The iommu driver and DT changes were added in v5.8-rc1. IMO There is no
> point in backporting this patch to any stable kernel.

Now dropped from everywhere, thanks.

greg k-h
