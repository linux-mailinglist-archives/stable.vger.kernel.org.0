Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22CE6E1
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbfD2Ptj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:49:39 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53874 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbfD2Ptj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:49:39 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A8DFE200251;
        Mon, 29 Apr 2019 17:49:37 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9B9D3200196;
        Mon, 29 Apr 2019 17:49:37 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 52107205EE;
        Mon, 29 Apr 2019 17:49:37 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH stable v4.4 7/8] powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2 boot arg
Date:   Mon, 29 Apr 2019 18:49:07 +0300
Message-Id: <1556552948-24957-8-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f633a8ad636efb5d4bba1a047d4a0f1ef719aa06 upstream.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Documentation/kernel-parameters.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index da515c535e62..f0bdf78420a0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2450,7 +2450,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
 
-	nospectre_v2	[X86] Disable all mitigations for the Spectre variant 2
+	nospectre_v2	[X86,PPC_FSL_BOOK3E] Disable all mitigations for the Spectre variant 2
 			(indirect branch prediction) vulnerability. System may
 			allow data leaks with this option, which is equivalent
 			to spectre_v2=off.
-- 
2.17.1

