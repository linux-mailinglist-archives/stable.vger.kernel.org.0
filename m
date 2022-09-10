Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397F15B4931
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiIJVR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiIJVRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299284D4EB;
        Sat, 10 Sep 2022 14:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5BB94CE0AE3;
        Sat, 10 Sep 2022 21:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E6DC433C1;
        Sat, 10 Sep 2022 21:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844614;
        bh=3zFCLOpoXLNmEwxV/ZHWHkmv39j1hbijtbmUtvjCD3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6LFCvetzqXKvDqC/pSP8TV97tqW1us3OlX9qG8eY6B+ZKvaJ5yhBczEAU0SEOPbk
         5R4AuRvYlveaxU7Jzt0cqCSPbji+OCvYA/H6/kX+mHpMfsf+dUcrCrZGHluV4dIh9E
         oJLf92glAhYq3nmsH+dLuC1mBM6cWrtHTueDZsXKv3fBeyzXcUZ3OgReqksHiL5Ue4
         m6IELC6uI/o7On/hHORwLJV63fowwORoT4GYiMpq4zF/cW2F8hOCW3dnYnhGKLuSa/
         qdJb0KjlN1nkWIhw/xp05jI/cBt0qpSnjXOehVFFnLR5SewtVXAtxlj59qihV4NGlz
         HzC0kwFlqELXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Even Xu <even.xu@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux@weissschuh.net, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 16/38] HID: intel-ish-hid: ipc: Add Meteor Lake PCI device ID
Date:   Sat, 10 Sep 2022 17:16:01 -0400
Message-Id: <20220910211623.69825-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Even Xu <even.xu@intel.com>

[ Upstream commit 467249a7dff68451868ca79696aef69764193a8a ]

Add device ID of Meteor Lake P into ishtp support list.

Signed-off-by: Even Xu <even.xu@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  | 1 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index e600dbf04dfc6..fc108f19a64c3 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -32,6 +32,7 @@
 #define ADL_P_DEVICE_ID		0x51FC
 #define ADL_N_DEVICE_ID		0x54FC
 #define RPL_S_DEVICE_ID		0x7A78
+#define MTL_P_DEVICE_ID		0x7E45
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 2c67ec17bec6f..7120b30ac51d0 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -43,6 +43,7 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_P_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_N_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, RPL_S_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MTL_P_DEVICE_ID)},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.35.1

