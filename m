Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCFA32AF17
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhCCAPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350227AbhCBMCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5697464F34;
        Tue,  2 Mar 2021 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686175;
        bh=A9uOVB4Ynr7nCCetlcG/xAcw+t0Gmj0YJfxfFxxrKyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O00Imk7JQzaeg89KZihPEkJOezJNxlYff9xH5xDJpW+pbbSHUxeGmF7cThSIJhdUx
         4KpIJa6NAzu05Qapm3SHzz4x3DkT6GMWx9/VLOr0NsHLsqW3YDM/doeUn/SqUGlVGz
         8hAmwxx23kTHYXpiK0dGBlzuP/KfFBh+ygL7vWXTFjhPLYWUMnw42hGKhCCAkmtA33
         Y4oY3BpM5lmBxRMF31sTZHVeLWaavcnzP1T+S50JkRC9KG6AETtmO1by5xfZnLdH7U
         HhRrT5rM5CHQv9gIFY/4SI+ORa9FVhz7+QTVRnp0wy+Rtd6XrPaOmxUTYR2b8lezjy
         dvL0BytP/CQEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 31/52] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:55:12 -0500
Message-Id: <20210302115534.61800-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 21f851179ff0..300a9b5296fe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -168,6 +168,7 @@ config X86
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_CONTEXT_TRACKING_OFFSTACK	if HAVE_CONTEXT_TRACKING
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-- 
2.30.1

