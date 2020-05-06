Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7F01C7E11
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgEFXmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgEFXmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:15 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8DC207DD;
        Wed,  6 May 2020 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808535;
        bh=7akyfljXHOsXTZNt/ZRqpS6+xpFKLbXbpvF+4i8FMic=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=zYs+Rm+eZ2yPy5K/0gn/YYP9H9yK63kbjFGxIVJxqAjUuV4aViLtvCBo8ruW4JCz1
         bIYayXQzYnW6vMA0ixk7PIzH6sNcIJEBOyNAoItgU/9qEHmHwxhu1VXSVfvHMRT4hK
         xYEydjJ1WvgopJnkM+N7JfWez+PMRHJAH6RZGkf0=
Date:   Wed, 06 May 2020 23:42:14 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 01/11] PCI: qcom: add missing ipq806x clocks in PCIe driver
In-Reply-To: <20200430220619.3169-2-ansuelsmth@gmail.com>
References: <20200430220619.3169-2-ansuelsmth@gmail.com>
Message-Id: <20200506234215.3A8DC207DD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver").

The bot has tested the following trees: v5.6.8, v5.4.36, v4.19.119, v4.14.177, v4.9.220.

v5.6.8: Build OK!
v5.4.36: Build OK!
v4.19.119: Build failed! Errors:
    drivers/pci/controller/dwc/pcie-qcom.c:240:17: error: implicit declaration of function ‘devm_clk_get_optional’; did you mean ‘devm_gpiod_get_optional’? [-Werror=implicit-function-declaration]

v4.14.177: Failed to apply! Possible dependencies:
    68e7c15ceb8d ("PCI: qcom: Use regulator bulk api for apq8064 supplies")

v4.9.220: Failed to apply! Possible dependencies:
    11a61a860281 ("PCI: dwc: Use PTR_ERR_OR_ZERO to simplify code")
    19ce01cc8cbc ("PCI: dwc: all: Rename cfg_read/cfg_write to read/write")
    1d77040bde2d ("PCI: layerscape: Add LS1046a support")
    1f6c4501c667 ("PCI: dra7xx: Group PHY API invocations")
    244e00071fd8 ("PCI: qcom: Explicitly request exclusive reset control")
    40f67fb2c384 ("PCI: dwc: designware: Get device pointer at the start of dw_pcie_host_init()")
    442ec4c04d12 ("PCI: dwc: all: Split struct pcie_port into host-only and core structures")
    5d0f1b84c526 ("PCI: qcom: Reorder to put v0 functions together, v1 functions together, etc")
    9bcf0a6fdc50 ("PCI: dwc: all: Use platform_set_drvdata() to save private data")
    ab5fe4f4d31e ("PCI: dra7xx: Add support to force RC to work in GEN1 mode")
    d0491fc39bdd ("PCI: qcom: Add support for MSM8996 PCIe controller")
    e594233803aa ("PCI: layerscape: Remove redundant error message from ls_pcie_probe()")
    ebe85a44aad4 ("PCI: dra7xx: Enable MSI and legacy interrupts simultaneously")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
