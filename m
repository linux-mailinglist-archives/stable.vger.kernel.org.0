Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22F42E7EE1
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 10:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgLaJLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 04:11:22 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:35338 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgLaJLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 04:11:22 -0500
Date:   Thu, 31 Dec 2020 12:10:34 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 134/717] spi: dw: fix build error by selecting
 MULTIPLEXER
Message-ID: <20201231091034.bw733orqxwouijkf@mobilestation>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125027.369952724@linuxfoundation.org>
 <20201231084956.ckobqvr5mdpcdxkc@mobilestation>
 <X+2RCc1I3LhFOkCc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <X+2RCc1I3LhFOkCc@kroah.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 31, 2020 at 09:51:21AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 31, 2020 at 11:49:56AM +0300, Serge Semin wrote:
> > Hello Greg,
> > The next patch has been created to supersede the one you've applied:
> > https://lore.kernel.org/linux-spi/20201127144612.4204-1-Sergey.Semin@baikalelectronics.ru/
> > Mark has already merged it in his repo.
> 

> Ok, so should that one be queued up as well?  Let us know the git commit
> id of it when it reaches Linus's kernel and we will be glad to take it.

I believe it is already there:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7218838109fef61cdec988ff728e902d434c9cc5
Yeah, it's better to queue that patch up too, otherwise the build
error will be indeed fixed by the commit you've merged in, but the
probe procedure will still always fail.

-Sergey

> 
> thanks,
> 
> greg k-h
