Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D501674B8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbgBUIYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:24:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387873AbgBUIYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:24:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E7F206ED;
        Fri, 21 Feb 2020 08:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273453;
        bh=64DALbzlGlflbsgACuyMA97btfFobsAvGvVaIDbOK/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4VcLhOoKYqKGN5TrEomz+MK/TPJw2Et0FWX55P+pVdwhj11O4mLEp6Ohw5IvQYUB
         NoYVveawDa9gIU1+WSv3Tk7c/egMs4O/a4o9yZtuTfT7i8PynCXntU2oWgwt2y4wrl
         5AxPcn66H1453LOHHV30mS1kbJMix1QGux/j2xes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/191] lib/scatterlist.c: adjust indentation in __sg_alloc_table
Date:   Fri, 21 Feb 2020 08:42:30 +0100
Message-Id: <20200221072312.030425239@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index 8c3036c37ba0e..60e7eca2f4bed 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -305,7 +305,7 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 			if (prv)
 				table->nents = ++table->orig_nents;
 
- 			return -ENOMEM;
+			return -ENOMEM;
 		}
 
 		sg_init_table(sg, alloc_size);
-- 
2.20.1



