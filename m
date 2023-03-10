Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE506B4394
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjCJOPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjCJOPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:15:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3706E119966
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1936B822BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D28BC433D2;
        Fri, 10 Mar 2023 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457659;
        bh=xDnGI23z2GKgubc1ZAg8UDUvr1T7vDEIITPh2ieat/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMvBfe/CSDzmInmmwZcCAY7QVvVvcgiKfs5eWVpKqGIHcK+8RQz36Wi8bZcbIuLnX
         exq7CQOaOH7/HN0s4Cgr+yuIdzWzrioXLYhJhoDtwMH5FVRW9vrM5ge4j28mHWAOH9
         aUlD6ym8wPvGP6xqsWFnCSNAMKD+NskjlIOJckvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/252] arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
Date:   Fri, 10 Mar 2023 14:36:24 +0100
Message-Id: <20230310133719.260252076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index a2c809f861c09..d5f2f7593c67e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -172,7 +172,7 @@ scpi_dvfs: clocks-0 {
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
-- 
2.39.2



