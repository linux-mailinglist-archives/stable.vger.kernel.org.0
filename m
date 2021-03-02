Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7432B011
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhCCAbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351017AbhCBNDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A91364FBD;
        Tue,  2 Mar 2021 11:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686353;
        bh=eAVB3EdlmAev76zlO/1udvUgZ/7/VVODmbDr8fIgoew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKQ+1JOI85ICi5B6OD+esOeBtrN2QmJVRNeoTwO/2omUgEZajVfR5tg9aSJll1W/0
         gUrr+sVGRk6rU1/vz+TnIrPl9VfSAoRibowv7Vx0mEA8cN4b8svm9RJD1/jFlJRnWW
         dXFoVmgKdiTQWTmq2Dsn0qS/HFo4NbvqoUkPYdabQ6X+sjDiZxH35ihyfhGkfuPB5F
         wzlZ0WGrYr3dP3aSNKJwfH6TZYoKeBOUJMfRdcfRNW0k4jjJJL56XbgL85AyVHecG7
         uPJrn9Qh87DxlGWBVnmf+jL/ks6dfPMEOH2OzIED/qZLcV3ks62dfTf9d6+kK2dbNZ
         actYO5tRhOX5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 07/13] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:58:57 -0500
Message-Id: <20210302115903.63458-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
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
index c55870ac907e..241bb049e803 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -126,6 +126,7 @@ config X86
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_API_DEBUG
-- 
2.30.1

