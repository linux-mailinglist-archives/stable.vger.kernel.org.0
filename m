Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D18B5A05B7
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiHYBel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiHYBec (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:34:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D795AE5;
        Wed, 24 Aug 2022 18:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C279B825ED;
        Thu, 25 Aug 2022 01:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1524C433D6;
        Thu, 25 Aug 2022 01:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391267;
        bh=TMF/aZzeYH4JHSWvoK8cWsldDd55md+i9K/71fl4VLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcZedJnvb40o8nHkgmlMphkPDIRoRZ3h/0IJ/9U9eZ1y6jGo3zJKH9QKa6yMiyWUY
         NM7JvlBGgXH7g208PUZcmFrmh8JA+uOrGCErMR+eUlh4u+CNYEBbQnGiGopuf3Rgj8
         3T+16MZOysVzUD8vwQre8T9xlcxfXMrUtmifzzITYNpRQ0CU3+QXlf/mn9JdWRITWH
         LFjvGUHexBVq7SLcgxthGVlT3IvD+RRoXLCUpYcENEc978hbPGn5ZGFmKHcdCL4HrU
         YBEkOelEz/iisOJb1pQFMND9xeguYs0g5BGeZsEHmoLkJyilSGoATDhfi7zdD7SNIu
         LnGiqx/iYBNuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Vicenzi <alexandre.vicenzi@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, bristot@kernel.org,
        corbet@lwn.net, wanjiabing@vivo.com,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 04/38] rtla: Fix tracer name
Date:   Wed, 24 Aug 2022 21:33:27 -0400
Message-Id: <20220825013401.22096-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Vicenzi <alexandre.vicenzi@suse.com>

[ Upstream commit f1432cd24c240cedf78c0d026631e3b10052c8e1 ]

The correct tracer name is timerlat and not timelat.

Link: https://lore.kernel.org/linux-trace-devel/20220808180343.22262-1-alexandre.vicenzi@suse.com

Signed-off-by: Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/tools/rtla/rtla-timerlat-hist.rst | 2 +-
 tools/tracing/rtla/src/timerlat_hist.c          | 2 +-
 tools/tracing/rtla/src/timerlat_top.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/tools/rtla/rtla-timerlat-hist.rst b/Documentation/tools/rtla/rtla-timerlat-hist.rst
index e12eae1f3301..6bf7f0ca4556 100644
--- a/Documentation/tools/rtla/rtla-timerlat-hist.rst
+++ b/Documentation/tools/rtla/rtla-timerlat-hist.rst
@@ -33,7 +33,7 @@ EXAMPLE
 =======
 In the example below, **rtla timerlat hist** is set to run for *10* minutes,
 in the cpus *0-4*, *skipping zero* only lines. Moreover, **rtla timerlat
-hist** will change the priority of the *timelat* threads to run under
+hist** will change the priority of the *timerlat* threads to run under
 *SCHED_DEADLINE* priority, with a *10us* runtime every *1ms* period. The
 *1ms* period is also passed to the *timerlat* tracer::
 
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index f3ec628f5e51..4b48af8a8309 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -892,7 +892,7 @@ int timerlat_hist_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (trace_is_off(&tool->trace, &record->trace)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 35452a1d45e9..334271935222 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -687,7 +687,7 @@ int timerlat_top_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (trace_is_off(&top->trace, &record->trace)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
-- 
2.35.1

