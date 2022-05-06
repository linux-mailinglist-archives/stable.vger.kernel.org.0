Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66D51DE58
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444201AbiEFR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 13:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444199AbiEFR2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 13:28:55 -0400
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EC4D6D944;
        Fri,  6 May 2022 10:25:11 -0700 (PDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 9923C72C8FA;
        Fri,  6 May 2022 20:25:10 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by imap.altlinux.org (Postfix) with ESMTP id 4885B4A46EE;
        Fri,  6 May 2022 20:25:10 +0300 (MSK)
From:   Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition
Date:   Fri,  6 May 2022 17:24:54 +0000
Message-Id: <20220506172454.120319-1-glebfm@altlinux.org>
X-Mailer: git-send-email 2.33.3
In-Reply-To: <20220506171534.99509-1-glebfm@altlinux.org>
References: <20220506171534.99509-1-glebfm@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes: 54f586a91532 ("rfkill: make new event layout opt-in")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
---
 include/uapi/linux/rfkill.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 283c5a7b3f2c..db6c8588c1d0 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -184,7 +184,7 @@ struct rfkill_event_ext {
 #define RFKILL_IOC_NOINPUT	1
 #define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
 #define RFKILL_IOC_MAX_SIZE	2
-#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_EXT_SIZE, __u32)
+#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_MAX_SIZE, __u32)
 
 /* and that's all userspace gets */
 
-- 
glebfm

