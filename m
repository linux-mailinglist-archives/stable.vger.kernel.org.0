Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086BF65782A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiL1OsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiL1Orp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BA8B7F1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B82E361545
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC6BC433D2;
        Wed, 28 Dec 2022 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238859;
        bh=vV9FExCOWA0sLX8BnZ1ODdHbAjaRfhPYrvLV1NsSyiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvdee/Je3gUVoeh6npZLVZAotbQooK39CuBWFYNcEa6/1zWOBdG31VUwrrrg1hWox
         sjyU5b4VKrBrYKO8y//SCbncTbd/azZ8OEUMolMB02+jcyU4VCKe4wkZkK+e5RJjBE
         IFrUk6vzLrTZN+Yh3VdVpaq2dZgqkmKhfw3naRsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jayesh Choudhary <j-choudhary@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/731] arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node
Date:   Wed, 28 Dec 2022 15:32:24 +0100
Message-Id: <20221228144257.629233752@linuxfoundation.org>
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
index 6c81997ee28a..ad21bb1417aa 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -336,7 +336,6 @@ main_crypto: crypto@4e00000 {
 		dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
 				<&main_udmap 0x4001>;
 		dma-names = "tx", "rx1", "rx2";
-		dma-coherent;
 
 		rng: rng@4e10000 {
 			compatible = "inside-secure,safexcel-eip76";
-- 
2.35.1



