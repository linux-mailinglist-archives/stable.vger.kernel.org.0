Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE351676EC
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgBUH7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:59:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbgBUH7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:59:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A5EE20801;
        Fri, 21 Feb 2020 07:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271978;
        bh=ghfHmbsHqcAaTT8fpcwffk7RwHomEhJQzeyQkH2KBl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFjRiWVkKHkcp6aSHKqIlOTqnkl3KiWbNBo5khXK3NFXhWZDE++TGQeQ8mOAiI6R8
         Xjx8s0K1i2HfA01DpCH+Ua3Br7jdWlNQz5ZyAu6vWfRwQyLZfDftrvkPHq9VZ3W+HU
         JBHM0GOhkqgsenQ0uP6749kp0CTtS+lkmRQRPjU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 371/399] lib/scatterlist.c: adjust indentation in __sg_alloc_table
Date:   Fri, 21 Feb 2020 08:41:36 +0100
Message-Id: <20200221072436.541669447@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 4e456fee215677584cafa7f67298a76917e89c64 ]

Clang warns:

  ../lib/scatterlist.c:314:5: warning: misleading indentation; statement
  is not part of the previous 'if' [-Wmisleading-indentation]
                          return -ENOMEM;
                          ^
  ../lib/scatterlist.c:311:4: note: previous statement is here
                          if (prv)
                          ^
  1 warning generated.

This warning occurs because there is a space before the tab on this
line.  Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

Link: http://lkml.kernel.org/r/20191218033606.11942-1-natechancellor@gmail.com
Link: https://github.com/ClangBuiltLinux/linux/issues/830
Fixes: edce6820a9fd ("scatterlist: prevent invalid free when alloc fails")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c2cf2c311b7db..5813072bc5895 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -311,7 +311,7 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 			if (prv)
 				table->nents = ++table->orig_nents;
 
- 			return -ENOMEM;
+			return -ENOMEM;
 		}
 
 		sg_init_table(sg, alloc_size);
-- 
2.20.1



