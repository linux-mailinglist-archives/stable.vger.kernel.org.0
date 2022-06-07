Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E87554198F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378320AbiFGVWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380634AbiFGVQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69F521E331;
        Tue,  7 Jun 2022 11:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99C161768;
        Tue,  7 Jun 2022 18:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0754C385A2;
        Tue,  7 Jun 2022 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628144;
        bh=FfPhJu8v9WFm9WF85DjB2S/mhUA3fz0JzrI1FkCPw8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBUZ6M/zleqr0j3B5/cBLMp4QW+wLlbk4UcBGf1smQAvIDxsJ205vsnQgyqAJfYoQ
         gkig+Y+dbcKM7FUA+DlfXc0lQllw+iJzy4NfWr34Sljub+F/vLjbSt2b972paLdVd3
         IRVro7V2HrKgppw8FNXKzfcLITOV/cpuKexSZfYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Selvaraj <jo@jsfamily.in>,
        Caleb Connolly <caleb@connolly.tech>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 222/879] arm64: dts: qcom: sdm845-xiaomi-beryllium: fix typo in panels vddio-supply property
Date:   Tue,  7 Jun 2022 18:55:40 +0200
Message-Id: <20220607165009.296704905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Selvaraj <jo@jsfamily.in>

[ Upstream commit 1f1c494082a1f10d03ce4ee1485ee96d212e22ff ]

vddio is misspelled with a "0" instead of "o". Fix it.

Signed-off-by: Joel Selvaraj <jo@jsfamily.in>
Reviewed-by: Caleb Connolly <caleb@connolly.tech>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/BY5PR02MB7009901651E6A8D5ACB0425ED91F9@BY5PR02MB7009.namprd02.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 367389526b41..a97f5e89e1d0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -218,7 +218,7 @@
 	panel@0 {
 		compatible = "tianma,fhd-video";
 		reg = <0>;
-		vddi0-supply = <&vreg_l14a_1p8>;
+		vddio-supply = <&vreg_l14a_1p8>;
 		vddpos-supply = <&lab>;
 		vddneg-supply = <&ibb>;
 
-- 
2.35.1



