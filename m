Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2203A2666FC
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgIKRgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgIKMxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:53:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229F422207;
        Fri, 11 Sep 2020 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828803;
        bh=uSb8C13w13wjjf8j9yWAfgsPzepRHcI0SMTOKWGF890=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zO4cAGPcrUvhTxW0rMKdUKD6PRxiciNJS7Z7ANvdotDFx4Gs7eEZBx1n4bCPVPF1Y
         q7KCttm+HgoaGpPjMgzsuqZmCpe8w8mzLs/pO8M6oHz3IgkoqNoGGXJ1rXlbNtFK9v
         OjxlsSflzCMNRCmn1+uadvcSTXQGwYnKigOeAVYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/62] netfilter: nf_tables: incorrect enum nft_list_attributes definition
Date:   Fri, 11 Sep 2020 14:45:56 +0200
Message-Id: <20200911122503.052822823@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit da9125df854ea48a6240c66e8a67be06e2c12c03 ]

This should be NFTA_LIST_UNSPEC instead of NFTA_LIST_UNPEC, all other
similar attribute definitions are postfixed with _UNSPEC.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d8c8a7c9d88a7..b0a1c33d4a153 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -111,7 +111,7 @@ enum nf_tables_msg_types {
  * @NFTA_LIST_ELEM: list element (NLA_NESTED)
  */
 enum nft_list_attributes {
-	NFTA_LIST_UNPEC,
+	NFTA_LIST_UNSPEC,
 	NFTA_LIST_ELEM,
 	__NFTA_LIST_MAX
 };
-- 
2.25.1



