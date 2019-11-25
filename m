Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9931093A5
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfKYSlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbfKYSlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 13:41:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35532082F;
        Mon, 25 Nov 2019 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574707291;
        bh=rYgBonXowp7xgx3e0XRb3HpU+JrdrElORUDmbWPkaJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eKU58wiJgCFHbTF2IAbph5bbmRoHwr70bHu8IKjzyKHtQKuNbSBV2FyUXX6i94JrX
         845e5oHTFdVk3/NMJlrcZRckTst7xjAqejfJf+hzfB15ZYSeqtM04cruyhg99hSWxM
         oA8xuskE9XntacdapQXgcy0Ur/coYyLU1QeVCcEs=
Date:   Mon, 25 Nov 2019 19:41:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     james.erwin@intel.com, dennis.dalessandro@intel.com,
        jgg@mellanox.com, kaike.wan@intel.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] IB/hfi1: Ensure full Gen3 speed in a Gen4
 system" failed to apply to 4.4-stable tree
Message-ID: <20191125184128.GB2961575@kroah.com>
References: <157409063466132@kroah.com>
 <20191125175529.GJ5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125175529.GJ5861@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 12:55:29PM -0500, Sasha Levin wrote:
> On Mon, Nov 18, 2019 at 04:23:54PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From a9c3c4c597704b3a1a2b9bef990e7d8a881f6533 Mon Sep 17 00:00:00 2001
> > From: James Erwin <james.erwin@intel.com>
> > Date: Fri, 1 Nov 2019 15:20:59 -0400
> > Subject: [PATCH] IB/hfi1: Ensure full Gen3 speed in a Gen4 system
> > 
> > If an hfi1 card is inserted in a Gen4 systems, the driver will avoid the
> > gen3 speed bump and the card will operate at half speed.
> > 
> > This is because the driver avoids the gen3 speed bump when the parent bus
> > speed isn't identical to gen3, 8.0GT/s.  This is not compatible with gen4
> > and newer speeds.
> > 
> > Fix by relaxing the test to explicitly look for the lower capability
> > speeds which inherently allows for gen4 and all future speeds.
> > 
> > Fixes: 7724105686e7 ("IB/hfi1: add driver files")
> > Link: https://lore.kernel.org/r/20191101192059.106248.1699.stgit@awfm-01.aw.intel.com
> > Cc: <stable@vger.kernel.org>
> > Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > Reviewed-by: Kaike Wan <kaike.wan@intel.com>
> > Signed-off-by: James Erwin <james.erwin@intel.com>
> > Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> I've fixed it up and queued for 4.4 (missing bf400235f392
> ("staging/rdma/hfi1: Avoid using upstream component if it is not
> accessible") ).

Great, thanks for doing that.

greg k-h
