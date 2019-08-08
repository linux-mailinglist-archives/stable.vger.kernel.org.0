Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF76785F27
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 12:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbfHHKBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 06:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbfHHKBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 06:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E75CC21880;
        Thu,  8 Aug 2019 10:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565258491;
        bh=xZV/d4sQHs2BhErm+RBDsxf6P6yrHJoDVH0LIb3zn9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aTEN92HO92079+IxH17uv81ZoMQRMFJQgGj3loJS+7qN4G2+m7/9gEtgU9zd1Ibfr
         udJ7LkQQw+BHh1WJhpX/FSH9z3dKUFs7TS7mme3lu9s1S3m+c0jW2uZjYesWt+2ixn
         UevMgK1hFLNXJUCbeC0RGx+Xwndk8Z6OAW9jK/Ro=
Date:   Thu, 8 Aug 2019 12:01:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     broonie@kernel.org, kernel@martin.sperl.org, nuno.sa@analog.com,
        wahrenst@gmx.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix 3-wire mode if DMA is
 enabled" failed to apply to 5.2-stable tree
Message-ID: <20190808100129.GA23844@kroah.com>
References: <156519648724814@kroah.com>
 <20190807205849.ualpzgp52crdmdol@wunner.de>
 <20190808055625.GA24491@kroah.com>
 <20190808062329.njfou4kfqwlz24qn@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808062329.njfou4kfqwlz24qn@wunner.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 08:23:29AM +0200, Lukas Wunner wrote:
> On Thu, Aug 08, 2019 at 07:56:25AM +0200, Greg KH wrote:
> > On Wed, Aug 07, 2019 at 10:58:49PM +0200, Lukas Wunner wrote:
> > > On Wed, Aug 07, 2019 at 06:48:07PM +0200, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.2-stable tree.
> > 
> > The patch applies everywhere, but breaks the build in all trees.
> 
> Ugh, yes you are right, my apologies.
> 
> The reason is that v5.3 converted spi-bcm2835.c to use the
> "spi_controller" nomenclature instead of "spi_master" with
> commit 5f336ea53b6b ("spi: bcm2835: Replace spi_master by
> spi_controller").
> 
> The replacement patch below should hopefully not break the
> build.  It's the same as upstream commit 8d8bef503658,
> except one occurrence of "ctlr" is replaced by "master".

Thanks for this, now queued up.

greg k-h
