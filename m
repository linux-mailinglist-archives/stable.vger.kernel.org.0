Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6303913E1C1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgAPQvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgAPQvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6078205F4;
        Thu, 16 Jan 2020 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193505;
        bh=iw+zIid3D37r/9X/VDFDJgW7dHV4hqA+p5fH4rA1mNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9ScuHI9lN/g3ZjhXYrOZ6UgeWyW3/wEVbVVkC85CG+U05Aui6/JYtSmbb4nopHnE
         PbmDD4C2PysSPvVXPtm6VipCQPuD9hrb/WTwddSJA/yd9mRJV+e0DbKKsh1jV77obO
         ny4rOw8R0qfFUm4PgS28QXxO3uLc20MRJMyWvatY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 092/205] crypto: amcc - restore CRYPTO_AES dependency
Date:   Thu, 16 Jan 2020 11:41:07 -0500
Message-Id: <20200116164300.6705-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 298b4c604008025b134bc6fccbc4018449945d60 ]

This patch restores the CRYPTO_AES dependency. This is
necessary since some of the crypto4xx driver provided
modes need functioning software fallbacks for
AES-CTR/CCM and GCM.

Fixes: da3e7a9715ea ("crypto: amcc - switch to AES library for GCM key derivation")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8eabf7b20101..7316312935c8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -333,6 +333,7 @@ config CRYPTO_DEV_PPC4XX
 	depends on PPC && 4xx
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_CCM
 	select CRYPTO_CTR
-- 
2.20.1

