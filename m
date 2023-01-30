Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31460681046
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbjA3OCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbjA3OBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3341D39BBC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7620B8114D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE34C4339B;
        Mon, 30 Jan 2023 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087291;
        bh=rMEB1azwDWK+j+onGnAdHJVqc+hhHapTSS2ntrTQ99o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9V7A7Skmn9s8lEPHNtm4XeprgUnHdFvP85AWqrKB30/DkSYSLbsjuGVGiykygZJq
         9opJsDpJfueUAwca9ueHdhjAfgS0ga5XZ8iOXNECg72iYNIcOFA8cZ7cWjBbaE78Tm
         Kp/PajC2fJ5paaB/NUf1R1NdNfL+uBv1pDufsoJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/313] s390/debug: add _ASM_S390_ prefix to header guard
Date:   Mon, 30 Jan 2023 14:49:54 +0100
Message-Id: <20230130134344.073011134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.39.0



