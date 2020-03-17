Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE88188000
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgCQLGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727407AbgCQLGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:06:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D228520736;
        Tue, 17 Mar 2020 11:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443179;
        bh=l+SslzW3aQwnBAb6lpZwBPLpDvnhkZu8HaV802HbA1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cY6AQjUYs7l68e+xsFm9YoQQXNkVpM5T4SLY4+uI9tGEDYAsnzEamLNtP53aLbsl3
         /BS595WNTO89/20OScDBbUibP+gqAdE3AlQG5mfGi2nUbiQsnNYFIL7IWNkVnyy77Z
         KBngWfbVd7veudFxtMlEKtiQQPow0TUhgUqb7xxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 113/123] netfilter: nft_payload: add missing attribute validation for payload csum flags
Date:   Tue, 17 Mar 2020 11:55:40 +0100
Message-Id: <20200317103318.966544234@linuxfoundation.org>
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

commit 9d6effb2f1523eb84516e44213c00f2fd9e6afff upstream.

Add missing attribute validation for NFTA_PAYLOAD_CSUM_FLAGS
to the netlink policy.

Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_payload.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -121,6 +121,7 @@ static const struct nla_policy nft_paylo
 	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,


