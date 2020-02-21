Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8193B16721C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgBUIAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgBUIAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:00:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F85206ED;
        Fri, 21 Feb 2020 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272016;
        bh=RrihWs1bIyYOToiy0ScEICNCuQs5FEPMAr1Amv+Q22g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNFxtXA8e4Tvzcq+2ZQmXjPEmTuSCwNHyZOl4mHnujCW5xu9xaaLl+HQiKgJIv70O
         apUtRNYYA+qLEpb8z/tu/OouWQIP5AOOXIMnHkCF7zzraLcj+tU8GV5PRXJe9mSTYE
         lQ/Xm3pfIYUkmIr8bXx/J7NB/Vmhn3iDZ9hb+r9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 383/399] tc-testing: add missing nsPlugin to basic.json
Date:   Fri, 21 Feb 2020 08:41:48 +0100
Message-Id: <20200221072437.383540819@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit e9ed4fa7b4400d7b2cf03108842a30e6c9bd0eb2 ]

since tdc tests for cls_basic need $DEV1, use 'nsPlugin' so that the
following command can be run without errors:

 [root@f31 tc-testing]# ./tdc.py -c basic

Fixes: 4717b05328ba ("tc-testing: Introduced tdc tests for basic filter")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../tc-testing/tc-tests/filters/basic.json    | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index 2e361cea63bcd..98a20faf31986 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -6,6 +6,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -25,6 +28,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -44,6 +50,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -63,6 +72,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -82,6 +94,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -101,6 +116,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -120,6 +138,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -139,6 +160,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -158,6 +182,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -177,6 +204,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -196,6 +226,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -215,6 +248,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -234,6 +270,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -253,6 +292,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -272,6 +314,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -291,6 +336,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
@@ -310,6 +358,9 @@
             "filter",
             "basic"
         ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
-- 
2.20.1



