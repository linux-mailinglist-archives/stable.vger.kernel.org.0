Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78403C4A62
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbhGLGwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238133AbhGLGsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D1F611AD;
        Mon, 12 Jul 2021 06:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072236;
        bh=bRID1WUDRBSGxPTH2JaoPg+8jnffbPLQFx/rjbCmz2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kix9YIhH0vP/KSMNd4osM5PY4WAmcM8OHhaffHtd49XvyH42+0cqkVYSOWHXrSVBA
         CJiTxuyCA3ryXW3WpX/yp+XtN3AkuD+dygJrQmsYH3NcdaG92CmaD+EmjJAWW01COq
         ObRC9kNpzxSjZx5KnjdOurGnr9MVOMMZDkA6ulpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/593] tc-testing: fix list handling
Date:   Mon, 12 Jul 2021 08:09:05 +0200
Message-Id: <20210712060929.425326985@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit b4fd096cbb871340be837491fa1795864a48b2d9 ]

python lists don't have an 'add' method, but 'append'.

Fixes: 14e5175e9e04 ("tc-testing: introduce scapyPlugin for basic traffic")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
index 229ee185b27e..a7b21658af9b 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
@@ -36,7 +36,7 @@ class SubPlugin(TdcPlugin):
         for k in scapy_keys:
             if k not in scapyinfo:
                 keyfail = True
-                missing_keys.add(k)
+                missing_keys.append(k)
         if keyfail:
             print('{}: Scapy block present in the test, but is missing info:'
                 .format(self.sub_class))
-- 
2.30.2



