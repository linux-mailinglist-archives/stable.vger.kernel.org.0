Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7B46AED36
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCGSCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjCGSCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:02:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E847AAA26A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:55:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD46EB81850
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D91C433D2;
        Tue,  7 Mar 2023 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211721;
        bh=7FPfhsixwY3MuYbT2s87ZFNTbxb179HSMv+1ZtweWWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xt5i63ijSkpl465vHKn6/V8PVkFr8sqCo+xk2lCQg83eekEIVZ7ryLCihs0tJkKwt
         v9gCGjPmNIG5XkOweO28TwgMHy00Ls53ptr1YuHU6Eop4X9HGROwEdGRyyuRrWvGHD
         OWcf/9XqJVkrEXI/dLdzANgBE7WKb2hXVx03Bqog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 0954/1001] tracing/eprobe: Fix to add filter on eprobe description in README file
Date:   Tue,  7 Mar 2023 18:02:06 +0100
Message-Id: <20230307170103.554455128@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 133921530c42960c07d25d12677f9e131a2b0cdf upstream.

Fix to add a description of the filter on eprobe in README file. This
is required to identify the kernel supports the filter on eprobe or not.

Link: https://lore.kernel.org/all/167309833728.640500.12232259238201433587.stgit@devnote3/

Fixes: 752be5c5c910 ("tracing/eprobe: Add eprobe filter support")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5598,7 +5598,7 @@ static const char readme_msg[] =
 #ifdef CONFIG_HIST_TRIGGERS
 	"\t           s:[synthetic/]<event> <field> [<field>]\n"
 #endif
-	"\t           e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>]\n"
+	"\t           e[:[<group>/][<event>]] <attached-group>.<attached-event> [<args>] [if <filter>]\n"
 	"\t           -:[<group>/][<event>]\n"
 #ifdef CONFIG_KPROBE_EVENTS
 	"\t    place: [<module>:]<symbol>[+<offset>]|<memaddr>\n"


