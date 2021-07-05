Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EBC3BBBDD
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhGELDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhGELDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2817D61416;
        Mon,  5 Jul 2021 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482832;
        bh=OrnQSVACSTK+4ffCAuorGWnAxcnbtW99AmSLPnDQlfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rt4iIh7foULxMVpjVJKKEHVMpHhQNA78fCRUfa6l6F95tZ7DctBHB2ZiR+RM7ZuL4
         uN10+Dv7JSj6Crtpen4hO5R/ir0UlIEYKk7u/rKgqHC+zV/aenFoBbu2Z1e9Um92Tg
         +1sAE+E0ESaFaPGfYwMt0ymQDhAURHhutsbjroEcglkG1cRrQSpr7wnL6Y0Zl8EcgK
         4ZT2lxIB33bDnZqTEzqlShF9DGUcZ3baBip0uUKG6wgSyaIforBxgfCLTbfmI7nhoQ
         SlshogBncalbmRqIBd1/8Up5/nqUtXutdf4UID2tvMQpq1iQdkghO7jkhJUqPWy7WS
         16sJnek2sDkjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 1/6] x86/efi: remove unused variables
Date:   Mon,  5 Jul 2021 07:00:24 -0400
Message-Id: <20210705110029.1513384-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
References: <20210705110029.1513384-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.130-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.130-rc1
X-KernelTest-Deadline: 2021-07-07T11:00+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 6f090192f8225f52ba95d08785989688cb768cca ]

commit ad723674d675 ("x86/efi: move common keyring handler functions
to new file") leave this unused.

Fixes: ad723674d675 ("x86/efi: move common keyring handler functions to new file")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20191115130830.13320-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/platform_certs/load_uefi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index aa874d84e413..f0c908241966 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -11,11 +11,6 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
 
-static efi_guid_t efi_cert_x509_guid __initdata = EFI_CERT_X509_GUID;
-static efi_guid_t efi_cert_x509_sha256_guid __initdata =
-	EFI_CERT_X509_SHA256_GUID;
-static efi_guid_t efi_cert_sha256_guid __initdata = EFI_CERT_SHA256_GUID;
-
 /*
  * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
  * it does.
-- 
2.30.2

