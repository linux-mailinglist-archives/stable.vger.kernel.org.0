Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8875D6A09AA
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjBWNI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjBWNI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A02A35AF
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:08:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45E7DCE1FEE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB64C433D2;
        Thu, 23 Feb 2023 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157727;
        bh=H6LqI9TaAog05LfXaZ26vJ7XtvPdxR/V69FAfYpQRgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFQW2R1VxoL3tKADVP3LPt6Qyxnnga9MwFdhXiHQ+AX4e4STpeZaMJw3ppRKjrlU6
         U2lV9KKG5cIEIXs4AzSSi7duXBrF+KqfszEhMPjEaIdpxgS6KqXnSj2mPXEg5ax5UY
         QrwxhbV+62BZG9wKRYhVfiBh24Jrjqw3CL0j3K1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/46] docs: perf: Fix PMU instance name of hisi-pcie-pmu
Date:   Thu, 23 Feb 2023 14:06:23 +0100
Message-Id: <20230223130432.302523447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit eb79f12b4c41dd2403a0d16772ee72fcd6416015 ]

The PMU instance will be called hisi_pcie<sicl>_core<core> rather than
hisi_pcie<sicl>_<core>. Fix this in the documentation.

Fixes: c8602008e247 ("docs: perf: Add description for HiSilicon PCIe PMU driver")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20221117084136.53572-3-yangyicong@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/perf/hisi-pcie-pmu.rst        | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/perf/hisi-pcie-pmu.rst b/Documentation/admin-guide/perf/hisi-pcie-pmu.rst
index 294ebbdb22af8..bbe66480ff851 100644
--- a/Documentation/admin-guide/perf/hisi-pcie-pmu.rst
+++ b/Documentation/admin-guide/perf/hisi-pcie-pmu.rst
@@ -15,10 +15,10 @@ HiSilicon PCIe PMU driver
 The PCIe PMU driver registers a perf PMU with the name of its sicl-id and PCIe
 Core id.::
 
-  /sys/bus/event_source/hisi_pcie<sicl>_<core>
+  /sys/bus/event_source/hisi_pcie<sicl>_core<core>
 
 PMU driver provides description of available events and filter options in sysfs,
-see /sys/bus/event_source/devices/hisi_pcie<sicl>_<core>.
+see /sys/bus/event_source/devices/hisi_pcie<sicl>_core<core>.
 
 The "format" directory describes all formats of the config (events) and config1
 (filter options) fields of the perf_event_attr structure. The "events" directory
@@ -33,13 +33,13 @@ monitored by PMU.
 Example usage of perf::
 
   $# perf list
-  hisi_pcie0_0/rx_mwr_latency/ [kernel PMU event]
-  hisi_pcie0_0/rx_mwr_cnt/ [kernel PMU event]
+  hisi_pcie0_core0/rx_mwr_latency/ [kernel PMU event]
+  hisi_pcie0_core0/rx_mwr_cnt/ [kernel PMU event]
   ------------------------------------------
 
-  $# perf stat -e hisi_pcie0_0/rx_mwr_latency/
-  $# perf stat -e hisi_pcie0_0/rx_mwr_cnt/
-  $# perf stat -g -e hisi_pcie0_0/rx_mwr_latency/ -e hisi_pcie0_0/rx_mwr_cnt/
+  $# perf stat -e hisi_pcie0_core0/rx_mwr_latency/
+  $# perf stat -e hisi_pcie0_core0/rx_mwr_cnt/
+  $# perf stat -g -e hisi_pcie0_core0/rx_mwr_latency/ -e hisi_pcie0_core0/rx_mwr_cnt/
 
 The current driver does not support sampling. So "perf record" is unsupported.
 Also attach to a task is unsupported for PCIe PMU.
@@ -64,7 +64,7 @@ bit8 is set, port=0x100; if these two Root Ports are both monitored, port=0x101.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mwr_latency,port=0x1/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mwr_latency,port=0x1/ sleep 5
 
 -bdf
 
@@ -76,7 +76,7 @@ For example, "bdf=0x3900" means BDF of target Endpoint is 0000:39:00.0.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mrd_flux,bdf=0x3900/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mrd_flux,bdf=0x3900/ sleep 5
 
 2. Trigger filter
 Event statistics start when the first time TLP length is greater/smaller
@@ -90,7 +90,7 @@ means start when TLP length < condition.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mrd_flux,trig_len=0x4,trig_mode=1/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mrd_flux,trig_len=0x4,trig_mode=1/ sleep 5
 
 3. Threshold filter
 Counter counts when TLP length within the specified range. You can set the
@@ -103,4 +103,4 @@ when TLP length < threshold.
 
 Example usage of perf::
 
-  $# perf stat -e hisi_pcie0_0/rx_mrd_flux,thr_len=0x4,thr_mode=1/ sleep 5
+  $# perf stat -e hisi_pcie0_core0/rx_mrd_flux,thr_len=0x4,thr_mode=1/ sleep 5
-- 
2.39.0



