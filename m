Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217ED4F2A51
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343804AbiDEJOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244890AbiDEIwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D3F240B2;
        Tue,  5 Apr 2022 01:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D784460FFC;
        Tue,  5 Apr 2022 08:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D2CC385A0;
        Tue,  5 Apr 2022 08:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148342;
        bh=0j7nHnS0t2sSr815chupnPL/fJYlIq6v+zh/udpGJTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/4X/KZiTkPd5Fe5qW7RHBgTUgbjtbLmH7Guhtn2zT34W/+k1shw1BsRZ91OnSpAT
         qv0KI1yXr4HQPLiGyvtVoNTQIz9plfYinupu5465uwVsM0ThXs3CvA0TzjwPMuw6EN
         Mm4Ffrf76pV0SNYi9YiiXVwpNQZX42KXHlYCVC1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kathiravan T <kathirav@codeaurora.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0322/1017] arm64: dts: qcom: ipq6018: fix usb reference period
Date:   Tue,  5 Apr 2022 09:20:35 +0200
Message-Id: <20220405070403.837288357@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_BTC_ID,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit d1c10ab1494f09eb12fa6e58fc78bb28d44922ae ]

Reference clock period for rate of 24MHz is 41ns (0x29).

Link: https://lore.kernel.org/r/1965fc315525b8ab26cf9f71f939c24d@codeaurora.org
Link: https://lore.kernel.org/r/a1932eba-564c-fe32-f220-53aa75250105@seco.com
Fixes: 20bb9e3dd2e4 ("arm64: dts: qcom: ipq6018: add usb3 DT description")
Reported-by: Kathiravan T <kathirav@codeaurora.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/4f4df55cf44cd0fd7d773aca171d4f48662fb1a5.1642704221.git.baruch@tkos.co.il
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 66ec5615651d..5dea37651adf 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -748,7 +748,7 @@
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_u3_susphy_quirk;
-				snps,ref-clock-period-ns = <0x32>;
+				snps,ref-clock-period-ns = <0x29>;
 				dr_mode = "host";
 			};
 		};
-- 
2.34.1



