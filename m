Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3551418813E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgCQLJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgCQLJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D1F0205ED;
        Tue, 17 Mar 2020 11:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443340;
        bh=GwI3gY1sXrC3gZXxwYXmVKTzAnQwUmakGOz+AjeK0GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgYXVuC/LSRw/9hzopzsXxQkgNlNQBg+jXg7LQISUUba6nZ46qC/T5WyrdTvhEeMj
         KuRR9PsSW4N12etZGc+1EkehU5PKnU2f76Rp7HUdvII0jPqU/NmqeNzczQmAN1ed7V
         VFkkjg8WTM1iKGrI/DGD6XzM9kZ6bHFvkPlcupXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 050/151] nl802154: add missing attribute validation for dev_type
Date:   Tue, 17 Mar 2020 11:54:20 +0100
Message-Id: <20200317103330.141505183@linuxfoundation.org>
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
@@ -27,6 +27,7 @@ const struct nla_policy ieee802154_polic
 	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_DEV_TYPE] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
 	[IEEE802154_ATTR_COORD_PAN_ID] = { .type = NLA_U16, },


