Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1B61346B
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 12:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiJaLXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 07:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJaLXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 07:23:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AD5E090;
        Mon, 31 Oct 2022 04:23:02 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N19cZ0c8LzVj0m;
        Mon, 31 Oct 2022 19:18:06 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:23:00 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:22:59 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <james.morse@arm.com>,
        <anshuman.khandual@arm.com>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <maz@kernel.org>, <suzuki.poulose@arm.com>,
        <ardb@kernel.org>, <mark.rutland@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <anders.roxell@linaro.org>
Subject: [PATCH 5.10 0/2] arm64: backport two patches to 5.10-stable
Date:   Mon, 31 Oct 2022 19:22:44 +0800
Message-ID: <20221031112246.1588-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch #1 (merged in 5.12-rc3) is required to address the issue
Anders Roxell reported on the list [1].  Patch #2 (in 5.15-rc1) is
a follow up.

[1] https://lore.kernel.org/lkml/20220826120020.GB520@mutt

Anshuman Khandual (1):
  arm64/kexec: Test page size support with new TGRAN range values

James Morse (1):
  arm64/mm: Fix __enable_mmu() for new TGRAN range values

 arch/arm64/include/asm/cpufeature.h       |  9 ++++--
 arch/arm64/include/asm/sysreg.h           | 36 +++++++++++++++--------
 arch/arm64/kernel/head.S                  |  6 ++--
 arch/arm64/kvm/reset.c                    | 10 ++++---
 drivers/firmware/efi/libstub/arm64-stub.c |  2 +-
 5 files changed, 41 insertions(+), 22 deletions(-)

-- 
2.33.0

