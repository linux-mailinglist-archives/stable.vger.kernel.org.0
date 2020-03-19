Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA87818B50A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgCSNPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbgCSNPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 460C820724;
        Thu, 19 Mar 2020 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623701;
        bh=2q5Dbnw8yuYhpC51sZqaU+VAAYD5B118pBrqWpIekxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNGIIp+z12c/s4X9X3C2UkvYGzGGU3llZOLora955GGygumkZDRDSAjgDscaC3BmV
         3HLigi7q3uYtKZlvnh1lycBSodW4l2J9ytz0PwDgjAX2syNqlKEhoNBTovigyd8+4d
         5HXzUu+MtC/r7vrKfQPzyzhM3WuHIQfUqT1nePHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 24/99] team: add missing attribute validation for port ifindex
Date:   Thu, 19 Mar 2020 14:03:02 +0100
Message-Id: <20200319123949.092095384@linuxfoundation.org>
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
@@ -2207,6 +2207,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_M
 	[TEAM_ATTR_OPTION_CHANGED]		= { .type = NLA_FLAG },
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
+	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)


