Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3070E6E2
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfD2Ptk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:49:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36634 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbfD2Ptj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:49:39 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0CFB31A0186;
        Mon, 29 Apr 2019 17:49:38 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 015881A017C;
        Mon, 29 Apr 2019 17:49:38 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AB90B205EE;
        Mon, 29 Apr 2019 17:49:37 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH stable v4.4 8/8] Documentation: Add nospectre_v1 parameter
Date:   Mon, 29 Apr 2019 18:49:08 +0300
Message-Id: <1556552948-24957-9-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently only supported on powerpc.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Documentation/kernel-parameters.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f0bdf78420a0..3ff87d5d6fea 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2449,6 +2449,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			legacy floating-point registers on task switch.
 
 	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
+	
+	nospectre_v1	[PPC] Disable mitigations for Spectre Variant 1 (bounds
+			check bypass). With this option data leaks are possible
+			in the system.
 
 	nospectre_v2	[X86,PPC_FSL_BOOK3E] Disable all mitigations for the Spectre variant 2
 			(indirect branch prediction) vulnerability. System may
-- 
2.17.1

