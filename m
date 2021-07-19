Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4433CD774
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbhGSOQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241650AbhGSOQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E46461175;
        Mon, 19 Jul 2021 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706642;
        bh=WeMnDraM7T103alnbGAvN8eaYx0y/ydJ1naFAKo6x0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QO8tTijEj15G0miQSeRYSEH/MywRqCrCBpeNKPFVBcIcpPwdjxkp9yAyGETe8731J
         +zAL9EbDsM20qsCfhEBwr1Dky8jTUeCojtCWt6I81iMpyA9ZNvMlePKekdX2Q9LSTV
         v3CWqU8+A6rB0JxWqJX054KMTXAhTmC12gXXaiEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xu <jack.xu@intel.com>,
        Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 033/188] crypto: qat - remove unused macro in FW loader
Date:   Mon, 19 Jul 2021 16:50:17 +0200
Message-Id: <20210719144920.803251349@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 923bb1988973..28e642959a9a 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -360,7 +360,6 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define ICP_DH895XCC_PESRAM_BAR_SIZE 0x80000
 static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
 				   struct icp_qat_uof_initmem *init_mem)
 {
-- 
2.30.2



