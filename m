Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1045F32B0CE
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhCCAjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351409AbhCBOW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:22:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 787F064FC6;
        Tue,  2 Mar 2021 11:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686383;
        bh=CTUYJnv8MliY6J4+/hZzZcFP6aNEEDo1FTIlzbrUvho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/YNq1OZZD1CV3lXXOHdzjCfx4A0MlzaPT676QtletGBwmyBEfupA7Cf0baVj2HX8
         lR/l/njacwglldCMvtX4zctPsrdM8vT91/isotBPe1xhWD+RVFNUN33ZNHIvCS/6gX
         Cfzv/Q7VSjwYKTJW6gpTT9S1+kGhEs/thtAbpkwLsn4CHPfKuDjKZxf/cCgv+hndkz
         1fRqzlyx5ppqYu0Q+/NODcggTPVJ3khdev5m00v0f368Mm1jvyIg2HAuVX+N5Uewbe
         wW/lIu3ddIlyr1P7oT5qG98m+s1QfxOXMN5P0QExcqyZ7ARciUmG/KhnvZG5UIllWU
         lWmXy+tCbi95Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 5/8] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:59:32 -0500
Message-Id: <20210302115935.63777-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115935.63777-1-sashal@kernel.org>
References: <20210302115935.63777-1-sashal@kernel.org>
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
index 1bee1c6a9891..2e2ddc864ea9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -94,6 +94,7 @@ config X86
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_API_DEBUG
-- 
2.30.1

