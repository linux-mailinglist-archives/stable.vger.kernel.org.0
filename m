Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2AF920
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfD3Mmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:42:45 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47862 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfD3Mmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 08:42:45 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E67331A0168;
        Tue, 30 Apr 2019 14:42:41 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DA7101A006D;
        Tue, 30 Apr 2019 14:42:41 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8EF1820614;
        Tue, 30 Apr 2019 14:42:41 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH v2 stable v4.4 1/2] powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2 boot arg
Date:   Tue, 30 Apr 2019 15:42:26 +0300
Message-Id: <1556628147-15687-1-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e59f5bd759b7dee57593c5b6c0441609bda5d530 upstream.

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

