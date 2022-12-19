Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF3F6512EA
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiLSTZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbiLSTYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:24:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9628913E99
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:24:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ABD1B80EF6
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD9BC433EF;
        Mon, 19 Dec 2022 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477851;
        bh=vYKeTppjGl837v9HY6B7ZCuKfbLO4QPiHSBQ2EWEIeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7nBnhbp0RsIRxLU49FToLIvL6/DnSGb5CSO5R3RhsKz+YqLEmOYVqDViFL6zdWyj
         eZ7mFjy+qDkDSwElOQmxGQgwyrUC4cDyfGIxwMzAc0trns8YDfYV0mHwSxdEWEGYWx
         99t793PU3ve736eZ3MTTRWgmX64QLtqkS89X/M1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>
Subject: [PATCH 6.1 22/25] usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake
Date:   Mon, 19 Dec 2022 20:23:01 +0100
Message-Id: <20221219182944.333617395@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shruthi Sanil <shruthi.sanil@intel.com>

commit f05f80f217bf52443a2582bca19fd78188333f25 upstream.

The device ID 0xa70e is defined for the USB3 device controller in the CPU
sub-system of Raptor Lake platform. Hence updating the ID accordingly.

Fixes: bad0d1d726ac ("usb: dwc3: pci: Add support for Intel Raptor Lake")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20221125105327.27945-1-shruthi.sanil@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -45,7 +45,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLN		0x465e
 #define PCI_DEVICE_ID_INTEL_ADLN_PCH		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
-#define PCI_DEVICE_ID_INTEL_RPL			0x460e
+#define PCI_DEVICE_ID_INTEL_RPL			0xa70e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e


