Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885FA106EFF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfKVKzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbfKVKzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2E020721;
        Fri, 22 Nov 2019 10:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420103;
        bh=T12/7retfQyoc+36Vzb58+LWVgO4QkqdGYK53unX8Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DM0RHBXCa+a906UQ6mDEMdGUaoMBBaXsat1EbmQ5pmz8yRhDNEMqRK1S8EuEXx1f2
         QSTV8QKfYMh8kaDgPcr0SNEmOzKG41ObKyJErxfNSXQ/GCiYWmXYvqAfeC8VuQ5t+F
         zX1nC1/P3+6Ob5sDT92JyMsmLdXwvFsOm13swNSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/122] mac80211: minstrel: fix CCK rate group streams value
Date:   Fri, 22 Nov 2019 11:29:28 +0100
Message-Id: <20191122100835.956227031@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 80df9be67c44cb636bbc92caeddad8caf334c53c ]

Fixes a harmless underflow issue when CCK rates are actively being used

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 25cb3e5f8b482..bc97d31907f60 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -129,7 +129,7 @@
 
 #define CCK_GROUP					\
 	[MINSTREL_CCK_GROUP] = {			\
-		.streams = 0,				\
+		.streams = 1,				\
 		.flags = 0,				\
 		.duration = {				\
 			CCK_DURATION_LIST(false),	\
-- 
2.20.1



