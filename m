Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA018B3F4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgCSNFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbgCSNFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3885E20740;
        Thu, 19 Mar 2020 13:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623130;
        bh=crAqJyoagg8GitwByqJaPF+YkVcw17OpzZ34+rgPKAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IW7jxg6iT8slCceG83GpxuLLMECHVRIkL+jhkW8kn86T8soGrbR+rg49Rae/G585h
         Pszj6NzTzghwHrJukNi93v4ezKmepEdwxyinYYPtwBOQQe7p80FnaAIC06bS4XcT9T
         MxYnmSIN1WItcwhuEEiWftIQvqO44geuWjbPqnvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 06/93] nl802154: add missing attribute validation
Date:   Thu, 19 Mar 2020 13:59:10 +0100
Message-Id: <20200319123926.982445021@linuxfoundation.org>
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

[ Upstream commit 9322cd7c4af2ccc7fe7c5f01adb53f4f77949e92 ]

Add missing attribute validation for several u8 types.

Fixes: 2c21d11518b6 ("net: add NL802154 interface for configuration of 802.15.4 devices")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl_policy.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ieee802154/nl_policy.c
+++ b/net/ieee802154/nl_policy.c
@@ -30,6 +30,11 @@ const struct nla_policy ieee802154_polic
 	[IEEE802154_ATTR_HW_ADDR] = { .type = NLA_HW_ADDR, },
 	[IEEE802154_ATTR_PAN_ID] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_CHANNEL] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_BCN_ORD] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_SF_ORD] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_PAN_COORD] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },


