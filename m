Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36321657965
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiL1PAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiL1PA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519921274B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D104A61544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E028AC433D2;
        Wed, 28 Dec 2022 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239627;
        bh=t5XbNXoBRtACAGbTM7G0lQ2RsEBtPRX7fKBOxZnFWc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06scAMSmKdJ3dd0baVl2sh6yCx1xsgJdsWfbi7RAnbclh9HkE8R+Heeww3/B5ajQ4
         a1682IHF1r26b767Z11Q7LT65LwX+QZDkBezBfgNBSNjntyBSAON+twr2mjbE+c0D/
         etdS/iIWLASt/ArRcqC4eL+jxcbzy7cA8+uH+kWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jayesh Choudhary <j-choudhary@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0057/1073] arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node
Date:   Wed, 28 Dec 2022 15:27:25 +0100
Message-Id: <20221228144329.651228411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 26c5012403f3f1fd3bf8f7d3389ee539ae5cc162 ]

crypto driver itself is not dma-coherent. So drop it.

Fixes: 8ebcaaae8017 ("arm64: dts: ti: k3-j721e-main: Add crypto accelerator node")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>
Link: https://lore.kernel.org/r/20221031152520.355653-3-j-choudhary@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 43b6cf5791ee..75789c0f82bd 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -337,7 +337,6 @@ main_crypto: crypto@4e00000 {
 		dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
 				<&main_udmap 0x4001>;
 		dma-names = "tx", "rx1", "rx2";
-		dma-coherent;
 
 		rng: rng@4e10000 {
 			compatible = "inside-secure,safexcel-eip76";
-- 
2.35.1



