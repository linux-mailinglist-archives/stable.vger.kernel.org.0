Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199C5657815
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiL1OsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiL1Org (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B79C11C36
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33229B81714
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D25EC433D2;
        Wed, 28 Dec 2022 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238803;
        bh=qY3awEG1aNTACb13FC0W+diU9Et+YRXyv5g6zLWNc0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCY6NOFThc1/TNTortcvTLKpdWLvGRDpODfXuSzeM9INMtfLhI5v4hInCG7FbRcXH
         3XoeZ5KI2RV8nNlo0jwr1WtjGFQ1/hZ9LqC6b4Iih0o2VfXXXAx/JawTN4qXIZL7V5
         nThpAsUuDO8kzBG1j06lPEmVAvY6P+mK1OYPHEqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/731] arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name
Date:   Wed, 28 Dec 2022 15:32:03 +0100
Message-Id: <20221228144257.009168411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 02549ba5de0a09a27616496c3512db5af4ad7862 ]

The register address in the node name is shadowing vph_pwr@83, whereas
the ADC5_VCOIN register resolves to 0x85.  Fix this copy-paste
discrepancy.

Fixes: 4bf097540506 ("arm64: dts: qcom: pm660: Add VADC and temp alarm nodes")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220926190148.283805-3-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm660.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm660.dtsi b/arch/arm64/boot/dts/qcom/pm660.dtsi
index e847d7209afc..affc736d154a 100644
--- a/arch/arm64/boot/dts/qcom/pm660.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm660.dtsi
@@ -152,7 +152,7 @@ vadc_vph_pwr: vph_pwr@83 {
 				qcom,pre-scaling = <1 3>;
 			};
 
-			vcoin: vcoin@83 {
+			vcoin: vcoin@85 {
 				reg = <ADC5_VCOIN>;
 				qcom,decimation = <1024>;
 				qcom,pre-scaling = <1 3>;
-- 
2.35.1



