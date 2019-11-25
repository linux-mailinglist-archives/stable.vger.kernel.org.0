Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA6109328
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfKYRzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfKYRzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 12:55:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E3E2086A;
        Mon, 25 Nov 2019 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574704530;
        bh=Is5mMbPOs1fFXaMcvpxmoeoT8XAiByShRm8dJHSzfl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HHYR+ZOBnutbl/F8S0fK7PNsqJaIpBMicXNhrf8E/TT051NR+pkRbaNlx+kT+affS
         pj7FGhy9drUUx8B8YRytXOVNrzy93vz2JT9iQnd5sYV8vRz2pgi3LXh6/u5ePPyTVN
         31ozNZW2teXzseFLZh2Lb0p02e5smWBcBJ011jMM=
Date:   Mon, 25 Nov 2019 12:55:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     james.erwin@intel.com, dennis.dalessandro@intel.com,
        jgg@mellanox.com, kaike.wan@intel.com, mike.marciniszyn@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] IB/hfi1: Ensure full Gen3 speed in a Gen4
 system" failed to apply to 4.4-stable tree
Message-ID: <20191125175529.GJ5861@sasha-vm>
References: <157409063466132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157409063466132@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 04:23:54PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From a9c3c4c597704b3a1a2b9bef990e7d8a881f6533 Mon Sep 17 00:00:00 2001
>From: James Erwin <james.erwin@intel.com>
>Date: Fri, 1 Nov 2019 15:20:59 -0400
>Subject: [PATCH] IB/hfi1: Ensure full Gen3 speed in a Gen4 system
>
>If an hfi1 card is inserted in a Gen4 systems, the driver will avoid the
>gen3 speed bump and the card will operate at half speed.
>
>This is because the driver avoids the gen3 speed bump when the parent bus
>speed isn't identical to gen3, 8.0GT/s.  This is not compatible with gen4
>and newer speeds.
>
>Fix by relaxing the test to explicitly look for the lower capability
>speeds which inherently allows for gen4 and all future speeds.
>
>Fixes: 7724105686e7 ("IB/hfi1: add driver files")
>Link: https://lore.kernel.org/r/20191101192059.106248.1699.stgit@awfm-01.aw.intel.com
>Cc: <stable@vger.kernel.org>
>Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>Reviewed-by: Kaike Wan <kaike.wan@intel.com>
>Signed-off-by: James Erwin <james.erwin@intel.com>
>Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

I've fixed it up and queued for 4.4 (missing bf400235f392
("staging/rdma/hfi1: Avoid using upstream component if it is not
accessible") ).

-- 
Thanks,
Sasha
