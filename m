Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7686B46B1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjCJOqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjCJOp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:45:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56396107D64
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FCD618B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59DCC4339E;
        Fri, 10 Mar 2023 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459511;
        bh=DfVE4v+iZaKZl3jMxxB4wIp4pPD/crTrtbFnk6Iu0Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3D/pHp1oR7rhS+kL4OHK3pNQoKeBH87QIqi2V9TzzXp7XZrUP+qcwdIeBLBzKofh
         8szl5qGEjnUB3HOf1O0yPHya2eVkbbDB2npXIcZIWn6mTYML6F8Tgi3lWp23VTDFgh
         pN/KU92lQXwFhtpc1Lv3OUHxtWNcL1lTz5KdHtRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/529] arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
Date:   Fri, 10 Mar 2023 14:32:51 +0100
Message-Id: <20230310133806.302658928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 5b7069d72f03c92a0ab919725017394ebce03a81 ]

Fixes:
scpi: clocks: 'clock-controller' does not match any of the regexes: '^clocks-[0-9a-f]+$', 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-2-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 5c75fbf0d4709..ddf9eb79e4930 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -151,7 +151,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: clock-controller {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
-- 
2.39.2



