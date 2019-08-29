Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB1A1738
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfH2Kuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbfH2Kui (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49CA2342B;
        Thu, 29 Aug 2019 10:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075837;
        bh=SpQSLdYBvyq82meyXXWCtVnYVpt4u878OvYEkOU5qS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTA6bGvxlhbxgT2HeFR8Q6yjPBdza8DjKL32zeBy4ZIqLFc9uv12SaFxGKxcI5Rng
         +6orEfvlKGwv8kVWCwMjnCBlXg2V9Hx0lduKeOWnEmMiM1RaClfnOSZ9On2HEKa9mR
         pj58K6SJjDcomfD1H6N4hf5oaZcbBXRJ1UUoU4XM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 24/29] riscv: remove unused variable in ftrace
Date:   Thu, 29 Aug 2019 06:50:04 -0400
Message-Id: <20190829105009.2265-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Abdurachmanov <david.abdurachmanov@gmail.com>

[ Upstream commit 397182e0db56b8894a43631ce72de14d90a29834 ]

Noticed while building kernel-4.20.0-0.rc5.git2.1.fc30 for
Fedora 30/RISCV.

[..]
BUILDSTDERR: arch/riscv/kernel/ftrace.c: In function 'prepare_ftrace_return':
BUILDSTDERR: arch/riscv/kernel/ftrace.c:135:6: warning: unused variable 'err' [-Wunused-variable]
BUILDSTDERR:   int err;
BUILDSTDERR:       ^~~
[..]

Signed-off-by: David Abdurachmanov <david.abdurachmanov@gmail.com>
Fixes: e949b6db51dc1 ("riscv/function_graph: Simplify with function_graph_enter()")
Reviewed-by: Olof Johansson <olof@lixom.net>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/ftrace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index c433f6d3dd64f..a840b7d074f7d 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -132,7 +132,6 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 {
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
 	unsigned long old;
-	int err;
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
-- 
2.20.1

