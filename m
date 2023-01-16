Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F7E66C1C0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjAPOO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjAPONC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:13:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AF32CFFF;
        Mon, 16 Jan 2023 06:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD782B80F93;
        Mon, 16 Jan 2023 14:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A8BC433F0;
        Mon, 16 Jan 2023 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877900;
        bh=RKVJTrAZUkG6t/A0BPaHjKKMK0/SXQKHA1NcmFyW9k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLBl84ITZJsK7USJLUkFnZjhKQtenTL69xl+HNIW7hWLsLTYSgLM42a7GkTfwzqOq
         vA25TtEP0DdjrKpR+RyeW3lUH1AbnvV3bhCd7akZJyu5KQoo+MEWx58VwcInQStG4e
         31P0Rar2gaBaHh8zpFavqRiyetScl1q4kQwwVfo38wnC/Gl5wqMGnw/TSTdNJrX5Jq
         dCQNAHUwMGMZePjwBCaNui/vgsFZdi5xKj+PYwoisVsbUU0CZp4WhKdF7KTEkVOGm8
         Rnf7cGJ4ekgGCwv5co+U3aGzgAk/fUdwPQmOmsXINxX2RSCX0la7IDE70l2yzdy6KU
         KDwenPAqL3LfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/17] s390/debug: add _ASM_S390_ prefix to header guard
Date:   Mon, 16 Jan 2023 09:04:37 -0500
Message-Id: <20230116140448.116034-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 0d4d52361b6c29bf771acd4fa461f06d78fb2fac ]

Using DEBUG_H without a prefix is very generic and inconsistent with
other header guards in arch/s390/include/asm. In fact it collides with
the same name in the ath9k wireless driver though that depends on !S390
via disabled wireless support. Let's just use a consistent header guard
name and prevent possible future trouble.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/debug.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index c1b82bcc017c..29a1badbe2f5 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -4,8 +4,8 @@
  *
  *    Copyright IBM Corp. 1999, 2020
  */
-#ifndef DEBUG_H
-#define DEBUG_H
+#ifndef _ASM_S390_DEBUG_H
+#define _ASM_S390_DEBUG_H
 
 #include <linux/string.h>
 #include <linux/spinlock.h>
@@ -425,4 +425,4 @@ int debug_unregister_view(debug_info_t *id, struct debug_view *view);
 #define PRINT_FATAL(x...)	printk(KERN_DEBUG PRINTK_HEADER x)
 #endif /* DASD_DEBUG */
 
-#endif /* DEBUG_H */
+#endif /* _ASM_S390_DEBUG_H */
-- 
2.35.1

