Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BAD4F6B38
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiDFUVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiDFUVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E25226F93B;
        Wed,  6 Apr 2022 11:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4108B824E1;
        Wed,  6 Apr 2022 18:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46979C385A5;
        Wed,  6 Apr 2022 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269662;
        bh=2J6ctvOnSqIruVSYh3Ad9r931XW/4YgbYF6bW2tts/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSOSjTSYQ6iHJwTUozPT3RLU/IBdMOqfmxejYtN+PaKGBeG8b+LDLNVXX5JOcXffQ
         qTqvmikOp4fh75kN3LEl12/kf59baJHaFp3CSKbgNJWbDYiUKMAFfHXO6udg5pH1Ha
         g74ZB/wpZtMIQaexdg792IOu28nOSancV/gVXe2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 23/43] arm64: Add Cortex-X2 CPU part definition
Date:   Wed,  6 Apr 2022 20:26:32 +0200
Message-Id: <20220406182437.354843663@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 72bb9dcb6c33cfac80282713c2b4f2b254cd24d1 upstream.

Add the CPU Partnumbers for the new Arm designs.

Cc: Will Deacon <will@kernel.org>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/1642994138-25887-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -89,6 +89,7 @@
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
 #define ARM_CPU_PART_CORTEX_A710	0xD47
+#define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 
 #define APM_CPU_PART_POTENZA		0x000
@@ -111,6 +112,7 @@
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
+#define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)


