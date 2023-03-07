Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED386AE960
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCGRXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjCGRWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE42911DE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED1B614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D862C433A8;
        Tue,  7 Mar 2023 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209517;
        bh=ikfnVinAPdN807eVqKdI+oZ1iqC+crWO2YaaJsKIIwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2EhD8kBPPbqqT9M4pILqs+osG7GxWywd/tOW/cKShAtVoROGxzcE/fSuwBNVlig9
         H33lVFMZ51bb/0k5XZb7/NufBLrjPyasfiz8HQvJIJdEhDr2I18H4y6+8CiXKwphJN
         /O531q2tFKetAwxgrh8UuXdAJ/cxkgAryS7ATdQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0244/1001] wifi: mt76: connac: fix POWER_CTRL command name typo
Date:   Tue,  7 Mar 2023 17:50:16 +0100
Message-Id: <20230307170032.391361972@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 0d82fc956edb67b5755cc64ac6b9aee79cfbbff0 ]

Fix typo MCU_UNI_CMD_POWER_CREL to MCU_UNI_CMD_POWER_CTRL.

Fixes: 779d34de055e ("wifi: mt76: connac: add more unified command IDs")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index f1e942b9a887b..82fdf6d794bcf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1198,7 +1198,7 @@ enum {
 	MCU_UNI_CMD_REPT_MUAR = 0x09,
 	MCU_UNI_CMD_WSYS_CONFIG = 0x0b,
 	MCU_UNI_CMD_REG_ACCESS = 0x0d,
-	MCU_UNI_CMD_POWER_CREL = 0x0f,
+	MCU_UNI_CMD_POWER_CTRL = 0x0f,
 	MCU_UNI_CMD_RX_HDR_TRANS = 0x12,
 	MCU_UNI_CMD_SER = 0x13,
 	MCU_UNI_CMD_TWT = 0x14,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index a88fc7680b1a9..d781c6e0f33ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2399,7 +2399,7 @@ mt7996_mcu_restart(struct mt76_dev *dev)
 		.power_mode = 1,
 	};
 
-	return mt76_mcu_send_msg(dev, MCU_WM_UNI_CMD(POWER_CREL), &req,
+	return mt76_mcu_send_msg(dev, MCU_WM_UNI_CMD(POWER_CTRL), &req,
 				 sizeof(req), false);
 }
 
-- 
2.39.2



