Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EDD2649E9
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIJQeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 12:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgIJQeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 12:34:18 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0861B21D90;
        Thu, 10 Sep 2020 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599755658;
        bh=SAS8w/Bw5MCuedq33AIHf5gIBQrN21/wnW8b/fWJrcg=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=rXuGu3OTUJUZaqa5DPhRZM0oi45e2Q1cAq8sAioammNmxPE4cbO8EV7d3GE6Bq+qJ
         eFQabl8NlOqVhlU1AAThtGJZrO3raCrBEGImE4u0vVU7AzTEN1Y447D554RYAaOeYH
         DMpSCqr5N5RtXJImrFN0ScfRhA9RhA3OCfLezN+A=
Date:   Thu, 10 Sep 2020 16:34:17 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
To:     dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     eperezma@redhat.com, peterx@redhat.com, mst@redhat.com
Cc:     stable@vger.kernel.org
Cc:     Ashok Raj <ashok.raj@intel.com>
Cc:     Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     Keith Busch <keith.busch@intel.com>
Cc:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: don't disable ATS for device without page aligned request
In-Reply-To: <20200909083432.9464-1-jasowang@redhat.com>
References: <20200909083432.9464-1-jasowang@redhat.com>
Message-Id: <20200910163418.0861B21D90@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Failed to apply! Possible dependencies:
    da656a042568 ("iommu/vt-d: Use pci_ats_supported()")

v4.19.143: Failed to apply! Possible dependencies:
    1b84778a62ad ("iommu/vt-d: Fix PRI/PASID dependency issue.")
    61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses page aligned address.")
    d8b859105457 ("iommu/vt-d: Disable ATS support on untrusted devices")
    da656a042568 ("iommu/vt-d: Use pci_ats_supported()")
    fb58fdcd295b ("iommu/vt-d: Do not enable ATS for untrusted devices")

v4.14.196: Failed to apply! Possible dependencies:
    1b84778a62ad ("iommu/vt-d: Fix PRI/PASID dependency issue.")
    61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses page aligned address.")
    cef74409ea79 ("PCI: Add "pci=noats" boot parameter")
    d8b859105457 ("iommu/vt-d: Disable ATS support on untrusted devices")
    da656a042568 ("iommu/vt-d: Use pci_ats_supported()")
    fb58fdcd295b ("iommu/vt-d: Do not enable ATS for untrusted devices")

v4.9.235: Failed to apply! Possible dependencies:
    1b84778a62ad ("iommu/vt-d: Fix PRI/PASID dependency issue.")
    61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses page aligned address.")
    cef74409ea79 ("PCI: Add "pci=noats" boot parameter")
    d8b859105457 ("iommu/vt-d: Disable ATS support on untrusted devices")
    da656a042568 ("iommu/vt-d: Use pci_ats_supported()")
    fb58fdcd295b ("iommu/vt-d: Do not enable ATS for untrusted devices")

v4.4.235: Failed to apply! Possible dependencies:
    0824c5920b16 ("iommu/vt-d: avoid dev iotlb logic for domains with no dev iotlbs")
    0cbd4b34cda9 ("xhci: mediatek: support MTK xHCI host controller")
    1b84778a62ad ("iommu/vt-d: Fix PRI/PASID dependency issue.")
    61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses page aligned address.")
    7e70cbffe236 ("usb: xhci: add a quirk bit for ssic port unused")
    9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend")
    cef74409ea79 ("PCI: Add "pci=noats" boot parameter")
    d8b859105457 ("iommu/vt-d: Disable ATS support on untrusted devices")
    da656a042568 ("iommu/vt-d: Use pci_ats_supported()")
    fb58fdcd295b ("iommu/vt-d: Do not enable ATS for untrusted devices")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
