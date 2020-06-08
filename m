Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AC11F2E07
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgFIAit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbgFHXNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B24E521527;
        Mon,  8 Jun 2020 23:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658011;
        bh=oeO3JbRNlXL4jdzpWTfG5jkpwsKeAcZJoppud5H82L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZUjzrbr7MdhLg80t2akgpSvhK/nJRCvSms7yhenVHt2LgL0Jh9NIVzVlcsHoZ5Mu
         YY4EuukTidnAteP0dS155WoD0EA+l43EVDczCzcsHZPP5T86xBGzhTi4nZmSA2YbUw
         7GQXN2UmYWOAlpRVPCpumGmHyYQtx5T/BLNvYL14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Shawn Guo <shawnguo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 066/606] dt-bindings: dma: fsl-edma: fix ls1028a-edma compatible
Date:   Mon,  8 Jun 2020 19:03:11 -0400
Message-Id: <20200608231211.3363633-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit d94a05f87327143f94f67dd256932163ac2bcd65 upstream.

The bootloader will fix up the IOMMU entries only on nodes with the
compatible "fsl,vf610-edma". Thus make this compatible string mandatory
for the ls1028a-edma.

While at it, fix the "fsl,fsl," typo.

Signed-off-by: Michael Walle <michael@walle.cc>
Fixes: d8c1bdb5288d ("dt-bindings: dma: fsl-edma: add new fsl,fsl,ls1028a-edma")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/dma/fsl-edma.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/fsl-edma.txt b/Documentation/devicetree/bindings/dma/fsl-edma.txt
index e77b08ebcd06..ee1754739b4b 100644
--- a/Documentation/devicetree/bindings/dma/fsl-edma.txt
+++ b/Documentation/devicetree/bindings/dma/fsl-edma.txt
@@ -10,7 +10,8 @@ Required properties:
 - compatible :
 	- "fsl,vf610-edma" for eDMA used similar to that on Vybrid vf610 SoC
 	- "fsl,imx7ulp-edma" for eDMA2 used similar to that on i.mx7ulp
-	- "fsl,fsl,ls1028a-edma" for eDMA used similar to that on Vybrid vf610 SoC
+	- "fsl,ls1028a-edma" followed by "fsl,vf610-edma" for eDMA used on the
+	  LS1028A SoC.
 - reg : Specifies base physical address(s) and size of the eDMA registers.
 	The 1st region is eDMA control register's address and size.
 	The 2nd and the 3rd regions are programmable channel multiplexing
-- 
2.25.1

