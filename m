Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE274F26FC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiDEID3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiDEH7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D168580DF;
        Tue,  5 Apr 2022 00:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93A86B81A32;
        Tue,  5 Apr 2022 07:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0523FC340EE;
        Tue,  5 Apr 2022 07:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145255;
        bh=0j7nHnS0t2sSr815chupnPL/fJYlIq6v+zh/udpGJTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqU+IeTdwMOpuj8kTPvb1T2/xaLGuqwAMRXxySI9jxef3D7VX+n0OyqMFZP4RdGnN
         ZshN8rydqQ7hxAqNjAWtz4Ciz7BoAv5+6QZfZTvqIhKUHP3d0zMRqo6df7Fm7zWJwV
         R+/cJXgekiaG+MUuYztkmt2C07C4JnxPzgJqFdC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kathiravan T <kathirav@codeaurora.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0339/1126] arm64: dts: qcom: ipq6018: fix usb reference period
Date:   Tue,  5 Apr 2022 09:18:06 +0200
Message-Id: <20220405070417.565613241@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



