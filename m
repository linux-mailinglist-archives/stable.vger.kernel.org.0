Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4278148188
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390971AbgAXLUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390751AbgAXLUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:20:47 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC657206D4;
        Fri, 24 Jan 2020 11:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864846;
        bh=eWyQCUum57864Lrr+ixe+YZ2NxOYY9VKc0e8YZEM39o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKhigGQOy/3wcMUtqQZAMivXbDNBBfnFlka7WCaNie02nTrBiq/VHLJ8rQHKd7JIl
         /jeUJGdNyIkLuI2mA1vl24QSHlG6GDLRL5/GUHZN7JtlgqA7IIstObYml+uhjrVntB
         5Sc8oOulzPYf9Vi5T3RjAOaFPlHG3ST+BfA/cqKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 370/639] netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value
Date:   Fri, 24 Jan 2020 10:29:00 +0100
Message-Id: <20200124093133.398042147@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 325ec6ef0a764..5eac62e1b68d5 100644
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



