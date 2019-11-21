Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87723104AD5
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 07:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUGxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 01:53:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUGxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 01:53:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD30D2088F;
        Thu, 21 Nov 2019 06:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574319184;
        bh=X2xuwSWMRzYjGfBs9wt4OK4wgwUxtYo4BGlyAFXoL+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l21AWJtnmy3ksGg3GAEnp1UwUFZvmQzas8adPonvgq1FBHVFCx9OjhfQ9CJBYJrEk
         J/j1WoMUbX5w9w074ktEd9Dldc2c0xlG4DgEpx98zsBl/8GZwNuhVBQwHoAg51XgJa
         HXhtoHOaKAj37z0k9BvWBF17Y3pfCoKUWzJKJdGM=
Date:   Thu, 21 Nov 2019 07:53:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: Patches missing from v4.14.y/v4.19.y after most recent stable
 release
Message-ID: <20191121065301.GB340798@kroah.com>
References: <20191120220238.GA21382@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120220238.GA21382@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 02:02:38PM -0800, Guenter Roeck wrote:
> Hi,
> 
> when merging the most recent stable releases into chromeos-4.14 and
> chromeos-4.19, I noticed that the following patches are missing
> in v4.14.y and v4.19.y. In both cases a backported fix was later fixed
> upstream, but the fix of the fix was not backported.
> 
> v4.14.y, v4.19.y:
> 
> commit a4d8f64f7267 ("spi: mediatek: use correct mata->xfer_len when in fifo transfer")
> 
>         Fixes commit 6237e9d0715a ("spi: mediatek: Don't modify spi_transfer
>         when transfer."), but is not marked for stable/fixes.

How did you figure that out?  That's not in the text of the changelog at
all?

Anyway, now queued up, thanks.

> v4.19.y:
> 
> commit bc1a7f75c85e ("i2c: mediatek: modify threshold passed to i2c_get_dma_safe_msg_buf()")
> 
>         Fixes: fc66b39fe36a ("i2c: mediatek: Use DMA safe buffers for i2c transactions")

Now queued up, thanks.

greg k-h
