Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06748261D44
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgIHTea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730998AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612D223C81;
        Tue,  8 Sep 2020 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579381;
        bh=MriHG1BLygmaZMuMK3vky09rXD0UTyfXkSs0tB3nb7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yg1Z3zISStLsa3NLcFobvyN4jD3a/321/TwZIyxgGoFUwYvcUkCKYROaBmyARF1br
         9YNfIuz+UmR165r2pS/i9c68RTeWuFb6Q+lhzmQML1ca122tJM2RcluGwZ0g2/zB4/
         qSp/mDiwxfj7QehMHAZ0zxYud8+uFuQTWHP4I9Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 055/186] netfilter: nf_tables: incorrect enum nft_list_attributes definition
Date:   Tue,  8 Sep 2020 17:23:17 +0200
Message-Id: <20200908152244.338875805@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
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
index 4565456c0ef44..0b27da1d771ba 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -133,7 +133,7 @@ enum nf_tables_msg_types {
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



