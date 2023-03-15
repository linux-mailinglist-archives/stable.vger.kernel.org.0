Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F36BB026
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCOMP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCOMPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AF68EA2F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18E8CB81DF8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EF9C433EF;
        Wed, 15 Mar 2023 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882532;
        bh=WLA5sa26QrNs5gvAtNlDbglcJ15fdNpi6+4Is2FtZS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Six8Hdc5VWoTa/kI0WXzp2zVFwS5+vUo0IB+7lhx8GDfNQFYkF7NcxHIz2YSLZEuh
         1x77zNPgg4DtOL8Q9zaOWoT0Y7H3Kw09UH2IVwklwa457cEmB/fTUFCaaKZ0/5tfzm
         iPcIu1ExsXA0YbjAoYp296WWROvuCmbSHxXYmHG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/39] ARM: dts: exynos: Fix language typo and indentation
Date:   Wed, 15 Mar 2023 13:12:28 +0100
Message-Id: <20230315115721.770930340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c31b11c3eb4d41df4038b0441b15f3f0b2fca5d4 ]

Correct language typo and wrong indentation.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Stable-dep-of: 408ab6786dbf ("ARM: dts: exynos: correct TMU phandle in Exynos4210")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index b6091c27f155d..0ed9ef75075bc 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -8,7 +8,7 @@
  *		www.linaro.org
  *
  * Samsung's Exynos4210 SoC device nodes are listed in this file. Exynos4210
- * based board files can include this file and provide values for board specfic
+ * based board files can include this file and provide values for board specific
  * bindings.
  *
  * Note: This file does not include device nodes for all the controllers in
@@ -379,13 +379,13 @@
 
 			trips {
 				cpu_alert0: cpu-alert-0 {
-				temperature = <85000>; /* millicelsius */
+					temperature = <85000>; /* millicelsius */
 				};
 				cpu_alert1: cpu-alert-1 {
-				temperature = <100000>; /* millicelsius */
+					temperature = <100000>; /* millicelsius */
 				};
 				cpu_alert2: cpu-alert-2 {
-				temperature = <110000>; /* millicelsius */
+					temperature = <110000>; /* millicelsius */
 				};
 			};
 		};
-- 
2.39.2



