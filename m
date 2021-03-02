Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102B832B060
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhCCAfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447618AbhCBNmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:42:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D93664F91;
        Tue,  2 Mar 2021 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686296;
        bh=0YgUISATPaoeQiXIOeaqI3ERm1eWdGLGjPdhsD+llEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3x31FwDjgyQInEes0zuQanzbdNAC/lgt7ik002TnAWvBqTZAeiRojuYpDabSuQzR
         zBdHv9I30AwZ3EjBVOPBodUT0W7a96hytgTjOpHIKQ0dSLKOl3WTynJCALj9h11xvo
         zsL/MBHywHBircEHJN5hTrXQwWmerhmVcjNejn+NCN4wTXDkJp43sHCMrxn2GyHfs/
         FBieC8FXWOcWwvCtX8XKJQy51y+mAtV21i1Y5D5yr+pcWf91S/WF77sA/cJyu0Aznq
         tOMh0KY/kXPYyzp/PrSoJJzUm8VNGZudBMRjINogRYQrvUk25phTAEiP3rQIsCJYW4
         ebfcCoQhYD7kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 20/33] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:57:36 -0500
Message-Id: <20210302115749.62653-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
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
index 8ef85139553f..8523579feced 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -154,6 +154,7 @@ config X86
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-- 
2.30.1

