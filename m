Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59F6D0914
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbjC3PHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 11:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjC3PHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 11:07:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E28C647;
        Thu, 30 Mar 2023 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680188825; x=1711724825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WjP6GPfoFS3QmD/u0mitD4XX36nF1GpzMNe7tOCMUBs=;
  b=F0JBK5fQ1OJ3TNTHP3TJnoCcqwbFfqv8nbyaqtuGp9bgoic+bOlIV6US
   lHutJ5ykN71ZK3N7x9IfAbQzcU2v+hlTIlHX3xW2fbenvMXoaFtCLocvx
   0Q1nX4L61cCO2FRq8ghXXoWvMaJ3TZcBDDqdbikDq/FlXfk6Kd4G7+Z8J
   eE93rwztji5lVTFL+0Ewd2vD0KBnPSsXOumXCcThC11KJZ0U0pZqnURbM
   hAyDrhr+UxHvu/SwQ29/sisXn62skKYTpzwrh5vs06irdSrZsa5yJEyPb
   HWnrVxXOBDbwPf33op4GKa52JamHjZn7XKwIBXcJ2OiyZragq5vTOdCNV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="320844925"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="320844925"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 08:05:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="828370365"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="828370365"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 30 Mar 2023 08:05:57 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] usb: dwc3: pci: add support for the Intel Meteor Lake-S
Date:   Thu, 30 Mar 2023 18:02:24 +0300
Message-Id: <20230330150224.89316-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch adds the necessary PCI ID for Intel Meteor Lake-S
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index a23ddbb819795..560793545362a 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -49,6 +49,7 @@
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLM		0x7eb1
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
+#define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
@@ -474,6 +475,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLS),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
-- 
2.39.2

