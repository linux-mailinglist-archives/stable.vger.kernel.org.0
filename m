Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8C84A89B3
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352737AbiBCRQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:16:15 -0500
Received: from foss.arm.com ([217.140.110.172]:58662 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237845AbiBCRQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Feb 2022 12:16:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 329001480;
        Thu,  3 Feb 2022 09:16:13 -0800 (PST)
Received: from e123427-lin.arm.com (unknown [10.57.39.201])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D5D43F40C;
        Thu,  3 Feb 2022 09:16:10 -0800 (PST)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     bhelgaas@google.com, Fabio Estevam <festevam@gmail.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        stable@vger.kernel.org, hongxing.zhu@nxp.com,
        linux-pci@vger.kernel.org, l.stach@pengutronix.de, robh@kernel.org
Subject: Re: [PATCH v2] PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails
Date:   Thu,  3 Feb 2022 17:16:03 +0000
Message-Id: <164390855018.15548.5458614023103971675.b4-ty@arm.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220106103645.2790803-1-festevam@gmail.com>
References: <20220106103645.2790803-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jan 2022 07:36:45 -0300, Fabio Estevam wrote:
> The intention of commit 886a9c134755 ("PCI: dwc: Move link handling into
> common code") was to standardize the behavior of link down as explained
> in its commit log:
> 
> "The behavior for a link down was inconsistent as some drivers would fail
> probe in that case while others succeed. Let's standardize this to
> succeed as there are usecases where devices (and the link) appear later
> even without hotplug. For example, a reconfigured FPGA device."
> 
> [...]

Applied to pci/imx6, thanks!

[1/1] PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails
      https://git.kernel.org/lpieralisi/pci/c/f81f095e87

Thanks,
Lorenzo
