Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E50722FB3F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgG0VYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0VYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:37 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03103207BB;
        Mon, 27 Jul 2020 21:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885076;
        bh=MLbhfNhfEWUuWMxtsosQROgke8OOlnnRmKKhop1HBKY=;
        h=Date:From:To:To:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=lOC8em/eCe10ZWbtq336EyzrF6MJarubmtalkuk7A+eJVealxhety4YlWrNkMSRbV
         T5yV6wzz0HcRXeKz/6FOlBj2qy2sUDkEVs+23uRDZhFmNDf2ih2pPwj+FH5ykICsad
         Yko9Iea0KyNLNC58GVk/GamNr6usT5YQcpjDthE0=
Date:   Mon, 27 Jul 2020 21:24:35 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ashok Raj <ashok.raj@intel.com>
To:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
To:     Joerg Roedel <joro@8bytes.com>
To:     Lu Baolu <baolu.lu@intel.com>
Cc:     Ashok Raj <ashok.raj@intel.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Cc:     Ashok Raj <ashok.raj@intel.com>
Cc:     iommu@lists.linux-foundation.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] PCI/ATS: Check PRI supported on the PF device when SRIOV is enabled
In-Reply-To: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
References: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
Message-Id: <20200727212436.03103207BB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: b16d0cb9e2fc ("iommu/vt-d: Always enable PASID/PRI PCI capabilities before ATS").

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Build OK!
v5.4.53: Failed to apply! Possible dependencies:
    2b0ae7cc3bfc ("PCI/ATS: Handle sharing of PF PASID Capability with all VFs")
    751035b8dc06 ("PCI/ATS: Cache PASID Capability offset")
    8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
    9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
    c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
    e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")

v4.19.134: Failed to apply! Possible dependencies:
    2b0ae7cc3bfc ("PCI/ATS: Handle sharing of PF PASID Capability with all VFs")
    4f802170a861 ("PCI/DPC: Save and restore config state")
    6e1ffbb7c2ab ("PCI: Move ATS declarations outside of CONFIG_PCI")
    751035b8dc06 ("PCI/ATS: Cache PASID Capability offset")
    8c938ddc6df3 ("PCI/ATS: Add pci_ats_page_aligned() interface")
    8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
    9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
    9c2120090586 ("PCI: Provide pci_match_id() with CONFIG_PCI=n")
    b92b512a435d ("PCI: Make pci_ats_init() private")
    c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
    e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
    e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
    fff42928ade5 ("PCI/ATS: Add inline to pci_prg_resp_pasid_required()")

v4.14.189: Failed to apply! Possible dependencies:
    1b79c5284439 ("PCI: cadence: Add host driver for Cadence PCIe controller")
    1e4511604dfa ("PCI/AER: Expose internal API for obtaining AER information")
    3133e6dd07ed ("PCI: Tidy Makefiles")
    37dddf14f1ae ("PCI: cadence: Add EndPoint Controller driver for Cadence PCIe controller")
    4696b828ca37 ("PCI/AER: Hoist aerdrv.c, aer_inject.c up to drivers/pci/pcie/")
    4f802170a861 ("PCI/DPC: Save and restore config state")
    8c938ddc6df3 ("PCI/ATS: Add pci_ats_page_aligned() interface")
    8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
    9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
    9de0eec29c07 ("PCI: Regroup all PCI related entries into drivers/pci/Makefile")
    b92b512a435d ("PCI: Make pci_ats_init() private")
    c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
    d3252ace0bc6 ("PCI: Restore resized BAR state on resume")
    e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
    e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
    fff42928ade5 ("PCI/ATS: Add inline to pci_prg_resp_pasid_required()")

v4.9.231: Failed to apply! Possible dependencies:
    4ebeb1ec56d4 ("PCI: Restore PRI and PASID state after Function-Level Reset")
    8c938ddc6df3 ("PCI/ATS: Add pci_ats_page_aligned() interface")
    8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
    9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
    a4f4fa681add ("PCI: Cache PRI and PASID bits in pci_dev")
    c065190bbcd4 ("PCI/ATS: Cache PRI Capability offset")
    e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
    e5adf79a1d80 ("PCI/ATS: Cache PRI PRG Response PASID Required bit")
    fff42928ade5 ("PCI/ATS: Add inline to pci_prg_resp_pasid_required()")

v4.4.231: Failed to apply! Possible dependencies:
    2a2aca316aed ("PCI: Include <asm/dma.h> for isa_dma_bridge_buggy")
    4d3f13845957 ("PCI: Add pci_unmap_iospace() to unmap I/O resources")
    4ebeb1ec56d4 ("PCI: Restore PRI and PASID state after Function-Level Reset")
    8cbb8a9374a2 ("PCI/ATS: Move pci_prg_resp_pasid_required() to CONFIG_PCI_PRI")
    9bf49e36d718 ("PCI/ATS: Handle sharing of PF PRI Capability with all VFs")
    a4f4fa681add ("PCI: Cache PRI and PASID bits in pci_dev")
    c5076cfe7689 ("PCI, of: Move PCI I/O space management to PCI core code")
    e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
