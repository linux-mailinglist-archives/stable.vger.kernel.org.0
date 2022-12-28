Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E68657E54
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbiL1Pww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiL1Pwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CD1186D2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:52:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F9B3B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AFBC433D2;
        Wed, 28 Dec 2022 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242765;
        bh=3eNZPOUfjfZvCR0uT53jpfnHzn1wwxe8slLk9byDHjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLDUnl8br3dPUQHJProF5SqcFs+nxKPVsNyypTk6x235+YgSOSB0AbF1nqje3yDHx
         ACrnzpjOXJrJ3IuVTe0G2noDuNipe6E6xmhU4YUOLohyZWW9OyLuEPQasVYrZ0Kgp9
         ncvzmZeVaPPrD87CXmQLlVG9HcIsWkBa7QrM31ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Herring <robh@kernel.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0449/1073] dt-bindings: clock: Add support for external MCLKs for LPASS on SC7280
Date:   Wed, 28 Dec 2022 15:33:57 +0100
Message-Id: <20221228144340.227061617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 1c3f9df77a506355b3c7761039b53e55ce746f17 ]

Support external mclk to interface external MI2S clocks for SC7280.

Fixes: 4185b27b3bef ("dt-bindings: clock: Add YAML schemas for LPASS clocks on SC7280")
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1662005846-4838-5-git-send-email-quic_c_skakit@quicinc.com
Stable-dep-of: d470be3c4f30 ("clk: qcom: lpass-sc7280: Fix pm_runtime usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,lpasscorecc-sc7280.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,lpasscorecc-sc7280.h b/include/dt-bindings/clock/qcom,lpasscorecc-sc7280.h
index 28ed2a07aacc..0324c69ce968 100644
--- a/include/dt-bindings/clock/qcom,lpasscorecc-sc7280.h
+++ b/include/dt-bindings/clock/qcom,lpasscorecc-sc7280.h
@@ -19,6 +19,8 @@
 #define LPASS_CORE_CC_LPM_CORE_CLK			9
 #define LPASS_CORE_CC_LPM_MEM0_CORE_CLK			10
 #define LPASS_CORE_CC_SYSNOC_MPORT_CORE_CLK		11
+#define LPASS_CORE_CC_EXT_MCLK0_CLK			12
+#define LPASS_CORE_CC_EXT_MCLK0_CLK_SRC			13
 
 /* LPASS_CORE_CC power domains */
 #define LPASS_CORE_CC_LPASS_CORE_HM_GDSC		0
-- 
2.35.1



