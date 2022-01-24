Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C433A4996DA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445762AbiAXVHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41414 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391015AbiAXUqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB13B60B1A;
        Mon, 24 Jan 2022 20:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CB5C340E5;
        Mon, 24 Jan 2022 20:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057207;
        bh=ADWlPxviep3j3KSwqXUux5ntWlp2DypFvaeUKSbxgpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SilDmNG/I31KIZ7tOT8xg6lTgUxUeh7dkWq32NTeg8HWQ79yALdHWa527kKKmS36X
         5ib+xQhrVyzfAGzyYdKAGC2ny2rzZjJGLx6t83Le4IzTko8ANr0r76XZ/k4otTh5cK
         HI+V7AOSEzGcs70unKeVoJ1Cdu42mDY4Hb3up9gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, German Gomex <german.gomez@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.15 736/846] Documentation: coresight: Fix documentation issue
Date:   Mon, 24 Jan 2022 19:44:13 +0100
Message-Id: <20220124184126.387849341@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
 


