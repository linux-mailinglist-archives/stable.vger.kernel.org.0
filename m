Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17C43F670B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbhHXRaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241177AbhHXR1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C037361B51;
        Tue, 24 Aug 2021 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824710;
        bh=bdMqeNruXNSyZwU7+lLh6nBG1X8uOSUfq93Zz8T8JH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyE1HIeX1usi0jZykUxhbV0MIFccOwveHZN2cMDqJE7+wjI2QfvzjT3gJHHr2IWCD
         A9WLw5WZ18t8Bs+U4vTcxfoGbmqGqdMDBJJhssLC5gHnFrtgRl4QlTTmC4eyngOyfj
         O49EyQ/RC458HNyKxT18ud6rv1vCYJ+y06WmyfTLYZMIMQJhNqRhOFV9dJZuaeN4YT
         OwXiumzuFEs+n6OGpnWBdUxARamrrM63ws+cLbenZhy1tP4azPe9M8DCDLmMGXVp2u
         Wzq/edOvRPbbLt47F//Vg0Iu+00kBWSEElzclDyXq0ehe1uzXIyQdhlIQwGbopC2yU
         K0boOo+t3TOdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/64] psample: Add a fwd declaration for skbuff
Date:   Tue, 24 Aug 2021 13:04:05 -0400
Message-Id: <20210824170457.710623-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 94cb37a7bf75..796f01e5635d 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -18,6 +18,8 @@ struct psample_group {
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
 void psample_group_put(struct psample_group *group);
 
+struct sk_buff;
+
 #if IS_ENABLED(CONFIG_PSAMPLE)
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
-- 
2.30.2

