Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05188106ACC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfKVKiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbfKVKiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:38:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8A020717;
        Fri, 22 Nov 2019 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419100;
        bh=1hd1YxdqOSmo/ZPMrdo8EiQzXs7O4BTVZC1l95ZHnf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igEjMqtT5ruajg6Eue92NZVCxLo33mZuanhXMz+0a59Ah6nLzxBZ3IikBfWvAjMKe
         84UNs2Pm1944MV/f3d9oX6UTPO1HJ6MZhR+KoMJW72UX2K9OnGyjv1ZM0UzF2gyMuz
         7SI1KO6c2tC0Ai3CXULsd+tuji7Re94BN2H3/sCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 156/159] mac80211: minstrel: fix CCK rate group streams value
Date:   Fri, 22 Nov 2019 11:29:07 +0100
Message-Id: <20191122100848.969348509@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
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
index 239ed6e92b89d..ff3b28e7dbce8 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -128,7 +128,7 @@
 
 #define CCK_GROUP					\
 	[MINSTREL_CCK_GROUP] = {			\
-		.streams = 0,				\
+		.streams = 1,				\
 		.flags = 0,				\
 		.duration = {				\
 			CCK_DURATION_LIST(false),	\
-- 
2.20.1



