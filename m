Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDFE354494
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbhDEQFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239118AbhDEQFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A2D613FC;
        Mon,  5 Apr 2021 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638723;
        bh=Sm8aQaGLHRowj8diWMhZrFvkldhFlLEA9Jvp+s9WktI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pylNZmBmuyLquhpqIqO19CGLVH0Ls4TKN8MEXAZyGyDZa3jOGduwQ7ys3pwVRMtQS
         dk78jSmA1z2IR2IHkdseC8faijPaspk/CcSdBkFoPzP7z6vB7X/k5zuBQ5butJE9Ei
         JvuyVBhGo1TrMPq2aCM4iyxUlWeBc8NikKMXiQoz605ZpiZV34JSghRl4Ugz0/ow/1
         Gb5H15BStmP2RHw059eMcLgOuPgvWWWw6OnvHhmDcYkci3fNCDKsjgIaxcMH/kvrw+
         lXWPcIrUwsfd+4t1jKJjaa2P+98kkDwgHTHL/gQlUN0d96OHVICYQaQuig3G31iC66
         Be48BCzlDAj2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/8] radix tree test suite: Fix compilation
Date:   Mon,  5 Apr 2021 12:05:13 -0400
Message-Id: <20210405160515.269020-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160515.269020-1-sashal@kernel.org>
References: <20210405160515.269020-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit dd841a749d1ded8e2e5facc4242ee0b6779fc0cb ]

Introducing local_lock broke compilation; fix it all up.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/linux/compiler_types.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 tools/testing/radix-tree/linux/compiler_types.h

diff --git a/tools/testing/radix-tree/linux/compiler_types.h b/tools/testing/radix-tree/linux/compiler_types.h
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.30.2

