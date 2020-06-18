Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2A81FF944
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgFRQb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:31:28 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:32957 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726928AbgFRQb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:31:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5B0D03B2;
        Thu, 18 Jun 2020 12:31:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uh6dkQ
        Ir6pqyrctccMlxTqdM+sm63OV1OeTqbbwFmUc=; b=ioyLKTnSr3Rmw8mem/iAc2
        CsgxveDqVtun6ThaUoTcWPZcbrTrqgF+yZ3mOXVD+d3btuB7KqavSz6QS6eVGdDH
        pZFiM7jgl7gcXR8gdj5SVb9tQOanWY0lRzBgWuqMzKSlriVAmZ9O9tMWlchS4FN7
        C0xR2K43WbxXzPVPP11zGqEzuMBxIInBDDBiG8liSO8fCfpHGr4ry5cJHGcYqmUx
        apGXjhw9fV2W1RdR+fik3KKvkjuhDxYvNS+9kXUh20BOTShgIjORJ7TrpQS4S7WH
        Yh5Qv025h156HAlE5rml1M/n+FpCUNl8cQDmZhZBqJOx39QgnwggH4cS4bapoMFA
        ==
X-ME-Sender: <xms:3ZbrXtH9ZreW8VIfbZhnJHJ-kwzMusCUstL9cCkx6vexh4CJ6xwJBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:3ZbrXiX0hSFiAfMeghSo6Ce7QYq7Gs4KHoepglgfz6q1GEH-5VQf2w>
    <xmx:3ZbrXvKJ3r6jdqMUQOeWV9wTFlpqpyBNLXkxG8aHp5MkjgAD2SiJWA>
    <xmx:3ZbrXjGUq4DnCD548nP4tljvBjW1KMoIzzTtuNoOBdOuwsmexFxH3A>
    <xmx:3ZbrXkczpDgyQYgmILvdcJM-2Us_F0kueJ_LC_T7KufvtJTcr1v_V3vScM0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E51643280059;
        Thu, 18 Jun 2020 12:31:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ima: Set again build_ima_appraise variable" failed to apply to 5.4-stable tree
To:     krzysztof.struczynski@huawei.com, roberto.sassu@huawei.com,
        zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 18:31:18 +0200
Message-ID: <15924978789846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b59fda449cf07f2db3be3a67142e6c000f5e8d79 Mon Sep 17 00:00:00 2001
From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Date: Mon, 27 Apr 2020 12:28:59 +0200
Subject: [PATCH] ima: Set again build_ima_appraise variable

After adding the new add_rule() function in commit c52657d93b05
("ima: refactor ima_init_policy()"), all appraisal flags are added to the
temp_ima_appraise variable. Revert to the previous behavior instead of
removing build_ima_appraise, to benefit from the protection offered by
__ro_after_init.

The mentioned commit introduced a bug, as it makes all the flags
modifiable, while build_ima_appraise flags can be protected with
__ro_after_init.

Cc: stable@vger.kernel.org # 5.0.x
Fixes: c52657d93b05 ("ima: refactor ima_init_policy()")
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index ea9b991f0232..ef7f68cc935e 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -643,8 +643,14 @@ static void add_rules(struct ima_rule_entry *entries, int count,
 
 			list_add_tail(&entry->list, &ima_policy_rules);
 		}
-		if (entries[i].action == APPRAISE)
-			temp_ima_appraise |= ima_appraise_flag(entries[i].func);
+		if (entries[i].action == APPRAISE) {
+			if (entries != build_appraise_rules)
+				temp_ima_appraise |=
+					ima_appraise_flag(entries[i].func);
+			else
+				build_ima_appraise |=
+					ima_appraise_flag(entries[i].func);
+		}
 	}
 }
 

