Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625B31880F3
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgCQLOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729574AbgCQLOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:14:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F1F20663;
        Tue, 17 Mar 2020 11:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443645;
        bh=OZ4tA3swY5p/fXXjR+dJe6w7K3IHPibdXnOGpcN37IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7c7XHMMevh4Il5YY7YgrNeArsjpwSDsvYK02u4j8NLlcVUTJrxHkij+20HcMc0he
         etfyWC34/aaxanQyk04XwWVciB4vdMdqfk7Hzc3tgVxId2XS4tE6vySTZ/95Bq+4Ey
         6IZlMePX0z1S1B9HB7hwMXgLv2TuwjkSisyWMdO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 136/151] nl80211: add missing attribute validation for critical protocol indication
Date:   Tue, 17 Mar 2020 11:55:46 +0100
Message-Id: <20200317103336.088171769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 0e1a1d853ecedc99da9d27f9f5c376935547a0e2 upstream.

Add missing attribute validation for critical protocol fields
to the netlink policy.

Fixes: 5de17984898c ("cfg80211: introduce critical protocol indication from user-space")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-2-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -530,6 +530,8 @@ const struct nla_policy nl80211_policy[N
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_CRIT_PROT_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_MAX_CRIT_PROT_DURATION] = { .type = NLA_U16 },
 	[NL80211_ATTR_PEER_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },


