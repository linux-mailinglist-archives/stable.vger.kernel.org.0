Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A792F2F8A
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388744AbhALM4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbhALM4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:56:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896C02311A;
        Tue, 12 Jan 2021 12:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456137;
        bh=x68/nWBFEmoquc1Oqn+w9LkVQx83+m4xn465UtfB1k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUwhuqPSJuwSoPkVL9jtMRJ1NlEt5FE9hbcVtUAXFXtFpqGMjeSfKLHZxfZZ/2PhX
         cs0wC2BsszRcbUZCyrwfsHAiE4qsIsYHWhtFw9Bvm8Poe6+5RZj0odOiMZkzHOl4Ny
         +u6cdXdg4CdaiA+dz/x9PwouPOAu0jIILUmcT5s9gcFz7cCiJ/6o1mSfycEhJQzfLf
         govHCo/Coatx6MTrrTs7laa0suK4YGQAujZueQ84Xlrk/EbgWlCsHkh4uZ/a7RUt8A
         /QDh56cpj25tECoAp56om6bcvjmNE8eupBHvu1r94/skL98QvKIDlFciST2WBo4lx8
         TIFXNkdlRUZ+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/51] ARC: build: add uImage.lzma to the top-level target
Date:   Tue, 12 Jan 2021 07:54:44 -0500
Message-Id: <20210112125534.70280-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f2712ec76a5433e5ec9def2bd52a95df1f96d050 ]

arch/arc/boot/Makefile supports uImage.lzma, but you cannot do
'make uImage.lzma' because the corresponding target is missing
in arch/arc/Makefile. Add it.

I also changed the assignment operator '+=' to ':=' since this is the
only place where we expect this variable to be set.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index acf99420e161d..61a41123ad4c4 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -102,7 +102,7 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-boot_targets += uImage uImage.bin uImage.gz
+boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
-- 
2.27.0

