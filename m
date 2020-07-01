Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAE2113A0
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgGATdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbgGATdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:18 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA03D208A7;
        Wed,  1 Jul 2020 19:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593631997;
        bh=3yFXOIlf/jaJ9LVqAKz8KOR8fQJjduxx7bKp5GcEi+M=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=2oAU5Ir4jBKIKpKMgw8qWqs+s4r3GWOAGleRz9cNaB7c62kttSM6hQEW709DGmX6g
         cb6Z7YnI+bVZJ/zs3Iciomyv9kNI1ZPkRDedEo72V2onSEYtaUFCvrUv1gZ0EhxMPw
         3ZldgAVF2MRpAMrLXrg5mwIlrdOPT+HuVVBCnbYk=
Date:   Wed, 01 Jul 2020 19:33:17 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Vishal Verma <vishal.l.verma@intel.com>
Cc:     Vishal Verma <vishal.l.verma@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Len Brown <lenb@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 01/12] libnvdimm: Validate command family indices
In-Reply-To: <159312902579.1850128.3536310031352445291.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159312902579.1850128.3536310031352445291.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20200701193317.AA03D208A7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism").

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228.

v5.7.6: Failed to apply! Possible dependencies:
    f517f7925b7b4 ("ndctl/papr_scm,uapi: Add support for PAPR nvdimm specific methods")

v5.4.49: Failed to apply! Possible dependencies:
    72c4ebbac476b ("powerpc/papr_scm: Mark papr_scm_ndctl() as static")
    f517f7925b7b4 ("ndctl/papr_scm,uapi: Add support for PAPR nvdimm specific methods")

v4.19.130: Failed to apply! Possible dependencies:
    01091c496f920 ("acpi/nfit: improve bounds checking for 'func'")
    0ead11181fe0c ("acpi, nfit: Collect shutdown status")
    6f07f86c49407 ("acpi, nfit: Introduce nfit_mem flags")
    72c4ebbac476b ("powerpc/papr_scm: Mark papr_scm_ndctl() as static")
    b3ed2ce024c36 ("acpi/nfit: Add support for Intel DSM 1.8 commands")
    b5beae5e224f1 ("powerpc/pseries: Add driver for PAPR SCM regions")
    d6548ae4d16dc ("acpi/nfit, libnvdimm: Store dimm id as a member to struct nvdimm")
    f517f7925b7b4 ("ndctl/papr_scm,uapi: Add support for PAPR nvdimm specific methods")

v4.14.186: Failed to apply! Possible dependencies:
    01091c496f920 ("acpi/nfit: improve bounds checking for 'func'")
    0e7f0741450b1 ("acpi, nfit: validate commands against the device type")
    1194c4133195d ("nfit: Add Hyper-V NVDIMM DSM command set to white list")
    11e1427016095 ("acpi, nfit: add support for NVDIMM_FAMILY_INTEL v1.6 DSMs")
    466d1493ea830 ("acpi, nfit: rework NVDIMM leaf method detection")
    4b27db7e26cdb ("acpi, nfit: add support for the _LSI, _LSR, and _LSW label methods")
    6f07f86c49407 ("acpi, nfit: Introduce nfit_mem flags")
    b37b3fd33d034 ("acpi nfit: Enable to show what feature is supported via ND_CMD_CALL for nfit_test")
    b9b1504d3c6d6 ("acpi, nfit: hide unknown commands from nmemX/commands")
    d6548ae4d16dc ("acpi/nfit, libnvdimm: Store dimm id as a member to struct nvdimm")

v4.9.228: Failed to apply! Possible dependencies:
    095ab4b39f91b ("acpi, nfit: allow override of built-in bitmasks for nvdimm DSMs")
    0f817ae696b04 ("usb: dwc3: pci: add a private driver structure")
    36daf3aa399c0 ("usb: dwc3: pci: avoid build warning")
    3f23df72dc351 ("mmc: sdhci-pci: Use ACPI to get max frequency for Intel NI byt sdio")
    41c8bdb3ab10c ("acpi, nfit: Switch to use new generic UUID API")
    42237e393f64d ("libnvdimm: allow a platform to force enable label support")
    42b06496407c0 ("mmc: sdhci-pci: Add PCI ID for Intel NI byt sdio")
    4b27db7e26cdb ("acpi, nfit: add support for the _LSI, _LSR, and _LSW label methods")
    6f07f86c49407 ("acpi, nfit: Introduce nfit_mem flags")
    8f078b38dd382 ("libnvdimm: convert NDD_ flags to use bitops, introduce NDD_LOCKED")
    94116f8126de9 ("ACPI: Switch to use generic guid_t in acpi_evaluate_dsm()")
    9cecca75b5a0d ("usb: dwc3: pci: call _DSM for suspend/resume")
    9d62ed9651182 ("libnvdimm: handle locked label storage areas")
    b7fe92999a98a ("ACPI / extlog: Switch to use new generic UUID API")
    b917078c1c107 ("net: hns: Add ACPI support to check SFP present")
    ba650cfcf9409 ("acpi, nfit: allow specifying a default DSM family")
    c959a6b00ff58 ("mmc: sdhci-pci: Don't re-tune with runtime pm for some Intel devices")
    d2061f9cc32db ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
    d6548ae4d16dc ("acpi/nfit, libnvdimm: Store dimm id as a member to struct nvdimm")
    fab9288428ec0 ("usb: USB Type-C connector class")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
