Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A920188DB8
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfHJUs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54842 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbfHJUoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDW-00053u-Qy; Sat, 10 Aug 2019 21:43:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003iN-NT; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.360144767@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 121/157] x86: cpufeatures: Renumber feature word 7
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Use the same bit numbers for all features that are also present in
4.4.y and 4.9.y, to make further backports slightly easier.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -177,29 +177,32 @@
 #define X86_FEATURE_ARAT	( 7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
-#define X86_FEATURE_XSAVEOPT	( 7*32+ 4) /* Optimized Xsave */
+#define X86_FEATURE_INVPCID_SINGLE ( 7*32+4) /* Effectively INVPCID && CR4.PCIDE=1 */
 #define X86_FEATURE_PLN		( 7*32+ 5) /* Intel Power Limit Notification */
 #define X86_FEATURE_PTS		( 7*32+ 6) /* Intel Package Thermal Status */
 #define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
-#define X86_FEATURE_INVPCID_SINGLE ( 7*32+10) /* Effectively INVPCID && CR4.PCIDE=1 */
-#define X86_FEATURE_RSB_CTXSW	( 7*32+11) /* "" Fill RSB on context switches */
-#define X86_FEATURE_USE_IBPB	( 7*32+12) /* "" Indirect Branch Prediction Barrier enabled */
-#define X86_FEATURE_USE_IBRS_FW ( 7*32+13) /* "" Use IBRS during runtime firmware calls */
-#define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE ( 7*32+14) /* "" Disable Speculative Store Bypass. */
-#define X86_FEATURE_LS_CFG_SSBD	( 7*32+15) /* "" AMD SSBD implementation */
-#define X86_FEATURE_IBRS	( 7*32+16) /* Indirect Branch Restricted Speculation */
-#define X86_FEATURE_IBPB	( 7*32+17) /* Indirect Branch Prediction Barrier */
-#define X86_FEATURE_STIBP	( 7*32+18) /* Single Thread Indirect Branch Predictors */
-#define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+19) /* "" MSR SPEC_CTRL is implemented */
-#define X86_FEATURE_SSBD	( 7*32+20) /* Speculative Store Bypass Disable */
-#define X86_FEATURE_ZEN		( 7*32+21) /* "" CPU is AMD family 0x17 (Zen) */
-#define X86_FEATURE_L1TF_PTEINV	( 7*32+22) /* "" L1TF workaround PTE inversion */
-#define X86_FEATURE_IBRS_ENHANCED ( 7*32+23) /* Enhanced IBRS */
-#define X86_FEATURE_RETPOLINE	( 7*32+29) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD ( 7*32+30) /* "" AMD Retpoline mitigation for Spectre variant 2 */
-/* Because the ALTERNATIVE scheme is for members of the X86_FEATURE club... */
+
+#define X86_FEATURE_RETPOLINE	( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_AMD ( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+
+#define X86_FEATURE_XSAVEOPT	( 7*32+15) /* Optimized Xsave */
+#define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
+#define X86_FEATURE_SSBD	( 7*32+17) /* Speculative Store Bypass Disable */
+
+#define X86_FEATURE_RSB_CTXSW	( 7*32+19) /* "" Fill RSB on context switches */
+
+#define X86_FEATURE_USE_IBPB	( 7*32+21) /* "" Indirect Branch Prediction Barrier enabled */
+#define X86_FEATURE_USE_IBRS_FW ( 7*32+22) /* "" Use IBRS during runtime firmware calls */
+#define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE ( 7*32+23) /* "" Disable Speculative Store Bypass. */
+#define X86_FEATURE_LS_CFG_SSBD	( 7*32+24) /* "" AMD SSBD implementation */
+#define X86_FEATURE_IBRS	( 7*32+25) /* Indirect Branch Restricted Speculation */
+#define X86_FEATURE_IBPB	( 7*32+26) /* Indirect Branch Prediction Barrier */
+#define X86_FEATURE_STIBP	( 7*32+27) /* Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_ZEN		( 7*32+28) /* "" CPU is AMD family 0x17 (Zen) */
+#define X86_FEATURE_L1TF_PTEINV	( 7*32+29) /* "" L1TF workaround PTE inversion */
+#define X86_FEATURE_IBRS_ENHANCED ( 7*32+30) /* Enhanced IBRS */
 #define X86_FEATURE_KAISER	( 7*32+31) /* CONFIG_PAGE_TABLE_ISOLATION w/o nokaiser */
 
 /* Virtualization flags: Linux defined, word 8 */

