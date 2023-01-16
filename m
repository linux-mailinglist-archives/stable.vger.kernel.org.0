Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C625366CC47
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbjAPRYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbjAPRXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:23:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642BD3EFD5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14964B8109B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BEBC433D2;
        Mon, 16 Jan 2023 17:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888469;
        bh=NvZsQhBEVa9BvcAEIzlPEstT1Xf5Bin7iI2soNcdTvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPFcnXBWZ9qMr/2JHsl5f82TWCQJfeTEj1yl0s0bFgzzd8ZR1msUbLf5wMUEmnOw3
         +zO8jq6B/ihO7PjZep76O7HX/xyZVInOXNPCj/4FhrSIfxPADCcxRMKxx2bTGqUUx5
         1je7toTyGz3ZTb+bTmwbUiL5lUuuoF2DKCT5agNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Schocher <hs@denx.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 008/338] can: sja1000: fix size of OCR_MODE_MASK define
Date:   Mon, 16 Jan 2023 16:48:01 +0100
Message-Id: <20230116154821.063024685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



