Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B31B7BBE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDXQiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:38:16 -0400
Received: from foss.arm.com ([217.140.110.172]:39442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXQiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:38:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0955B31B;
        Fri, 24 Apr 2020 09:38:16 -0700 (PDT)
Received: from melchizedek.cambridge.arm.com (melchizedek.cambridge.arm.com [10.1.196.50])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E85B3F68F;
        Fri, 24 Apr 2020 09:38:15 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org
Subject: [stable:PATCH 0/4 v5.4] arm64: Workaround Neoverse-N1 #1542419
Date:   Fri, 24 Apr 2020 17:38:01 +0100
Message-Id: <20200424163805.4087-1-james.morse@arm.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports the Neoverse-N1 #1542419 erratum workaround
to v5.4.35. The series was originally merged in v5.5.

These patches handle user-space. The kernel change was:
commit dd8a1f134884 ("arm64: ftrace: Ensure synchronisation in PLT setup
for Neoverse-N1 #1542419"), which was taken as a fix for v5.4.

Thanks,

James

Catalin Marinas (1):
  arm64: Silence clang warning on mismatched value/register sizes

James Morse (3):
  arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1
    #1542419
  arm64: Fake the IminLine size on systems affected by Neoverse-N1
    #1542419
  arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space

 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 16 +++++++++++++
 arch/arm64/include/asm/cache.h         |  3 ++-
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 32 +++++++++++++++++++++++++-
 arch/arm64/kernel/sys_compat.c         | 11 +++++++++
 arch/arm64/kernel/traps.c              |  9 ++++++++
 7 files changed, 73 insertions(+), 3 deletions(-)

-- 
2.19.1

