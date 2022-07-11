Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84B356FC9E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiGKJpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiGKJpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB1FA9E6C;
        Mon, 11 Jul 2022 02:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7D70B80E7F;
        Mon, 11 Jul 2022 09:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DD2C34115;
        Mon, 11 Jul 2022 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531349;
        bh=0gd7H/PDn7gfPt/8kA00oAnxY4DvAvEYKewAvbpW1YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZETOW1JJ0uC+hc+2IriwVYeB09jHCZKoPPhJSZeVrQKL04c2RNoHimIObTEfzZrF
         maarvdc/yzOhPfaY1cRorPZQ9tmt6BaT9TPmtHP8r3xAj3oD1tK/lto5ZT0YIBU4OQ
         7KMWZ+S9g1APlSbjFUdafcOmOIT5ehLe7CUoCg3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/230] mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
Date:   Mon, 11 Jul 2022 11:05:29 +0200
Message-Id: <20220711090606.147920434@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 77d4435e4581..72a70a7046fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -556,7 +556,7 @@ enum {
 	MCU_CMD_SET_BSS_CONNECTED = MCU_CE_PREFIX | 0x16,
 	MCU_CMD_SET_BSS_ABORT = MCU_CE_PREFIX | 0x17,
 	MCU_CMD_CANCEL_HW_SCAN = MCU_CE_PREFIX | 0x1b,
-	MCU_CMD_SET_ROC = MCU_CE_PREFIX | 0x1d,
+	MCU_CMD_SET_ROC = MCU_CE_PREFIX | 0x1c,
 	MCU_CMD_SET_P2P_OPPPS = MCU_CE_PREFIX | 0x33,
 	MCU_CMD_SET_RATE_TX_POWER = MCU_CE_PREFIX | 0x5d,
 	MCU_CMD_SCHED_SCAN_ENABLE = MCU_CE_PREFIX | 0x61,
-- 
2.35.1



