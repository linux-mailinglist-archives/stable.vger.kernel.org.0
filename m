Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBC657829
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiL1OsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiL1Orp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F7A3AB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49CB2CE134B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D089C433EF;
        Wed, 28 Dec 2022 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238856;
        bh=/ktPaq/YzgBVClus7kHpd2KsIxg0q/vQGKSjOSuQAnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbrNujtw/2YkvX2fytu0Ecetr6ZFbAdLd0YUDFoVbP7bNCFtB4DC/+NpQb9HLHY1V
         5hw8YSNP4Rkic4dIWkTmFgK778zjJlf/sjK7eiRh20HGHibmuwpVXtDLFJjVodf2Pj
         Ieeu7PnlTPLzoFaqz32zOYvq9E4pw2atxadPdrGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jayesh Choudhary <j-choudhary@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/731] arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
Date:   Wed, 28 Dec 2022 15:32:23 +0100
Message-Id: <20221228144257.600862503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit b86833ab3653dbb0dc453eec4eef8615e63de4e2 ]

crypto driver itself is not dma-coherent. So drop it.

Fixes: b366b2409c97 ("arm64: dts: ti: k3-am6: Add crypto accelarator node")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>
Link: https://lore.kernel.org/r/20221031152520.355653-2-j-choudhary@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 82be00069bcd..4f232f575ab2 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -120,7 +120,6 @@ crypto: crypto@4e00000 {
 		dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
 				<&main_udmap 0x4001>;
 		dma-names = "tx", "rx1", "rx2";
-		dma-coherent;
 
 		rng: rng@4e10000 {
 			compatible = "inside-secure,safexcel-eip76";
-- 
2.35.1



