Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF46E2F79AC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388319AbhAOMje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732190AbhAOMjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0132388B;
        Fri, 15 Jan 2021 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714332;
        bh=727SLJwcnDyVJtbaGSPfY/D3gLMX3sFF19oBNHjajJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbFp0qT2v7LXzUdveQUaCzmvAKVdHp3mpjtYZ8jBOCtB+2AOM4BUKCb9oRKelm7yy
         b+HUe9rcmJIaJ8+dohEcBUeoskXbvpk8BfTYUGMu8Ko1MnutjSc0HFhYMyrsK3Mvuo
         DxnC0fvXUX7HTc8yg7/TzWJb8VkE7533BSh4LkGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 088/103] arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST
Date:   Fri, 15 Jan 2021 13:28:21 +0100
Message-Id: <20210115122010.272945586@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linux.alibaba.com>

commit 45ba7b195a369f35cb39094fdb32efe5908b34ad upstream.

Commit d82755b2e781 ("KVM: arm64: Kill off CONFIG_KVM_ARM_HOST") deletes
CONFIG_KVM_ARM_HOST option, it should use CONFIG_KVM instead.

Just remove CONFIG_KVM_ARM_HOST here.

Fixes: d82755b2e781 ("KVM: arm64: Kill off CONFIG_KVM_ARM_HOST")
Signed-off-by: Shannon Zhao <shannon.zhao@linux.alibaba.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1609760324-92271-1-git-send-email-shannon.zhao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpufeature.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2552,7 +2552,7 @@ static void verify_hyp_capabilities(void
 	int parange, ipa_max;
 	unsigned int safe_vmid_bits, vmid_bits;
 
-	if (!IS_ENABLED(CONFIG_KVM) || !IS_ENABLED(CONFIG_KVM_ARM_HOST))
+	if (!IS_ENABLED(CONFIG_KVM))
 		return;
 
 	safe_mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);


