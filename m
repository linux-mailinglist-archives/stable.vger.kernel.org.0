Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044721F3A96
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 14:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgFIM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 08:26:13 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:1858 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgFIM0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 08:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591705573; x=1623241573;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=UI8OHfpgm3c40RX7wHCGN4i7Xw+2A2LWoExN4GLWau8=;
  b=onMrov9tDRWrKyiHp2jC5T3nQ0n5j4AxOixY5pNYuH8fu4/9MqqAF7Mj
   TucWwdo/cwKOEmS+/LEYTitr8kQgybguWzQ6tQvjPrg1wV72iNdEGtItt
   /MguNrj9l5xDUe76a0g86K9jydWHWPPgIaVQhaZPkR94sMT4+FXzFzhLj
   o=;
IronPort-SDR: 8PfTBE6zGS51tWv/nAHvWOvfgy40J7aQclU4y01Rc6qccqtctai10/jpJLepxbTQ1kgadpEw/X
 Jlqio2QyTa9w==
X-IronPort-AV: E=Sophos;i="5.73,492,1583193600"; 
   d="scan'208";a="36604877"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Jun 2020 12:26:12 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 32D40A1FDB;
        Tue,  9 Jun 2020 12:26:09 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 12:26:09 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.140) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 12:26:05 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <akpm@linux-foundation.org>
CC:     <colin.king@canonical.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: [PATCH v2] scripts/spelling: Recommend blocklist/allowlist instead of blacklist/whitelist
Date:   Tue, 9 Jun 2020 14:25:49 +0200
Message-ID: <20200609122549.26304-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D02UWB003.ant.amazon.com (10.43.161.48) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This commit recommends the patches to replace 'blacklist' and
'whitelist' with the 'blocklist' and 'allowlist', because the new
suggestions are incontrovertible, doesn't make people hurt, and more
self-explanatory.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 scripts/spelling.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index d9cd24cf0d40..ea785568d8b8 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -230,6 +230,7 @@ beter||better
 betweeen||between
 bianries||binaries
 bitmast||bitmask
+blacklist||blocklist
 boardcast||broadcast
 borad||board
 boundry||boundary
@@ -1495,6 +1496,7 @@ whcih||which
 whenver||whenever
 wheter||whether
 whe||when
+whitelist||allowlist
 wierd||weird
 wiil||will
 wirte||write
-- 
2.17.1

