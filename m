Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86CB33E374
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCQA4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhCQA4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2890964FA5;
        Wed, 17 Mar 2021 00:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942574;
        bh=AenPixLi3LmTLnH+rm9+o4/1K1iikmmlr7EnwM8NEZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks2kkLqeN432BKUmZaDpgiL5E4OAja+j103hX86viayV5Gj7DfqxAXaArxeMGq7W2
         LxxRP9GGXTVDyCt7vmDH7EbMmwSCKsNjWqX7qkrNCWYMM0l3qI+7IW6JBi/0UHr6T0
         Roq1Hy3ACqG3lRWiTDYlJm3gsvy6jg6/2r0XsjHucughN5xEYfdV6pbs0urQMBO9Zt
         0KEQE2ZTXT6FOSp/DB4A7845132PsuQ7xqAnU6Cmv/u7BxTVBP5kl6XStBpWdGYhcd
         2Sxpkx7WYvQim4iUdCcAe/t28usvyGzTFlHsdMRgTHCQqqS6NBMnD5zG6xL/640Odt
         SxxbKOfzPGhHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 31/61] kbuild: add image_name to no-sync-config-targets
Date:   Tue, 16 Mar 2021 20:55:05 -0400
Message-Id: <20210317005536.724046-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 993bdde94547887faaad4a97f0b0480a6da271c3 ]

'make image_name' needs include/config/auto.conf to show the correct
output because KBUILD_IMAGE depends on CONFIG options, but should not
attempt to resync the configuration.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 472136a7881e..c67cc0d46833 100644
--- a/Makefile
+++ b/Makefile
@@ -265,7 +265,8 @@ no-dot-config-targets := $(clean-targets) \
 			 $(version_h) headers headers_% archheaders archscripts \
 			 %asm-generic kernelversion %src-pkg dt_binding_check \
 			 outputmakefile
-no-sync-config-targets := $(no-dot-config-targets) %install kernelrelease
+no-sync-config-targets := $(no-dot-config-targets) %install kernelrelease \
+			  image_name
 single-targets := %.a %.i %.ko %.lds %.ll %.lst %.mod %.o %.s %.symtypes %/
 
 config-build	:=
-- 
2.30.1

