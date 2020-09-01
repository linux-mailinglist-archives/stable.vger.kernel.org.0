Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6714A25907F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgIAOcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 10:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgIAObm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 10:31:42 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3ADD206FA;
        Tue,  1 Sep 2020 14:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598970701;
        bh=fhLTAIKoCOTjpKp6UcYsaLLmc4N9luo4RarGEIKjBEs=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=WtDCCAk2I8xTK2kwDktUtxzbZCStrmdSfRwmE474FISt+pHuy+SP7mT0pwCDN8R2p
         xe7Q6vBhaXhF81e8F4YpDosQjJ0oizEeBPy4ks1goIha0/SxCbX3TVBEffOFCEqtDL
         DMMzZ9xztk7GJMQJORCsiidaNt6dMnyHC1/j5XeE=
Date:   Tue, 01 Sep 2020 14:31:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0
In-Reply-To: <20200901124955.137-1-ansuelsmth@gmail.com>
References: <20200901124955.137-1-ansuelsmth@gmail.com>
Message-Id: <20200901143141.B3ADD206FA@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver").

The bot has tested the following trees: v5.8.5, v5.4.61, v4.19.142, v4.14.195, v4.9.234.

v5.8.5: Failed to apply! Possible dependencies:
    8b6f0330b5f9 ("PCI: qcom: Add missing ipq806x clocks in PCIe driver")
    dd58318c019f ("PCI: qcom: Change duplicate PCI reset to phy reset")
    ee367e2cdd22 ("PCI: qcom: Add missing reset for ipq806x")

v5.4.61: Failed to apply! Possible dependencies:
    8b6f0330b5f9 ("PCI: qcom: Add missing ipq806x clocks in PCIe driver")
    dd58318c019f ("PCI: qcom: Change duplicate PCI reset to phy reset")
    ee367e2cdd22 ("PCI: qcom: Add missing reset for ipq806x")

v4.19.142: Failed to apply! Possible dependencies:
    8b6f0330b5f9 ("PCI: qcom: Add missing ipq806x clocks in PCIe driver")
    dd58318c019f ("PCI: qcom: Change duplicate PCI reset to phy reset")
    ee367e2cdd22 ("PCI: qcom: Add missing reset for ipq806x")

v4.14.195: Failed to apply! Possible dependencies:
    68e7c15ceb8d ("PCI: qcom: Use regulator bulk api for apq8064 supplies")
    8b6f0330b5f9 ("PCI: qcom: Add missing ipq806x clocks in PCIe driver")
    dd58318c019f ("PCI: qcom: Change duplicate PCI reset to phy reset")
    ee367e2cdd22 ("PCI: qcom: Add missing reset for ipq806x")

v4.9.234: Failed to apply! Possible dependencies:
    19ce01cc8cbc ("PCI: dwc: all: Rename cfg_read/cfg_write to read/write")
    1d77040bde2d ("PCI: layerscape: Add LS1046a support")
    1f6c4501c667 ("PCI: dra7xx: Group PHY API invocations")
    442ec4c04d12 ("PCI: dwc: all: Split struct pcie_port into host-only and core structures")
    5d76117f070d ("PCI: qcom: Add support for IPQ8074 PCIe controller")
    68e7c15ceb8d ("PCI: qcom: Use regulator bulk api for apq8064 supplies")
    90d52d57ccac ("PCI: qcom: Add support for IPQ4019 PCIe controller")
    9bcf0a6fdc50 ("PCI: dwc: all: Use platform_set_drvdata() to save private data")
    ab5fe4f4d31e ("PCI: dra7xx: Add support to force RC to work in GEN1 mode")
    b8f2a8565603 ("PCI: qcom: Limit TLP size to 2K to work around hardware issue")
    d0491fc39bdd ("PCI: qcom: Add support for MSM8996 PCIe controller")
    deff11f884f0 ("PCI: qcom: Use block IP version for operations")
    e594233803aa ("PCI: layerscape: Remove redundant error message from ls_pcie_probe()")
    ebe85a44aad4 ("PCI: dra7xx: Enable MSI and legacy interrupts simultaneously")
    ee367e2cdd22 ("PCI: qcom: Add missing reset for ipq806x")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
