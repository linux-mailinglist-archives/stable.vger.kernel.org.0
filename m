Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CCF6AEDCE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCGSHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjCGSHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E338299C23
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2238B819C9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CADCC4339B;
        Tue,  7 Mar 2023 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212027;
        bh=wZWe1jOZeErmH1UTx09zfyqg1fmC4QstP/qA8sk0rBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0w58+Cynm90kPBiYQRL9yeoeKM5DOr45kapLTs9XOQ86PhyOh5vwWzg9T02vBpjz
         4xugEOXl4chgHf+r8NPY3GTt2W6kvPZ6cUXQTwV0FN0fvzXNucIlVVIpSzF48g669s
         kx1DUq/H74NjEONv3sDRzEybc0qFx1gThc7OAdnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/885] arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
Date:   Tue,  7 Mar 2023 17:49:48 +0100
Message-Id: <20230307170004.080213291@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 2ff650051493d5bdb6dd09d4c2850bb37db6be31 ]

Fixes:
scpi: sensors:compatible: 'oneOf' conditional failed, one must be fixed:
	['amlogic,meson-gxbb-scpi-sensors'] is too short
	'arm,scpi-sensors' was expected

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-3-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 3885eccf6da42..6cc685f91fc94 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -161,7 +161,7 @@ scpi_dvfs: clocks-0 {
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
-- 
2.39.2



