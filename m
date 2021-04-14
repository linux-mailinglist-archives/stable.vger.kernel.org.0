Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73635F909
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349470AbhDNQf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 12:35:29 -0400
Received: from foss.arm.com ([217.140.110.172]:58900 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhDNQf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 12:35:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6E5B11B3;
        Wed, 14 Apr 2021 09:35:06 -0700 (PDT)
Received: from e123427-lin.arm.com (unknown [10.57.44.24])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5D453F73B;
        Wed, 14 Apr 2021 09:35:04 -0700 (PDT)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-msm@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Rob Herring <robh@kernel.org>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>, stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] PCI: dwc: Move iATU detection earlier
Date:   Wed, 14 Apr 2021 17:34:59 +0100
Message-Id: <161841808904.25586.4339920653315344161.b4-ty@arm.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
References: <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Apr 2021 17:22:19 +0300, Dmitry Baryshkov wrote:
> dw_pcie_ep_init() depends on the detected iATU region numbers to allocate
> the in/outbound window management bitmap.  It fails after 281f1f99cf3a
> ("PCI: dwc: Detect number of iATU windows").
> 
> Move the iATU region detection into a new function, move the detection to
> the very beginning of dw_pcie_host_init() and dw_pcie_ep_init().  Also
> remove it from the dw_pcie_setup(), since it's more like a software
> initialization step than hardware setup.
> 
> [...]

Applied to pci/dwc, thanks!

[1/1] PCI: dwc: Move iATU detection earlier
      https://git.kernel.org/lpieralisi/pci/c/22f750acc7

Thanks,
Lorenzo
