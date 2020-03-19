Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF4018B3E8
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCSNFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgCSNFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893AA20732;
        Thu, 19 Mar 2020 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623110;
        bh=b5TTVW7188gt4/nG313X27wCLCsYHEoj3altvGYn27I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/1fq21SKe7Bo9j5y4rPTjreXO/Fo2zuFvgrJQt5If30MPGCl+SwetzX8GEObUtC6
         dsr6M3JHBMXdz/4G3vyYIcXnqqWZbreULFWdwgeouGxZoePXxTzd5xR609Aah/jnea
         BA4i25D5HeBKHKEALyrSBPprSCR6E5gOqkAsrgbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 11/93] nfc: add missing attribute validation for vendor subcommand
Date:   Thu, 19 Mar 2020 13:59:15 +0100
Message-Id: <20200319123928.455727652@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
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
@@ -64,6 +64,8 @@ static const struct nla_policy nfc_genl_
 				     .len = NFC_FIRMWARE_NAME_MAXSIZE },
 	[NFC_ATTR_SE_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_SE_APDU] = { .type = NLA_BINARY },
+	[NFC_ATTR_VENDOR_ID] = { .type = NLA_U32 },
+	[NFC_ATTR_VENDOR_SUBCMD] = { .type = NLA_U32 },
 	[NFC_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 
 };


