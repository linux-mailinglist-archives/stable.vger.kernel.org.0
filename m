Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD56032B012
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhCCAbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351020AbhCBNDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE2B64FC2;
        Tue,  2 Mar 2021 11:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686370;
        bh=bMJ+4KZFTTAhfNQfKVq3Q4hG5xnb/if3LpJydkC4iKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjLBb9JPj7IYYaX1BrLQLz9IUTasQgx7n7Yle3H59zSQuRN9ixbEfs1TkytUYo1Ip
         +ns2bQcC1wqD6PXM4n4tjbwQCZVv43BACy41UhCv30IeJq0NSEhQpH75MRASH/E5UY
         WRLqyFWbzilji4ELbFUdRGO7d+beTtVCQW4hUydd5C4cCvdl72oU6ozxYFeQQDGA/g
         nSApA0mLm1/i0wxR2lPjaZymEAB/ZhCxyRjh9DO9mXn0v2oPpsPgzOJWXlMAciL0P6
         piiFS4Vbi1YWM7rJE3/JeBfBvR8o807xKhRuMsB2/buvQWQtFszbetNglXQsLwPXX0
         5rA9lTjMGCuXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 06/10] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:59:17 -0500
Message-Id: <20210302115921.63636-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115921.63636-1-sashal@kernel.org>
References: <20210302115921.63636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 6dafca97803309c3cb5148d449bfa711e41ddef2 ]

Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
objtool to generate __mcount_loc sections for dynamic ftrace with
Clang and gcc <5 (later versions of gcc use -mrecord-mcount).

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80636caee07c..b03d075ee9ee 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -101,6 +101,7 @@ config X86
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_API_DEBUG
-- 
2.30.1

