Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0751F3A84
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgFIMTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 08:19:08 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:46817 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgFIMTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 08:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591705146; x=1623241146;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ppbm9dOx2yalk56mgi/czzstCDtRcKHOYmXV76tvdn8=;
  b=HScVOp8mVgglLIBgb+RjcDNtbv+AGzKLsXxAR77Jt9S0EolafRGFOftp
   +xCUvvcQo1/vktQgTJ8/fcrDywk+K0W/cvb83BpCSJtDS857aqEaiqjqX
   TUOsQ56N96sjHp2g1aEPR3cGV/YwMBTwhPBy1ebyibDerX3YgeUrHS/By
   8=;
IronPort-SDR: ZBYWs3nHmZuLlXmI58t4qHp7JeywiL3FHDP70wijH28qXWVZK0GmLdtTAKBvrg2o+WBRn8Ld18
 W/PBr/X/XrKQ==
X-IronPort-AV: E=Sophos;i="5.73,492,1583193600"; 
   d="scan'208";a="35275635"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 09 Jun 2020 12:19:05 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 16796A1DBA;
        Tue,  9 Jun 2020 12:19:03 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 12:19:03 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 12:18:59 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <akpm@linux-foundation.org>
CC:     <colin.king@canonical.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: [PATCH] scripts/spelling: Recommend blocklist/allowlist instead of blacklist/whitelist
Date:   Tue, 9 Jun 2020 14:18:43 +0200
Message-ID: <20200609121843.24147-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D07UWB004.ant.amazon.com (10.43.161.196) To
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

cr https://code.amazon.com/reviews/CR-27247203
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

