Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA0A2E3C86
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437216AbgL1ODr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437185AbgL1ODq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EE7E207A9;
        Mon, 28 Dec 2020 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164185;
        bh=rfExsww83arYKhUC20ckG0nEuoMmRNcFwTtyPdSk7UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTl5pjtk7nFkeYwQTNaE6V9PLf7i0pDCkQF0h+8UbtgKAiZnW+XrbKshMD3oCgJ/W
         KylmcavL4/cMvimwEwCx1cFDQo6sTsan8tY/Hag90vsKHsMg5uhc6bQQB/yUjdtX3E
         Vhr2d/JKvRxZpjznNVSc6Md9RxQ7QLuUkdElPC10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/717] selftests/run_kselftest.sh: fix dry-run typo
Date:   Mon, 28 Dec 2020 13:41:30 +0100
Message-Id: <20201228125025.383373808@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 93f20eff0cca972d74cb554a2e8b47730228be16 ]

Should be -d instead of -n for dry-run.

Fixes: 5da1918446a1 ("selftests/run_kselftest.sh: Make each test individually selectable")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/run_kselftest.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/run_kselftest.sh b/tools/testing/selftests/run_kselftest.sh
index 609a4ef9300e3..97165a83df632 100755
--- a/tools/testing/selftests/run_kselftest.sh
+++ b/tools/testing/selftests/run_kselftest.sh
@@ -48,7 +48,7 @@ while true; do
 		-l | --list)
 			echo "$available"
 			exit 0 ;;
-		-n | --dry-run)
+		-d | --dry-run)
 			dryrun="echo"
 			shift ;;
 		-h | --help)
-- 
2.27.0



