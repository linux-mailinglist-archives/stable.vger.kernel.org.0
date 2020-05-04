Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15B21C46B0
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgEDTFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 15:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgEDTFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 15:05:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE090206B8;
        Mon,  4 May 2020 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588619120;
        bh=aCv1F6E9QThI8vva9EtdscBCQGKHO0zt1VxPt/iOnuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FM+39DPfhYzon6z5jHCkAmHn44SVhQMQMIZTUIzPmQV7C0U8JxiW2XBN9i/Wiqn7M
         WVPuiNL0DsifwbVEh8alUx2v9umGlJ1VyJE0BTk0KwADG4X/l0ESsmYUytivx9TKHp
         04XIccgKGT+ABFSBYqNCPimn6tDZbzCDNrZD+e5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sanjay K <sanjay.k.kumar@intel.com>
Subject: [PATCH 5.6 61/73] iommu/vt-d: Use right Kconfig option name
Date:   Mon,  4 May 2020 19:58:04 +0200
Message-Id: <20200504165509.860520707@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit ba61c3da00f4a5bf8805aeca1ba5ac3c9bd82e96 upstream.

The CONFIG_ prefix should be added in the code.

Fixes: 046182525db61 ("iommu/vt-d: Add Kconfig option to enable/disable scalable mode")
Reported-and-tested-by: Kumar, Sanjay K <sanjay.k.kumar@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Link: https://lore.kernel.org/r/20200501072427.14265-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -371,11 +371,11 @@ int dmar_disabled = 0;
 int dmar_disabled = 1;
 #endif /* CONFIG_INTEL_IOMMU_DEFAULT_ON */
 
-#ifdef INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON
+#ifdef CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON
 int intel_iommu_sm = 1;
 #else
 int intel_iommu_sm;
-#endif /* INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON */
+#endif /* CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON */
 
 int intel_iommu_enabled = 0;
 EXPORT_SYMBOL_GPL(intel_iommu_enabled);


