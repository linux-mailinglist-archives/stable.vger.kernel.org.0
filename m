Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16D25B720C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiIMOsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiIMOr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED9D1261A;
        Tue, 13 Sep 2022 07:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2BC0614C1;
        Tue, 13 Sep 2022 14:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076CCC433C1;
        Tue, 13 Sep 2022 14:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079010;
        bh=wO9RjbU6KDzFYVnAQsZULHB+i/4zxZ8hL2n3irCY6s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LE+oYfQ4W5GLdCcR/0TnFa+RI36IRp8k0mY++I3G9rkrunZJpig7NvlSMPG5MuQ7q
         Mn4u7boV5qByeQdPlsGuhwjWz3xEle0LkOplYnpZpdtoLItJwq7R72TVy1WiChvs/Z
         HFkss29D4JzBSq2b8+L8bO3qCgRXW9xK8m1IVwo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/79] ARM: dts: at91: sama5d2_icp: dont keep vdd_other enabled all the time
Date:   Tue, 13 Sep 2022 16:04:52 +0200
Message-Id: <20220913140352.537379319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 3d074b750d2b4c91962f10ea1df1c289ce0d3ce8 ]

VDD_OTHER is not connected to any on board consumer thus it is not
needed to keep it enabled all the time.

Fixes: 68a95ef72cef ("ARM: dts: at91: sama5d2-icp: add SAMA5D2-ICP")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-9-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d2_icp.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index 9fbcd107d1afb..00b9e88ff5451 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -256,7 +256,6 @@
 					regulator-max-microvolt = <1850000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
-					regulator-always-on;
 
 					regulator-state-standby {
 						regulator-on-in-suspend;
-- 
2.35.1



