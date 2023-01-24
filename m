Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CA4679A73
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbjAXNrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjAXNrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:47:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521A94708E;
        Tue, 24 Jan 2023 05:44:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59DF9B811DC;
        Tue, 24 Jan 2023 13:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E5EC433D2;
        Tue, 24 Jan 2023 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567851;
        bh=QMl81KdbSXSCb1rKBKfsD8j5xzoomHoeMrA/2fCvCEA=;
        h=From:To:Cc:Subject:Date:From;
        b=CX4uo58nD4pbrZ52Tx3C/QXpWgU38IDmjpRCoeEYRBxCZcGNnUp8q1WUvqGjn3Dl9
         SCNmL6v9/AzREUWgPf+s+j55WZ3hN7uTtUz0t7gGAZTsUCEzCrCOkIYUqmkC7TbxwW
         2TPSnhQhfUfH29hsD+gMz7aE/SMKyEa+yCfqt17dEybA6O71aimYolwtk4jDzjoVUW
         q+PG6yhs5OKjHID6HSzV+3SIEq8JOPPmEHy26fFwPqa3kpsODRZXkP+KoW/ATFV0kJ
         AsG/EMz1u5I5fsIJIMijBZUyLrdLL0lvGZEetTVdHnSKQzBxXD21JTnsj1HSTy8pYy
         1SsZdrZ1egBog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        ndesaulniers@google.com, hannes@cmpxchg.org, nathan@kernel.org,
        ojeda@kernel.org, mhiramat@kernel.org, atomlin@redhat.com,
        tj@kernel.org, christophe.leroy@csgroup.eu, vbabka@suse.cz
Subject: [PATCH AUTOSEL 4.14 1/2] init/Kconfig: fix LOCALVERSION_AUTO help text
Date:   Tue, 24 Jan 2023 08:44:05 -0500
Message-Id: <20230124134407.638009-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
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
index c87858c434cc..bc3c44f6b503 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -101,7 +101,7 @@ config LOCALVERSION_AUTO
 	  appended after any matching localversion* files, and after the value
 	  set in CONFIG_LOCALVERSION.
 
-	  (The actual string used here is the first eight characters produced
+	  (The actual string used here is the first 12 characters produced
 	  by running the command:
 
 	    $ git rev-parse --verify HEAD
-- 
2.39.0

