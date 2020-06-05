Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316DE1EFA07
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgFEOKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFEOKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:47 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CEEE206A2;
        Fri,  5 Jun 2020 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366246;
        bh=gcNMH6K4jbl+nG1GAEf+q+ZawQsFXCO+U5lS5rJQpao=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=LcIfD6UgvB62mEa7qYsBKCLGwLDorAUdWEleG+5sQYUWYdYsmc1LodzmqBfcmMLD9
         thzfA5OG6O5nfVX5SV10eoawsrMn/pVzmAHwFV9kXNRqDoWUy3iKhJ9KFf87VASd6t
         5/8ZasRFqYigTRhXQjNrNx+r7N3KYX+jEn562UIA=
Date:   Fri, 05 Jun 2020 14:10:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5 07/11] PCI: qcom: Define some PARF params needed for ipq8064 SoC
In-Reply-To: <20200602115353.20143-8-ansuelsmth@gmail.com>
References: <20200602115353.20143-8-ansuelsmth@gmail.com>
Message-Id: <20200605141046.8CEEE206A2@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225.

v5.6.15: Build OK!
v5.4.43: Build OK!
v4.19.125: Build OK!
v4.14.182: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.225: Failed to apply! Possible dependencies:
    19ce01cc8cbc ("PCI: dwc: all: Rename cfg_read/cfg_write to read/write")
    1d77040bde2d ("PCI: layerscape: Add LS1046a support")
    1f6c4501c667 ("PCI: dra7xx: Group PHY API invocations")
    40f67fb2c384 ("PCI: dwc: designware: Get device pointer at the start of dw_pcie_host_init()")
    442ec4c04d12 ("PCI: dwc: all: Split struct pcie_port into host-only and core structures")
    9bcf0a6fdc50 ("PCI: dwc: all: Use platform_set_drvdata() to save private data")
    ab5fe4f4d31e ("PCI: dra7xx: Add support to force RC to work in GEN1 mode")
    ad719956a848 ("PCI: hisi: Remove redundant error message from hisi_pcie_probe()")
    e594233803aa ("PCI: layerscape: Remove redundant error message from ls_pcie_probe()")
    ebe85a44aad4 ("PCI: dra7xx: Enable MSI and legacy interrupts simultaneously")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
