Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0545A34DAE3
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhC2WXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhC2WXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E469C61985;
        Mon, 29 Mar 2021 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056582;
        bh=QqJ6V7p29A6hy7pO13lJp8FLfBtD/z01iqplRdElkxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puTeDPn64+pPQTsAaP6FWNjNleJ33mjVh1/unMEprm5+nFS4gNbh++0keQvXbXZ3D
         gCXttHvnyW5RqzKdZTM9d1M9bpMjGat9NLuoGFmKO0n3C9cbqlS8DLNmPLOLu223Um
         ndZUx5CavOXp5fevr5JWasCN01NkI8vBrspo5FkMKVSNH/pDBk2LF/oHAr58WzU42r
         UTZW1xXEKgtsx1SlBVWvWPlWuqFugyJwTOkX5FuXopY6ie89IUmG+v0R8yaAe/r7Y3
         AE2QbYOr+6OFGgLE6EUp4ZBTeAzMk5e7byvOcd0lNBUz20bhtvX5hN4idObL16RIS7
         lRJy/pBIpWHMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 33/33] math: Export mul_u64_u64_div_u64
Date:   Mon, 29 Mar 2021 18:22:21 -0400
Message-Id: <20210329222222.2382987-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
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
index 3952a07130d8..edd1090c9edb 100644
--- a/lib/math/div64.c
+++ b/lib/math/div64.c
@@ -230,4 +230,5 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 c)
 
 	return res + div64_u64(a * b, c);
 }
+EXPORT_SYMBOL(mul_u64_u64_div_u64);
 #endif
-- 
2.30.1

