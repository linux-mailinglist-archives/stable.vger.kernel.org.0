Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6D531921
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbiEWR2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241265AbiEWR0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4FA6EB3C;
        Mon, 23 May 2022 10:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05CFA60919;
        Mon, 23 May 2022 17:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F53C385A9;
        Mon, 23 May 2022 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326387;
        bh=bmaIBOnLPV+9ts2gzWUwpvTbWoeX6xYEorQENEVPD0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4IhpH1peFXa1M12K4DYUIR9uylt4UoBImDK8C1FtIZVaCft9MJEJUNQ4yGYIXybw
         ktrDAcdm94dMV+t0jJp6WeN21UnMPP3VAqGpzW7jiigIu/61eIAOARcCpEw8vmukKQ
         y2BH0zbaLbX0rw9f4HlGjTteT2QcFeUnyC9sELnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Ryan Chen <ryan_chen@aspeedtech.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/132] ARM: dts: aspeed: Add secure boot controller node
Date:   Mon, 23 May 2022 19:04:35 +0200
Message-Id: <20220523165834.167796816@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit fea289467608ffddb2f8d3a740912047974bb183 ]

The ast2600 has a secure boot controller.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Ryan Chen <ryan_chen@aspeedtech.com>
Link: https://lore.kernel.org/r/20211117035106.321454-3-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
index ee171b3364fa..8f947ed47fc5 100644
--- a/arch/arm/boot/dts/aspeed-g6.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6.dtsi
@@ -384,6 +384,11 @@ adc1: adc@1e6e9100 {
 				status = "disabled";
 			};
 
+			sbc: secure-boot-controller@1e6f2000 {
+				compatible = "aspeed,ast2600-sbc";
+				reg = <0x1e6f2000 0x1000>;
+			};
+
 			gpio0: gpio@1e780000 {
 				#gpio-cells = <2>;
 				gpio-controller;
-- 
2.35.1



