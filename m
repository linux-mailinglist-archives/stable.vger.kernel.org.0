Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3343ED588
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhHPNMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237215AbhHPNIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55C4B632C0;
        Mon, 16 Aug 2021 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119237;
        bh=+8+I/aHfhTxU6u0ECwrMbi1S1XkESYbRawlupUyyV7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4HyfbKL+vhcbVQmcdKFEJJqvfBWWMsS8LwceQpBW82U5rpy+zkABal2XKM+i5yHX
         +Ukzd2OXUyLjt0WXKK1Q6GFSMcDWB/LdQ989zKo5NrH3zu7cBL9xV/FoueSH9Mdnf1
         KsgDrS7hcP5aOibblkFj7AQQ5WKWyRVvQRBz4U9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/96] psample: Add a fwd declaration for skbuff
Date:   Mon, 16 Aug 2021 15:01:56 +0200
Message-Id: <20210816125436.494334290@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit beb7f2de5728b0bd2140a652fa51f6ad85d159f7 ]

Without this there is a warning if source files include psample.h
before skbuff.h or doesn't include it at all.

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Link: https://lore.kernel.org/r/20210808065242.1522535-1-roid@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/psample.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/psample.h b/include/net/psample.h
index 68ae16bb0a4a..20a17551f790 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -18,6 +18,8 @@ struct psample_group *psample_group_get(struct net *net, u32 group_num);
 void psample_group_take(struct psample_group *group);
 void psample_group_put(struct psample_group *group);
 
+struct sk_buff;
+
 #if IS_ENABLED(CONFIG_PSAMPLE)
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
-- 
2.30.2



