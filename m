Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A415316E4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbiEWRSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbiEWRQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C109171D92;
        Mon, 23 May 2022 10:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D955B81210;
        Mon, 23 May 2022 17:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28ADC385AA;
        Mon, 23 May 2022 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325992;
        bh=JPZQFf+Z10UugVERxncmE+0Y4M/PuyKVWD8ZnKhZ/7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtSisNXbXP+Ybh9zYC8swmQhzdj7pTjKT+ktisAN5bcHfbweL4qia0FDlBcK+We3R
         4QE/pRq9yphcyn2ynnSfMHQ0ShZvK3R1gzioA2yh6GzAOV5BffYLfDFjRnkWHQWmsJ
         qDcEboebZYJG+AG56L3gqOS6Cd+ns5YE4vq1yTgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/68] ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi
Date:   Mon, 23 May 2022 19:05:01 +0200
Message-Id: <20220523165808.266598660@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>

[ Upstream commit efddaa397cceefb61476e383c26fafd1f8ab6356 ]

FWSPIDQ2 and FWSPIDQ3 are not part of FWSPI18 interface so remove
FWQSPID group in pinctrl dtsi. These pins must be used with the
FWSPI pins that are dedicated for boot SPI interface which provides
same 3.3v logic level.

Fixes: 2f6edb6bcb2f ("ARM: dts: aspeed: Fix AST2600 quad spi group")
Signed-off-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220329173932.2588289-2-quic_jaehyoo@quicinc.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index f310f4d3bcc7..4792b3d9459d 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -117,11 +117,6 @@ pinctrl_fwspid_default: fwspid_default {
 		groups = "FWSPID";
 	};
 
-	pinctrl_fwqspid_default: fwqspid_default {
-		function = "FWSPID";
-		groups = "FWQSPID";
-	};
-
 	pinctrl_fwspiwp_default: fwspiwp_default {
 		function = "FWSPIWP";
 		groups = "FWSPIWP";
-- 
2.35.1



