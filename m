Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2093F1B304C
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDUT0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgDUT0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 15:26:15 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA84C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 12:26:15 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id j4so12146236otr.11
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 12:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4RufJM5NgKGQC4bqZpexQ+zKH5F1WL0DieK2D4zEP+o=;
        b=rPNM6O+oSKBi/Y1in99mIMofZwtCVIeUsl5rJ8k8UA0H6Cs9xbPoUZgsv14UalFIUY
         QnyqxZiC8w7DxZ7iG0wDx9SAHNxWJDfdEVBOwIMN/j9o8dK/DKp6B8dwXsXv5g50fFwS
         bTfJvC1pLC+aERcVzr9rGNGeNhOqkpF8SFmLQBmRwOL018u4TwduR3i9Btk8duU5NT1X
         pj539ZWAzL56ClK7fWbMSOOjTr/+z5kVz651dsyvT45YyymQoGSoDdwOjav7RCtycpWs
         Qq6XmmzjMdtUiueWFzjra16IdPgEDPuoXKeWgD0miKDZ4y+TYu7Qk1vrEu8Lj6EtGiVM
         2cRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4RufJM5NgKGQC4bqZpexQ+zKH5F1WL0DieK2D4zEP+o=;
        b=lmYxv7aVfO8Sp4567VY1BsnJk/GUgYEkK9jOzMRYQsjP0hVWYqWjdvBTdGCWOcgAE/
         SXrmwfGJaLJhoK5Vb0JR2slt6Q4LmylUjnv76r+5MFvhEGdS+l8d+DUYc1DfjLwFYk1J
         K22PurNUG9WW2lp6dPcfE6KmY3ZB7+LpHz85VJQAqNpoSEaq1YL/Y+1Htwk7uTe7KxjF
         vBqXFAmkWIwx01KrZfR8GbBcvCwSWUy2d3c/Cto7kdFrtsYaa5GhpdNypB2xcjYz95c1
         WXv27DeSR/FsX0UBHXLWDvubeC0zd/7j/EJWPUBsSO3FYDMQdhN0i8BSBTUjVIjBaoL5
         SWcg==
X-Gm-Message-State: AGi0PubHxTOiOtEf4bfbcdQXGfKd0218aTt4BEJOyd41HS0z7/fOfx9G
        /sJkQ/CFPlOS+wnW+xfHFiPmqQbG
X-Google-Smtp-Source: APiQypJfo6igOEwTtb5JB/z51Yqbp5HFULEGaLTO4DbRyP0sGELLZZdjPIFUsQl/+GjuGaAGaZHNcg==
X-Received: by 2002:a9d:798b:: with SMTP id h11mr2999703otm.120.1587497174917;
        Tue, 21 Apr 2020 12:26:14 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id o73sm951553ota.77.2020.04.21.12.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 12:26:14 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.9] arm64: cpu_errata: include required headers
Date:   Tue, 21 Apr 2020 12:20:41 -0700
Message-Id: <20200421192040.43080-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 94a5d8790e79ab78f499d2d9f1ff2cab63849d9f upstream.

Without including psci.h and arm-smccc.h, we now get a build failure in
some configurations:

arch/arm64/kernel/cpu_errata.c: In function 'arm64_update_smccc_conduit':
arch/arm64/kernel/cpu_errata.c:278:10: error: 'psci_ops' undeclared (first use in this function); did you mean 'sysfs_ops'?

arch/arm64/kernel/cpu_errata.c: In function 'arm64_set_ssbd_mitigation':
arch/arm64/kernel/cpu_errata.c:311:3: error: implicit declaration of function 'arm_smccc_1_1_hvc' [-Werror=implicit-function-declaration]
   arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Greg and Sasha,

Please apply this to 4.9. The error in the commit message can be
reproduced on 4.9.219 when CONFIG_ARM64_SSBD is enabled and
CONFIG_HARDEN_BRANCH_PREDICTOR is disabled. It was reported to me by a
user of one of my Android stable trees, where one of the configs in
Qualcomm's 4.9 tree reproduced this issue.

This commit is in 4.14 already so this should be the only tree where it
is needed.

 arch/arm64/kernel/cpu_errata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 930e74d9fcbd..3b680a32886b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -16,6 +16,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm-smccc.h>
+#include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/cachetype.h>
 #include <asm/cpu.h>

base-commit: 5188957a315f664d46ff58fedecbc0f7503f1b22
-- 
2.26.2

