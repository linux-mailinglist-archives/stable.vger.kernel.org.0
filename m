Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A651113FFC4
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390207AbgAPXp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390974AbgAPXXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F0A20684;
        Thu, 16 Jan 2020 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216981;
        bh=9TP65DmAZOyP+WVUXv3LqkBhonR0W5m6WbRnSaordVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDq4g8LDL+K1i9InSb7iscvkyClJ2eFoU6MFAgnJcDmw547oI0JFFZAYef/lr4ik0
         VwSXfORNYSSqdlZdHZpbmTLP/rgDpbkWZkewNQYzBMYaLmWCy4yTLmDsnIREVmrpMo
         YIvLwkt4HLovxoHjQpkwwp5PJdeLgwKM3ibaNMO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Wang <wangzhou1@hisilicon.com>,
        kbuild test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 099/203] crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm Kconfig
Date:   Fri, 17 Jan 2020 00:16:56 +0100
Message-Id: <20200116231754.278397020@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Wang <wangzhou1@hisilicon.com>

commit b981744ef04f7e8cb6931edab50021fff3c8077e upstream.

To avoid compile error in some platforms, select NEED_SG_DMA_LENGTH in
qm Kconfig.

Fixes: dfed0098ab91 ("crypto: hisilicon - add hardware SGL support")
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/hisilicon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -17,6 +17,7 @@ config CRYPTO_DEV_HISI_SEC
 config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 && PCI && PCI_MSI
+	select NEED_SG_DMA_LENGTH
 	help
 	  HiSilicon accelerator engines use a common queue management
 	  interface. Specific engine driver may use this module.


