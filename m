Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A542E7EF2
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 10:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgLaJYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 04:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLaJYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 04:24:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC3972158C;
        Thu, 31 Dec 2020 09:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609406622;
        bh=Qi6/jIycT5wphOtRdAA5hAawmZvgWwfjjKoabxQMeqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecFOZ61uDAb+aA7kw9y4V22yCtirbXt4TZ/xFCgoWlbt+RAKWwUIIbteSUIbAnXdG
         njCezoBm7oeZUtmENKA+mCon8cPH7QMReS2MXR3N8CU0LxHSTOU/GJKho0mXazJlHw
         OZ8mXywa5QqLW/g3Edtc/knH7QCVUpBr+hw+IBvw=
Date:   Thu, 31 Dec 2020 10:25:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 134/717] spi: dw: fix build error by selecting
 MULTIPLEXER
Message-ID: <X+2Y8ynC4JgOZvSw@kroah.com>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125027.369952724@linuxfoundation.org>
 <20201231084956.ckobqvr5mdpcdxkc@mobilestation>
 <X+2RCc1I3LhFOkCc@kroah.com>
 <20201231091034.bw733orqxwouijkf@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231091034.bw733orqxwouijkf@mobilestation>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 31, 2020 at 12:10:34PM +0300, Serge Semin wrote:
> On Thu, Dec 31, 2020 at 09:51:21AM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Dec 31, 2020 at 11:49:56AM +0300, Serge Semin wrote:
> > > Hello Greg,
> > > The next patch has been created to supersede the one you've applied:
> > > https://lore.kernel.org/linux-spi/20201127144612.4204-1-Sergey.Semin@baikalelectronics.ru/
> > > Mark has already merged it in his repo.
> > 
> 
> > Ok, so should that one be queued up as well?  Let us know the git commit
> > id of it when it reaches Linus's kernel and we will be glad to take it.
> 
> I believe it is already there:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7218838109fef61cdec988ff728e902d434c9cc5
> Yeah, it's better to queue that patch up too, otherwise the build
> error will be indeed fixed by the commit you've merged in, but the
> probe procedure will still always fail.

Ok, now queued up, thanks for letting us know.

greg k-h
