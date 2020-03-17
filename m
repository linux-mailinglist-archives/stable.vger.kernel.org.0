Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FB7188121
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgCQLL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgCQLLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5662206EC;
        Tue, 17 Mar 2020 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443485;
        bh=h/kIjDv2xTNpT4MgTWA/Bf85z2gj7vvs8SRL/Gxd+Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMFieO2qqMrwb2CGYI+dFnivcqj/Ab6wrvQpLUWR7mBHFsZ41eXgnN8g7MRPhQDOs
         1GDsqqn9IF7NWkVp4xtP6eYH4frcwwJ1+MIGekHmqy8kERC1sdRXwpr1DB2z9q0sfc
         eUHWt3ElosKJ1b+KuWVniSvCvf6O4oZI+pUavsBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 061/151] nfc: add missing attribute validation for vendor subcommand
Date:   Tue, 17 Mar 2020 11:54:31 +0100
Message-Id: <20200317103330.870451237@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6ba3da446551f2150fadbf8c7788edcb977683d3 ]

Add missing attribute validation for vendor subcommand attributes
to the netlink policy.

Fixes: 9e58095f9660 ("NFC: netlink: Implement vendor command support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -46,6 +46,8 @@ static const struct nla_policy nfc_genl_
 				     .len = NFC_FIRMWARE_NAME_MAXSIZE },
 	[NFC_ATTR_SE_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_SE_APDU] = { .type = NLA_BINARY },
+	[NFC_ATTR_VENDOR_ID] = { .type = NLA_U32 },
+	[NFC_ATTR_VENDOR_SUBCMD] = { .type = NLA_U32 },
 	[NFC_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 
 };


