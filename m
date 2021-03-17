Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054D233E394
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhCQA5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230410AbhCQA4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B049464FAE;
        Wed, 17 Mar 2021 00:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942583;
        bh=loSHwK2MBX8jk4o2QA+i+HmRZZgkfxNoedrsqCKiIZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YV2Lg8y2uwicFNZI0+8HxVgreKQNKHt5gHOZhHohVRtb3GjcL4cGWLuNhR3IRPOxl
         Wy0FmNGSMwcQ1SfPKT8KfTxFqSjor9TGqTAU83YsjWOw+8uR6/GM1u2YvU1z4m/KTc
         lzEZ23bhLfTXdAaxC9bFxVj9oaYF+xzqo5nFgcincx4ctHkMbCL1vfJYdKCdnzJpEO
         x949tcv0r4LhSh/o/AM6bELfogHKJ2W5JUEAr17H23YmJXnZoG/1UezH61Ni2YQ3mc
         jPJrlTAFkqUH/+vtpdfNR0LrZoYEmx+2P2ppxyBcSwpbVNNCXCKf3lDJCTW80vT5UT
         MaILj/xqvq6Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 39/61] kselftest: arm64: Fix exit code of sve-ptrace
Date:   Tue, 16 Mar 2021 20:55:13 -0400
Message-Id: <20210317005536.724046-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 07e644885bf6727a48db109fad053cb43f3c9859 ]

We track if sve-ptrace encountered a failure in a variable but don't
actually use that value when we exit the program, do so.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210309190304.39169-1-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index b2282be6f938..612d3899614a 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -332,5 +332,5 @@ int main(void)
 
 	ksft_print_cnts();
 
-	return 0;
+	return ret;
 }
-- 
2.30.1

