Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F8408E93
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242375AbhIMNf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242093AbhIMNdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:33:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC9361374;
        Mon, 13 Sep 2021 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539572;
        bh=mc+rpcB+SnSAVcNchxUQ3vLDWSMWjRNrb9TlqMYCSXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGo4vmAIEtR5XIciRIqdz/nBqxx9+6Pv82PrzEclogAURDXF/v5EmrDAS3uQt4afm
         oBCu64X2sYKx4BjQP0roSbH29kCADf2s1aUhma6K34H7Wz8c3pGrngI4xM+THql8cV
         AHu9upqFNVvIRfsM/M0yNJGR34Zvbgt0u0YxpGiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/236] bpf: Fix a typo of reuseport map in bpf.h.
Date:   Mon, 13 Sep 2021 15:13:02 +0200
Message-Id: <20210913131102.980438416@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit f170acda7ffaf0473d06e1e17c12cd9fd63904f5 ]

Fix s/BPF_MAP_TYPE_REUSEPORT_ARRAY/BPF_MAP_TYPE_REUSEPORT_SOCKARRAY/ typo
in bpf.h.

Fixes: 2dbb9b9e6df6 ("bpf: Introduce BPF_PROG_TYPE_SK_REUSEPORT")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20210714124317.67526-1-kuniyu@amazon.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 556216dc9703..762bf87c26a3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2450,7 +2450,7 @@ union bpf_attr {
  * long bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Select a **SO_REUSEPORT** socket from a
- *		**BPF_MAP_TYPE_REUSEPORT_ARRAY** *map*.
+ *		**BPF_MAP_TYPE_REUSEPORT_SOCKARRAY** *map*.
  *		It checks the selected socket is matching the incoming
  *		request in the socket buffer.
  *	Return
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 556216dc9703..762bf87c26a3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2450,7 +2450,7 @@ union bpf_attr {
  * long bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Select a **SO_REUSEPORT** socket from a
- *		**BPF_MAP_TYPE_REUSEPORT_ARRAY** *map*.
+ *		**BPF_MAP_TYPE_REUSEPORT_SOCKARRAY** *map*.
  *		It checks the selected socket is matching the incoming
  *		request in the socket buffer.
  *	Return
-- 
2.30.2



