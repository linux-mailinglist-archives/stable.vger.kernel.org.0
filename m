Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE53F1948
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhHSMbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 08:31:14 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8045 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbhHSMbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 08:31:13 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gr3xs348dzYrFf;
        Thu, 19 Aug 2021 20:30:09 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:35 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:34 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10.y 0/6] Collected perf patches for stable 5.10.y
Date:   Thu, 19 Aug 2021 20:19:06 +0800
Message-ID: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I collected some bugfix perf patches which are missing for 5.10.y,
please consider to apply.

Athira Rajeev (1):
  powerpc/perf: Invoke per-CPU variable access with disabled interrupts

Jianlin Lv (1):
  perf tools: Fix arm64 build error with gcc-11

Martin Liška (1):
  perf annotate: Fix jump parsing for C++ code.

Namhyung Kim (1):
  perf record: Fix memory leak in vDSO found using ASAN

Riccardo Mancini (2):
  perf env: Fix memory leak of bpf_prog_info_linear member
  perf symbol-elf: Fix memory leak by freeing sdt_note.args

 arch/powerpc/perf/core-book3s.c             | 10 ++++++----
 tools/perf/arch/arm/include/perf_regs.h     |  2 +-
 tools/perf/arch/arm64/include/perf_regs.h   |  2 +-
 tools/perf/arch/csky/include/perf_regs.h    |  2 +-
 tools/perf/arch/powerpc/include/perf_regs.h |  2 +-
 tools/perf/arch/riscv/include/perf_regs.h   |  2 +-
 tools/perf/arch/s390/include/perf_regs.h    |  2 +-
 tools/perf/arch/x86/include/perf_regs.h     |  2 +-
 tools/perf/util/annotate.c                  |  8 ++++++++
 tools/perf/util/annotate.h                  |  1 +
 tools/perf/util/env.c                       |  1 +
 tools/perf/util/perf_regs.h                 |  7 +++++++
 tools/perf/util/symbol-elf.c                |  1 +
 tools/perf/util/vdso.c                      |  2 ++
 14 files changed, 33 insertions(+), 11 deletions(-)

-- 
1.7.12.4

