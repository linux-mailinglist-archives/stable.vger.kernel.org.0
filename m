Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5502C593E27
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344772AbiHOUhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346079AbiHOUf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:35:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF9A2AE31;
        Mon, 15 Aug 2022 12:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D4DE612A0;
        Mon, 15 Aug 2022 19:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F3DC433C1;
        Mon, 15 Aug 2022 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590393;
        bh=TsPnHu1UXHbWPwLLScYxhp6RvVMszap/m+Uy0kSwgTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+HapOe/A1lvyk6jI/WjIwvytW8Hs48K4gkNxfHTESWqG0gLJG0CErp0C8bkNy77Q
         kCw0BjQVPu63Iasm7fgyc3ZQZSO/LMmAfQsrxSJVS4sxeSY3x2MZ97zWH1uQ4as+Dg
         eA+oMMEMh/bomWsl4SeQX+wbVGaWCnLpdwt4pQkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Luca Weiss <luca@z3ntu.xyz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0246/1095] ARM: dts: qcom: msm8974: add required ranges to OCMEM
Date:   Mon, 15 Aug 2022 19:54:05 +0200
Message-Id: <20220815180439.968387380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 7a16ea7f3a5ec0f30b146b058c273b7a9c8ceadf ]

The OCMEM bindings require ranges property.

Fixes: a2cc991ed634 ("ARM: dts: qcom: msm8974: add ocmem node")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Tested-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220607171848.535128-7-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index ed3e46e7f96d..7a25d313e4fb 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1369,6 +1369,7 @@ ocmem@fdd00000 {
 			reg = <0xfdd00000 0x2000>,
 			      <0xfec00000 0x180000>;
 			reg-names = "ctrl", "mem";
+			ranges = <0 0xfec00000 0x180000>;
 			clocks = <&rpmcc RPM_SMD_OCMEMGX_CLK>,
 				 <&mmcc OCMEMCX_OCMEMNOC_CLK>;
 			clock-names = "core", "iface";
-- 
2.35.1



