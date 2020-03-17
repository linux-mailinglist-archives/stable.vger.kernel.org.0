Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BB5187FF3
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgCQLFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgCQLFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF4820714;
        Tue, 17 Mar 2020 11:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443143;
        bh=jg9wXEWMykp+JAjQyfJSxokQ/arLStUhwMarpSaa9Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neJLVPme66qKixsf+RF5Oakl5WA/0DwJuaUHHI7xacSielO2bK8Yfjabk5IqnQDo+
         AjAj+bpEmpGodas79W9HSqBf1daNW8mNB6U40r4kCV5JCeIcb7D4QvRCrPqSVf4FBu
         8/DqABQbDTn9frAHee5vulrhAcnl+G6C3ni41WDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 110/123] nl80211: add missing attribute validation for channel switch
Date:   Tue, 17 Mar 2020 11:55:37 +0100
Message-Id: <20200317103318.723944780@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
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
@@ -564,6 +564,7 @@ const struct nla_policy nl80211_policy[N
 		NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_UPS - 1),
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_OPER_CLASS] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = {
 		.type = NLA_EXACT_LEN_WARN,
 		.len = ETH_ALEN


