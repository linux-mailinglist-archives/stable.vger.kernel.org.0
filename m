Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A35FB5CD
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiJKO5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiJKO4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:56:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5A49D512;
        Tue, 11 Oct 2022 07:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAFE9611B1;
        Tue, 11 Oct 2022 14:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2CFC433D6;
        Tue, 11 Oct 2022 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499923;
        bh=ja63l6fWkyIo6KJfs31Ijpq9Ie4oX6paXQj4eLkITmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAP/ZpD9Tng4yGYbtfO8wKzIaLH/FfGdfC2fxr3rdf55DAsaNYTOMtA7/G+EB9egR
         qiIJFz0H0QRSF4hx/2Dmkus28ZBk9GalhJ3/vTEkMpcbXSxRxangQp7Xe4vP3c9TDe
         FVdVAF5WvNGIYDEN2G6O60CFkvr0bZMInpsn8qh/2YcQe1t872ZxGFhLFafQ88EB26
         9jTP1fYypsvQYfHUECptx7zZLYvQjLO+0zWEU2AO50kaa8fZPl9iz0Fa/1S0fjPAO3
         30A2GoJXWulqpVYh45SK+Uk8x/GCzodWYAw22bs6rQFhvZ0scxZ48p5TN3ywqNLzSU
         Tw2FfF4AkIPDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 20/40] arm64: dts: imx8ulp: no executable source file permission
Date:   Tue, 11 Oct 2022 10:51:09 -0400
Message-Id: <20221011145129.1623487-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 7db9905d48e1b9a97a28224c5a201262ebce7489 ]

This fixes the following error:

arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h: error: do not set
 execute permissions for source files

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Acked-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8ulp-pinfunc.h
old mode 100755
new mode 100644
-- 
2.35.1

