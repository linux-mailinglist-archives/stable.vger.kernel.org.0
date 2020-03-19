Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77F218B407
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCSNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbgCSNGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CCCD20732;
        Thu, 19 Mar 2020 13:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623168;
        bh=TR6pipZLEliX57JMcvym6sJGsYd66ngAeILcBPDXjC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wN8tgut1CMLPIqtnp4zOdTwAktaDGfPzCSUFjFKh3R/FrUrOn15x3gS9IsJyuVHtv
         Iq1Xhq/3ACPpT2e/5vXYvB8GH/sckJCq/eK+kdK325hHPvI2pZe4qIVAa9SGcQezwb
         goo122quwHIu/35l5UdhR3GmghPioQgUwJ5en/n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 31/93] nl80211: add missing attribute validation for channel switch
Date:   Thu, 19 Mar 2020 13:59:35 +0100
Message-Id: <20200319123934.915512433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 5cde05c61cbe13cbb3fa66d52b9ae84f7975e5e6 upstream.

Add missing attribute validation for NL80211_ATTR_OPER_CLASS
to the netlink policy.

Fixes: 1057d35ede5d ("cfg80211: introduce TDLS channel switch commands")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-4-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -431,6 +431,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_OPER_CLASS] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },


