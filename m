Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37065B7380
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiIMPHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiIMPFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2828774E1A;
        Tue, 13 Sep 2022 07:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E286FB80F4B;
        Tue, 13 Sep 2022 14:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5C5C433D6;
        Tue, 13 Sep 2022 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078888;
        bh=x8/AfkFC1myYwerM7grWJWme6bV0VUgM6ojfjkOg+9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbROmwBq3y+WilJeS8A1WQEkj9UHkSBsXZfX2mM4kzqnuBtQ+nM5D1xc16eAln+gL
         KOB/LSdX+4TfYnojzeYrvhvzPvyHkXK8IKzT2ncWHzy/k9cAPnxw69vZFzOHgHNTM1
         PdIJWGdk31YFzV9IOCLTPZMgZdXIKQ+Y9a06nIQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/121] ARM: at91: ddr: remove CONFIG_SOC_SAMA7 dependency
Date:   Tue, 13 Sep 2022 16:05:12 +0200
Message-Id: <20220913140402.562011888@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

[ Upstream commit dc3005703f8cd893d325081c20b400e08377d9bb ]

Remove CONFIG_SOC_SAMA7 dependency to avoid having #ifdef preprocessor
directives in driver code (arch/arm/mach-at91/pm.c). This prepares the
code for next commits.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220113144900.906370-2-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/soc/at91/sama7-ddr.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/soc/at91/sama7-ddr.h b/include/soc/at91/sama7-ddr.h
index 72d19887ab810..f203f34dba12e 100644
--- a/include/soc/at91/sama7-ddr.h
+++ b/include/soc/at91/sama7-ddr.h
@@ -11,8 +11,6 @@
 #ifndef __SAMA7_DDR_H__
 #define __SAMA7_DDR_H__
 
-#ifdef CONFIG_SOC_SAMA7
-
 /* DDR3PHY */
 #define DDR3PHY_PIR				(0x04)		/* DDR3PHY PHY Initialization Register	*/
 #define	DDR3PHY_PIR_DLLBYP		(1 << 17)	/* DLL Bypass */
@@ -83,6 +81,4 @@
 #define UDDRC_PCTRL_3				(0x6A0)		/* UDDRC Port 3 Control Register */
 #define UDDRC_PCTRL_4				(0x750)		/* UDDRC Port 4 Control Register */
 
-#endif /* CONFIG_SOC_SAMA7 */
-
 #endif /* __SAMA7_DDR_H__ */
-- 
2.35.1



