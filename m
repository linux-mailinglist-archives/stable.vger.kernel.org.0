Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5075E6ECD96
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjDXNYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjDXNYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4AF4C2E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA046228F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE67AC4339B;
        Mon, 24 Apr 2023 13:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342677;
        bh=R38uLk+hE1VJzOZOp2vgaO9WZJoICvTpMOsyZbKSRmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvGqOeGk4PstyTxyiCeTwYHw4tdzRi1gKJ/jTjD7eakOWQ0BWGQKOM9ds/W3zpdJK
         7SAcx+AOeTv9AqSltaVtfXHqt2XSb1EMcUe0C4Q4i+2DsSoj+p1NIEpzZ/HYSAVgKn
         iSfbHjb/uLIp4Kc+bCeuHbUb+mLkYpYKZVjggiFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/98] arm64: dts: qcom: hk10: use "okay" instead of "ok"
Date:   Mon, 24 Apr 2023 15:16:27 +0200
Message-Id: <20230424131134.007302429@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 7284a3943909606016128b79fb18dd107bc0fe26 ]

Use "okay" instead of "ok" in USB nodes as "ok" is deprecated.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221107092930.33325-1-robimarko@gmail.com
Stable-dep-of: 1dc40551f206 ("arm64: dts: qcom: ipq8074-hk10: enable QMP device, not the PHY node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi b/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
index db4b87944cdf2..262b937e0bc62 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
@@ -22,7 +22,7 @@
 };
 
 &blsp1_spi1 {
-	status = "ok";
+	status = "okay";
 
 	flash@0 {
 		#address-cells = <1>;
@@ -34,33 +34,33 @@
 };
 
 &blsp1_uart5 {
-	status = "ok";
+	status = "okay";
 };
 
 &pcie0 {
-	status = "ok";
+	status = "okay";
 	perst-gpios = <&tlmm 58 0x1>;
 };
 
 &pcie1 {
-	status = "ok";
+	status = "okay";
 	perst-gpios = <&tlmm 61 0x1>;
 };
 
 &pcie_phy0 {
-	status = "ok";
+	status = "okay";
 };
 
 &pcie_phy1 {
-	status = "ok";
+	status = "okay";
 };
 
 &qpic_bam {
-	status = "ok";
+	status = "okay";
 };
 
 &qpic_nand {
-	status = "ok";
+	status = "okay";
 
 	nand@0 {
 		reg = <0>;
-- 
2.39.2



