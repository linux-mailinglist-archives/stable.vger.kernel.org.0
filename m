Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD549A48B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371498AbiAYAIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363972AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC54C05A1BE;
        Mon, 24 Jan 2022 13:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2176150C;
        Mon, 24 Jan 2022 21:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F7C340E4;
        Mon, 24 Jan 2022 21:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060424;
        bh=ADWlPxviep3j3KSwqXUux5ntWlp2DypFvaeUKSbxgpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eafDJ19BJH5OyAfcoh06zFZIkP2gMU7XlZRvNbfgk4JYS2PSts4JQHQJntg3/i7Aj
         bHQPhdmMVfoAf8t6SkAcs2zIxzWScSnTrBxlZJ3zK8CVqT/Sic5yWvaqVzdz+dpQG1
         SblOEQwD4TR9gdWfrpMoQWEaZe4OAk640sDEpzus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, German Gomex <german.gomez@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.16 0910/1039] Documentation: coresight: Fix documentation issue
Date:   Mon, 24 Jan 2022 19:44:59 +0100
Message-Id: <20220124184155.889896289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

commit 66bd1333abd7fa191f13b929c9119d6cd3df27b0 upstream.

Fix the description of the directories and attributes used
in cs_etm as used by perf.

Drop the references to the 'configurations' sub-directory which
had been removed in an earlier version of the patchset.

Fixes: f71cd93d5ea4 ("Documentation: coresight: Add documentation for CoreSight config")
Reported-by: German Gomex <german.gomez@arm.com>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20211117164220.14883-1-mike.leach@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/trace/coresight/coresight-config.rst |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/Documentation/trace/coresight/coresight-config.rst
+++ b/Documentation/trace/coresight/coresight-config.rst
@@ -211,19 +211,13 @@ also declared in the perf 'cs_etm' event
 be selected when running trace under perf::
 
     $ ls /sys/devices/cs_etm
-    configurations  format  perf_event_mux_interval_ms  sinks  type
-    events  nr_addr_filters  power
+    cpu0  cpu2  events  nr_addr_filters		power  subsystem  uevent
+    cpu1  cpu3  format  perf_event_mux_interval_ms	sinks  type
 
-Key directories here are 'configurations' - which lists the loaded
-configurations, and 'events' - a generic perf directory which allows
-selection on the perf command line.::
+The key directory here is 'events' - a generic perf directory which allows
+selection on the perf command line. As with the sinks entries, this provides
+a hash of the configuration name.
 
-    $ ls configurations/
-    autofdo
-    $ cat configurations/autofdo
-    0xa7c3dddd
-
-As with the sinks entries, this provides a hash of the configuration name.
 The entry in the 'events' directory uses perfs built in syntax generator
 to substitute the syntax for the name when evaluating the command::
 


