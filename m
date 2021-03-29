Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACBA34DACC
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhC2WXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhC2WWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA5DC61999;
        Mon, 29 Mar 2021 22:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056541;
        bh=U1OIyu+mTgJLsAtO74cQhfi++WuRnr963XcdDdVrIcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoE1B1G2l8zvpm1vtemnejSMF7V7xiQp394czVc9G0HTZHR7UlZ3IMJaLY2N6BIos
         BQaQBxzhhD9yN2eHtRWVpckyrvjXVZz4w1NohfNa9IKXeazF1qz3t2qb4ryB7sMPee
         fB1Xkm8IW+5TcrYCLFzGBid4jNAgvFWMWMhnmbTWhjzHeFgEPSF1MIzSirNLLsOkUf
         1oSkoHL1nCmDIfwOh044Zx6JUuyFQhTKXZ1tcN+ROGQb0FIsdlaCg8w/r27oqCJcY4
         O6Oqp78x3DOVbveO6cWQMRLhRL3O90pkF9++Qe0kzGfVY3vSU3IgqnkUKczOUozvjG
         AS8hW9bqpXSog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 38/38] math: Export mul_u64_u64_div_u64
Date:   Mon, 29 Mar 2021 18:21:33 -0400
Message-Id: <20210329222133.2382393-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit bf45947864764548697e7515fe693e10f173f312 ]

Fixes: f51d7bf1dbe5 ("ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/math/div64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/math/div64.c b/lib/math/div64.c
index 064d68a5391a..46866394fc84 100644
--- a/lib/math/div64.c
+++ b/lib/math/div64.c
@@ -232,4 +232,5 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 c)
 
 	return res + div64_u64(a * b, c);
 }
+EXPORT_SYMBOL(mul_u64_u64_div_u64);
 #endif
-- 
2.30.1

