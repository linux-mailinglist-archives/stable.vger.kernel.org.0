Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934593F1857
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 13:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhHSLkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 07:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbhHSLkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 07:40:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95554C061575;
        Thu, 19 Aug 2021 04:40:05 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g138so3644056wmg.4;
        Thu, 19 Aug 2021 04:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EtgvXhAGt19qhroUE6m6P7pb+TNdJ1fCcsUGPxSLauI=;
        b=qgdelYbbaIFqrbFwfaA5EXeG+i70bRf7BubylNOL2c8rnvz4kBrWAJX2G7Fnb1u2OQ
         lO9a6X6BJ1gV/GGO+OZU5bA/vpXb9fC3c0o7WhIKJrLDmSXJ8cjyLHcsqChCEx9BrIY4
         LiupfmrUAVFAfTpZyO/g4+tJUg9AmPU2f3gvxZU4vGjgDOq9SJbrQ+qkJAq0D2ryAzzC
         UtQR5u+oINJ0DfoyRdke5/USJTG8egMCz5D4Oa8U9H6n66YLjSPR5o6cc4kfkbVW8UP6
         3M+0DxeXQVYPHyykhXqn+w+Cf89SXMzTSWtmwkd0Y3yAQWtYn4F6cQusgXDLJoFYCO2/
         nlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EtgvXhAGt19qhroUE6m6P7pb+TNdJ1fCcsUGPxSLauI=;
        b=cu+Qwo4XVw5LEL+3XjWEiCs9AENMXSzBD30vC3za7aPZFSuz9vQN4Fjbi435gc+V7m
         I4N6gwcuAAcTdpJfXqhO24xJz25ONPEjH15ubeoqGHHScx/Txa63A+52e/T1lWOz7PpS
         WC+qUiHcyaKGR/KrO8Xb8d2HlNwktPeOkxGCZAsk+6emfBUbWZrjotrxaFOpRlxqjUGR
         Aziog/UKJTF8+V5l2XMZYiYlFmnkC/24vcZwcsO02PdWz8fMzYVPcOCjNTiG+TZqBGnP
         FpnhOkhDX9ez8Jgwmj5utkk2/muyMBUsnko3zaRmOnacWAC5PECIZO6AUO5bS/lYIfNk
         Y/nw==
X-Gm-Message-State: AOAM532FhVQdNDQebffdvVasT6ahT2pJmKa+9MELC+iVd369S2eXglvo
        7V7EQKbZdaeLTJ9RV4jr7Hk=
X-Google-Smtp-Source: ABdhPJysGEtO7h5HDEHbCC6sb2xHTov/gXqitGsEWyloYIsqxzFsQa4iMVyAfZ4X38bnwpxBw9mMMQ==
X-Received: by 2002:a05:600c:3554:: with SMTP id i20mr2089272wmq.70.1629373204136;
        Thu, 19 Aug 2021 04:40:04 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id b13sm2650891wrf.86.2021.08.19.04.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:40:03 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v2 0/2] Kconfig symbol fixes on powerpc
Date:   Thu, 19 Aug 2021 13:39:52 +0200
Message-Id: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear powerpc maintainers,

The script ./scripts/checkkconfigsymbols.py warns on invalid references to
Kconfig symbols (often, minor typos, name confusions or outdated references).

This patch series addresses all issues reported by
./scripts/checkkconfigsymbols.py in ./drivers/usb/ for Kconfig and Makefile
files. Issues in the Kconfig and Makefile files indicate some shortcomings in
the overall build definitions, and often are true actionable issues to address.

These issues can be identified and filtered by:

  ./scripts/checkkconfigsymbols.py | grep -E "arch/powerpc/.*(Kconfig|Makefile)" -B 1 -A 1

After applying this patch series on linux-next (next-20210817), the command
above yields just two false positives (SHELL, r13) due to tool shortcomings.

As these two patches are fixes, please consider if they are suitable for
backporting to stable.

v1 -> v2:
  Followed Christophe Leroy's comment and drop the obsolete select.


Lukas

Lukas Bulwahn (2):
  powerpc: kvm: remove obsolete and unneeded select
  powerpc: rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK

 arch/powerpc/kvm/Kconfig               | 1 -
 arch/powerpc/platforms/Kconfig.cputype | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
2.26.2

