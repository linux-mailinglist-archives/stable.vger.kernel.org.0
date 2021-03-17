Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9137C33E417
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCQA6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhCQA5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E626E64FE3;
        Wed, 17 Mar 2021 00:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942659;
        bh=loSHwK2MBX8jk4o2QA+i+HmRZZgkfxNoedrsqCKiIZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRCB2a5JyblMnXMCZAB9jcifpWCSQqKTT0mPp5RC1WyP2OiK5KvTD6PtLa8f9XrtY
         fRdLgcTmhmYkF1zs1ooZpD4qktFMkDPFb0pyYaxf7JkOY8a4olCC+Kc6Wrv1Gn43FT
         0hRfkNapG7e0FGP3pgISGhKznRLAg72pEWWMaglO2ObSayLtVHfrFkzst4ESPEvH+P
         Ex2LFfVt1I79dUy4P+OeuyBv8luSHsItc6Q1AUDzpFU8hc3AHq6KkaXhJmMt8a2QHr
         D69DHO0NoXAUGZhh+3R/MjBC9ZS1U11coGTLFKnqnDKWoQu30tdgmMiVtmrM+dDsB8
         jp11C5OhqxzBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 37/54] kselftest: arm64: Fix exit code of sve-ptrace
Date:   Tue, 16 Mar 2021 20:56:36 -0400
Message-Id: <20210317005654.724862-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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

