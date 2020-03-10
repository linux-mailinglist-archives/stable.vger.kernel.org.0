Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D083B17FEBC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCJMlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgCJMlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E12246A1;
        Tue, 10 Mar 2020 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844067;
        bh=yF4Ztizqe6OAY18YyV2d1eE+3ZkYoQOuvreLCSvwfoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcA0SyximazwgIlRN0jKVSHjgfmq8+RrHYZOsnVzsLM2R6XwM/kIVVTT05VHMHmhU
         IuFm73ipSqIliCR1cTuU8GzCOopttSK+OOyPBfLErR4vEDHJgwlmdBFYCzKeDu8kPE
         QIjPJB7KACnWaxv6XwW0hAZX4nkbwbbUgR+jBPUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/72] cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE
Date:   Tue, 10 Mar 2020 13:38:22 +0100
Message-Id: <20200310123603.945548066@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit ea75080110a4c1fa011b0a73cb8f42227143ee3e ]

The nl80211_policy is missing for NL80211_ATTR_STATUS_CODE attribute.
As a result, for strictly validated commands, it's assumed to not be
supported.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Link: https://lore.kernel.org/r/20200213131608.10541-2-sergey.matyukevich.os@quantenna.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd0bf278067ef..4b30e91106d07 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -330,6 +330,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CONTROL_PORT_ETHERTYPE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
+	[NL80211_ATTR_STATUS_CODE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
-- 
2.20.1



