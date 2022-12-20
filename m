Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF02651809
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiLTBYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiLTBW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:22:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097E715A0E;
        Mon, 19 Dec 2022 17:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9856D61210;
        Tue, 20 Dec 2022 01:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E626CC433F1;
        Tue, 20 Dec 2022 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499305;
        bh=c4PJoMBpiZ6Sy9yEgOccbk7gFera47jXs90Lp50O1Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucdZ3AG2vwwvu2apuRMfXTfs+pn3rtFkscso/3/HF4vPKAoeMkvK/ftI4kg8uac3Q
         L3U3ZlmyovwO9veilMt8NwNM5k5cZBXv0/TAwx06C4pqZQiqebYpMdY7Dp7VvV0Vl3
         tLEG7KqiWS8meAmt9yNhMhLr3zSFw5HY+n55FjqGkqYXr4XEjLKWwbg0HVn1yKco1/
         3LDvCf0pLTFvOcaa6VV5nfGobq76qpz2YupfLx0Sy5EK2uWQ2vgJy+aF2FwNEdta6Z
         8VPqp6j7AaGcOuc+fbBeYnhHnOpg0YR1ODzmYXbi5PsRDG4rW2nuYEXlX+MyVecHFP
         HNd4yp7foi0Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike McGowen <mike.mcgowen@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        storagedev@microchip.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 08/16] scsi: smartpqi: Add new controller PCI IDs
Date:   Mon, 19 Dec 2022 20:21:18 -0500
Message-Id: <20221220012127.1222311-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012127.1222311-1-sashal@kernel.org>
References: <20221220012127.1222311-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

[ Upstream commit 0b93cf2a9097b1c3d75642ef878ba87f15f03043 ]

All PCI ID entries in Hex.
Add PCI IDs for ByteDance controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    ByteHBA JGH43024-8                      9005 / 028f / 1e93 / 1000
    ByteHBA JGH43034-8                      9005 / 028f / 1e93 / 1001
    ByteHBA JGH44014-8                      9005 / 028f / 1e93 / 1002

Add PCI IDs for new Inspur controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    INSPUR RT0800M7E                        9005 / 028f / 1bd4 / 0086
    INSPUR RT0800M7H                        9005 / 028f / 1bd4 / 0087
    INSPUR RT0804M7R                        9005 / 028f / 1bd4 / 0088
    INSPUR RT0808M7R                        9005 / 028f / 1bd4 / 0089

Add PCI IDs for new FAB A controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    Adaptec SmartRAID 3254-16e /e           9005 / 028f / 9005 / 1475
    Adaptec HBA 1200-16e                    9005 / 028f / 9005 / 14c3
    Adaptec HBA 1200-8e                     9005 / 028f / 9005 / 14c4

Add H3C controller PCI IDs:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    H3C H4508-Mf-8i                         9005 / 028f / 193d / 110b

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/166793530327.322537.6056884426657539311.stgit@brunhilda
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 44 +++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7a8c2c75acba..898b0054cfa1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9302,6 +9302,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1109)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x110b)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
@@ -9402,6 +9406,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0072)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0086)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0087)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0088)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0089)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -9650,6 +9670,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1474)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1475)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1480)
@@ -9706,6 +9730,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14c2)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c3)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c4)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14d0)
@@ -9942,6 +9974,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0623)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1000)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1001)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1002)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.35.1

