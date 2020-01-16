Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF57A13F56B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389260AbgAPS4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:56:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389160AbgAPRHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34DE822522;
        Thu, 16 Jan 2020 17:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194443;
        bh=Fdu8TQpO1tEs/+OcMpBLTyKdUUXXKVkzyXLjzKgtZ2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+rbqetvGz0SwJKdjHoB8BIl1y4v2rW9MwMZb9DiHwTmKOXOKrttaA0U+bnlMP/GX
         tKDcBQJ/UKdTW5n7SVv6yJ4JbwS+hqAyE0W3+pDDQAOfmh9EEpMwF/DfuLjQRoXGPU
         SQqJM37xj7roM9QGBMLQ5PVr1W7U+wIWIYRAh3r0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH AUTOSEL 4.19 355/671] netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value
Date:   Thu, 16 Jan 2020 11:59:53 -0500
Message-Id: <20200116170509.12787-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 92285a079eedfe104a773a7c4293f77a01f456fb ]

should be same as NFT_LOGLEVEL_AUDIT, so use -, not +.

Fixes: 7eced5ab5a73 ("netfilter: nf_tables: add NFT_LOGLEVEL_* enumeration and use it")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 325ec6ef0a76..5eac62e1b68d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1128,7 +1128,7 @@ enum nft_log_level {
 	NFT_LOGLEVEL_AUDIT,
 	__NFT_LOGLEVEL_MAX
 };
-#define NFT_LOGLEVEL_MAX	(__NFT_LOGLEVEL_MAX + 1)
+#define NFT_LOGLEVEL_MAX	(__NFT_LOGLEVEL_MAX - 1)
 
 /**
  * enum nft_queue_attributes - nf_tables queue expression netlink attributes
-- 
2.20.1

