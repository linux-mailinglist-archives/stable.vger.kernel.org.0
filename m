Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0347D354457
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhDEQFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238808AbhDEQEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 318A5613F5;
        Mon,  5 Apr 2021 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638687;
        bh=eNRxCHjDEZm7ZMVSCK8sEwsiZEqUyXr6H0sI5kRJgcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trkiSGUu2zucjk38VM+K4uXBKlnEmq8mFvMfeSN63c+egGc/T4GWBzHJ6dkgl+Mdt
         77ImCawiDIZAm4KzLnmFG2+H6QKlDzL0TDK3OOINhvOf0uT4KIdtgoA0DdXs2UMiN/
         y8TRE2f4xJ5uTq6ndi1g6YUUDmq7ErK1CCx46IjS9oVtuPqceHkI5tDjNdjit7l7UE
         fQ3BKE2/AET+EfhyFPbcyjaeQS9OVFx8vL5+p2Y5PmthdS5lq0Wt+Bt35v8ClUrqpJ
         r9WLPbw611L0pI8Nd23/pslmXjGiCQ9ZfN9KVGzn1BCiT3i/7YdzY+nY7qJja1IInT
         Px4di1pFffC3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/22] radix tree test suite: Fix compilation
Date:   Mon,  5 Apr 2021 12:04:22 -0400
Message-Id: <20210405160432.268374-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 7487de534dcbe143e6f41da751dd3ffcf93b00ee ]

Commit 4bba4c4bb09a added tools/include/linux/compiler_types.h which
includes linux/compiler-gcc.h.  Unfortunately, we had our own (empty)
compiler_types.h which overrode the one added by that commit, and
so we lost the definition of __must_be_array().  Removing our empty
compiler_types.h fixes the problem and reduces our divergence from the
rest of the tools.

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

