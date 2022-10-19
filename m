Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E522D6041D7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiJSKuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiJSKsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E59122754;
        Wed, 19 Oct 2022 03:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D625B824D3;
        Wed, 19 Oct 2022 09:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19D2C433D6;
        Wed, 19 Oct 2022 09:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170761;
        bh=hC7weKyqCI/bOmZ+4VQhssSCJ6Wn8R/IKSruyt9fD58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEon5jEBQSIyGBw1LfW9rOKrClRpzOjUtZOuiI//+KOE8zSrSgDP/ed0K+FXlmvS8
         qWU+ciu8HTp/0p/yvNc1BgRu+qjIs55Gi4tGAmRJM3QQtIjE9wEhXJ6oFGIhaNSqKS
         NzFYzlPUOY5ygtShDMvdnkjnYbBOF7h6eSSza3rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 775/862] ARM: dts: imx6sll: add missing properties for sram
Date:   Wed, 19 Oct 2022 10:34:22 +0200
Message-Id: <20221019083324.148244847@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 7492a83ed9b7a151e2dd11d64b06da7a7f0fa7f9 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sll.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index d4a000c3dde7..2873369a57c0 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -115,6 +115,9 @@
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 
 		intc: interrupt-controller@a01000 {
-- 
2.35.1



