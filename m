Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B532D54B931
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357037AbiFNSnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356567AbiFNSm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:42:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17674B418;
        Tue, 14 Jun 2022 11:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A7EB81AF1;
        Tue, 14 Jun 2022 18:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC427C3411B;
        Tue, 14 Jun 2022 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232117;
        bh=o8Sf0D6Qd6QqHLBx+8yDRL9ZoeMOaYYhYVXm408rksU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+Tdt8tdphFOY8/QaDgbF76Pqi3f7bnj9jhDQoxLYk9c3ZqFFze+K/Zqlf251Ou8U
         KdBtTv7UJdr3avXNIjxdFqdbEOYKlme1qUScUOE/vgZ2xzPziLX3El0fhMCNiEdXGf
         O3OndoCLTYjyqjQcVwjt6aq7Qg0MX6SqfQAU3grU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 01/20] x86/cpu: Add Elkhart Lake to Intel family
Date:   Tue, 14 Jun 2022 20:39:52 +0200
Message-Id: <20220614183723.685479391@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183723.328825625@linuxfoundation.org>
References: <20220614183723.328825625@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

commit 0f65605a8d744b3a205d0a2cd8f20707e31fc023 upstream.

Add the model number/CPUID of atom based Elkhart Lake to the Intel
family.

Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rahul Tanwar <rahul.tanwar@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190905193020.14707-3-tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -68,7 +68,9 @@
 #define INTEL_FAM6_ATOM_GOLDMONT	0x5C /* Apollo Lake */
 #define INTEL_FAM6_ATOM_GOLDMONT_X	0x5F /* Denverton */
 #define INTEL_FAM6_ATOM_GOLDMONT_PLUS	0x7A /* Gemini Lake */
+
 #define INTEL_FAM6_ATOM_TREMONT_X	0x86 /* Jacobsville */
+#define INTEL_FAM6_ATOM_TREMONT		0x96 /* Elkhart Lake */
 
 /* Xeon Phi */
 


