Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C42285A1F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 07:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfHHF42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 01:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfHHF42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 01:56:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B3C2086D;
        Thu,  8 Aug 2019 05:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565243787;
        bh=sTjxqBEWzZ3t+0OxMPjG91Qb/l1Z3pBEben6ZzaVEgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jRerqa5cZAADlPIKkqt4CRVaGDE76SvsjPzqTOvevIsgIO4aWtNPjWIIAOepGYitJ
         dZIgJN3d4dVQ/SN8JpvxLXkpaKeGRzKmKHQGoQralCpK1kw+KM0Od3cLjcIs8ZJ1ZF
         Dp0thUhGbJiW7qvaxdA80h/i6hQ5TKQv69iwFXmQ=
Date:   Thu, 8 Aug 2019 07:56:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     broonie@kernel.org, kernel@martin.sperl.org, nuno.sa@analog.com,
        wahrenst@gmx.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix 3-wire mode if DMA is
 enabled" failed to apply to 5.2-stable tree
Message-ID: <20190808055625.GA24491@kroah.com>
References: <156519648724814@kroah.com>
 <20190807205849.ualpzgp52crdmdol@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807205849.ualpzgp52crdmdol@wunner.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 10:58:49PM +0200, Lukas Wunner wrote:
> On Wed, Aug 07, 2019 at 06:48:07PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.2-stable tree.
> 
> That's odd, it works for me:
> 
> $ git fetch linux-stable
> $ git checkout linux-stable/linux-5.2.y
> Checking out files: 100% (43562/43562), done.
> HEAD is now at 5697a9d... Linux 5.2.7
> $ git am /tmp/pt
> Applying: spi: bcm2835: Fix 3-wire mode if DMA is enabled
> 
> Could you be a little more specific why it couldn't be applied
> when you tried it?

Sorry, that's the problem of form letters, sometimes they are wrong :(

The patch applies everywhere, but breaks the build in all trees.  So it
needs to be modified to build properly.  I need to write up a different
error message for this type of failure one of these days, luckily it is
pretty rare.

thanks,

greg k-h
