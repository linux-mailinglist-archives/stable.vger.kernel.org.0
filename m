Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D3B187F2F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCQK7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgCQK7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01BA120658;
        Tue, 17 Mar 2020 10:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442752;
        bh=fKFixO4x7tSiOPMbkZ5ccIwBp4+3bjT5G+OXtVOn+94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QO4Cc+EkBwfyCNCr+tCIfOW10gXcmoI0HKDJPstvz8hHicTDY5UmpVSujcjx62cA3
         ZgPK31/keZNoIB1jTLPzXP2vw7mKO+UD3QB2vTktubtRYm/BSPVgl6QZRSHMPF3PUc
         aJD5zz41aFy4tBGX6MzpD16nEE9XfIJd50pE7swY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 32/89] team: add missing attribute validation for array index
Date:   Tue, 17 Mar 2020 11:54:41 +0100
Message-Id: <20200317103303.579946922@linuxfoundation.org>
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
@@ -2216,6 +2216,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_M
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
 	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
+	[TEAM_ATTR_OPTION_ARRAY_INDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)


