Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0355C172164
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgB0OsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbgB0NnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:43:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC72F21D7E;
        Thu, 27 Feb 2020 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810998;
        bh=UcX1KRWMAwqV7+3ramiGds4rqxADxTFIV7lKuDR3NbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DqCPUrJDKf0P86LkhF595mjAMEotpncLrMdAExlW+D13uGYiATnGfTUGNnpcF0pY
         DSwST1opW7M8x0ue3RTVbEnIVf61YfDj1M23EVA6VqeC81wzwgSOr9eo3zQGUTxBTn
         7uHVoecGz4/K8XfUEj/2umqMCIJrofmav8FOeGpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 077/113] lib/scatterlist.c: adjust indentation in __sg_alloc_table
Date:   Thu, 27 Feb 2020 14:36:33 +0100
Message-Id: <20200227132224.101407733@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
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
index 0b86b7992f931..1875c09eede91 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -317,7 +317,7 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 			if (prv)
 				table->nents = ++table->orig_nents;
 
- 			return -ENOMEM;
+			return -ENOMEM;
 		}
 
 		sg_init_table(sg, alloc_size);
-- 
2.20.1



