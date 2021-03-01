Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DF6328C7C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240647AbhCASxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240405AbhCASqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7496665315;
        Mon,  1 Mar 2021 17:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620589;
        bh=k6NxZ6Yebye94Y8CnNCVJrM63WQpjvNbNO1pybH1ndk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zp9MZgVbbduUZm88KFMnVILz6L+XYlsYKt2FUmVZ4iSQmdRbVv9JzEydrCmytmv5k
         cb2At/sQOeZSGlLASssZ8Kgc59AFY6mqkeaUDr3TKhZ4jUsR/gNmEO1qptohHnlEzb
         rt1sR5/nfaT6i/x4rRxGAb7xbx+sKRrIPS+oT0Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 208/775] crypto: qat - replace CRYPTO_AES with CRYPTO_LIB_AES in Kconfig
Date:   Mon,  1 Mar 2021 17:06:16 +0100
Message-Id: <20210301161211.919870796@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

[ Upstream commit 4f1a02e75a2eedfddd10222c0fe61d2a04d80099 ]

Use CRYPTO_LIB_AES in place of CRYPTO_AES in the dependences for the QAT
common code.

Fixes: c0e583ab2016 ("crypto: qat - add CRYPTO_AES to Kconfig dependencies")
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 846a3d90b41a3..77783feb62b25 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -11,7 +11,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select FW_LOADER
 
 config CRYPTO_DEV_QAT_DH895xCC
-- 
2.27.0



