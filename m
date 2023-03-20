Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6496C1801
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjCTPT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjCTPTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CCD10F3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BE76B80EDE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A45C433EF;
        Mon, 20 Mar 2023 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325174;
        bh=0TsNUXKV3wLdZrBAng5eK1GLFYZjBydisLq78Y8QHBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+letd4U2RtJGYJ8B+D2DRBpwQFsJva8gr+LVKYnxTbAs9S9G/SRMtJJqG5deMv1+
         DdsuKTwUR47PfATGKyP9xbo4ujl5PGscfvP3z2GT4JDV4vHgJQMu804tK4gwlJ//EH
         PKPSapx4FbQ/xcW6474zjrVQ5Fg+N9TJj1fyVvD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/198] net: dsa: mt7530: remove now incorrect comment regarding port 5
Date:   Mon, 20 Mar 2023 15:53:06 +0100
Message-Id: <20230320145509.498950435@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit feb03fd11c5616f3a47e4714d2f9917d0f1a2edd ]

Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
port 5") under mt7530_setup_port5().

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20230310073338.5836-1-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1e0b8bcd59e6c..4306782bf2257 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2206,7 +2206,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
-	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
+	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
-- 
2.39.2



