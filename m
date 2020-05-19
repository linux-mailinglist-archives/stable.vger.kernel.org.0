Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0201D9598
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgESLtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgESLtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:09 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD48207D3;
        Tue, 19 May 2020 11:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888949;
        bh=XeXNgwdGIbBosuDIwionstOfknYS4qT5dxq3wmJeGxs=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=IjlfodWC9Xf4wdFhQpvhA26IJmiAT3ER64luxytCGX7ykO2PxZm2ZGvx0qweUeWir
         +JgKyJIwKrbjhFAt72RNqflyrVP2LXyOxEMU0qp9KGyVvkENONpKKBKBjM7BKAZKYt
         fWPEOc/rsH+27zin7orjyAGyPEHvUVHD+KcduEbc=
Date:   Tue, 19 May 2020 11:49:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4 07/10] PCI: qcom: Define some PARF params needed for ipq8064 SoC
In-Reply-To: <20200514200712.12232-8-ansuelsmth@gmail.com>
References: <20200514200712.12232-8-ansuelsmth@gmail.com>
Message-Id: <20200519114909.2DD48207D3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver").

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Build OK!
v4.14.180: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.223: Failed to apply! Possible dependencies:
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
