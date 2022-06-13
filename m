Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2AE548710
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357282AbiFMMAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357267AbiFML4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:56:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C1A4D9CB;
        Mon, 13 Jun 2022 03:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D18F61368;
        Mon, 13 Jun 2022 10:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61953C34114;
        Mon, 13 Jun 2022 10:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117771;
        bh=Y0R34XCIbfGw9P2jW4VI1KTGDab0h87DaHLn0mRVp/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYSqsVmhFvm6WGk2s4rZ5pcio6utC3TvrF9V+gBdUkZBwdaDJzmy+M9xX91MEWrCg
         YQ8/1JK2jALZVScNisEOlYBTuvrcWK9B3gOUzb5+lNcg5WFpu1qdGxj6I7f80RMOdy
         EFsKyfwepl8eLWWlm1/Iu0ZIv3HcVG+A/BuhxBy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/287] ARM: dts: bcm2835-rpi-b: Fix GPIO line names
Date:   Mon, 13 Jun 2022 12:08:58 +0200
Message-Id: <20220613094927.335046659@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 97bd8659c1c46c23e4daea7e040befca30939950 ]

Recently this has been fixed in the vendor tree, so upstream this.

Fixes: 731b26a6ac17 ("ARM: bcm2835: Add names for the Raspberry Pi GPIO lines")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-rpi-b.dts | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi-b.dts b/arch/arm/boot/dts/bcm2835-rpi-b.dts
index 31ff602e2cd3..6bac18d7c070 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b.dts
@@ -48,18 +48,17 @@
 			  "GPIO18",
 			  "NC", /* GPIO19 */
 			  "NC", /* GPIO20 */
-			  "GPIO21",
+			  "CAM_GPIO0",
 			  "GPIO22",
 			  "GPIO23",
 			  "GPIO24",
 			  "GPIO25",
 			  "NC", /* GPIO26 */
-			  "CAM_GPIO0",
-			  /* Binary number representing build/revision */
-			  "CONFIG0",
-			  "CONFIG1",
-			  "CONFIG2",
-			  "CONFIG3",
+			  "GPIO27",
+			  "GPIO28",
+			  "GPIO29",
+			  "GPIO30",
+			  "GPIO31",
 			  "NC", /* GPIO32 */
 			  "NC", /* GPIO33 */
 			  "NC", /* GPIO34 */
-- 
2.35.1



