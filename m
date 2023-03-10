Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4E66B44D9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjCJO3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjCJO2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5CC5F221
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB02B6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64B5C433EF;
        Fri, 10 Mar 2023 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458421;
        bh=rjdaWGKYobY44KpXqvxPkVBT5CfP7Q1oXKbWx2xkOIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQq0Db1icOiDNlhrppn9AWDttuZcS1LeKE1+Riieus7+8a+YeLF2e507Iy5dK//yw
         YhuvnmxRaXn+F6YVpvRc3XxWtPPeGcQ4ChQyNOfGfHOyrj6zLl+RkQ/HFkRUmFrK+4
         9zcN9j3g0qYaXhddY5Xn1O7PNwFz6YIMUqJYWQQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vyacheslav Bocharov <adeep@lexina.in>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/357] arm64: dts: meson-gx: Fix Ethernet MAC address unit name
Date:   Fri, 10 Mar 2023 14:34:56 +0100
Message-Id: <20230310133734.296168935@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 8ed5310356bfa47cc6bb4221ae6b21258c52e3d1 ]

Unit names should use hyphens instead of underscores to not cause
warnings.

Fixes: bfe59f92d306 ("ARM64: dts: amlogic: gxbb: Enable NVMEM")
Suggested-by: Vyacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-5-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 0c667ec15f8cf..ff68dcaf64ef8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -172,7 +172,7 @@ sn: sn@14 {
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
-- 
2.39.2



