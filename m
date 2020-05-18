Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD811D83F2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733275AbgERSHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732667AbgERSHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBADE2083E;
        Mon, 18 May 2020 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825232;
        bh=R9t161ilWQedy/NqnlXW+T1TNV3XDuy7tQ8SwCJMymA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bin8mfzEBp0Bm2Kwid/XHvCgSvbt39MYpEDc7vVoJN8/Fzb3PdmxnBxnx1uZGAErp
         hlDmsHFiae8M4TRdK32K+8i1RspupRWYN+YR0cEPaDpT0xrCJbPW64Q8DrU3xCbwTp
         6y/yBsTk5PCSUD5BtX83GZ8oTYHTOoI0/gtWRRE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.6 182/194] dt-bindings: dma: fsl-edma: fix ls1028a-edma compatible
Date:   Mon, 18 May 2020 19:37:52 +0200
Message-Id: <20200518173546.641537060@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 Documentation/devicetree/bindings/dma/fsl-edma.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


