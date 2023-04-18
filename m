Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3936E63F9
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjDRMpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjDRMo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0494D167C6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912E263383
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FEFC433D2;
        Tue, 18 Apr 2023 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821897;
        bh=JegotNx5fBXykk8QkNgylxdkaBH7T4nUuNR8kI4BsII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nS3cObzAv+jnwZ31NfWc1I8ElX22pok1Q5L7M5/abHyGbevktl13ABl7s0b+0EwH7
         De3qKiW3Iqo57NwCBohvuu0dhLqyBVsGRJcORtoR9CiApgf93m9EHg7Xv3Tya+c37M
         o/mkqrR1JHVKtWsNcdyYmsQhvUHXUTvhoJMUup/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/134] selftests/bpf: Fix progs/find_vma_fail1.c build error.
Date:   Tue, 18 Apr 2023 14:22:11 +0200
Message-Id: <20230418120315.647096892@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 32513d40d908b267508d37994753d9bd1600914b ]

The commit 11e456cae91e ("selftests/bpf: Fix compilation errors: Assign a value to a constant")
fixed the issue cleanly in bpf-next.
This is an alternative fix in bpf tree to avoid merge conflict between bpf and bpf-next.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/find_vma_fail1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
index b3b326b8e2d1c..6dab9cffda132 100644
--- a/tools/testing/selftests/bpf/progs/find_vma_fail1.c
+++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
+#define vm_flags vm_start
 
 char _license[] SEC("license") = "GPL";
 
-- 
2.39.2



