Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D4318B82B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCSNFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbgCSNFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ECE820732;
        Thu, 19 Mar 2020 13:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623137;
        bh=jBcCmIgf2q+xSIB1k4q5k3egNWDT3t1/n/FY+t+dslk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTXwAQ2HX6ejD6yvM3ngEssfkEYTufT6IqlA+zdRFS0EGFi/PBFt9y5OEB5Qn9Zi7
         3wDlspG6et0uRCT9DRvU9xMn96dAXmcLmK2PGUFxO1psutza4PBdjGp4ylxG5ZA3aH
         LnhcZY/pJcghu4Eg81PNu3CJ5By76M9Ol8eYVZi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 08/93] team: add missing attribute validation for port ifindex
Date:   Thu, 19 Mar 2020 13:59:12 +0100
Message-Id: <20200319123927.576702532@linuxfoundation.org>
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

[ Upstream commit dd25cb272ccce4db67dc8509278229099e4f5e99 ]

Add missing attribute validation for TEAM_ATTR_OPTION_PORT_IFINDEX
to the netlink policy.

Fixes: 80f7c6683fe0 ("team: add support for per-port options")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2169,6 +2169,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_M
 	[TEAM_ATTR_OPTION_CHANGED]		= { .type = NLA_FLAG },
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
+	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)


