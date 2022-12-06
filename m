Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A197A6440C9
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiLFJyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235564AbiLFJwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:52:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08852791E;
        Tue,  6 Dec 2022 01:51:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C42661615;
        Tue,  6 Dec 2022 09:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A60BC433C1;
        Tue,  6 Dec 2022 09:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320294;
        bh=NvZsQhBEVa9BvcAEIzlPEstT1Xf5Bin7iI2soNcdTvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qc/zTxI7sBfg/XcRjPwnDkqFvB93SuQ10kf7SLtbaZOHRdE75PLIfyQTgec3G20/c
         IzV8QFFOWrQgNuSxjG7EYt+h1t+3BiCpr1SPGpz7mNjVQxfHrK5KMavihzrblE5CBk
         igbx4UZH7pZwdxXtbVYGwzbg+661tLAWKm23OfWLEqNoOcPWg4HEQxjsNfAqscPIli
         wdkgCk7Kf4EdI0Q7qYRq9kyjOyvTVPFh3wAR1a72DELQKewrfmcu+aAjEUWUGHoeMv
         ivsJfHmLM+QuZ6ECmKz/RJcVnXZq9FXCRVwnCzIWCUS0xgyGqgYOe6DyOf2bnDga38
         LUxbST4CPAdvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Schocher <hs@denx.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        linux-can@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/4] can: sja1000: fix size of OCR_MODE_MASK define
Date:   Tue,  6 Dec 2022 04:51:26 -0500
Message-Id: <20221206095128.987873-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095128.987873-1-sashal@kernel.org>
References: <20221206095128.987873-1-sashal@kernel.org>
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

From: Heiko Schocher <hs@denx.de>

[ Upstream commit 26e8f6a75248247982458e8237b98c9fb2ffcf9d ]

bitfield mode in ocr register has only 2 bits not 3, so correct
the OCR_MODE_MASK define.

Signed-off-by: Heiko Schocher <hs@denx.de>
Link: https://lore.kernel.org/all/20221123071636.2407823-1-hs@denx.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/can/platform/sja1000.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/can/platform/sja1000.h b/include/linux/can/platform/sja1000.h
index 5755ae5a4712..6a869682c120 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -14,7 +14,7 @@
 #define OCR_MODE_TEST     0x01
 #define OCR_MODE_NORMAL   0x02
 #define OCR_MODE_CLOCK    0x03
-#define OCR_MODE_MASK     0x07
+#define OCR_MODE_MASK     0x03
 #define OCR_TX0_INVERT    0x04
 #define OCR_TX0_PULLDOWN  0x08
 #define OCR_TX0_PULLUP    0x10
-- 
2.35.1

