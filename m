Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABC259370F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbiHOSev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243208AbiHOSeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:34:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D6D2AE3A;
        Mon, 15 Aug 2022 11:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76719B8107D;
        Mon, 15 Aug 2022 18:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90F5C433D6;
        Mon, 15 Aug 2022 18:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587730;
        bh=httprFRWS2IWljd7AHDAQs1mveoWNaulkMZGUEXjL2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHKsSNBsO1XSrz0eKeEsh+ugaGclulvPZaMtLlCcgo7N6KVj1VzzNQT2X984qAs/2
         JrcqxZ78hGM9QlaHe9qS1I/2Cvex1MPXUwHuUK77jOF0VYBBVdg3q2GMaiOV1oB8Cr
         qDBzJriZxEc9Cw0HTh0l4Gw2JQ94+nOau0TpUXaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/779] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
Date:   Mon, 15 Aug 2022 19:57:00 +0200
Message-Id: <20220815180344.801087363@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit e60414644cf3a703e10ed4429c15263095945ffe ]

We don't use this carveout on trogdor boards, and having it defined in
the sc7180 SoC file causes an overlap message to be printed at boot.

 OF: reserved mem: OVERLAP DETECTED!
 memory@86000000 (0x0000000086000000--0x000000008ec00000) overlaps with memory@8b700000 (0x000000008b700000--0x000000008b710000)

Delete the node in the trogdor dtsi file to fix the overlap problem and
remove the error message.

Cc: Alex Elder <elder@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: 310b266655a3 ("arm64: dts: qcom: sc7180: define ipa_fw_mem node")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220517193307.3034602-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 70c88c37de32..a9d36ac6cb90 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -42,6 +42,7 @@ charger-crit {
  */
 
 /delete-node/ &hyp_mem;
+/delete-node/ &ipa_fw_mem;
 /delete-node/ &xbl_mem;
 /delete-node/ &aop_mem;
 /delete-node/ &sec_apps_mem;
-- 
2.35.1



