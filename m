Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF114F2790
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiDEIHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbiDEH73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF47344DB;
        Tue,  5 Apr 2022 00:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D34B81BA7;
        Tue,  5 Apr 2022 07:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AA9C340EE;
        Tue,  5 Apr 2022 07:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145236;
        bh=Zh/8yJOwchY4WnK5AxAwtRxXpaTTm1ot5ouHhpuoZ7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oycch8PCSDY7QH44RsehBAqeQSqSomszbqVwlQpNrIm6Rd/WHtpedSWupIY2Nm5Aa
         WDXV652V8sMCer9C4cm63B6r2GlPZAoSTlw/RDOoNgcOL1FlB2koHW1tmEoPhsWUVV
         /RRLqGXEzPupKtSQFKDqouKC/tJT+2EdqE0A/Y2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0333/1126] arm64: dts: qcom: msm8916-j5: Fix typo
Date:   Tue,  5 Apr 2022 09:18:00 +0200
Message-Id: <20220405070417.391067229@linuxfoundation.org>
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

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 1f87900493845c0a0d731496150e915649209f1c ]

Fixes: bd943653b10d ("arm64: dts: qcom: Add device tree for Samsung J5 2015 (samsung-j5)")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211231213635.116324-1-petr.vorel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916-samsung-j5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-samsung-j5.dts b/arch/arm64/boot/dts/qcom/msm8916-samsung-j5.dts
index 687bea438a57..6c408d61de75 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-samsung-j5.dts
+++ b/arch/arm64/boot/dts/qcom/msm8916-samsung-j5.dts
@@ -41,7 +41,7 @@
 		};
 
 		home-key {
-			lable = "Home Key";
+			label = "Home Key";
 			gpios = <&msmgpio 109 GPIO_ACTIVE_LOW>;
 			linux,code = <KEY_HOMEPAGE>;
 		};
-- 
2.34.1



