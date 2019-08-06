Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6CA83B49
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfHFVeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfHFVeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2052089E;
        Tue,  6 Aug 2019 21:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127254;
        bh=j7dRkRn0P7DuIjEpAV9BUNkDp+uQeUKmWjYYzdwUzds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGrHG4MDkeST0rTxMk/NWR0hNZq1aURM0UDmjEwTE32HO+QRZRQ9G3e5H5v/qsmbJ
         kjKjQ+SfSAjsm9Pp1FSlVYKTODsO6/n1OTsG1U8vUOQn0ad/biJkbFqYvsI69MYXze
         RFAsrGl8E4BcWUXexbCJjfZYptqMbem5QhQvYy4I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 28/59] tracing: Fix header include guards in trace event headers
Date:   Tue,  6 Aug 2019 17:32:48 -0400
Message-Id: <20190806213319.19203-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit b1d45c23284e55a379f85554a27a548b7988d47a ]

These include guards are broken.

Match the #if !define() and #define lines so that they work correctly.

Link: http://lkml.kernel.org/r/20190720103943.16982-1-yamada.masahiro@socionext.com

Fixes: f54d1867005c3 ("dma-buf: Rename struct fence to dma_fence")
Fixes: 2e26ca7150a4f ("tracing: Fix tracepoint.h DECLARE_TRACE() to allow more than one header")
Fixes: e543002f77f46 ("qdisc: add tracepoint qdisc:qdisc_dequeue for dequeued SKBs")
Fixes: 95f295f9fe081 ("dmaengine: tegra: add tracepoints to driver")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/dma_fence.h     | 2 +-
 include/trace/events/napi.h          | 4 ++--
 include/trace/events/qdisc.h         | 4 ++--
 include/trace/events/tegra_apb_dma.h | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/dma_fence.h b/include/trace/events/dma_fence.h
index 2212adda8f77f..64e92d56c6a8f 100644
--- a/include/trace/events/dma_fence.h
+++ b/include/trace/events/dma_fence.h
@@ -2,7 +2,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM dma_fence
 
-#if !defined(_TRACE_FENCE_H) || defined(TRACE_HEADER_MULTI_READ)
+#if !defined(_TRACE_DMA_FENCE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_DMA_FENCE_H
 
 #include <linux/tracepoint.h>
diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index f3a12566bed05..6678cf8b235b8 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -3,7 +3,7 @@
 #define TRACE_SYSTEM napi
 
 #if !defined(_TRACE_NAPI_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_NAPI_H_
+#define _TRACE_NAPI_H
 
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
@@ -38,7 +38,7 @@ TRACE_EVENT(napi_poll,
 
 #undef NO_DEV
 
-#endif /* _TRACE_NAPI_H_ */
+#endif /* _TRACE_NAPI_H */
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 60d0d8bd336d0..0d1a9ebf55ba4 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -2,7 +2,7 @@
 #define TRACE_SYSTEM qdisc
 
 #if !defined(_TRACE_QDISC_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_QDISC_H_
+#define _TRACE_QDISC_H
 
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
@@ -44,7 +44,7 @@ TRACE_EVENT(qdisc_dequeue,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
 
-#endif /* _TRACE_QDISC_H_ */
+#endif /* _TRACE_QDISC_H */
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/include/trace/events/tegra_apb_dma.h b/include/trace/events/tegra_apb_dma.h
index 0818f62861109..971cd02d2dafe 100644
--- a/include/trace/events/tegra_apb_dma.h
+++ b/include/trace/events/tegra_apb_dma.h
@@ -1,5 +1,5 @@
 #if !defined(_TRACE_TEGRA_APB_DMA_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_TEGRA_APM_DMA_H
+#define _TRACE_TEGRA_APB_DMA_H
 
 #include <linux/tracepoint.h>
 #include <linux/dmaengine.h>
@@ -55,7 +55,7 @@ TRACE_EVENT(tegra_dma_isr,
 	TP_printk("%s: irq %d\n",  __get_str(chan), __entry->irq)
 );
 
-#endif /*  _TRACE_TEGRADMA_H */
+#endif /* _TRACE_TEGRA_APB_DMA_H */
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
-- 
2.20.1

