Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A5D34C7F1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhC2IS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhC2ISB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73CED61878;
        Mon, 29 Mar 2021 08:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005881;
        bh=loSHwK2MBX8jk4o2QA+i+HmRZZgkfxNoedrsqCKiIZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14+sHNvze6TG9ZXZqngPoK4/5Z8UfExo7Nd9ltlTilXHUrc5R8RGLxhfbnMatJlqA
         2PIFSFf3ozdAm17SunOxi3V3T+9EO4UcxLoj+3FBg57Q0v5DOngqIfYhttVfG4EbdL
         2y/Rgbz3Fl3hxsL5ZGwTsaUrDIrwtDXrMFBlu71w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/221] kselftest: arm64: Fix exit code of sve-ptrace
Date:   Mon, 29 Mar 2021 09:56:10 +0200
Message-Id: <20210329075630.477963919@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



