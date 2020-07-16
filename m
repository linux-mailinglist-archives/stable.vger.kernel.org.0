Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FDF2218D6
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGPA1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGPA1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:33 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8812072E;
        Thu, 16 Jul 2020 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859252;
        bh=i1LNN4WVmP1gJ2McGRO9CoJw6cChicuN0gCVtMCRO08=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=sY3w2ns0vlmd+cgyZiDFHU9JK1xX4z3TSQKEYIDxeokjvS7l8m9X5nMistAFEDtUj
         1gchHOG6NpUq5Ghyf/pdPFxMCo378+lhvv2NLuTiN7QGTPNbwS7hsoaIyV5c9praN3
         I1M9GNG5HxLjqnE4rjhApfq9176lOyqIxN8BVXXU=
Date:   Thu, 16 Jul 2020 00:27:31 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] irqdomain/treewide: Keep firmware node unconditionally allocated
In-Reply-To: <873661qakd.fsf@nanos.tec.linutronix.de>
References: <873661qakd.fsf@nanos.tec.linutronix.de>
Message-Id: <20200716002732.3A8812072E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 711419e504eb ("irqdomain: Add the missing assignment of domain->fwnode for named fwnode").

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188.

v5.7.8: Failed to apply! Possible dependencies:
    Unable to calculate

v5.4.51: Failed to apply! Possible dependencies:
    051a07ec7a3de ("net: sgi: ioc3-eth: simplify setting the DMA mask")
    0ce5ebd24d25f ("mfd: ioc3: Add driver for SGI IOC3 chip")
    10cf8300ecada ("MIPS: SGI-IP27: fix readb/writeb addressing")
    4dd147471dae0 ("net: sgi: ioc3-eth: don't abuse dma_direct_* calls")

v4.19.132: Failed to apply! Possible dependencies:
    437f2b8c20858 ("MIPS: remove the HT_PCI config option")
    69a07a41d908f ("MIPS: SGI-IP27: rework HUB interrupts")
    a15687ca7b927 ("powerpc: PCI_MSI needs PCI")
    e6308b6d35ea7 ("MIPS: SGI-IP27: abstract chipset irq from bridge")
    eb01d42a77785 ("PCI: consolidate PCI config entry in drivers/pci")

v4.14.188: Failed to apply! Possible dependencies:
    3369ddb62a42e ("MIPS: make the default mips dma implementation optional")
    4a2e130cce1f6 ("m68k: allow ColdFire PCI bus on MMU and non-MMU configuration")
    4c301f9b6a94b ("ARM: Convert to GENERIC_IRQ_MULTI_HANDLER")
    69a07a41d908f ("MIPS: SGI-IP27: rework HUB interrupts")
    76053854f7d10 ("ARC: [plat-hsdk] Add PCIe support")
    b6e05477c10c1 ("dma/direct: Handle the memory encryption bit in common code")
    d1f2564a5639b ("MIPS: ath25: use generic dma noncoherent ops")
    e6308b6d35ea7 ("MIPS: SGI-IP27: abstract chipset irq from bridge")
    ea8c64ace8664 ("dma-mapping: move swiotlb arch helpers to a new header")
    eb01d42a77785 ("PCI: consolidate PCI config entry in drivers/pci")
    f6d302e33d68d ("MIPS: consolidate the swiotlb implementations")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
