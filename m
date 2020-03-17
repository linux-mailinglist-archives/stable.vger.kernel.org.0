Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC81881D4
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgCQLA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbgCQLA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:00:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F542205ED;
        Tue, 17 Mar 2020 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442827;
        bh=LW5w64SLdBwL8T9RXfGhhZjZsqczabeKN+f5KV5G93Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccNNaoJaoUyfn4aDwJaZE4SoJzOduMM/iIghaN9Bj/86nbjbj1cTLFg/UO8B5AUvr
         BDvAxdrZsvQiZcKFlYK00I3pygzd3MsaevOo50VaSvOaGgjkmCPsFkmIpLH/WMDpfl
         lSFbcmuVEM10+OwXaXaY4wQCpYp7Y/2rGIF/5aNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 76/89] nl80211: add missing attribute validation for beacon report scanning
Date:   Tue, 17 Mar 2020 11:55:25 +0100
Message-Id: <20200317103308.822677678@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 056e9375e1f3c4bf2fd49b70258c7daf788ecd9d upstream.

Add missing attribute validation for beacon report scanning
to the netlink policy.

Fixes: 1d76250bd34a ("nl80211: support beacon report scanning")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-3-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -349,6 +349,8 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_PLINK_STATE] = { .type = NLA_U8 },
+	[NL80211_ATTR_MEASUREMENT_DURATION] = { .type = NLA_U16 },
+	[NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_REKEY_DATA] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SUPP_RATES] = { .type = NLA_NESTED },


