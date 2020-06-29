Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02C20E380
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgF2VO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:14:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:16510 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgF2S4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:56:51 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05TDt0rP010969;
        Mon, 29 Jun 2020 06:55:01 -0700
Date:   Mon, 29 Jun 2020 19:25:00 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-nvme@lists.infradead.org, eduard@hasenleithner.at,
        sagi@grimberg.me, hch@lst.de, stable@vger.kernel.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: [PATCH for-stable nvmet 0/6] nvme: Fix for blk_update_request IO
 error.
Message-ID: <20200629135459.GA32129@chelsio.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
 <20200617141541.GA712019@dhcp-10-100-145-180.wdl.wdc.com>
 <20200622112143.GA25601@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200622112143.GA25601@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, June 06/22/20, 2020 at 16:51:43 +0530, Dakshaja Uppalapati wrote:
> On Wednesday, June 06/17/20, 2020 at 07:15:41 -0700, Keith Busch wrote:
> > On Thu, Jun 11, 2020 at 09:23:33PM +0530, Dakshaja Uppalapati wrote:
> > > The below error is seen in dmesg, while formatting the disks discovered on host.
> > > 
> > > dmesg:
> > >         [  636.733374] blk_update_request: I/O error, dev nvme4n1, sector 0 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
> > > 
> > > Patch 6 fixes it and there are 5 other dependent patches that also need to be 
> > > pulled from upstream to stable, 5.4 and 4.19 branches.
> > > 
> > > Patch 1 dependent patch
> > > 
> > > Patch 2 dependent patch
> > > 
> > > Patch 3 dependent patch
> > > 
> > > Patch 4 dependent patch
> > > 
> > > Patch 5 dependent patch
> > > 
> > > Patch 6 fix patch
> > 
> > 1. You need to copy the linux-nvme mainling list for linux nvme kernel patches.
> > 
> > 2. If you're sending someone else's patch, the patch is supposed to have
> > the From: tag so the author is appropriately identified.
> > 
> > 3. Stable patches must referece the upstream commit ID.
> > 
> > As for this particular issue, while stable patches are required to
> > reference an upstream commit, you don't need to bring in dependent
> > patches. You are allowed to write an equivalent fix specific to the
> > stable branch so that stable doesn't need to take a bunch of unrelated
> > changes. For example, it looks like this particular isssue can be fixed
> > with the following simple stable patch:
> >
> 
> Hi keith,
> 
> Thanks for the review.
> 
> I initially tried pushing only the fix + required portion of the dependent 
> patches(https://www.spinics.net/lists/stable/msg387744.html) but as that 
> approach is discouraged in stable tree, I submitted all the patches as it is.
> 
> Here are the ways to fix the issue in stable tree:
> 
> •  push fix + all dependent patches
> •  push fix + custom patch of dependent patches
> •  revert the culprit patch.
> 
> Please let me know how this issue can be resolved in stable tree.
>

Hi keith,

Gentle reminder.

Thanks,
Dakshaja
