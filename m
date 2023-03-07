Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B386AE80A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjCGRM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCGRMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA08C98EA1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 954EC6150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C53C4339B;
        Tue,  7 Mar 2023 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208801;
        bh=Uz81I3n+VgOx1HimoofgZSz2rKXimD+4sz9smWt8tMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5e3xexF4QRaBwhfuUJF2x5GODhR0yTJTjWbyT6+zSZLvbQE0yEEyxMR4Gw3De8MD
         SLcqmaQWbmRLdAEoOI9IKNvQYV9UJivz8C9NwZ9NJ3LeGW2xE9KyQUa5eNp6IduqdX
         wZKCAOKtF6sv+272KfIYRifHsLVF36xYjOB5Vlfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Luca Weiss <luca@z3ntu.xyz>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0015/1001] arm64: dts: qcom: pmi8950: Correct rev_1250v channel label to mv
Date:   Tue,  7 Mar 2023 17:46:27 +0100
Message-Id: <20230307170022.813827798@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 3c3d2cb221b8647d1c547b4c44d2d6060cc742a9 ]

This was pointed out in review but never followed up on thanks to
sidetracked discussions about labels vs node names.

Fixes: 0d97fdf380b4 ("arm64: dts: qcom: Add configuration for PMI8950 peripheral")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221209215437.1783067-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmi8950.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmi8950.dtsi b/arch/arm64/boot/dts/qcom/pmi8950.dtsi
index 32d27e2187e38..8008f02434a9e 100644
--- a/arch/arm64/boot/dts/qcom/pmi8950.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8950.dtsi
@@ -47,7 +47,7 @@ adc-chan@9 {
 			adc-chan@a {
 				reg = <VADC_REF_1250MV>;
 				qcom,pre-scaling = <1 1>;
-				label = "ref_1250v";
+				label = "ref_1250mv";
 			};
 
 			adc-chan@d {
-- 
2.39.2



