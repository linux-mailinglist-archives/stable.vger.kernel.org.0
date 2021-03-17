Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BE633E416
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhCQA6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhCQA5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7441C64FC0;
        Wed, 17 Mar 2021 00:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942652;
        bh=cyb8ztiybluG8OXorUpZ6w30Kin104bO0jot/us/D0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTxhbX1cEvJLixzK1KAYOLJgiggSQ9jWWrtBTxpWcC/84K8OWk31vDNYtAL/6gxVp
         P2rV2EA/zCUiaOPDyny3GUUQBSpZXib5ccASK1tXHYD4f6EoWCJkRlJB3ZvvMH5Lue
         sY195ZkOw4gr6qddmkg14f+Pm3B56qaDZimM70H6XexYkwcmavGl3bkOcc1EkGZsZO
         GwaMr9TPbnRWscLkGtbOqNK1gBjroEREK12ZYVCQlzNCJTNBzDeiWJ0IWPAX9Fd1X5
         mxCkjvPNwWg5o0jxbOH29aG8xTgANu4+43s9uy49oh+oztwzUMS36ROAuDuLo8Ic+6
         Qe4bJOhDtk3NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/54] kbuild: add image_name to no-sync-config-targets
Date:   Tue, 16 Mar 2021 20:56:29 -0400
Message-Id: <20210317005654.724862-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 7fdb78b48f55..901ab5c19ae4 100644
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

