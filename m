Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF18032AF9A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhCCA1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350690AbhCBMX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C44964FA8;
        Tue,  2 Mar 2021 11:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686329;
        bh=KmoZ7s9pD8ZiBe0SxA1TqfUuPUXQiFGYERBjMS7tid8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmdqZh69gPgnLFBO8zSNO9lQjyqbYhlc2TZudMtUvwaiXEtxFxK7gZfgLh88OUw8L
         GwEyVoSjdRhJ8QjEDus+Fn0OU8yGFXIya+sFXe3o3gycncUDMm3l6FeGp0LDWOry/P
         hqgYHQBpVnZnrm/MPD9VJVS4t0pnrhAX97Pf24w5zgDCzkO0CqYoTjMbzlZCNdwpag
         HxKaNgA5AQDyUpKur0oceRNn2naO6W50E87GquWFnCdUrraf0E9+NKajXsP0ZuUlkh
         j03gX560Dt/8WoMySywga5uW5oxHtQLFTb58UlrKlJXPu4XCKiLs0Coj5NPsYX/Pwa
         XV80Z6RF2R60A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 11/21] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:58:25 -0500
Message-Id: <20210302115835.63269-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115835.63269-1-sashal@kernel.org>
References: <20210302115835.63269-1-sashal@kernel.org>
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
index af35f5caadbe..4ae2ffa8ad7b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -137,6 +137,7 @@ config X86
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_CONTIGUOUS
-- 
2.30.1

