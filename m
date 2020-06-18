Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5071FF946
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgFRQbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:31:37 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52001 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726928AbgFRQbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:31:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 563C9395;
        Thu, 18 Jun 2020 12:31:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dunYNS
        ttOx0yoB7MsCa6vtksxj4SSPDzatIfl7WcG6w=; b=ozHnUy+ntxvRHf5J804FyI
        rjDfyBKbYz9PDrChH3ZJb8Iye/ii5W16sm0R7C6yIj/j0pjDHqVIsqMJmhF/q/VA
        AdaiOx2lwDvPmUc1TU/P2uA/RY952RrauEziEvfsqssGKUywgRP2j/qivskhNuyj
        ho6fHOT+Um7xPwtqIX/Dd/D/CimP4E05l18GXCsWSW93UJx4TwpwjzBQuT3VCSHE
        3HGCcPQp3qBvNg7HHAWbbASdzLorjOJfUjAMi9rJgwZRPZ6Jnu0Uzhq6umB8XzZG
        ENCrdr36DXBUej1r/R+Xs/QXGuIdZZpGh+Ej7uJdVq8b/hHWeFgQKbRS20GN0Xzg
        ==
X-ME-Sender: <xms:5ZbrXi75DgCaNX40NukNrgK7gVMc4DGVBjimi01cS5_7p1BZ8C7Hlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:5ZbrXr6InVxfEVQRDw99S8DqiXBOTFS1g_O53I_iaooFmj_eKOv3FA>
    <xmx:5ZbrXhdFdsJa8GGxOpit2aS4nwCqalxr-t6zToT8qn3Zj_MOe3W-iA>
    <xmx:5ZbrXvKAhfY9Os37mKmzrhh775vg1PjJJIlLM6ItCGPshT6pi7u6fg>
    <xmx:5ZbrXgxOyPMQE69p8v6tlq9QWkGvw_t5Uz6HUs9k-JQMURidU_PwiSZV6MM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84CC53061CCB;
        Thu, 18 Jun 2020 12:31:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ima: Set again build_ima_appraise variable" failed to apply to 5.7-stable tree
To:     krzysztof.struczynski@huawei.com, roberto.sassu@huawei.com,
        zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 18:31:19 +0200
Message-ID: <15924978792949@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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
 

