Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2736047D1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiJSNqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiJSNpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:45:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA42D19422D;
        Wed, 19 Oct 2022 06:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC0D7B8242A;
        Wed, 19 Oct 2022 08:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2802BC43143;
        Wed, 19 Oct 2022 08:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169834;
        bh=YrszN6eVicWhmXjqMk37JK1ZOS4B/sC3cR7rdsIqFvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVh9vrmLZW3N2fmQ7i6gQUUTJ+8u3O9j7U4faC9ue9SaSIStiSd9vxdM6H6aeot/7
         Aqm8vgraXI002RaEX/hwQ+i4qFmSwd3Go0OrWmleIMKP1k27zT/VI5DrJeI5Rao32J
         tm04Ot6NvT4QC6B4fl57NpXgTsD56t241fFbBrdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Satya Priya <quic_c_skakit@quicinc.com>,
        Taniya Das <quic_tdas@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 427/862] arm64: dts: qcom: sc7280: Cleanup the lpasscc node
Date:   Wed, 19 Oct 2022 10:28:34 +0200
Message-Id: <20221019083308.834812892@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Satya Priya <quic_c_skakit@quicinc.com>

[ Upstream commit 8c7ebabd2e3f33ef24378d3cac00d3e59886cecb ]

Remove "cc" regmap from lpasscc node which is overlapping
with the lpass_aon regmap.

Fixes: 422a295221bb ("arm64: dts: qcom: sc7280: Add clock controller nodes")
Signed-off-by: Satya Priya <quic_c_skakit@quicinc.com>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1660107909-27947-2-git-send-email-quic_c_skakit@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index dac3b69e314f..1d48f92a2982 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2168,9 +2168,8 @@
 		lpasscc: lpasscc@3000000 {
 			compatible = "qcom,sc7280-lpasscc";
 			reg = <0 0x03000000 0 0x40>,
-			      <0 0x03c04000 0 0x4>,
-			      <0 0x03389000 0 0x24>;
-			reg-names = "qdsp6ss", "top_cc", "cc";
+			      <0 0x03c04000 0 0x4>;
+			reg-names = "qdsp6ss", "top_cc";
 			clocks = <&gcc GCC_CFG_NOC_LPASS_CLK>;
 			clock-names = "iface";
 			#clock-cells = <1>;
-- 
2.35.1



