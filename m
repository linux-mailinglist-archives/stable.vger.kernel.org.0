Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43CE32AF3D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbhCCAQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443603AbhCBMLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69A2564EE8;
        Tue,  2 Mar 2021 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686241;
        bh=ykJHNFRYPs7QPL5s+OAFF9zYsHAJL8hyD1I3HpllVAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVEcQu1VCNK3GedNN2aGE8H97WG/+MoDm8RuxgCs3CINB7QZKNtj8tqdjA3Fm6l+d
         b2BCR7uxmA7hoXMZH0h0yqQRkNnpUEcOqrRbMwn8xQlgOQBSkSBY/ShinZ0eWC66MF
         R0/OGcjrBMLZUI+ytOxBaQoXk5pE01InzdJ5yQboAcu5Ua5uL8hED7jvzWLRLrv7AL
         QBCMEeZZZDseyIqZ/YOSiww6qby+VlxUhwOoXAeEvkPwV3xhTDSY6e7mmVapWMhb+O
         Bbqjd7m8BZ4OxwCd5+gyVoKQRfp69uLVGTm5iwqS5buhSw5HxYl8bK55OP2UK0WCjP
         YU3MzYv0adb1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 27/47] x86, build: use objtool mcount
Date:   Tue,  2 Mar 2021 06:56:26 -0500
Message-Id: <20210302115646.62291-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
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
index 3a5ecb1039bf..48d6367fe249 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -165,6 +165,7 @@ config X86
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-- 
2.30.1

