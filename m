Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD513447C0
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhCVOsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:48:46 -0400
Received: from foss.arm.com ([217.140.110.172]:33154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhCVOsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:48:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 717881042;
        Mon, 22 Mar 2021 07:48:44 -0700 (PDT)
Received: from e123427-lin.arm.com (unknown [10.57.55.31])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45E183F719;
        Mon, 22 Mar 2021 07:48:37 -0700 (PDT)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PCI: keystone: Let AM65 use the pci_ops defined in pcie-designware-host.c
Date:   Mon, 22 Mar 2021 14:48:31 +0000
Message-Id: <161642448420.20787.1576994239586353648.b4-ty@arm.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20210317131518.11040-1-kishon@ti.com>
References: <20210317131518.11040-1-kishon@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Mar 2021 18:45:18 +0530, Kishon Vijay Abraham I wrote:
> Both TI's AM65x (K3) and TI's K2 PCIe driver are implemented in
> pci-keystone. However Only K2 PCIe driver should use it's own pci_ops
> for configuration space accesses. But commit 10a797c6e54a
> ("PCI: dwc: keystone: Use pci_ops for config space accessors") used
> custom pci_ops for both AM65x and K2. This breaks configuration space
> access for AM65x platform. Fix it here.

Applied to pci/dwc, thanks!

[1/1] PCI: keystone: Let AM65 use the pci_ops defined in pcie-designware-host.c
      https://git.kernel.org/lpieralisi/pci/c/3d0b2a3a87

Thanks,
Lorenzo
