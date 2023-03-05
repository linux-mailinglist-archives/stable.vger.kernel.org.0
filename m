Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887FA6AB0C9
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 15:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCEODy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 09:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCEODv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 09:03:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986B9EFB9;
        Sun,  5 Mar 2023 06:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9E860B23;
        Sun,  5 Mar 2023 13:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C3AC433EF;
        Sun,  5 Mar 2023 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024539;
        bh=LqwQRxQJ8yM/tgpG0HtjBBaEWie9NUFFmB+B0q2b/o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNHXigo/4SdbB+/y/TbBsqbBWItPkl/m4gYkKw0d4if8iy4SB8ssQt6ZCBQDpTcFW
         vS/If93hqI7aFnTHdkZCLuYWzrY/NHH+cDvWq/tgFGBlToM0Ms7zjpYESF0av6MfQ2
         3BldtqDGoTRVw0MXEaOp7bTkB39CzlDN07U5k45XtxSm8G0ScWTpce3ZTIc4nodloo
         YgN7tyxDzzePkBtdVTE0Ax4TobXcVdXLe36Zquy1/MfMzz8IO6lZI6ZJ2uK4P7Yz88
         HKodR3ivHbLw/OcksT3rH3iLNP1+y1NwC88d53PDvtD/4N9lPF+X7Jb1cQmubtqXfq
         xuGUU9PLIWZYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/6] PCI: Add SolidRun vendor ID
Date:   Sun,  5 Mar 2023 08:55:24 -0500
Message-Id: <20230305135525.1794277-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135525.1794277-1-sashal@kernel.org>
References: <20230305135525.1794277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvaro Karsz <alvaro.karsz@solid-run.com>

[ Upstream commit db6c4dee4c104f50ed163af71c53bfdb878a8318 ]

Add SolidRun vendor ID to pci_ids.h

The vendor ID is used in 2 different source files, the SNET vDPA driver
and PCI quirks.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Message-Id: <20230110165638.123745-2-alvaro.karsz@solid-run.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d4eae72202fab..0122286beda53 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3045,6 +3045,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
-- 
2.39.2

