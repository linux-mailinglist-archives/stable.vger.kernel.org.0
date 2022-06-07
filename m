Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8FB541040
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354387AbiFGTVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356156AbiFGTSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:18:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA4C719F6;
        Tue,  7 Jun 2022 11:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B58EE6171C;
        Tue,  7 Jun 2022 18:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D7BC385A5;
        Tue,  7 Jun 2022 18:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625297;
        bh=rcBjoiXgO+z+OvXdXoESTU8m02RbV16e9JWR3eqW3Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtJ4ZJRcb3TVBKniu8qZyFjEmXqyi3X85IofwMDoRqKM+Yk7IYrJXJPHE2CGbw8e1
         v36k5nwgIxK5BlAjsLtEPMOrjj7yKEptUzBo94/D816+lv7iexH/4Vux4c/myEEIsi
         TSZtBR+PMbQZ4wCjFa+HnAESLplepydrkTkQE8Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kathiravan T <quic_kathirav@quicinc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 636/667] arm64: dts: qcom: ipq8074: fix the sleep clock frequency
Date:   Tue,  7 Jun 2022 19:05:01 +0200
Message-Id: <20220607164953.736696860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Kathiravan T <quic_kathirav@quicinc.com>

commit f607dd767f5d6800ffbdce5b99ba81763b023781 upstream.

Sleep clock frequency should be 32768Hz. Lets fix it.

Cc: stable@vger.kernel.org
Fixes: 41dac73e243d ("arm64: dts: Add ipq8074 SoC and HK01 board support")
Link: https://lore.kernel.org/all/e2a447f8-6024-0369-f698-2027b6edcf9e@codeaurora.org/
Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1644581655-11568-1-git-send-email-quic_kathirav@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -13,7 +13,7 @@
 	clocks {
 		sleep_clk: sleep_clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32768>;
 			#clock-cells = <0>;
 		};
 


