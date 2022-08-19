Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7959A08E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350176AbiHSQJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351424AbiHSQH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:07:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0994108100;
        Fri, 19 Aug 2022 08:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9156061199;
        Fri, 19 Aug 2022 15:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E41C433D6;
        Fri, 19 Aug 2022 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924572;
        bh=0YmcELewkq0m2pG7nTjmkORBYFQKbDKx046uezXclag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6In01/FNI1SxcDhZK3qWR4O8S5620UiAM6km83lBTS2SyxkQ1Pfd6rNfWZwFZam5
         CJpp9rIpPq3nn6Xic6lgbUCMVjFdGqDFnx89FiwAJfshtKditFG40vRmfDg4DPCRsw
         ssdtVDD9F96b82FhntKFx0odEtQzH3CPx4eXdVWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/545] lib: bitmap: order includes alphabetically
Date:   Fri, 19 Aug 2022 17:39:42 +0200
Message-Id: <20220819153838.848648623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit c13656b904b6173aad723d9680a81c60de2f5edc ]

For better readability and maintenance: order the includes in bitmap
source files alphabetically.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitmap.h | 4 ++--
 lib/bitmap.c           | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 99058eb81042..4dd2e1d39c74 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -4,10 +4,10 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/types.h>
 #include <linux/bitops.h>
-#include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 75006c4036e9..78f70d9007ad 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -3,17 +3,18 @@
  * lib/bitmap.c
  * Helper functions for bitmap.h.
  */
-#include <linux/export.h>
-#include <linux/thread_info.h>
-#include <linux/ctype.h>
-#include <linux/errno.h>
+
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/bug.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/thread_info.h>
 #include <linux/uaccess.h>
 
 #include <asm/page.h>
-- 
2.35.1



