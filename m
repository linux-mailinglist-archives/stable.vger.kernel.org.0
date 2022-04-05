Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0504F2BA9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbiDEJds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiDEIyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A057E219E;
        Tue,  5 Apr 2022 01:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47CD5B81B92;
        Tue,  5 Apr 2022 08:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CE6C385A1;
        Tue,  5 Apr 2022 08:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148712;
        bh=78RxZR77BSioRzFqKK8i55TTw5bKAdRw/UP/KCM/hrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dfetiqjvxc4c+Lzs4mapGTR7OYx/gFRTyJlsPRqk/fPZ3dzOia0mFyj3zQcs/VL6/
         lpIrDThafCo9siQR/yOmulDUsaKk2NCyxMY9c2GxWnDZAqzPRtk2veN2jDah8oABgM
         Ot83z2avJ81xmppBBn38PBMhsaOifQrYcVSDhAtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0454/1017] mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
Date:   Tue,  5 Apr 2022 09:22:47 +0200
Message-Id: <20220405070407.775336709@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit bf9727a27442a50c75b7d99a5088330c578b2a42 ]

Fixed an MCU_CE_CMD_SET_ROC definition error that occurred from a previous
refactor work.

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index acb9a286d354..63fc331e98bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -598,7 +598,7 @@ enum {
 	MCU_CE_CMD_SET_BSS_CONNECTED = 0x16,
 	MCU_CE_CMD_SET_BSS_ABORT = 0x17,
 	MCU_CE_CMD_CANCEL_HW_SCAN = 0x1b,
-	MCU_CE_CMD_SET_ROC = 0x1d,
+	MCU_CE_CMD_SET_ROC = 0x1c,
 	MCU_CE_CMD_SET_P2P_OPPPS = 0x33,
 	MCU_CE_CMD_SET_RATE_TX_POWER = 0x5d,
 	MCU_CE_CMD_SCHED_SCAN_ENABLE = 0x61,
-- 
2.34.1



