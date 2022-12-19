Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EAF651314
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiLST10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiLST0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8E525DE
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB28560F93
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C21DC433EF;
        Mon, 19 Dec 2022 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477994;
        bh=cpC2J3PotioDThivrAY30LR9J14qdtQlBsBivvfn5U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sU8u8q6gCmsr/poPn9YPWnltk9Lypsm2/8TN7URw3ik/LpoDWEEo4B72wHh8+NbdK
         5tajAA6jjxMiDjrJPBSoEfF2Ssowd52eSE3qJdhi84D/66ULCD3nPF1LyEokS874YP
         a1aEtvfziOOQLldeHASdqddZme6VbNJX4uLxG6Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Shruthi Sanil <shruthi.sanil@intel.com>
Subject: [PATCH 6.0 23/28] usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake
Date:   Mon, 19 Dec 2022 20:23:10 +0100
Message-Id: <20221219182945.181024447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
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
@@ -44,7 +44,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLP		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
-#define PCI_DEVICE_ID_INTEL_RPL			0x460e
+#define PCI_DEVICE_ID_INTEL_RPL			0xa70e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e


