Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061644928A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfFQVVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729310AbfFQVVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:21:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD742089E;
        Mon, 17 Jun 2019 21:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806473;
        bh=oAUOUWEhdKBN4khXPD+Q8RvK53Yw50WUgHO41gXbvZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSl7637gm1bFzFXIxbp/U0hGqCHTogMlwhqgVaHacsexa6W2poljtI8qc7MoiIfds
         sBKIjmF5Dq4RkZLj9XBRvx1996ZLKqdIMsJaDyfbR0iqSEqRV/74sPzyRq3Q/9fxa3
         cnFdzItXJAV42m4E4JbB0cvb9EzT9M+O5fd5bd2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 064/115] selftests/bpf: fix bpf_get_current_task
Date:   Mon, 17 Jun 2019 23:09:24 +0200
Message-Id: <20190617210803.459510549@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ed4b4e60bb1dd3df7a45dfbde3a96efce9df7eb ]

Fix bpf_get_current_task() declaration.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index c81fc350f7ad..a43a52cdd3f0 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -246,7 +246,7 @@ static int (*bpf_skb_change_type)(void *ctx, __u32 type) =
 	(void *) BPF_FUNC_skb_change_type;
 static unsigned int (*bpf_get_hash_recalc)(void *ctx) =
 	(void *) BPF_FUNC_get_hash_recalc;
-static unsigned long long (*bpf_get_current_task)(void *ctx) =
+static unsigned long long (*bpf_get_current_task)(void) =
 	(void *) BPF_FUNC_get_current_task;
 static int (*bpf_skb_change_tail)(void *ctx, __u32 len, __u64 flags) =
 	(void *) BPF_FUNC_skb_change_tail;
-- 
2.20.1



