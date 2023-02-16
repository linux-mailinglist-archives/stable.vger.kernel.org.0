Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD427698B3E
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 04:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBPDpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 22:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBPDpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 22:45:01 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B5BDDB;
        Wed, 15 Feb 2023 19:45:00 -0800 (PST)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PHLNv2KwCzRs3x;
        Thu, 16 Feb 2023 11:42:23 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Feb 2023 11:44:57 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <naveen.n.rao@linux.ibm.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <mhiramat@kernel.org>, <ast@kernel.org>,
        <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <yangjihong1@huawei.com>
Subject: [PATCH v2 0/2] kprobes: Fix issues related to optkprobe
Date:   Thu, 16 Feb 2023 11:42:45 +0800
Message-ID: <20230216034247.32348-1-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixed optkprobe issues, mainly related to the x86 architecture.

Yang Jihong (2):
  x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
  x86/kprobes: Fix arch_check_optimized_kprobe check within
    optimized_kprobe range

 arch/x86/kernel/kprobes/opt.c | 6 +++---
 include/linux/kprobes.h       | 2 ++
 kernel/kprobes.c              | 4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 

Changes since v1:
  - Remove patch1 since there is already a fix patch.
  - Add "cc stable" and modify comment for patch2.
  - Use "kprobe_disarmed" instead of "kprobe_disabled" for patch3.
  - Add fix commmit and "cc stable" for patch3.

2.30.GIT

