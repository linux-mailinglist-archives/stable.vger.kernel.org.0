Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5457326196B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbgIHSOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731490AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55CB24801;
        Tue,  8 Sep 2020 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579787;
        bh=qp8RZsd2aYv6FgQdLh75U8iYJJYma6uoW2beJd6jk+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFZ0CHEmQHfmjgR9RFfN8GLTh217W6yWDD/9WX3G1lCOb7ATrV5+N8jJNo8jn5NuP
         t3/pdFLTkZA+Sqydh7Eu74LieZ6jvaig7bAwfZ9CCGHqy5rinBK0xGak2WV49CjGV0
         QNFodGfnHo16GD3PkQ474qQMnDcFBD62ohrNqH+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/129] netfilter: nf_tables: incorrect enum nft_list_attributes definition
Date:   Tue,  8 Sep 2020 17:24:34 +0200
Message-Id: <20200908152231.344748837@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
index ed8881ad18edd..0a995403172cc 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -132,7 +132,7 @@ enum nf_tables_msg_types {
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



