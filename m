Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630356AE853
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCGRPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCGROl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2400939B80
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5441B8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EFDC433EF;
        Tue,  7 Mar 2023 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208972;
        bh=BRqCrAIO/e5j/T+/rH4lmh3g+XoUB9m7ZUIG8D7YaEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oh9tFiCf5ko0NFYjyTbBZsqwCSFRorkmVhMocpI32jGpo9mQCkdwC6RZQ+jceGPy3
         Rugzutcttkjs/7KusHfKxoFtq+BHmNQWTFdaNlGfofoVmDY9Uftux1K2CViYpy4FWW
         F9mgrzlQgPGM2dqWyPYVIb+Lf+IejPK9k1OEX6AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0070/1001] arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name
Date:   Tue,  7 Mar 2023 17:47:22 +0100
Message-Id: <20230307170025.120771245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 417523dc4cc03..c87df0b2dfdea 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -153,7 +153,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: clock-controller {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
-- 
2.39.2



