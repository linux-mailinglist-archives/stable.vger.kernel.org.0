Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7FF187EEB
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCQK5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCQK5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE75B2073E;
        Tue, 17 Mar 2020 10:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442628;
        bh=tIDuFIuCHpKAC0CNL2sqNH/zangInW0CyT/NEaHTTQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VB5BFk/ltKgYLc7J/fwozDbN124dCYmZez7gRu4n84RY/VObBJYe10LS9WIyvc/7p
         wSMKMHb/5DElF4S9cv4GnTLbWjzh5oBqyDBFnQPpB0pxMo2DM05ik9yqd7YJw5SA29
         N/1L7zNYM/sda6jkr72s/5NspOwN6gB3jMDljcwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 27/89] nl802154: add missing attribute validation for dev_type
Date:   Tue, 17 Mar 2020 11:54:36 +0100
Message-Id: <20200317103303.021442576@linuxfoundation.org>
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

[ Upstream commit b60673c4c418bef7550d02faf53c34fbfeb366bf ]

Add missing attribute type validation for IEEE802154_ATTR_DEV_TYPE
to the netlink policy.

Fixes: 90c049b2c6ae ("ieee802154: interface type to be added")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl_policy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ieee802154/nl_policy.c
+++ b/net/ieee802154/nl_policy.c
@@ -36,6 +36,7 @@ const struct nla_policy ieee802154_polic
 	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_DEV_TYPE] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
 	[IEEE802154_ATTR_COORD_PAN_ID] = { .type = NLA_U16, },


