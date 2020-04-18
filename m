Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D221AF07D
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgDROtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgDROnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:43:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF21522240;
        Sat, 18 Apr 2020 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221001;
        bh=jLcx/PX4V1oqcaCLrKcQSdHT+RP0udwt28vs2JKiCNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RAY118gBcxrDKWDByccfPbk0jLpwBdjEqHwFQSyYMGcxVwfeGferzQGtWT4NH8i+
         6+LYm+MJw4b5aJNp2pEMGG9izF0WXC3GQH9aYkZdauSwWlUoTnEhda53QA/cLLkUg4
         ageYauy1W9n9jcHlToKiuLQ5rZ6iDiWY/sS2Nd3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Alastair D'Silva <alastair@d-silva.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 43/47] ocxl: Add PCI hotplug dependency to Kconfig
Date:   Sat, 18 Apr 2020 10:42:23 -0400
Message-Id: <20200418144227.9802-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144227.9802-1-sashal@kernel.org>
References: <20200418144227.9802-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit 49ce94b8677c7d7a15c4d7cbbb9ff1cd8387827b ]

The PCI hotplug framework is used to update the devices when a new
image is written to the FPGA.

Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191121134918.7155-12-fbarrat@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/ocxl/Kconfig b/drivers/misc/ocxl/Kconfig
index 4bbdb0d3c8ee7..de7d25ba22e34 100644
--- a/drivers/misc/ocxl/Kconfig
+++ b/drivers/misc/ocxl/Kconfig
@@ -11,6 +11,7 @@ config OCXL
 	tristate "OpenCAPI coherent accelerator support"
 	depends on PPC_POWERNV && PCI && EEH
 	select OCXL_BASE
+	select HOTPLUG_PCI_POWERNV
 	default m
 	help
 	  Select this option to enable the ocxl driver for Open
-- 
2.20.1

