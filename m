Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929ED18B751
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgCSNPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgCSNPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48BF20724;
        Thu, 19 Mar 2020 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623704;
        bh=ADkIHwvZEhovUlJ4V3u1rGSb3YPotjMy4SJysm5AF6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aACFpffzXK3DfDPdH9NAXeBeWsP0TCToDeT6nooIeAvKsvskhp5ioES54fc7twzJ7
         hN2JszMFAbcGpfflJ8gX6VZRxVJURU/LXrsr6FKa/3tTpH3AeklxgrcKN0LR1kOOXG
         L8/AcSqy9MvNt/HDHC3PEWby/NW4T1qWV6xALkA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 25/99] team: add missing attribute validation for array index
Date:   Thu, 19 Mar 2020 14:03:03 +0100
Message-Id: <20200319123949.365925458@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 669fcd7795900cd1880237cbbb57a7db66cb9ac8 ]

Add missing attribute validation for TEAM_ATTR_OPTION_ARRAY_INDEX
to the netlink policy.

Fixes: b13033262d24 ("team: introduce array options")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2208,6 +2208,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_M
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
 	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
+	[TEAM_ATTR_OPTION_ARRAY_INDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)


