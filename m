Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6532DCD84
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 09:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgLQISp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 03:18:45 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:22048 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQISo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 03:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608193125; x=1639729125;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=prFN0av+RelE2tmiEvc2jgseRO3BsOAUQRTZxLgjkN4=;
  b=MPwAkivS9KSWchujzHzAthdw6FFxqkMHJR7sB/0ItNB5JBmq40GsGpAe
   dTwoMN1AqIpgwWN81uTM3kF/tBHVT3d4LluPsQRyoUas8/g73f2cu/IOm
   S02UnEzGkgBwFG+GWElwtoG7Wn9hZizCJ7QbOHanQxweTdLvAfspCL6sF
   o=;
X-IronPort-AV: E=Sophos;i="5.78,426,1599523200"; 
   d="scan'208";a="69667039"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 17 Dec 2020 08:17:57 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id A7F36C097F;
        Thu, 17 Dec 2020 08:17:55 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.144) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 08:17:50 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Backport of patch series for stable 4.4 branch
Date:   Thu, 17 Dec 2020 09:17:22 +0100
Message-ID: <20201217081727.8253-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

SeongJae Park (5):
  xen/xenbus: Allow watches discard events before queueing
  xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
  xen/xenbus/xen_bus_type: Support will_handle watch callback
  xen/xenbus: Count pending messages for each watch
  xenbus/xenbus_backend: Disallow pending watch messages

 drivers/block/xen-blkback/xenbus.c        |  3 +-
 drivers/net/xen-netback/xenbus.c          |  4 ++-
 drivers/xen/xen-pciback/xenbus.c          |  2 +-
 drivers/xen/xenbus/xenbus_client.c        |  8 ++++-
 drivers/xen/xenbus/xenbus_probe.c         |  1 +
 drivers/xen/xenbus/xenbus_probe.h         |  2 ++
 drivers/xen/xenbus/xenbus_probe_backend.c |  7 +++++
 drivers/xen/xenbus/xenbus_xs.c            | 38 +++++++++++++++--------
 include/xen/xenbus.h                      | 15 ++++++++-
 9 files changed, 62 insertions(+), 18 deletions(-)

-- 
2.17.1

