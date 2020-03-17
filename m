Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA3B188093
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgCQLLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbgCQLLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35D8205ED;
        Tue, 17 Mar 2020 11:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443480;
        bh=fGyAV7Yw7d6Dx2eyFEQUbtDjhL3f2SAPH0DtT/aCFs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2CgS1dvyy6fHLmtDGny5mCtVdkpBA7mvFZ4n+gQ24wKiMxc4bNASSopLfeH1ajHN
         k0j2uAvuB3+SDNx6VEp0ZzQgd6PkVbtwm2prYZrQY2Av4iIcgTjRQGsqzwBWUTm9N5
         Xi+YCvCzthJp4t0WXa16v8I8X2hKinbbY3vSZlEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 059/151] nfc: add missing attribute validation for SE API
Date:   Tue, 17 Mar 2020 11:54:29 +0100
Message-Id: <20200317103330.739066267@linuxfoundation.org>
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

[ Upstream commit 361d23e41ca6e504033f7e66a03b95788377caae ]

Add missing attribute validation for NFC_ATTR_SE_INDEX
to the netlink policy.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -43,6 +43,7 @@ static const struct nla_policy nfc_genl_
 	[NFC_ATTR_LLC_SDP] = { .type = NLA_NESTED },
 	[NFC_ATTR_FIRMWARE_NAME] = { .type = NLA_STRING,
 				     .len = NFC_FIRMWARE_NAME_MAXSIZE },
+	[NFC_ATTR_SE_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_SE_APDU] = { .type = NLA_BINARY },
 	[NFC_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 


