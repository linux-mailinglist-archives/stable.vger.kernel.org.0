Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350F348E654
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbiANI00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbiANIYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:24:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F1DC06175B;
        Fri, 14 Jan 2022 00:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F7C0B82448;
        Fri, 14 Jan 2022 08:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8072FC36AE9;
        Fri, 14 Jan 2022 08:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148586;
        bh=gqA5DvM7iufFFeKiwPPhmqQ/Opiz/rJd18h1wVAhjDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDCMeyZa+IarRm7OVQ45NReqNzDiJBlCMzneDFSXMBRWaw+nsddiMeecBOGCk2j2d
         FUPQEoxEJestoVINHaHfA0ttjQLXo+qEP/31/kbTSsLQvYOTji1Kf4d3EbO8dAJBTa
         Khx79O1sa7s3+Osl+0U3mrfUYYgmNXcMM1bAoIrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.16 37/37] parisc: Fix pdc_toc_pim_11 and pdc_toc_pim_20 definitions
Date:   Fri, 14 Jan 2022 09:16:51 +0100
Message-Id: <20220114081546.057590359@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 712a270d2db967b387338c26c3dc04ccac3fcec3 upstream.

The definitions for pdc_toc_pim_11 and pdc_toc_pim_20 are wrong since they
include an entry for a hversion field which doesn't exist in the specification.

Fix this and clean up some whitespaces so that the whole file will be in
sync with it's copy in the SeaBIOS-hppa sources.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.16
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/uapi/asm/pdc.h |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/arch/parisc/include/uapi/asm/pdc.h
+++ b/arch/parisc/include/uapi/asm/pdc.h
@@ -4,7 +4,7 @@
 
 /*
  *	PDC return values ...
- *	All PDC calls return a subset of these errors. 
+ *	All PDC calls return a subset of these errors.
  */
 
 #define PDC_WARN		  3	/* Call completed with a warning */
@@ -165,7 +165,7 @@
 #define PDC_PSW_GET_DEFAULTS	1	/* Return defaults              */
 #define PDC_PSW_SET_DEFAULTS	2	/* Set default                  */
 #define PDC_PSW_ENDIAN_BIT	1	/* set for big endian           */
-#define PDC_PSW_WIDE_BIT	2	/* set for wide mode            */ 
+#define PDC_PSW_WIDE_BIT	2	/* set for wide mode            */
 
 #define PDC_SYSTEM_MAP	22		/* find system modules		*/
 #define PDC_FIND_MODULE 	0
@@ -274,7 +274,7 @@
 #define PDC_PCI_PCI_INT_ROUTE_SIZE	13
 #define PDC_PCI_GET_INT_TBL_SIZE	PDC_PCI_PCI_INT_ROUTE_SIZE
 #define PDC_PCI_PCI_INT_ROUTE		14
-#define PDC_PCI_GET_INT_TBL		PDC_PCI_PCI_INT_ROUTE 
+#define PDC_PCI_GET_INT_TBL		PDC_PCI_PCI_INT_ROUTE
 #define PDC_PCI_READ_MON_TYPE		15
 #define PDC_PCI_WRITE_MON_TYPE		16
 
@@ -345,7 +345,7 @@
 
 /* constants for PDC_CHASSIS */
 #define OSTAT_OFF		0
-#define OSTAT_FLT		1 
+#define OSTAT_FLT		1
 #define OSTAT_TEST		2
 #define OSTAT_INIT		3
 #define OSTAT_SHUT		4
@@ -403,7 +403,7 @@ struct zeropage {
 	int	vec_pad1[6];
 
 	/* [0x040] reserved processor dependent */
-	int	pad0[112];
+	int	pad0[112];              /* in QEMU pad0[0] holds "SeaBIOS\0" */
 
 	/* [0x200] reserved */
 	int	pad1[84];
@@ -691,6 +691,22 @@ struct pdc_hpmc_pim_20 { /* PDC_PIM */
 	unsigned long long fr[32];
 };
 
+struct pim_cpu_state_cf {
+	union {
+	unsigned int
+		iqv : 1,	/* IIA queue Valid */
+		iqf : 1,	/* IIA queue Failure */
+		ipv : 1,	/* IPRs Valid */
+		grv : 1,	/* GRs Valid */
+		crv : 1,	/* CRs Valid */
+		srv : 1,	/* SRs Valid */
+		trv : 1,	/* CR24 through CR31 valid */
+		pad : 24,	/* reserved */
+		td  : 1;	/* TOC did not cause any damage to the system state */
+	unsigned int val;
+	};
+};
+
 struct pdc_toc_pim_11 {
 	unsigned int gr[32];
 	unsigned int cr[32];
@@ -698,8 +714,7 @@ struct pdc_toc_pim_11 {
 	unsigned int iasq_back;
 	unsigned int iaoq_back;
 	unsigned int check_type;
-	unsigned int hversion;
-	unsigned int cpu_state;
+	struct pim_cpu_state_cf cpu_state;
 };
 
 struct pdc_toc_pim_20 {
@@ -709,8 +724,7 @@ struct pdc_toc_pim_20 {
 	unsigned long long iasq_back;
 	unsigned long long iaoq_back;
 	unsigned int check_type;
-	unsigned int hversion;
-	unsigned int cpu_state;
+	struct pim_cpu_state_cf cpu_state;
 };
 
 #endif /* !defined(__ASSEMBLY__) */


