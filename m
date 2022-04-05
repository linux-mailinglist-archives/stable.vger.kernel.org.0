Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47AD4F2755
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiDEIFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiDEH7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D15954FA2;
        Tue,  5 Apr 2022 00:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61FC1B81B9C;
        Tue,  5 Apr 2022 07:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9257C340EE;
        Tue,  5 Apr 2022 07:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145209;
        bh=U807mwT5uLeYFhAzrjf6WOAwsLXfnFIitsstvV5q7cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jzy/BqY9RwCaC8Xc48eTuAg60y6NcoBQ0C5CP+B9nbQOgBRhz2azuT9xw423CEgjq
         Qq72Qqzkh1l6ouODxnVlukSG8+jPW+gJAU9YJm+0RygSPiZg1tI+3XwTbfuN7XoVDC
         gz0++7B6q+e242Ow2KbmDGzeCJa2ZLYAWH+7Qfoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0324/1126] arm64: dts: qcom: sc7280: Fix gmu unit address
Date:   Tue,  5 Apr 2022 09:17:51 +0200
Message-Id: <20220405070417.128317271@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 142a4d995c6adb6bf5b22166f51b525e83c96661 ]

When processing sc7280 device trees, I can see:

  Warning (simple_bus_reg): /soc@0/gmu@3d69000:
    simple-bus unit address format error, expected "3d6a000"

There's a clear typo in the node name. Fix it.

Fixes: 96c471970b7b ("arm64: dts: qcom: sc7280: Add gpu support")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220125144316.v2.1.I19f60014e9be4b9dda4d66b5d56ef3d9600b6e10@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 937c2e0e93eb..eab7a8505053 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1790,7 +1790,7 @@
 			};
 		};
 
-		gmu: gmu@3d69000 {
+		gmu: gmu@3d6a000 {
 			compatible="qcom,adreno-gmu-635.0", "qcom,adreno-gmu";
 			reg = <0 0x03d6a000 0 0x34000>,
 				<0 0x3de0000 0 0x10000>,
-- 
2.34.1



