Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7488669CEAA
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjBTOBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjBTOBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924AD1F495
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F2F2B80D4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A01C433EF;
        Mon, 20 Feb 2023 14:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901660;
        bh=ojSDw7p1+2VEAI4rsIcDGila+1o216iQJs/pZlF2sdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRNnZEaMGTpGOJ0dGkVuJqSdGIAXfHf8TpTUnFKu0aECcPJhCqJ5mhOKuSEY0Xy/q
         PmjySvtQfk8/Q6/De8e970ZyXki7jc5Qmtd1iUgGeAb7zUhYFV4K5vuEdsYHdwBs5O
         EEHqVV9zrB9NuqZwsCxmEfkvtod2Pm5wv+D0PQpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Reported-by: kernel test robot" <lkp@intel.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 095/118] tracing: Make trace_define_field_ext() static
Date:   Mon, 20 Feb 2023 14:36:51 +0100
Message-Id: <20230220133604.189314554@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 70b5339caf847b8b6097b6dfab0c5a99b40713c8 upstream.

trace_define_field_ext() is not used outside of trace_events.c, it should
be static.

Link: https://lore.kernel.org/oe-kbuild-all/202302130750.679RaRog-lkp@intel.com/

Fixes: b6c7abd1c28a ("tracing: Fix TASK_COMM_LEN in trace event format file")
Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6a4696719297..6a942fa275c7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -155,7 +155,7 @@ int trace_define_field(struct trace_event_call *call, const char *type,
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
-int trace_define_field_ext(struct trace_event_call *call, const char *type,
+static int trace_define_field_ext(struct trace_event_call *call, const char *type,
 		       const char *name, int offset, int size, int is_signed,
 		       int filter_type, int len)
 {
-- 
2.39.1



