Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396AE1E586C
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 09:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgE1HWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 03:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE1HWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 03:22:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC2BA20B80;
        Thu, 28 May 2020 07:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590650539;
        bh=3XjTnBlMk1giv4BLPLXsPpldbAa5vuf18F09TmqotZ0=;
        h=Subject:To:From:Date:From;
        b=JB0YAS4DU8QXZJQD205J8uEU6t3PMfNxODYgEDVnR4kiJdNpg+cn/rXXnGUIpcf55
         rU+kSJqFQfB8fCWnPy0n6k2IEStojnC3YiSmQmbVSAxBok2szx/+sTFdMSxLsY92GO
         PhCILzcYvGNC/FtECOh9vMeHeJeWjiQS6mLkgRQ0=
Subject: patch "staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK" added to staging-next
To:     pterjan@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 May 2020 09:22:14 +0200
Message-ID: <1590650534202108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 15ea976a1f12b5fd76b1bd6ff3eb5132fd28047f Mon Sep 17 00:00:00 2001
From: Pascal Terjan <pterjan@google.com>
Date: Sat, 23 May 2020 22:12:47 +0100
Subject: staging: rtl8712: Fix IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK

The value in shared headers was fixed 9 years ago in commit 8d661f1e462d
("ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro") and
while looking at using shared headers for other duplicated constants
I noticed this driver uses the old value.

The macros are also defined twice in this file so I am deleting the
second definition.

Signed-off-by: Pascal Terjan <pterjan@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200523211247.23262-1-pterjan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/wifi.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/wifi.h b/drivers/staging/rtl8712/wifi.h
index be731f1a2209..91b65731fcaa 100644
--- a/drivers/staging/rtl8712/wifi.h
+++ b/drivers/staging/rtl8712/wifi.h
@@ -440,7 +440,7 @@ static inline unsigned char *get_hdr_bssid(unsigned char *pframe)
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
@@ -532,13 +532,6 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
-/* block-ack parameters */
-#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
-#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
-#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
-#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
-
 /*
  * A-PMDU buffer sizes
  * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2)
-- 
2.26.2


