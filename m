Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417C0D6293
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbfJNMdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 08:33:00 -0400
Received: from foss.arm.com ([217.140.110.172]:42546 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbfJNMdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 08:33:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B47DC337;
        Mon, 14 Oct 2019 05:32:59 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8D66A3F68E;
        Mon, 14 Oct 2019 05:32:58 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        maz@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable-4.4][PATCH 0/2] arm64: cpufeature: Fix truncating a feature value
Date:   Mon, 14 Oct 2019 13:32:52 +0100
Message-Id: <20191014123254.22002-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes the issue with arm64_ftr_value() where the signed
fields are truncated to unsigned values corrupting the system wide
safe values.


Suzuki K Poulose (2):
  arm64: capabilities: Handle sign of the feature bit
  arm64: Rename cpuid_feature field extract routines

 arch/arm64/include/asm/cpufeature.h | 29 +++++++++++++++---------
 arch/arm64/kernel/cpufeature.c      | 35 ++++++++++++++++-------------
 arch/arm64/kernel/debug-monitors.c  |  2 +-
 arch/arm64/kvm/sys_regs.c           |  2 +-
 arch/arm64/mm/context.c             |  3 ++-
 5 files changed, 42 insertions(+), 29 deletions(-)

-- 
2.21.0

