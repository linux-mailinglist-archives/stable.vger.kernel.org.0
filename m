Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D7515DDBD
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389078AbgBNQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389072AbgBNQAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6844024676;
        Fri, 14 Feb 2020 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696009;
        bh=RrihWs1bIyYOToiy0ScEICNCuQs5FEPMAr1Amv+Q22g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UebtiiKDbsMrYnxnfE6C2zsZRmOHGsMq1q4O4UkyKbHsWeqIT8ytCYB7Dq6MTHL7a
         ZeozXZ6AGogSSQSH+qSDITP67xse5qvg63EHcQ43iDzyd9hssq0HTEFBEkr+ewHwMd
         P0XLfBtX3K1Z9Q7C5LVeuiwVG/HyTiF460UlZxFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 526/542] tc-testing: add missing 'nsPlugin' to basic.json
Date:   Fri, 14 Feb 2020 10:48:38 -0500
Message-Id: <20200214154854.6746-526-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

