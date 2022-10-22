Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A94608782
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiJVICo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiJVIA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:00:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FA9269092;
        Sat, 22 Oct 2022 00:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF6E0B82E1C;
        Sat, 22 Oct 2022 07:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD5DC433C1;
        Sat, 22 Oct 2022 07:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425028;
        bh=av6IIo9dQWWrz+gy2p6l7x7pffWvKphYgpbV9re8afE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWyCT6lLSQma5kOPRg2d9VZNYF9K/Y2aupsJQM8VvestievJbqu0ofqK4VgTF29xd
         Q85ozAlMtf+Dn/8A3eWebWS1DljwXBadX/FJxhZrSoIhsvIyMEjvcCaAAKI+Fl03Ev
         TMmVmy7Q3wQ09N5HBHV534ArfuRFj3pRyDW6VJFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 358/717] dt-bindings: clock: exynosautov9: correct clock numbering of peric0/c1
Date:   Sat, 22 Oct 2022 09:23:57 +0200
Message-Id: <20221022072512.006484747@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit b6740089b740b842d5e6ff55b4b2c3bf5961c69a ]

There are duplicated definitions of peric0 and peric1 cmu blocks. Thus,
they should be defined correctly as numerical order.

Fixes: 680e1c8370a2 ("dt-bindings: clock: add clock binding definitions for Exynos Auto v9")
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220727021357.152421-2-chanho61.park@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dt-bindings/clock/samsung,exynosautov9.h  | 56 +++++++++----------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/dt-bindings/clock/samsung,exynosautov9.h b/include/dt-bindings/clock/samsung,exynosautov9.h
index ea9f91b4eb1a..a7db6516593f 100644
--- a/include/dt-bindings/clock/samsung,exynosautov9.h
+++ b/include/dt-bindings/clock/samsung,exynosautov9.h
@@ -226,21 +226,21 @@
 #define CLK_GOUT_PERIC0_IPCLK_8		28
 #define CLK_GOUT_PERIC0_IPCLK_9		29
 #define CLK_GOUT_PERIC0_IPCLK_10	30
-#define CLK_GOUT_PERIC0_IPCLK_11	30
-#define CLK_GOUT_PERIC0_PCLK_0		31
-#define CLK_GOUT_PERIC0_PCLK_1		32
-#define CLK_GOUT_PERIC0_PCLK_2		33
-#define CLK_GOUT_PERIC0_PCLK_3		34
-#define CLK_GOUT_PERIC0_PCLK_4		35
-#define CLK_GOUT_PERIC0_PCLK_5		36
-#define CLK_GOUT_PERIC0_PCLK_6		37
-#define CLK_GOUT_PERIC0_PCLK_7		38
-#define CLK_GOUT_PERIC0_PCLK_8		39
-#define CLK_GOUT_PERIC0_PCLK_9		40
-#define CLK_GOUT_PERIC0_PCLK_10		41
-#define CLK_GOUT_PERIC0_PCLK_11		42
+#define CLK_GOUT_PERIC0_IPCLK_11	31
+#define CLK_GOUT_PERIC0_PCLK_0		32
+#define CLK_GOUT_PERIC0_PCLK_1		33
+#define CLK_GOUT_PERIC0_PCLK_2		34
+#define CLK_GOUT_PERIC0_PCLK_3		35
+#define CLK_GOUT_PERIC0_PCLK_4		36
+#define CLK_GOUT_PERIC0_PCLK_5		37
+#define CLK_GOUT_PERIC0_PCLK_6		38
+#define CLK_GOUT_PERIC0_PCLK_7		39
+#define CLK_GOUT_PERIC0_PCLK_8		40
+#define CLK_GOUT_PERIC0_PCLK_9		41
+#define CLK_GOUT_PERIC0_PCLK_10		42
+#define CLK_GOUT_PERIC0_PCLK_11		43
 
-#define PERIC0_NR_CLK			43
+#define PERIC0_NR_CLK			44
 
 /* CMU_PERIC1 */
 #define CLK_MOUT_PERIC1_BUS_USER	1
@@ -272,21 +272,21 @@
 #define CLK_GOUT_PERIC1_IPCLK_8		28
 #define CLK_GOUT_PERIC1_IPCLK_9		29
 #define CLK_GOUT_PERIC1_IPCLK_10	30
-#define CLK_GOUT_PERIC1_IPCLK_11	30
-#define CLK_GOUT_PERIC1_PCLK_0		31
-#define CLK_GOUT_PERIC1_PCLK_1		32
-#define CLK_GOUT_PERIC1_PCLK_2		33
-#define CLK_GOUT_PERIC1_PCLK_3		34
-#define CLK_GOUT_PERIC1_PCLK_4		35
-#define CLK_GOUT_PERIC1_PCLK_5		36
-#define CLK_GOUT_PERIC1_PCLK_6		37
-#define CLK_GOUT_PERIC1_PCLK_7		38
-#define CLK_GOUT_PERIC1_PCLK_8		39
-#define CLK_GOUT_PERIC1_PCLK_9		40
-#define CLK_GOUT_PERIC1_PCLK_10		41
-#define CLK_GOUT_PERIC1_PCLK_11		42
+#define CLK_GOUT_PERIC1_IPCLK_11	31
+#define CLK_GOUT_PERIC1_PCLK_0		32
+#define CLK_GOUT_PERIC1_PCLK_1		33
+#define CLK_GOUT_PERIC1_PCLK_2		34
+#define CLK_GOUT_PERIC1_PCLK_3		35
+#define CLK_GOUT_PERIC1_PCLK_4		36
+#define CLK_GOUT_PERIC1_PCLK_5		37
+#define CLK_GOUT_PERIC1_PCLK_6		38
+#define CLK_GOUT_PERIC1_PCLK_7		39
+#define CLK_GOUT_PERIC1_PCLK_8		40
+#define CLK_GOUT_PERIC1_PCLK_9		41
+#define CLK_GOUT_PERIC1_PCLK_10		42
+#define CLK_GOUT_PERIC1_PCLK_11		43
 
-#define PERIC1_NR_CLK			43
+#define PERIC1_NR_CLK			44
 
 /* CMU_PERIS */
 #define CLK_MOUT_PERIS_BUS_USER		1
-- 
2.35.1



