Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC675F91B0
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbiJIWk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiJIWii (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:38:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D1B40BF1;
        Sun,  9 Oct 2022 15:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEDB9B80DCD;
        Sun,  9 Oct 2022 22:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9468FC4347C;
        Sun,  9 Oct 2022 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354013;
        bh=giqT9MYoDXKQ+baoc0Lp9B7z0xLRE2QZ8nR3HVgVdV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T94w5KEVQMxoqkeTdzoC6Ss4Pm4SCbZGavo/yn3Qbu4rd//qd4zZFnLY5Xi+QXTXh
         VfIM/jvfPZ2H4flhDRh2bip1sNVlFDRnwlE5dyFXOA+9pwnfOFYKcIUBFQIv/Hmzgx
         OjUN7mf7kXG0CHj+P9VJETUU2IRZCDJ0F6XD0ZVeSGZOV+m2CVIeuuM6ZPcpMLR8Oi
         1/h5TjBjeNeCQxiW7SZSNQDvixCUfe1Ss3J3rMHlF/gGf6vLQaIzGuVQueX6/n/yfD
         yKEtaRemMwCjrcaUQ3maM9VGHTMubhLiKx/2xrCMALsJiexCmIiDqVMPWCSwrZZPrN
         hInirz2gMJQ7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiran K <kiran.k@intel.com>,
        Chethan T N <chethan.tumkur.narayan@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/46] Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk
Date:   Sun,  9 Oct 2022 18:18:46 -0400
Message-Id: <20221009221912.1217372-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit dd0a1794f4334ddbf9b7c5e7d642aaffff38c69b ]

HarrrisonPeak, CyclonePeak, SnowFieldPeak and SandyPeak controllers
are marked to support HCI_QUIRK_LE_STATES.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index d122cc973917..de3d851d85e7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2274,15 +2274,20 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 					       INTEL_ROM_LEGACY_NO_WBS_SUPPORT))
 				set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 					&hdev->quirks);
+			if (ver.hw_variant == 0x08 && ver.fw_variant == 0x22)
+				set_bit(HCI_QUIRK_VALID_LE_STATES,
+					&hdev->quirks);
 
 			err = btintel_legacy_rom_setup(hdev, &ver);
 			break;
 		case 0x0b:      /* SfP */
-		case 0x0c:      /* WsP */
 		case 0x11:      /* JfP */
 		case 0x12:      /* ThP */
 		case 0x13:      /* HrP */
 		case 0x14:      /* CcP */
+			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+			fallthrough;
+		case 0x0c:	/* WsP */
 			/* Apply the device specific HCI quirks
 			 *
 			 * All Legacy bootloader devices support WBS
@@ -2290,11 +2295,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 			set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 				&hdev->quirks);
 
-			/* Valid LE States quirk for JfP/ThP familiy */
-			if (ver.hw_variant == 0x11 || ver.hw_variant == 0x12)
-				set_bit(HCI_QUIRK_VALID_LE_STATES,
-					&hdev->quirks);
-
 			/* Setup MSFT Extension support */
 			btintel_set_msft_opcode(hdev, ver.hw_variant);
 
@@ -2361,9 +2361,8 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		 */
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
-		/* Valid LE States quirk for JfP/ThP familiy */
-		if (ver.hw_variant == 0x11 || ver.hw_variant == 0x12)
-			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+		/* Set Valid LE States quirk */
+		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
 
 		/* Setup MSFT Extension support */
 		btintel_set_msft_opcode(hdev, ver.hw_variant);
-- 
2.35.1

