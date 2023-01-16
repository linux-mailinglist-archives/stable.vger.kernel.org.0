Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3183F66C163
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjAPOLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjAPOJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1376C2A9AD;
        Mon, 16 Jan 2023 06:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44F1CB80F98;
        Mon, 16 Jan 2023 14:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378ECC433F0;
        Mon, 16 Jan 2023 14:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877854;
        bh=RRf7L9aD0O2MwG9AXEtXVL/Un4z7IwC8Hb90Z2CxOmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJdih9UP5wWF08NeCfgJW8WI70k+tM0Xocyh4AnEO0ICHp6lOadKct+9jEiKKGjwp
         v7v0UbsaYVs3Ik2vNRCsOhDM6elXDp1Ge+/f+ciOLsjOl7AXCyhqjENECnDXBODngu
         2KKZeT2omDctVhG585zEgFQnzLPsSw0H7K4F5w98DRseO7pQkfT3u4AdiZegSTE5Xs
         N5hCkHYlU7uUMOtHIp/RdB9xuCAfRadyboAxoO4Yv9DhsCLt4BFXiXeDok4R6aKpyt
         vaTGESxlPcDabFeOvBbbffigKkz0RXabpKHWrgw0s7R1P50XMldVpVLMkjmEVqS2Wx
         o3/pDiIxvbK/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/24] s390/debug: add _ASM_S390_ prefix to header guard
Date:   Mon, 16 Jan 2023 09:03:43 -0500
Message-Id: <20230116140359.115716-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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
index 19a55e1e3a0c..5fc91a90657e 100644
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
@@ -487,4 +487,4 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas);
 
 #endif /* MODULE */
 
-#endif /* DEBUG_H */
+#endif /* _ASM_S390_DEBUG_H */
-- 
2.35.1

