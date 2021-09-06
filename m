Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C74013BB
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbhIFB2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240082AbhIFB0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D20461178;
        Mon,  6 Sep 2021 01:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891354;
        bh=SNITxGpC+2r8FKwiaWFb6tHN5Sa63IzCStlGnpXq07k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snvo8uhM0m9mUn/2vG0dWCsYIkeHNYbrEkh2YR5WnpuKdlBtbPV7DYH7vBHM4AVSD
         RG7MnaW87IgeE2uGBEadDSHQTTPqhogLhfGn0sMogQviR7L23W7Gs9+zBwyfes1mO/
         9Mck3m3dfipLJoH8fIqdnoSgoP3Pjz32i+KMH13OsuUYKjDk/yurMqyEQb1AHohAJm
         CnwsbnYadxXlhRl5HvWHimNAFuDDaelobRwLY8Srye0LnRv81osXlzso+NVH/HlyRi
         MxO+sxxMwNYvx+oc5+cD87BpwfkFA7L/KojUctH3oolyxgeMnU4pjwy7p/uVOaliJy
         mmhJnvvmdb9rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/39] crypto: qat - do not export adf_iov_putmsg()
Date:   Sun,  5 Sep 2021 21:21:46 -0400
Message-Id: <20210906012153.929962-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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
index 4c39731c51c8..e829c6aaf16f 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -186,7 +186,6 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(adf_iov_putmsg);
 
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
-- 
2.30.2

