Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB1681137
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbjA3OLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbjA3OLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA7E3BD9C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1820F6104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08400C433EF;
        Mon, 30 Jan 2023 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087859;
        bh=3ba9il19a7JA91ZLcQKFLSWjcAp+9FW/xRFkQVBV0aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzBXPKrS46H3PExQEt9FpZ3zfS2E3U/Aryq4pBaufq7/g/gLzcvLrCkjXVd5DeNk8
         T7tJeRtnFUOt81U7xjRUhXX+KtzCDUWDihn7sLOIUfvkyRYcBpXtG15YctXUaAJcna
         Mkpm7JpviTjZEFeWBTcJn6f8Qvhv4ezu4hH2YqTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/204] ARM: dts: imx6ul-pico-dwarf: Use clock-frequency
Date:   Mon, 30 Jan 2023 14:49:31 +0100
Message-Id: <20230130134316.584251502@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 94e2cf1e0db5b06c7a6ae0878c5cbec925819a8a ]

'clock_frequency' is not a valid property.

Use the correct 'clock-frequency' instead.

Fixes: 47246fafef84 ("ARM: dts: imx6ul-pico: Add support for the dwarf baseboard")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-pico-dwarf.dts b/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
index 162dc259edc8..5a74c7f68eb6 100644
--- a/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
+++ b/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
@@ -32,7 +32,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
-- 
2.39.0



