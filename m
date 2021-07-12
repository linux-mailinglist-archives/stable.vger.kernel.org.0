Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B49D3C44BF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhGLGVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234168AbhGLGUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8795E610E5;
        Mon, 12 Jul 2021 06:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070655;
        bh=YNE87x3dW6Wqycoe5tTp/rWbfZKiosqjDcU+YXDRDSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2c04Q9FK3ZjNjvgbbwWLxxy58nQ1pphsoUaHBPWeYykVtsCclSKHl2LkbzfHejs9
         gKYU12OgteXSxYc+uI7PMn52b79a3SGJbTq84XUld7ydPzFOiQMZTY7QQqqAezsoSn
         awvTqSq95euxiIcKzJ40ffIWf+EEk8z6zgdGr6vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xu <jack.xu@intel.com>,
        Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/348] crypto: qat - remove unused macro in FW loader
Date:   Mon, 12 Jul 2021 08:07:48 +0200
Message-Id: <20210712060712.963525246@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index aeb03081415c..9542423bb7ca 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -385,7 +385,6 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define ICP_DH895XCC_PESRAM_BAR_SIZE 0x80000
 static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
 				   struct icp_qat_uof_initmem *init_mem)
 {
-- 
2.30.2



