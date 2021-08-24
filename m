Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E43F6638
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhHXRVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240673AbhHXRTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB14611EF;
        Tue, 24 Aug 2021 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824586;
        bh=bdMqeNruXNSyZwU7+lLh6nBG1X8uOSUfq93Zz8T8JH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+o05xO/9XNOsc13+OUYhY0zEHAN/DcJC/Xcezx+xs6KxAwXJHB7wcX1HQNrgvuT/
         1BJZ0ZMiNcUgC6+QfWWmqE0pmu9l/f+sqvr6DsOIFay/6Rs/STQ+4Ct7DoQnjVM0bc
         opBBghydqcEhZuFzPO+4A+ze9sgKvqvizVeVFYL0iQXQyWuTIIG0I4EMYf+niPDXbP
         d5T33l+vmhIBPEDpncK92lGDHTCZKPIK0nyG6mPW46mECwkHrAZMwR+xXNg3DOb9SD
         TXh+E5yiSpyc5ShICWLb5/uw9thZwG+MznSXGESjrEfvgf4jCiFpxscLDF9sla68Jq
         EuspPjZQCctDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/84] psample: Add a fwd declaration for skbuff
Date:   Tue, 24 Aug 2021 13:01:41 -0400
Message-Id: <20210824170250.710392-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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

