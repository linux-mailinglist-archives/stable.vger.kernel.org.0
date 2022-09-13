Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1015B7154
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiIMOhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiIMOfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8456B6B166;
        Tue, 13 Sep 2022 07:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9C2CB80D87;
        Tue, 13 Sep 2022 14:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54400C433C1;
        Tue, 13 Sep 2022 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078345;
        bh=aE3XUsx9yhCv47JRVJw4tRPM/gRu82FTTx4OBbvS8zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ir88+cFK5lhN4VY3Dfk8V9sWeUjbPhGNegtkXxuCvEPx07RLG8eKpXkafC+iG0AKH
         Xk7mBQudQbJDnUioP6VXruCUsLogdzZOljMLG7xf3XFJccjZoiuBkeA67BMQa1jLlK
         g0G/BCC7bRw/5O1m2WHfeNoojdoXwUMA3f5gOE9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 077/192] ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible
Date:   Tue, 13 Sep 2022 16:03:03 +0200
Message-Id: <20220913140413.799186053@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit af7d78c957017f8b3a0986769f6f18e57f9362ea ]

Drop the "winbond,w25q16dw" compatible since it causes to set the
MODALIAS to w25q16dw which is not specified within spi-nor id table.
Fix this by use the common "jedec,spi-nor" compatible.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index f159c58b9edba..6b791d515e294 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -249,7 +249,7 @@
 
 	/* default boot source: workaround #1 for errata ERR006282 */
 	smarc_flash: flash@0 {
-		compatible = "winbond,w25q16dw", "jedec,spi-nor";
+		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <20000000>;
 	};
-- 
2.35.1



