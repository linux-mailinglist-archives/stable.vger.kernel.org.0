Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE63211394
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgGATdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgGATdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:25 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01CEC2085B;
        Wed,  1 Jul 2020 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593632004;
        bh=EiWpEdXorboEZ/c2VyqXgUAQPbieeRfB4g9GB9AIYaY=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=lEh6aACriy+BTHeGW2yPIa3ISymRcwPo9a7iSYImL59EIk59xGKi3dsOdG+uNbQgI
         iJjKG6gKnOJzNHvt2DY/o/t3dz97ToOlO9BmU7yo0ffDi10DNxszkonx7S4F/5iGpP
         hL1FABsoUQ7yEps0yDgcmU0E9o40qnR/AfKVgZGU=
Date:   Wed, 01 Jul 2020 19:33:23 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     Kaike Wan <kaike.wan@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for-rc v2 1/2] IB/hfi1: Do not destroy hfi1_wq when the device is shut down
In-Reply-To: <20200623204047.107638.77646.stgit@awfm-01.aw.intel.com>
References: <20200623204047.107638.77646.stgit@awfm-01.aw.intel.com>
Message-Id: <20200701193324.01CEC2085B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 8d3e71136a08 ("IB/{hfi1, qib}: Add handling of kernel restart").

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Failed to apply! Possible dependencies:
    09e71899b9cf5 ("IB/hfi1: Prepare for new HFI1 MSIx API")
    24c5bfeaf1e66 ("IB/hfi1: Add the TID second leg ACK packet builder")
    3ca633f1ff7b1 ("IB/hfi1: Right size user_sdma sequence numbers and related variables")
    572f0c3301138 ("IB/hfi1: Add the dual leg code")
    57f97e96625fe ("IB/hfi1: Get the hfi1_devdata structure as early as possible")
    5da0fc9dbf891 ("IB/hfi1: Prepare resource waits for dual leg")
    6eb4eb10fb0d1 ("IB/hfi1: Make the MSIx resource allocation a bit more flexible")
    829eaee5d09a7 ("IB/hfi1: Add TID RDMA retry timer")
    a2f7bbdc2dba0 ("IB/hfi1: Rework the IRQ API to be more flexible")
    c54a73d8202a3 ("IB/hfi1: Rework file list in Makefile")
    f01b4d5a43da4 ("IB/hfi1: OPFN interface")

v4.14.186: Failed to apply! Possible dependencies:
    05cb18fda926d ("IB/hfi1: Update HFI to use the latest PCI API")
    09e71899b9cf5 ("IB/hfi1: Prepare for new HFI1 MSIx API")
    1b311f8931cfe ("IB/hfi1: Add tx_opcode_stats like the opcode_stats")
    2d9544aacf9e6 ("IB/hfi1: Insure int mask for in-kernel receive contexts is clear")
    442e55661db1d ("IB/hfi1: Extend input hdr tracing for packet type")
    473291b3ea0e1 ("IB/hfi1: Fix for early release of sdma context")
    5d18ee67d4c17 ("IB/{hfi1, rdmavt, qib}: Implement CQ completion vector support")
    6eb4eb10fb0d1 ("IB/hfi1: Make the MSIx resource allocation a bit more flexible")
    70324739ac5e0 ("IB/hfi1: Remove INTx support and simplify MSIx usage")
    a2f7bbdc2dba0 ("IB/hfi1: Rework the IRQ API to be more flexible")
    a74d5307caba4 ("IB/hfi1: Rework fault injection machinery")
    b5de809ef6f6c ("IB/hfi1: Show fault stats in both TX and RX directions")
    c54a73d8202a3 ("IB/hfi1: Rework file list in Makefile")
    cc9a97ea2c74e ("IB/hfi1: Do not allocate PIO send contexts for VNIC")
    d108c60d3d55e ("IB/hfi1: Set in_use_ctxts bits for user ctxts only")
    e9777ad4399c2 ("IB/{hfi1, rdmavt}: Fix memory leak in hfi1_alloc_devdata() upon failure")

v4.9.228: Failed to apply! Possible dependencies:
    0181ce31b2602 ("IB/hfi1: Add receive fault injection feature")
    1bb0d7b781b1c ("IB/hfi1: Code reuse with memdup_copy")
    2280740f01aee ("IB/hfi1: Virtual Network Interface Controller (VNIC) HW support")
    6e768f0682e26 ("IB/hfi1: Optimize devdata cachelines")
    a2f7bbdc2dba0 ("IB/hfi1: Rework the IRQ API to be more flexible")
    b7481944b06e9 ("IB/hfi1: Show statistics counters under IB stats interface")
    cc9a97ea2c74e ("IB/hfi1: Do not allocate PIO send contexts for VNIC")
    d108c60d3d55e ("IB/hfi1: Set in_use_ctxts bits for user ctxts only")
    d295dbeb2a0c9 ("IB/hf1: User context locking is inconsistent")
    d4829ea6035b8 ("IB/hfi1: OPA_VNIC RDMA netdev support")
    ec8a142327f85 ("IB/hfi1: Force logical link down")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
