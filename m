Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8114F36D7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352411AbiDELIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiDEJsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7A475C26;
        Tue,  5 Apr 2022 02:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE506615E5;
        Tue,  5 Apr 2022 09:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0879C385A0;
        Tue,  5 Apr 2022 09:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151322;
        bh=DGfFICk0ZyhZyp7gehgdnGZsI2rdjdBF6ht5fhvYKxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4bGA29HlQXiht/kYfkXPB+NuUwMKjvAV0kxXZzFVgyaN9Hi9bUg97mlgR7eHv9rI
         WDQ9e5JR60vcyFw3KCB9TzRtztQRO1P+CkjL0ssus84VnTmBtqUIjD2pDR20t8QKP1
         eNjRC2oUaGTcfDqKe6InUAojIolWNPdaG9rVvSXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <singh.kuldeep87k@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/913] arm64: dts: ns2: Fix spi-cpol and spi-cpha property
Date:   Tue,  5 Apr 2022 09:23:17 +0200
Message-Id: <20220405070349.890901609@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Kuldeep Singh <singh.kuldeep87k@gmail.com>

[ Upstream commit c953c764e505428f59ffe6afb1c73b89b5b1ac35 ]

Broadcom ns2 platform has spi-cpol and spi-cpho properties set
incorrectly. As per spi-slave-peripheral-prop.yaml, these properties are
of flag or boolean type and not integer type. Fix the values.

Fixes: d69dbd9f41a7c (arm64: dts: Add ARM PL022 SPI DT nodes for NS2)
Signed-off-by: Kuldeep Singh <singh.kuldeep87k@gmail.com>
CC: Ray Jui <rjui@broadcom.com>
CC: Scott Branden <sbranden@broadcom.com>
CC: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts b/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
index ec19fbf928a1..12a4b1c03390 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
@@ -111,8 +111,8 @@
 		compatible = "silabs,si3226x";
 		reg = <0>;
 		spi-max-frequency = <5000000>;
-		spi-cpha = <1>;
-		spi-cpol = <1>;
+		spi-cpha;
+		spi-cpol;
 		pl022,hierarchy = <0>;
 		pl022,interface = <0>;
 		pl022,slave-tx-disable = <0>;
@@ -135,8 +135,8 @@
 		at25,byte-len = <0x8000>;
 		at25,addr-mode = <2>;
 		at25,page-size = <64>;
-		spi-cpha = <1>;
-		spi-cpol = <1>;
+		spi-cpha;
+		spi-cpol;
 		pl022,hierarchy = <0>;
 		pl022,interface = <0>;
 		pl022,slave-tx-disable = <0>;
-- 
2.34.1



