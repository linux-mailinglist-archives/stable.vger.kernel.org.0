Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2C25D770
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgIDLeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbgIDLeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:34:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D785206B7;
        Fri,  4 Sep 2020 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599219249;
        bh=PzH+BwwKFQmrK/nyu7AzRC4Cxi+w6WcK6Tb1bGxR+EI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty/pDBQgApnNsl3C/Pn72U8Q8azQIZpf5sRxFJXFxgHYAwhShQtglOiKdMDyt4r/2
         Ni69U/MC6qm1xrzkjnMGeQ/cCywKnC6WhNZs8H2zD43jahCgOk3PpMNRwVWPY48yas
         pzjQfFIxxGXaMXkt9sV4hm0q4F2Y6kHrtSWrgyjE=
Date:   Fri, 4 Sep 2020 13:34:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        eduard@hasenleithner.at, kbusch@kernel.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200904113430.GD2831752@kroah.com>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
 <20200603130750.GA13511@lst.de>
 <20200603161717.GA11442@chelsio.com>
 <20200603162338.GA27240@lst.de>
 <6b58318c-fc41-66b9-b4d2-868d832392bb@grimberg.me>
 <20200604063638.GA15118@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604063638.GA15118@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 12:06:39PM +0530, Dakshaja Uppalapati wrote:
> On Wednesday, June 06/03/20, 2020 at 14:20:01 -0700, Sagi Grimberg wrote:
> > 
> > > > > Err, why?  Please send an actual bug report with details of your
> > > > > setup.
> > > > 
> > > > Hi Christoph,
> > > > 
> > > > Here is the link describing the issue initially reported for upstream
> > > > kernel 5.5:
> > > > 
> > > > https://lore.kernel.org/linux-nvme/CH2PR12MB40053A64681EFA3E6F63FDFBDD2A0@CH2PR12MB4005.namprd12.prod.outlook.com/
> > > > 
> > > > Issue is later fixed with upstream commit b716e688.
> > > 
> > > We are talking about two different things here.  One is the Linux NVMe
> > > host code that can be used with lots of different controllers.  Many of
> > > them are PCIe controller, especially cheap ones.
> > > 
> > > The other is the Linux NVMe target code.  So if a fix for very common
> > > PCIe controller trigger a bug in the target code there is no 1:1
> > > relationship as even if you are talking to a Linux fabrics controller
> > > it usually runs a different kernel version on a different system.
> > > 
> > > That being said you can always backport that fix as well, which probably
> > > is a good idea as it fixes a real bug.
> > > 
> > > Nevermind that nothing in your revert patch indicated it wasn't for
> > > mainline.
> > 
> > Agree..
> 
> Just to confirm that I got it right, Do you want me to send all 6 patches 
> (fix and dependent patches) to stable?

Yes, in a format that can be applied, thanks.

greg k-h
