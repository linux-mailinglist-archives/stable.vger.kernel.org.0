Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CFF2DD1D0
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 14:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgLQNGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 08:06:03 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:38097 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgLQNGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 08:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608210361; x=1639746361;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=BAffkaoVJtm+T+Kd6T923eXE7+ZB8K1xfmB+Tklg18Q=;
  b=QCbJIelty+beg17xx7pJfKHh64nDtQtMVF6BSAr8IHg8ai48W/MuAqi7
   b9wSMRnWk7oOkAi5faWm5iyilbPoF8Yro4bp+HWSS6at+3+N6ZL1+etgG
   geh4KAmInkR/wgd5LMrfWYjgmMGVIK7rsCgbQm62lTfTJGOC3ZiEbLdHI
   g=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="903914475"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 17 Dec 2020 13:05:21 +0000
Received: from EX13D31EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 688BD282DFF;
        Thu, 17 Dec 2020 13:05:20 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.160.66) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 13:05:15 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/5] Backport of patch series for stable 4.4 branch
Date:   Thu, 17 Dec 2020 14:04:56 +0100
Message-ID: <20201217130501.12702-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D39UWA002.ant.amazon.com (10.43.160.20) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Changes from v1
(https://lore.kernel.org/stable/20201217081727.8253-1-sjpark@amazon.com/)
- Remove wrong 'Signed-off-by' lines for 'Author Redacted'

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

