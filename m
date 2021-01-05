Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C072EA95C
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbhAELCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 06:02:52 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:1645 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728318AbhAELCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 06:02:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609844570; x=1641380570;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=prFN0av+RelE2tmiEvc2jgseRO3BsOAUQRTZxLgjkN4=;
  b=YkORImtdsJQkcJtSl6HwIJcab5hzGN6kYa8q4ooBppfkwzoAPbxwWdcd
   n0WchsRKUYc6WgE7OjRTHoLiLRPQVwehMTqev6h4FybDFvkW+EijULfy+
   UU37q4QaYSORs5//U70FAMcx9PplmHixoYte0MyYa7g+SMBgOveQTFc5A
   0=;
X-IronPort-AV: E=Sophos;i="5.78,476,1599523200"; 
   d="scan'208";a="75426693"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 Jan 2021 11:02:09 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id B3586A2137;
        Tue,  5 Jan 2021 11:02:07 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.94) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 Jan 2021 11:02:02 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Backport of patch series for stable 4.9 branch
Date:   Tue, 5 Jan 2021 12:01:37 +0100
Message-ID: <20210105110142.1810-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D45UWA001.ant.amazon.com (10.43.160.91) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
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

