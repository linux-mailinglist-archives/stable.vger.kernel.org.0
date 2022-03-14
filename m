Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4FE4D8224
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbiCNMAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbiCNMAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF135FAE;
        Mon, 14 Mar 2022 04:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9F86125F;
        Mon, 14 Mar 2022 11:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6351C340ED;
        Mon, 14 Mar 2022 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259103;
        bh=o/ZljB33tbEyw/3OJ4/rKpj5QYTr4X7wpW6V8xR5JkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ym+VmX/jc992mP4SkMuxx+OpqdLQ4r6t2gg8BV+gGB+QkJlduRdLrG0t1lhleftWr
         Fb203RFWArTSpAGaZu3WNzB/rZPXT5Poxro0eMhmPQx+zQHTBg86U7GjVD509h/VcK
         nPgWMEHi94sUivrFZO1K2OoS29S2bPvfWyFLuT4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Liam Merwick <liam.merwick@oracle.com>
Subject: [PATCH 5.4 40/43] x86/cpufeatures: Mark two free bits in word 3
Date:   Mon, 14 Mar 2022 12:53:51 +0100
Message-Id: <20220314112735.544396815@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit fbd5969d1ff2598143d6a6fbc9491a9e40ab9b82 upstream.

... so that they get reused when needed.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200604104150.2056-1-bp@alien8.de
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -96,6 +96,7 @@
 #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
+/* free					( 3*32+17) */
 #define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
@@ -107,6 +108,7 @@
 #define X86_FEATURE_EXTD_APICID		( 3*32+26) /* Extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM		( 3*32+27) /* AMD multi-node processor */
 #define X86_FEATURE_APERFMPERF		( 3*32+28) /* P-State hardware coordination feedback capability (APERF/MPERF MSRs) */
+/* free					( 3*32+29) */
 #define X86_FEATURE_NONSTOP_TSC_S3	( 3*32+30) /* TSC doesn't stop in S3 state */
 #define X86_FEATURE_TSC_KNOWN_FREQ	( 3*32+31) /* TSC has known frequency */
 


