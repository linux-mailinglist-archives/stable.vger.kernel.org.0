Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30356AE852
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCGRPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCGROm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C048C945
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04C9CB819A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33608C433EF;
        Tue,  7 Mar 2023 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208975;
        bh=TOCk5TqdSo3iu+xG25060p4XTUvLUuDhux4eA5lftIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFSBxi7rFJQPxfY1Wpap0EaDk9dU4CRwtSKmk8NYnHeeybUBZT0kx7KS1KEVieEmU
         qlusFnumU7S2WQIMcoWACqnf03nUOI6cqISX0hEsz6pDLEOClc2DkWILUc7+DgjZpT
         7qHXwx5Kby7p4Hp+wtU6rmHBrOmEFwHXcSqirR60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0071/1001] arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible
Date:   Tue,  7 Mar 2023 17:47:23 +0100
Message-Id: <20230307170025.157529660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index c87df0b2dfdea..ff2b33313e637 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -162,7 +162,7 @@ scpi_dvfs: clocks-0 {
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
-- 
2.39.2



