Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D776440D5
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiLFJzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbiLFJzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:55:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2500427B34;
        Tue,  6 Dec 2022 01:51:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A618761607;
        Tue,  6 Dec 2022 09:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC722C43470;
        Tue,  6 Dec 2022 09:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320309;
        bh=79tXwsD53OwRdsZl5C4BsJ7Q9LM9ft++e4i8LYCZjQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmmsqh/XW2lFl86gqGvB960yXzLxtSZRiyd18g3Eh8jqhQRMIrHX9ngtRwI2fnz/D
         9d8XOmdWI6cSWR44WnCxkdVW6gOOAU7njz7TwpUcNeXiElsELiXKE3gETTlfg2AJvQ
         YjzUsx8Fsu7C6JSCAItpcLasejXfs3Ullqy1isVlQWBXi7i+63jfoYOrcY5wkj4Ejr
         9IIfiMq3VJLEkNe7cT75MVUu+gc5nfVwJLstH03ej3DgJAOurzn29ME7K2ce8SZEYo
         f1IUcSH5DoNxE8gmbW32KoueUkc0iPCCOxlfPnCiNROqWfMVqi2aqkWFsgcj+qpIPh
         6wHt5hRxleF0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Schocher <hs@denx.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        linux-can@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] can: sja1000: fix size of OCR_MODE_MASK define
Date:   Tue,  6 Dec 2022 04:51:41 -0500
Message-Id: <20221206095143.987934-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095143.987934-1-sashal@kernel.org>
References: <20221206095143.987934-1-sashal@kernel.org>
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
index 93570b61ec6c..919f3329d822 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -13,7 +13,7 @@
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

