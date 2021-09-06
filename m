Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8424540146E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351718AbhIFBdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351691AbhIFBa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E053161214;
        Mon,  6 Sep 2021 01:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891453;
        bh=5u9PJq7N7hzxm6sNiHCCpXP6/HjC2HxHXzIWC/PSEMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yrl3MVDgsuPdRAK26oBZMMlqrBRKF5TFfRj73THBQ7lHj/eSCUgyrTJSjZTbWTVQ1
         +axVEMgrcxquQW10KPMbNXIzU7wNR5nGYkJpKFgiHJEp72YR8f9MqXwsQJNRguenWG
         WytmechNh0e6pQKRglydv6NLP2qOcGYMdMDyR+iFuXQfO6/dHNgr+3q4zzR4ueHcFH
         4gQ2zliWfJ5DrBKB/LGOEDdFSJxO0i5wz/gj4eSTJYr6KyrxYrLW7C3tlvLeq4jhnz
         HtoCQkZ0MG9oo8Lsqeu06uAkpweUeuYlumELIfDfZc5Bf5kC2lLuaBgcL/v0UM9opY
         ncCL3Mg6ydg/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/17] crypto: qat - do not export adf_iov_putmsg()
Date:   Sun,  5 Sep 2021 21:23:51 -0400
Message-Id: <20210906012352.930954-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012352.930954-1-sashal@kernel.org>
References: <20210906012352.930954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 645ae0af1840199086c33e4f841892ebee73f615 ]

The function adf_iov_putmsg() is only used inside the intel_qat module
therefore should not be exported.
Remove EXPORT_SYMBOL for the function adf_iov_putmsg().

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 9dab2cc11fdf..c64481160b71 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -231,7 +231,6 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
-- 
2.30.2

