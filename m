Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6E01F6BD4
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFKQIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 12:08:39 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:30296 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgFKQIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 12:08:38 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05BG8BR2005573;
        Thu, 11 Jun 2020 09:08:16 -0700
Date:   Thu, 11 Jun 2020 21:38:10 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, eduard@hasenleithner.at,
        sagi@grimberg.me, hch@lst.de,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200611160805.GA9897@chelsio.com>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
 <20200605134340.GA3109673@kroah.com>
 <20200608063539.GA15373@chelsio.com>
 <20200608150533.GA477@redsun51.ssa.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608150533.GA477@redsun51.ssa.fujisawa.hgst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, June 06/09/20, 2020 at 00:05:33 +0900, Keith Busch wrote:
> On Mon, Jun 08, 2020 at 12:05:44PM +0530, Dakshaja Uppalapati wrote:
> > On Friday, June 06/05/20, 2020 at 15:43:40 +0200, Greg KH wrote:
> > > On Wed, Jun 03, 2020 at 02:48:51PM +0530, Dakshaja Uppalapati wrote:
> > > > This reverts upstream 'commit 530436c45ef2
> > > > ("nvme: Discard workaround for non-conformant devices")'
> > > > 
> > > > Since commit `530436c45ef2` introduced a regression due to which
> > > > blk_update_request IO error is observed on formatting device, reverting it.
> > > > 
> > > > Fixes: 530436c45ef2 ("nvme: Discard workaround for non-conformant devices")
> > > > Cc: stable <stable@vger.kernel.org> # 4.19+
> > > > Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
> > > > ---
> > > >  drivers/nvme/host/core.c | 12 +++---------
> > > >  1 file changed, 3 insertions(+), 9 deletions(-)
> > > 
> > > This was only for stable?
> > > 
> > 
> > Yes this is for stable 5.4 and 4.19 branches
> 
> No, this revert needs to be rejected. The stable patches need to be the
> upstream equivalent.

Hi keith,

I have sent the required patches which are need to pulled from upstream to
stable 5.4 and 4.19 branches.

Please let me know if you need any further info.

Thanks,
Dakshaja
