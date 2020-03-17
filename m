Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605E1188209
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgCQK7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbgCQK7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9141420757;
        Tue, 17 Mar 2020 10:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442759;
        bh=NJ3VBxsbkJ2nRjiRJuZezISDL5eV2Iu2tM7LeVd/8iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbUYO9r5aKyVMJjtGZD90dGgNoNN9K2tS/oAxmV5Q2bWBd8y/H7dXSxIlpjNsJTkL
         ArdAaiCJND65knFooeGHrVLA6f60sEGKysEXAHkvzjr4G//rq5SAWBo+IOYipZdfSz
         RuPeaUBUaM+c3lNC6X0xH/A6ZWFgMHNoIe1NTtvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 34/89] nfc: add missing attribute validation for deactivate target
Date:   Tue, 17 Mar 2020 11:54:43 +0100
Message-Id: <20200317103303.794124420@linuxfoundation.org>
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

[ Upstream commit 88e706d5168b07df4792dbc3d1bc37b83e4bd74d ]

Add missing attribute validation for NFC_ATTR_TARGET_INDEX
to the netlink policy.

Fixes: 4d63adfe12dd ("NFC: Add NFC_CMD_DEACTIVATE_TARGET support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -44,6 +44,7 @@ static const struct nla_policy nfc_genl_
 	[NFC_ATTR_DEVICE_NAME] = { .type = NLA_STRING,
 				.len = NFC_DEVICE_NAME_MAXSIZE },
 	[NFC_ATTR_PROTOCOLS] = { .type = NLA_U32 },
+	[NFC_ATTR_TARGET_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_COMM_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_RF_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_DEVICE_POWERED] = { .type = NLA_U8 },


