Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3D8187F31
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgCQK7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbgCQK7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EF742071C;
        Tue, 17 Mar 2020 10:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442761;
        bh=aWGY0cYn8GeJA9IoDWSuvg5KNAsISLdmlUvHYoMMSM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMb4JofvkdP40rP2kEMrqh4oULB7+S1v9RtJ3x5WF6p5WLFeIOxyEy29G6NAqrkGP
         Apg45WEoA6KvtORetpZJzn/GAek3P9RWgHs9E5kgpbihymkbM6iP+JMhxJN3orRizF
         8Yzi5Cf2KVJGnurX/mO9BMFF2G2+cgmgSuHNKmHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 35/89] nfc: add missing attribute validation for vendor subcommand
Date:   Tue, 17 Mar 2020 11:54:44 +0100
Message-Id: <20200317103303.918961358@linuxfoundation.org>
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
@@ -58,6 +58,8 @@ static const struct nla_policy nfc_genl_
 				     .len = NFC_FIRMWARE_NAME_MAXSIZE },
 	[NFC_ATTR_SE_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_SE_APDU] = { .type = NLA_BINARY },
+	[NFC_ATTR_VENDOR_ID] = { .type = NLA_U32 },
+	[NFC_ATTR_VENDOR_SUBCMD] = { .type = NLA_U32 },
 	[NFC_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 
 };


