Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF0D541CE8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382495AbiFGWG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382798AbiFGWEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F6125069A;
        Tue,  7 Jun 2022 12:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124D361846;
        Tue,  7 Jun 2022 19:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20081C385A2;
        Tue,  7 Jun 2022 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629345;
        bh=bZ/gkPK6FV5YKNITi2OCbXEZcm6VBFXIXhsjV92dqrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1PfjqkW6xsWtYxrPD7QKvuQI1nrwjvbw06D2cjCx1lcJikW0PUFK2asuIumAjcAE
         w2hTo6i779pp8S4j8EFVTAQ3AgJB9zlDFU2SeAdvOVzi+7btIsM7YUOAKa6mPUotBh
         Hq36nroxxK9OB2/nJGrpNjFuJCZSoobXOhi4eHQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jayesh Choudhary <j-choudhary@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 658/879] dmaengine: ti: k3-psil-am62: Update PSIL thread for saul.
Date:   Tue,  7 Jun 2022 19:02:56 +0200
Message-Id: <20220607165021.944736373@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit b21fe492a3a9831c315eb456cf5480c9490eaeef ]

Correct the RX PSIL thread for sa3ul.

Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Fixes: 5ac6bfb587772 ("dmaengine: ti: k3-psil: Add AM62x PSIL and PDMA data")
Link: https://lore.kernel.org/r/20220421065323.16378-1-j-choudhary@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-psil-am62.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ti/k3-psil-am62.c b/drivers/dma/ti/k3-psil-am62.c
index d431e2033237..2b6fd6e37c61 100644
--- a/drivers/dma/ti/k3-psil-am62.c
+++ b/drivers/dma/ti/k3-psil-am62.c
@@ -70,10 +70,10 @@
 /* PSI-L source thread IDs, used for RX (DMA_DEV_TO_MEM) */
 static struct psil_ep am62_src_ep_map[] = {
 	/* SAUL */
-	PSIL_SAUL(0x7500, 20, 35, 8, 35, 0),
-	PSIL_SAUL(0x7501, 21, 35, 8, 36, 0),
-	PSIL_SAUL(0x7502, 22, 43, 8, 43, 0),
-	PSIL_SAUL(0x7503, 23, 43, 8, 44, 0),
+	PSIL_SAUL(0x7504, 20, 35, 8, 35, 0),
+	PSIL_SAUL(0x7505, 21, 35, 8, 36, 0),
+	PSIL_SAUL(0x7506, 22, 43, 8, 43, 0),
+	PSIL_SAUL(0x7507, 23, 43, 8, 44, 0),
 	/* PDMA_MAIN0 - SPI0-3 */
 	PSIL_PDMA_XY_PKT(0x4302),
 	PSIL_PDMA_XY_PKT(0x4303),
-- 
2.35.1



