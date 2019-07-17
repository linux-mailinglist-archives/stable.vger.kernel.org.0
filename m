Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE26B7AF
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 09:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfGQHyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 03:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfGQHyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 03:54:20 -0400
Received: from localhost (unknown [113.157.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A242077C;
        Wed, 17 Jul 2019 07:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563350059;
        bh=gh2grlGu2xJ48BElrK9ZYGDMl22lctdMTYpWME/t5Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=amrq428/UustB0B0OQx+T7UCb8Xm+yp4yBWGUQLb71X4tTbWHQa9cWAcubqHgYuT3
         /3xkvT8WSalimdLCGOK8yzNChEA+zwG4ao73jpufxHxlsFJPLipStGe3EHq7DVjfEn
         mogEA2fhEqCq4IUJjSvv+lzsSPN/bHSy9HiYt4L4=
Date:   Wed, 17 Jul 2019 16:54:17 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     stable <stable@vger.kernel.org>, Mark Zhang <markz@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Jinyoung Park <jinyoungp@nvidia.com>,
        Venkat Reddy Talla <vreddytalla@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] regmap-irq: do not write mask register if mask_base is
 zero
Message-ID: <20190717075417.GB13620@kroah.com>
References: <20190520172139.16991-1-linus.walleij@linaro.org>
 <CACRpkdbcobeABjcA8+_cAjgddZnmHwoCx4pqAPbSS1GDNm6J2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbcobeABjcA8+_cAjgddZnmHwoCx4pqAPbSS1GDNm6J2g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 09:42:00AM +0200, Linus Walleij wrote:
> Hi Greg,
> 
> On Mon, May 20, 2019 at 7:23 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> 
> > From: Mark Zhang <markz@nvidia.com>
> >
> > commit 7151449fe7fa5962c6153355f9779d6be99e8e97 upstream.
> >
> > If client have not provided the mask base register then do not
> > write into the mask register.
> >
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>
> > Signed-off-by: Venkat Reddy Talla <vreddytalla@nvidia.com>
> > Signed-off-by: Mark Zhang <markz@nvidia.com>
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > ---
> > This commit was found in an nVidia product tree based on
> > v4.19, and looks like definitive stable material to me.
> > It should go into v4.19 only as far as I can tell.
> 
> Was this missed or is there some reason for why this didn't get
> queued to stable?

I think it was missed, sorry :(

Now queued up.

greg k-h
