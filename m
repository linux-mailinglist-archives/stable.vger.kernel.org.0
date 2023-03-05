Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E67F6AB08C
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCEN5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCEN4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D24D166F5;
        Sun,  5 Mar 2023 05:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7054E60B3C;
        Sun,  5 Mar 2023 13:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38571C433D2;
        Sun,  5 Mar 2023 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024463;
        bh=ZrQItzjtZ6eqskAtEI2IcLitdCI34AQWy2ttJZUXcTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVfpfmYRjbUYjubJiqart8kDeJbXC15VuW72pbEDrjkSgAxu5ghJREuTnIb1VWBOJ
         ZDtsF6+NSN+xiN4v4C1HZnexYc5/jakzZQFjS92PbZVIIyevxhV5iIawpm4E7qZyM4
         VztzpFOGR2s9WkzKjEAFyubWY/zUXT7BxlMkpIKjZyDSv3XI0zVtWscGKpQY1yk/p6
         Rqlj9o1e+aEaVGwE23WVQUtKyB49iM+4eSJsTzNRMjq4EGsXpey9jfoRazPvFPkgqE
         IPJCfG/4qYlebm6YZCbK5ipvfKOkuCj2ZLauP3ueyIFisWWliUMla8eZkDVK6VPUwD
         C4YfuO50LbNXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 8/9] PCI: Add SolidRun vendor ID
Date:   Sun,  5 Mar 2023 08:53:58 -0500
Message-Id: <20230305135359.1793830-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135359.1793830-1-sashal@kernel.org>
References: <20230305135359.1793830-1-sashal@kernel.org>
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
index 04f44a4694a2e..f856e5e4be85a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3092,6 +3092,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
-- 
2.39.2

