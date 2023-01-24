Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF4679A7B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbjAXNs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbjAXNsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:48:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1987474F2;
        Tue, 24 Jan 2023 05:46:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58726B811D5;
        Tue, 24 Jan 2023 13:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A259EC433D2;
        Tue, 24 Jan 2023 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567843;
        bh=jOFfhD9+l03ulQofOi5TYfPSQNSMmRl8/wb7g0TxpSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxAtHGR4jSFqKI2KJrfdBZdlDCTXYJoFQR13xobgWgQlom6cDE9qe21iJBtPOL1hc
         2GJiI1+FKpIk5ET6TjYUk44MGhGr4ok0Q9rDUJFM4E7426DU7iMOVpeFWK9UBuMm3A
         8FU2kmzOp0WrLtY4t4I+gdpeFOkNTIoATZZGKuvzlhtPXT5FRFo9muf5SYblvfGKG7
         0kzU0+PHVbX5JFt2IpCqRUu3RWYcZBad+vUmWJZbpodIZRjSoMqTJ9oWa2S1eCElKy
         l+Uf5IJtL/8yl5sd2aHBIwslhIGSsjGyML+Uo8B5SK0Bp2l/Ui8uJTyydwWtL8cCIu
         ct/DmNoqYtqFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        ndesaulniers@google.com, hannes@cmpxchg.org, nathan@kernel.org,
        ojeda@kernel.org, mhiramat@kernel.org, atomlin@redhat.com,
        ddiss@suse.de, christophe.leroy@csgroup.eu, vbabka@suse.cz
Subject: [PATCH AUTOSEL 4.19 2/4] init/Kconfig: fix LOCALVERSION_AUTO help text
Date:   Tue, 24 Jan 2023 08:43:55 -0500
Message-Id: <20230124134357.637945-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134357.637945-1-sashal@kernel.org>
References: <20230124134357.637945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 0f9c608d4a1eb852d6769d2fc5906c71c02565ae ]

It was never guaranteed to be exactly eight, but since commit
548b8b5168c9 ("scripts/setlocalversion: make git describe output more
reliable"), it has been exactly 12.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 15c02e15d3fd..b072772eb3a7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -105,7 +105,7 @@ config LOCALVERSION_AUTO
 	  appended after any matching localversion* files, and after the value
 	  set in CONFIG_LOCALVERSION.
 
-	  (The actual string used here is the first eight characters produced
+	  (The actual string used here is the first 12 characters produced
 	  by running the command:
 
 	    $ git rev-parse --verify HEAD
-- 
2.39.0

