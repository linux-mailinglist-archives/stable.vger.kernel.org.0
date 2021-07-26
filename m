Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DA43D56B1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhGZIzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhGZIzi (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:55:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 198D3600D1;
        Mon, 26 Jul 2021 09:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627292167;
        bh=OC8uJIxM5DBUfxmvwysQIvhAWeKOEE+77GeGk4czdlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0T3dh8x1p6BAQkj0ACky6KkNbf7rsenmkSIoEXw6y6QB0d1OJ+q5f77fHrrDuf2Gx
         uIfPyNIOIINoEaiZCjIBPt2abUpVAU2cm/AXAgF90tEawAl0k1Bzgwi1h18lijffC0
         4Yr8ufaYDWzJkp3rVoNFpwL+UlCkzlpNdYJigxxc=
Date:   Mon, 26 Jul 2021 11:32:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org, pmeerw@pmeerw.net
Subject: Re: FAILED: patch "[PATCH] iio: accel: bma180: Fix BMA25x bandwidth
 register values" failed to apply to 5.4-stable tree
Message-ID: <YP6BPhiTaByxVJ7T@kroah.com>
References: <1626008487114116@kroah.com>
 <YPnTfOMe1xP5p+ly@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPnTfOMe1xP5p+ly@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 09:22:20PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Jul 11, 2021 at 03:01:27PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with 9436abc40139 ("iio: accel: bma180: Use
> explicit member assignment") which makes the backporting a little easier.
> This will apply to all branches till 4.4-stable.
> 

Thanks, both now queued up.

greg k-h
