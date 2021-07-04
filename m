Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907FE3BB1B3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhGDXMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhGDXJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B44A613D2;
        Sun,  4 Jul 2021 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440021;
        bh=TSvhwjjIRCuy4ZF5RtOACoeAoEzRBrwReraD+c3BIGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzisoAQa0RGotAquflVuOnGu1NCwNceClXCQg7nyU5/m3254WQCJZXcwyfWR5ZzMK
         l0E4J2F6hRr/l8OACzzqM2wV+L2tJ+guOFcdK0eUMIUDoiphES2yCWAiwoMR7HSAd5
         BQ90BoVrRdfNfONh/3yRkOGNtrFUW+Oz64ztZra5m8rri1zg4WsSWXf+rNqotYijzq
         osbTJhqniHXfVCoven4vaUxnAMc87JuPhMfeaIk64cPcVAblLfvTMCoEJSZXMNno35
         LejeT3NOTl0e7kc3dg/roBDHrTq9K70BmUy5Dtkk917H2uxENPcgoh+X3pW1e1VRfa
         u2TizaUrCGJHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Xu <jack.xu@intel.com>, Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 32/80] crypto: qat - remove unused macro in FW loader
Date:   Sun,  4 Jul 2021 19:05:28 -0400
Message-Id: <20210704230616.1489200-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Xu <jack.xu@intel.com>

[ Upstream commit 9afe77cf25d9670e61b489fd52cc6f75fd7f6803 ]

Remove the unused macro ICP_DH895XCC_PESRAM_BAR_SIZE in the firmware
loader.

This is to fix the following warning when compiling the driver using the
clang compiler with CC=clang W=2:

    drivers/crypto/qat/qat_common/qat_uclo.c:345:9: warning: macro is not used [-Wunused-macros]

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Zhehui Xiang <zhehui.xiang@intel.com>
Signed-off-by: Zhehui Xiang <zhehui.xiang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 1fb5fc852f6b..6d95160e451e 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -342,7 +342,6 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define ICP_DH895XCC_PESRAM_BAR_SIZE 0x80000
 static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
 				   struct icp_qat_uof_initmem *init_mem)
 {
-- 
2.30.2

