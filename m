Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B2359AE5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhDIKDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233883AbhDIKBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843D96100B;
        Fri,  9 Apr 2021 09:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962372;
        bh=468E9xolqwqaMx889QTebTC2v0UfCzdw38F83fOG2kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gp5nJMOy92CaCRVer8DnBvruS6TDqfT6yl+xK8eBnWQOo7/JeQ+BeQ+WBXCsBvvoK
         EBTKGQltFyMyEZJZqa/flb3DI42AJMKCDQpFVKDx0pyXsFz55YyhNhIEEu0ArxqABU
         89KeKaNzz0YCYI3Z9bp9y/nvyGfmcvQk4rtJJa0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/41] math: Export mul_u64_u64_div_u64
Date:   Fri,  9 Apr 2021 11:53:53 +0200
Message-Id: <20210409095305.811484624@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

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
2.30.2



