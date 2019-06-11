Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC73C1F2
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 06:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfFKEFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 00:05:14 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:32892 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfFKEFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 00:05:13 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 8538022A5E;
        Tue, 11 Jun 2019 00:05:08 -0400 (EDT)
Date:   Tue, 11 Jun 2019 14:05:13 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Sasha Levin <sashal@kernel.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/7] scsi: mac_scsi: Fix pseudo DMA implementation,
 take 2
In-Reply-To: <20190610151838.C12F020859@mail.kernel.org>
Message-ID: <alpine.LNX.2.21.1906111401340.203@nippy.intranet>
References: <62e2c6d87f091669718584461fcb76546ecf58d5.1560043151.git.fthain@telegraphics.com.au> <20190610151838.C12F020859@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jun 2019, Sasha Levin wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 3a0f64bfa907 mac_scsi: Fix pseudo DMA implementation.
> 
> The bot has tested the following trees: v5.1.7, v4.19.48, v4.14.123, v4.9.180.
> 
> v5.1.7: Build OK!
> v4.19.48: Build OK!
> v4.14.123: Build OK!
> v4.9.180: Failed to apply! Possible dependencies:
>     25894d1f98ae ("scsi: ncr5380: Improve hostdata struct member alignment and cache-ability")
>     4a98f896bf2c ("scsi: ncr5380: Use correct types for DMA routines")
>     61e1ce588b10 ("scsi: ncr5380: Use correct types for device register accessors")
>     820682b1b34e ("scsi: ncr5380: Store IO ports and addresses in host private data")
>     abd12b09292c ("scsi: atari_scsi: Make device register accessors re-entrant")
>     b61bacbc2bf5 ("scsi: g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio drivers")
>     d4408dd7ecff ("scsi: ncr5380: Simplify register polling limit")
>     d5d37a0ab13b ("scsi: ncr5380: Pass hostdata pointer to register polling routines")
> 
> 
> How should we proceed with this patch?
> 


Please don't backport to v4.9.y.

I added a Cc header in the hope of avoiding this question (Cc: 
stable@vger.kernel.org # v4.14+) but it appears that this bot doesn't work 
that way.

For this particular platform, v4.9.y would need quite a few patches to 
bring it up to the same level of stability and functionality as v4.14.y or 
v4.19.y. I don't really want to pursue that so I drew the line at v4.14.y.

Thanks.

-- 

> --
> Thanks,
> Sasha
> 
