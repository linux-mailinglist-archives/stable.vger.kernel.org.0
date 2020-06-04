Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627F91EDD3E
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 08:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgFDGhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 02:37:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:25718 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgFDGhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 02:37:07 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0546aexD007993;
        Wed, 3 Jun 2020 23:36:41 -0700
Date:   Thu, 4 Jun 2020 12:06:39 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     eduard@hasenleithner.at, kbusch@kernel.org,
        gregkh@linuxfoundation.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200604063638.GA15118@chelsio.com>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
 <20200603130750.GA13511@lst.de>
 <20200603161717.GA11442@chelsio.com>
 <20200603162338.GA27240@lst.de>
 <6b58318c-fc41-66b9-b4d2-868d832392bb@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b58318c-fc41-66b9-b4d2-868d832392bb@grimberg.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday, June 06/03/20, 2020 at 14:20:01 -0700, Sagi Grimberg wrote:
> 
> > > > Err, why?  Please send an actual bug report with details of your
> > > > setup.
> > > 
> > > Hi Christoph,
> > > 
> > > Here is the link describing the issue initially reported for upstream
> > > kernel 5.5:
> > > 
> > > https://lore.kernel.org/linux-nvme/CH2PR12MB40053A64681EFA3E6F63FDFBDD2A0@CH2PR12MB4005.namprd12.prod.outlook.com/
> > > 
> > > Issue is later fixed with upstream commit b716e688.
> > 
> > We are talking about two different things here.  One is the Linux NVMe
> > host code that can be used with lots of different controllers.  Many of
> > them are PCIe controller, especially cheap ones.
> > 
> > The other is the Linux NVMe target code.  So if a fix for very common
> > PCIe controller trigger a bug in the target code there is no 1:1
> > relationship as even if you are talking to a Linux fabrics controller
> > it usually runs a different kernel version on a different system.
> > 
> > That being said you can always backport that fix as well, which probably
> > is a good idea as it fixes a real bug.
> > 
> > Nevermind that nothing in your revert patch indicated it wasn't for
> > mainline.
> 
> Agree..

Just to confirm that I got it right, Do you want me to send all 6 patches 
(fix and dependent patches) to stable?
