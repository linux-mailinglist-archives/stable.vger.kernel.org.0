Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6822A15B0
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgJaLhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727350AbgJaLhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:37:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0A120731;
        Sat, 31 Oct 2020 11:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144233;
        bh=QSgOOz8EW0QAiJ/4zYD9fBA1PX1UTHtZc2GxUPW0aH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTizZLhbYVJkPqyM4LPKjF5b6I/kmH2imPP7utHGCthNP4xllc0inTuSnDhRhJXxk
         4yLuTMfXF7T0FtCDqTTuFjOfnomho/qTzNu90LqFfXW0Ih0sRiR50SQZWKYNocaisc
         Pa/REsTDyEoXqIgcYK14yQ8rLeulVZ35XpXYGF/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 34/49] bpf: Fix comment for helper bpf_current_task_under_cgroup()
Date:   Sat, 31 Oct 2020 12:35:30 +0100
Message-Id: <20201031113457.086971655@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit 1aef5b4391f0c75c0a1523706a7b0311846ee12f upstream.

This should be "current" not "skb".

Fixes: c6b5fb8690fa ("bpf: add documentation for eBPF helpers (42-50)")
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/bpf/20200910203314.70018-1-songliubraving@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/bpf.h       |    4 ++--
 tools/include/uapi/linux/bpf.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1294,8 +1294,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- * 		* 0, if the *skb* task belongs to the cgroup2.
- * 		* 1, if the *skb* task does not belong to the cgroup2.
+ *		* 0, if current task belongs to the cgroup2.
+ *		* 1, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * int bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1294,8 +1294,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- * 		* 0, if the *skb* task belongs to the cgroup2.
- * 		* 1, if the *skb* task does not belong to the cgroup2.
+ *		* 0, if current task belongs to the cgroup2.
+ *		* 1, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * int bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)


