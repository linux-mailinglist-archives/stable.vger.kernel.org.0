Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069B04F279E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiDEIHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbiDEH7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8C657165;
        Tue,  5 Apr 2022 00:54:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CFC5B81B18;
        Tue,  5 Apr 2022 07:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820EEC340EE;
        Tue,  5 Apr 2022 07:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145241;
        bh=EbOZ/oVGLOsnnwYomOpaf9hYYjlbnYBhs4SnLCj8OQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFc63gOa4PiorzYNA/0oVo2IxVoWDcKDHN7/x+VdEkfOUrGc0TA8jCGW/i04fW3Ys
         a3yzDJB52IlhJH9P2VDK8FwxGIMZf7fgRSw+1LwUN0ahkdmjZLV8GMFqbNG3EGYq70
         Z2vgpe17R1lPO0DmDsA8U0ub5eMpK2k34jcIKV5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, devicetree@vger.kernel.org,
        Maulik Shah <quic_mkshah@quicinc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0335/1126] arm64: dts: qcom: sm8150: Correct TCS configuration for apps rsc
Date:   Tue,  5 Apr 2022 09:18:02 +0200
Message-Id: <20220405070417.449490661@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maulik Shah <quic_mkshah@quicinc.com>

[ Upstream commit 17ac8af678b6da6a8f1df7da8ebf2c5198741827 ]

Correct the TCS config by updating the number of TCSes for each type.

Cc: devicetree@vger.kernel.org
Fixes: d8cf9372b654 ("arm64: dts: qcom: sm8150: Add apps shared nodes")
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1641749107-31979-2-git-send-email-quic_mkshah@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 6012322a5984..78265646feff 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3556,9 +3556,9 @@
 			qcom,tcs-offset = <0xd00>;
 			qcom,drv-id = <2>;
 			qcom,tcs-config = <ACTIVE_TCS  2>,
-					  <SLEEP_TCS   1>,
-					  <WAKE_TCS    1>,
-					  <CONTROL_TCS 0>;
+					  <SLEEP_TCS   3>,
+					  <WAKE_TCS    3>,
+					  <CONTROL_TCS 1>;
 
 			rpmhcc: clock-controller {
 				compatible = "qcom,sm8150-rpmh-clk";
-- 
2.34.1



