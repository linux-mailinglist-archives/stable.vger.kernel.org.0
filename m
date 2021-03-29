Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE9634C9A0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhC2Iaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhC2I3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:29:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E87D2614A7;
        Mon, 29 Mar 2021 08:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006556;
        bh=loSHwK2MBX8jk4o2QA+i+HmRZZgkfxNoedrsqCKiIZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grV98Mfd1sio99mrxH3LdAYdWj22MVrY/INAZeIMM47sAxVnExO+EyAqQoQDCEv46
         TWMd0NYPVUG/D9aYJBBneoSPABpGQj6EW3w0GAgEPB/uEzZ9HubHD2FIjR6KbKThBF
         /fx9eHYS/TXGOJewVBDUud/NiCiAp3YhwUin0CAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 039/254] kselftest: arm64: Fix exit code of sve-ptrace
Date:   Mon, 29 Mar 2021 09:55:55 +0200
Message-Id: <20210329075634.432140701@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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



