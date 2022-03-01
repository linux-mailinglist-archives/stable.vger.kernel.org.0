Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01A44C962A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbiCAUTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238019AbiCAURx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:17:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43189CF0;
        Tue,  1 Mar 2022 12:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E4EB81CB4;
        Tue,  1 Mar 2022 20:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823E7C340F2;
        Tue,  1 Mar 2022 20:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165807;
        bh=92awyDG6T52IsdsbSeDSnL7mpT5M1S2TkLHv3GFwsBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5yiinFSioV0poc1zX9OSgbFCWbus+Wp7djFS+QBY53PzqTWy91DhcnhFaWBwswLA
         raYlJeY5XV5ciFG5YD0jn96sxSkSWbD8Lzl4Ri8zFTd7VSa364Aux1N2+ukYouhqiJ
         4Vae+CEkCR9j5MkDpBT8f/BREueA00Hy3TEG0s16yH9ye6G78vmW8QAc0qg6Xmqv/V
         qBp3CcBf6/piAXQntoo8nkFG3NgxRxxafvwDPe/HJ5P2OA1nIuYgIlRuDTk4plsZm3
         YrsvzrnWsYOlNMhH+D5Pvq8aFWLEL0UsB5cKR0KzeEFGxy/DZZPj1RYXHcHUr0KOfv
         qZ2umRkkGBC2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/23] usb: dwc3: pci: add support for the Intel Raptor Lake-S
Date:   Tue,  1 Mar 2022 15:16:02 -0500
Message-Id: <20220301201629.18547-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 038438a25c45d5ac996e95a22fa9e76ff3d1f8c7 ]

This patch adds the necessary PCI ID for Intel Raptor Lake-S
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220214141948.18637-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 7ff8fc8f79a9b..4e69a9d829f23 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -43,6 +43,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLP		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
+#define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
@@ -409,6 +410,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
-- 
2.34.1

