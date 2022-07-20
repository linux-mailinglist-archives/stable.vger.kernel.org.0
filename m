Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877B657AC84
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbiGTBXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240645AbiGTBNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:13:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF4664ED;
        Tue, 19 Jul 2022 18:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62777B81DE3;
        Wed, 20 Jul 2022 01:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E48CC341D6;
        Wed, 20 Jul 2022 01:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279554;
        bh=078VrX8jAWlotZGyN3aUMk8m+zf1CYMqe6FLEVyvPqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ8b+NjLrCnGLoyHhunn7gpo/2ZR4IkQ6H+BCvewhjY7JmTE7PCaz4RGls222KAQn
         o81R5qJMMYp2NTwu70SlnXpOisGhX+aKqkb/xC4mHXfByphZZXVL5F4GAz0VnzldyM
         DditLNpYxt8IBwSZVeWQ1wvwtPyeRg56tXJCmha++SKHBUM8jB16MrJwdIxFo7/hRv
         RWfxjvd223Km3M9loKZqmJ5VoPEVLG21bE/Q25zri5lG1gGRHsn52oipXUAGuqHnA5
         kOHq+SL5RNNp/gTMOlCbRFm8jmZC0HVJZtj7xXpuDmhZ96UBmker9v81LID3NAQ99B
         4BA6F8cXG2dDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Staudt <max@enpas.org>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 5.18 28/54] tty: Add N_CAN327 line discipline ID for ELM327 based CAN driver
Date:   Tue, 19 Jul 2022 21:10:05 -0400
Message-Id: <20220720011031.1023305-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Staudt <max@enpas.org>

[ Upstream commit ec5ad331680c96ef3dd30dc297b206988023b9e1 ]

The actual driver will be added via the CAN tree.

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Max Staudt <max@enpas.org>
Link: https://lore.kernel.org/r/20220618180134.9890-1-max@enpas.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/tty.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tty.h b/include/uapi/linux/tty.h
index 9d0f06bfbac3..68aeae2addec 100644
--- a/include/uapi/linux/tty.h
+++ b/include/uapi/linux/tty.h
@@ -38,8 +38,9 @@
 #define N_NULL		27	/* Null ldisc used for error handling */
 #define N_MCTP		28	/* MCTP-over-serial */
 #define N_DEVELOPMENT	29	/* Manual out-of-tree testing */
+#define N_CAN327	30	/* ELM327 based OBD-II interfaces */
 
 /* Always the newest line discipline + 1 */
-#define NR_LDISCS	30
+#define NR_LDISCS	31
 
 #endif /* _UAPI_LINUX_TTY_H */
-- 
2.35.1

