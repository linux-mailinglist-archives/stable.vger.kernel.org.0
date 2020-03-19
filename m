Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35818B850
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgCSNre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgCSNre (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:47:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435452080C;
        Thu, 19 Mar 2020 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584625653;
        bh=0C8hZU/YxpZVRYqef82R8KCTqT8U8jWoXQOw7dID8a4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YjIQXGfURrlH08Kx68uk3vGL3vma7uc5UvnvSXjZL+T0WWw4yQ2LjjTQmx6aSXeQ0
         giDRHsX2Sl+Xwb90KjYe97dQ32dXhOLWiNdYjZ2MuqkefAf9kWySPOIf7pQ7BDK5Kg
         DAgas/A9ZCo36SmPIOYFER1o2wRyxM3hXd75v1aw=
Date:   Thu, 19 Mar 2020 14:47:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.5 01/65] gpiolib: Add support for the irqdomain which
 doesnt use irq_fwspec as arg
Message-ID: <20200319134710.GA4092809@kroah.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <20200319123926.902914624@linuxfoundation.org>
 <20200319133355.GB711692@pek-khao-d2.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319133355.GB711692@pek-khao-d2.corp.ad.wrs.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 09:33:55PM +0800, Kevin Hao wrote:
> On Thu, Mar 19, 2020 at 02:03:43PM +0100, Greg Kroah-Hartman wrote:
> > From: Kevin Hao <haokexin@gmail.com>
> > 
> > [ Upstream commit 242587616710576808dc8d7cdf18cfe0d7bf9831 ]
> > 
> > Some gpio's parent irqdomain may not use the struct irq_fwspec as
> > argument, such as msi irqdomain. So rename the callback
> > populate_parent_fwspec() to populate_parent_alloc_arg() and make it
> > allocate and populate the specific struct which is needed by the
> > parent irqdomain.
> 
> Hi Greg,
> 
> This commit shouldn't go to stable because it is not a bug fix. It is just a
> prerequisite of switching to general GPIOLIB_IRQCHIP for thunderx gpio driver
> (commit 7a9f4460f74d "gpio: thunderx: Switch to GPIOLIB_IRQCHIP").

This seems to be a prerequisite for f98371476f36 ("pinctrl: qcom:
ssbi-gpio: Fix fwspec parsing bug") to apply properly.  With that
information, is it ok to keep?

thanks,

greg k-h
