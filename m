Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0B87C09
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406828AbfHINqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406518AbfHINqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 803E6217D7;
        Fri,  9 Aug 2019 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358361;
        bh=1FDd1yFLv1xP4YB+H2uGGTbxLU9UAx5omIAoX2E56kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6zFQc/W7Qc2P66GjKMW8KS0xO1IqNGn2UugYIh+9S2su4mHLZybZz4nPI/1+1DbA
         hONeY3AQui8xAhYNjj7fXwpalLQQA4hBwkgqe1y9ai6qpaxW08RPQvUW0XGuPn7fYJ
         Z/aXJXdrRD3L9fAVCFrNsF/1TEn/7SDMYr1SM348=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 16/21] x86: cpufeatures: Sort feature word 7
Date:   Fri,  9 Aug 2019 15:45:20 +0200
Message-Id: <20190809134242.234053013@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

This will make it clearer which bits are allocated, in case we need to
assign more feature bits for later backports.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -196,13 +196,10 @@
 #define X86_FEATURE_RETPOLINE_AMD ( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
 
 #define X86_FEATURE_INTEL_PT	( 7*32+15) /* Intel Processor Trace */
-#define X86_FEATURE_RSB_CTXSW	( 7*32+19) /* "" Fill RSB on context switches */
-
 #define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
 #define X86_FEATURE_SSBD	( 7*32+17) /* Speculative Store Bypass Disable */
 
-/* Because the ALTERNATIVE scheme is for members of the X86_FEATURE club... */
-#define X86_FEATURE_KAISER	( 7*32+31) /* CONFIG_PAGE_TABLE_ISOLATION w/o nokaiser */
+#define X86_FEATURE_RSB_CTXSW	( 7*32+19) /* "" Fill RSB on context switches */
 
 #define X86_FEATURE_USE_IBPB	( 7*32+21) /* "" Indirect Branch Prediction Barrier enabled*/
 #define X86_FEATURE_USE_IBRS_FW	( 7*32+22) /* "" Use IBRS during runtime firmware calls */
@@ -215,6 +212,7 @@
 #define X86_FEATURE_ZEN		( 7*32+28) /* "" CPU is AMD family 0x17 (Zen) */
 #define X86_FEATURE_L1TF_PTEINV	( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
+#define X86_FEATURE_KAISER	( 7*32+31) /* CONFIG_PAGE_TABLE_ISOLATION w/o nokaiser */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  ( 8*32+ 0) /* Intel TPR Shadow */


