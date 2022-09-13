Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894005B7020
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiIMOUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiIMOSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:18:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6390441983;
        Tue, 13 Sep 2022 07:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E12BB80EFC;
        Tue, 13 Sep 2022 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935E3C433C1;
        Tue, 13 Sep 2022 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078280;
        bh=7Qf2TzxD4QPkN2AzhPNYqAyC+xga9dZrma+t5P67Rsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGku2cc/MExNRaZZAQUVTmyNlHLPEY+d/3zrpMDyEMDWQd2WVOMEGVEmPvjGi2HkV
         olcWzvGHz+ffR4qB5FbH8tF3gqQFeNHsmpB6uqZeLEkUYqS4EgvF3O1OBfJ3FtLqMw
         5efr5ifdLnLEeObziFthxhrdjQbxvPKH98gOmNy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 072/192] arm64: dts: imx8mq-tqma8mq: Remove superfluous interrupt-names
Date:   Tue, 13 Sep 2022 16:02:58 +0200
Message-Id: <20220913140413.554512018@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 8eaac789128a84e79c193e662959469e824423ee ]

This property was never needed, remove it. This also silences
dtbs_check warnings.

Fixes: b186b8b6e770 ("arm64: dts: freescale: add initial device tree for TQMa8Mx with i.MX8M")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi
index 899e8e7dbc24f..802ad6e5cef61 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi
@@ -204,7 +204,6 @@
 		reg = <0x51>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_rtc>;
-		interrupt-names = "irq";
 		interrupt-parent = <&gpio1>;
 		interrupts = <1 IRQ_TYPE_EDGE_FALLING>;
 		quartz-load-femtofarads = <7000>;
-- 
2.35.1



