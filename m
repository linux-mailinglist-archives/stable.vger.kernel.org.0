Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC01ED415
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFCQSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 12:18:01 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:54075 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCQSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 12:18:01 -0400
Received: from localhost (moto.blr.asicdesigners.com [10.193.184.79] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 053GHIhT006322;
        Wed, 3 Jun 2020 09:17:19 -0700
Date:   Wed, 3 Jun 2020 21:47:18 +0530
From:   Dakshaja Uppalapati <dakshaja@chelsio.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     eduard@hasenleithner.at, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de, gregkh@linuxfoundation.org, nirranjan@chelsio.com,
        bharat@chelsio.com, stable@vger.kernel.org
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200603161717.GA11442@chelsio.com>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
 <20200603130750.GA13511@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603130750.GA13511@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday, June 06/03/20, 2020 at 15:07:50 +0200, Christoph Hellwig wrote:
> On Wed, Jun 03, 2020 at 02:48:51PM +0530, Dakshaja Uppalapati wrote:
> > This reverts upstream 'commit 530436c45ef2
> > ("nvme: Discard workaround for non-conformant devices")'
> > 
> > Since commit `530436c45ef2` introduced a regression due to which
> > blk_update_request IO error is observed on formatting device, reverting it.
> 
> Err, why?  Please send an actual bug report with details of your
> setup.

Hi Christoph,

Here is the link describing the issue initially reported for upstream 
kernel 5.5:

https://lore.kernel.org/linux-nvme/CH2PR12MB40053A64681EFA3E6F63FDFBDD2A0@CH2PR12MB4005.namprd12.prod.outlook.com/

Issue is later fixed with upstream commit b716e688.

Now the same issue is observed with stable kernels 4.19 and 5.4 as 
commit 530436c4 was pulled in to stable. Here is the link describing the same 
for stable kernels.

https://www.spinics.net/lists/stable/msg387744.html

Please let me know if you need any further info.

Thanks,
Dakshaja

