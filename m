Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24252A168A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgJaLqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgJaLqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AE2120739;
        Sat, 31 Oct 2020 11:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144779;
        bh=I7ef5RP+nZYYyssBBSxTSJttzDcyY9c8ZJO+3R3iCgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMAVwQpVmka0p6Oy6zn2gO3LTdpCOv1e8aU6kWJuCUFBoOJDyDKZHm9HvXDgbnpaa
         BflcBR6qKfPE/YSHO7n514noUG8XO77RP9PTdPLkggFHqY2QbXJ9bZewwFjmQRibtY
         UtvqR4v39hA3Zmw2HhjGreG1uqwSGr0NzUR86Pos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.9 59/74] bpf: Fix comment for helper bpf_current_task_under_cgroup()
Date:   Sat, 31 Oct 2020 12:36:41 +0100
Message-Id: <20201031113502.859072000@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
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
@@ -1438,8 +1438,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- * 		* 0, if the *skb* task belongs to the cgroup2.
- * 		* 1, if the *skb* task does not belong to the cgroup2.
+ *		* 0, if current task belongs to the cgroup2.
+ *		* 1, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1438,8 +1438,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- * 		* 0, if the *skb* task belongs to the cgroup2.
- * 		* 1, if the *skb* task does not belong to the cgroup2.
+ *		* 0, if current task belongs to the cgroup2.
+ *		* 1, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)


