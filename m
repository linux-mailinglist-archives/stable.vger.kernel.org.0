Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF0566C0CE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjAPOEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjAPODr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:03:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1631E5D4;
        Mon, 16 Jan 2023 06:02:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFA360FD2;
        Mon, 16 Jan 2023 14:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D843C43392;
        Mon, 16 Jan 2023 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877776;
        bh=zzzR+i1RdIxy+of6mVtWgC+AjHORIvJnVjDamou9W9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5ohLqYh/osTkSDJqX3J1lrfpPm+3F1AYkbakKpiT7SkXdUwbNIyJEejtwKdwtq6W
         omo607sgozGjt17uSIgtYtz9EjiFTMiRzSeK9pydRzlsalpdcqyMXmRFtdY28WORsj
         A1DtrHerTUmGS5a/fpW4gTEqx6GkSpip4rMrHhAtwajyHIrWTyMETSWOWrVsmwfCb0
         w/41R8r288k+YqM8Ds6dMi2aq/yBMMgX4VjyAdpPdoigwJLlsWdnxqBYGehOhNPIEH
         xjTTnYfqCFdGzEzJByllmukCz+U88WuLyez93zTnHtmWBMMvVxZqiTDJ2u1jvS8Kwo
         VIaUS1SFr9MyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/53] s390/debug: add _ASM_S390_ prefix to header guard
Date:   Mon, 16 Jan 2023 09:01:19 -0500
Message-Id: <20230116140154.114951-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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
index 77f24262c25c..ac665b9670c5 100644
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

