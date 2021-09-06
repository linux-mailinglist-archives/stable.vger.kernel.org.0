Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86C40148B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351369AbhIFBd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351896AbhIFBbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68AE461108;
        Mon,  6 Sep 2021 01:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891486;
        bh=KZ9AY3lB/W9x1y+Itz/mPa6TbJmSI9vc87PU5wAgFcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1UNnkw7yAFu4F9XCCEWXTg3D9fKLxFKItydZQRXFVjsZq+pvGu4kba0nrMUyhs33
         s/usfiQKjNKcRheOOufrWTLFV/awQYY9fsvYZv0es8rL0XpqBocQ2bUnfI2NpAVTdv
         dLuPO1XlNqMO4Wdf7jVUdWMHsXdQMrhpa3lymQ12unCrvF0FjttS30YsunTlXtEAI+
         ToOAjF1D2KN6Bpj+fZPWNtJPLepuVK/sNtiEVGNb+6lIh0BzDkHXabrqclWNcclr2U
         lvVmCiBS5wTX4oYD7aaODZMriN9/lfffTa7tsR0rHckoEvmBFV3Pm+2+EFfqQfA0jp
         EkOBwRBDt9UIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 8/9] crypto: qat - do not export adf_iov_putmsg()
Date:   Sun,  5 Sep 2021 21:24:33 -0400
Message-Id: <20210906012435.931318-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012435.931318-1-sashal@kernel.org>
References: <20210906012435.931318-1-sashal@kernel.org>
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
index 711706819b05..f071aba32a28 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -254,7 +254,6 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
-- 
2.30.2

