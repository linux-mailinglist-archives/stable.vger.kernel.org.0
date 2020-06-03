Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C691ED431
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFCQXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 12:23:42 -0400
Received: from verein.lst.de ([213.95.11.211]:51390 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgFCQXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 12:23:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 11D4168B05; Wed,  3 Jun 2020 18:23:39 +0200 (CEST)
Date:   Wed, 3 Jun 2020 18:23:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     Christoph Hellwig <hch@lst.de>, eduard@hasenleithner.at,
        kbusch@kernel.org, sagi@grimberg.me, gregkh@linuxfoundation.org,
        nirranjan@chelsio.com, bharat@chelsio.com, stable@vger.kernel.org
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200603162338.GA27240@lst.de>
References: <20200603091851.16957-1-dakshaja@chelsio.com> <20200603130750.GA13511@lst.de> <20200603161717.GA11442@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603161717.GA11442@chelsio.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 09:47:18PM +0530, Dakshaja Uppalapati wrote:
> > Err, why?  Please send an actual bug report with details of your
> > setup.
> 
> Hi Christoph,
> 
> Here is the link describing the issue initially reported for upstream 
> kernel 5.5:
> 
> https://lore.kernel.org/linux-nvme/CH2PR12MB40053A64681EFA3E6F63FDFBDD2A0@CH2PR12MB4005.namprd12.prod.outlook.com/
> 
> Issue is later fixed with upstream commit b716e688.

We are talking about two different things here.  One is the Linux NVMe
host code that can be used with lots of different controllers.  Many of
them are PCIe controller, especially cheap ones.

The other is the Linux NVMe target code.  So if a fix for very common
PCIe controller trigger a bug in the target code there is no 1:1
relationship as even if you are talking to a Linux fabrics controller
it usually runs a different kernel version on a different system.

That being said you can always backport that fix as well, which probably
is a good idea as it fixes a real bug.

Nevermind that nothing in your revert patch indicated it wasn't for
mainline.
