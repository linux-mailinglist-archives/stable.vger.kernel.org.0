Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101B16B7BC
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 09:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfGQHzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 03:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfGQHzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 03:55:46 -0400
Received: from localhost (unknown [113.157.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B3A2077C;
        Wed, 17 Jul 2019 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563350145;
        bh=XWpdzQMxIi4AhVMZd7okMCwen1dJPcVyeK6NLp4V7A8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0OfwJnkAvlNUmEOUWnYQbiS14GXR14jxcbvRv63zFtc06TPrIsWA4gBQ4cUo6d57O
         9rf+Du30pqynx8vmGnlqCVEAtstjsIdFof5F1G94IwAPB5Jd+YUu7ofnHThqaZ3aiL
         eH4bKOZgwHI3puVzXDG2ZkHcyHo3gP5Zd5gwDy+o=
Date:   Wed, 17 Jul 2019 16:55:43 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     stable <stable@vger.kernel.org>, Mark Zhang <markz@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Jinyoung Park <jinyoungp@nvidia.com>,
        Venkat Reddy Talla <vreddytalla@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] regmap-irq: do not write mask register if mask_base is
 zero
Message-ID: <20190717075543.GA14309@kroah.com>
References: <20190520172139.16991-1-linus.walleij@linaro.org>
 <CACRpkdbcobeABjcA8+_cAjgddZnmHwoCx4pqAPbSS1GDNm6J2g@mail.gmail.com>
 <20190717075417.GB13620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717075417.GB13620@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 04:54:17PM +0900, Greg Kroah-Hartman wrote:
> On Wed, Jul 17, 2019 at 09:42:00AM +0200, Linus Walleij wrote:
> > Hi Greg,
> > 
> > On Mon, May 20, 2019 at 7:23 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> > 
> > > From: Mark Zhang <markz@nvidia.com>
> > >
> > > commit 7151449fe7fa5962c6153355f9779d6be99e8e97 upstream.
> > >
> > > If client have not provided the mask base register then do not
> > > write into the mask register.
> > >
> > > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > > Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>
> > > Signed-off-by: Venkat Reddy Talla <vreddytalla@nvidia.com>
> > > Signed-off-by: Mark Zhang <markz@nvidia.com>
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > ---
> > > This commit was found in an nVidia product tree based on
> > > v4.19, and looks like definitive stable material to me.
> > > It should go into v4.19 only as far as I can tell.
> > 
> > Was this missed or is there some reason for why this didn't get
> > queued to stable?
> 
> I think it was missed, sorry :(

Found it, it was burried in my "to-queue" stable mbox, thanks for
resending.

greg k-h
