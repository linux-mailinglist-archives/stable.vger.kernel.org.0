Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA42D032B
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgLFLH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbgLFLHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:07:55 -0500
Date:   Sun, 6 Dec 2020 12:08:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607252835;
        bh=JcAtjlLYW1IK/Zqhmur9wshDm9M/wsoSWr5HgCk4Kos=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkm/aOWGLOYhUorWtMX7TTXkQSxnuE2Rsx8ceIxim/mZyRD4OKCjAQiDHhro52uoZ
         uwMBX3vhCk/CwALaVgbkdJPovXUi99thD4ZImmEaMWMzdLcXLr+lCbAh+tEZsDVl9u
         k9KeoI08+eqfiYvIbl7XmBFZ95dg97Lj0EGcBfoQ=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835aux: Fix use-after-free on
 unbind" failed to apply to 4.19-stable tree
Message-ID: <X8y7q+Hbi+/fYmz9@kroah.com>
References: <1606121644237255@kroah.com>
 <20201205095858.GA5563@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205095858.GA5563@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 10:58:58AM +0100, Lukas Wunner wrote:
> On Mon, Nov 23, 2020 at 09:54:04AM +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Below please find the backport of e13ee6cc4781 to linux-4.19.y.
> 
> Be aware that it depends on commit 5e844cc37a5c ("spi: Introduce
> device-managed SPI controller allocation").

<snip>

Ok, I'm totally confused by all of these different attachments,
dependancies, and different versions.

Can you send me a patch series for the different stable trees with the
specific patches backported already, as I am lost with all of these
responses and threads, sorry.

thanks,

greg k-h
