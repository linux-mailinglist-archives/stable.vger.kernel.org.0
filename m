Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62A8655DF
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfGKLnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:43:45 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58671 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbfGKLnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:43:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DD26F4E8;
        Thu, 11 Jul 2019 07:43:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AfPC2L
        POX2CkdnWQKUXaXzQxuWOoFbSE2QJX023WMaY=; b=JQPsUlKQ1MAAg87tWsZshi
        PSCdCmHjB6WPNITUjm4EFD9/twnRe2JAAJSqHt6/Jgw2hrofYtpBZfbP98xKfF0s
        3b67onrAMeP9wY2oe02s6FphOjCijMTr7NcJfv7jWw6vjoSRnb4O11xxBTT+ZKOF
        0lRTsYHAVR0iR6YYtkafXmL2GpZPqRiPF6PvMZqJC5JDFrfFHhOHIt28utIqIZCH
        1/y/fnJd/Qon3GdnVMste9viVlLCgRzp408Zd1N4yoKh//wQvwwDsU/AVLHTfSUN
        mP6RRuh4jUOL0kp0ySqD3LggpgwvoNcdnB619A4PCfHw5IaH60w6L+8JFr8Z3CUw
        ==
X-ME-Sender: <xms:7iAnXfiooRyTNJ9WWaNkor4T13PCeeS6qcPdgnABQbSF2T58HglrkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:7iAnXX7mZasfXizjvDtr3KcN7SnLe3z01MMt3HxmPDwrbEFIWoxaxg>
    <xmx:7iAnXfzUxhYHSnnbGHpPeYq2IA4L9Kpa_-54qYUAGZ33T8-ibQ2Tyw>
    <xmx:7iAnXXdKfLrKlKSdS8NIhRRvBmM2Af5FQpl9qJ2gE9KVfrZfM2Mabg>
    <xmx:7yAnXYaWmq7nKB6HY3fLIkHtFjVGrQDmtBOyVk3nQ8izWQfnmnWdnQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 590D9380079;
        Thu, 11 Jul 2019 07:43:42 -0400 (EDT)
Subject: WTF: patch "[PATCH] ima: Make arch_policy_entry static" was seriously submitted to be applied to the 5.2-stable tree?
To:     yuehaibing@huawei.com, hulkci@huawei.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:43:40 +0200
Message-ID: <156284542044138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.2-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 68f2529078f97dd4dc7f01bc4d495cf5f5814363 Mon Sep 17 00:00:00 2001
From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 11 Jun 2019 21:40:32 +0800
Subject: [PATCH] ima: Make arch_policy_entry static

Fix sparse warning:

security/integrity/ima/ima_policy.c:202:23: warning:
 symbol 'arch_policy_entry' was not declared. Should it be static?

Fixes: 6191706246de ("ima: add support for arch specific policies")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: stable@vger.kernel.org (linux-5.0)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 1cc822a59054..cd1b7281244e 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -199,7 +199,7 @@ static struct ima_rule_entry secure_boot_rules[] __ro_after_init = {
 };
 
 /* An array of architecture specific rules */
-struct ima_rule_entry *arch_policy_entry __ro_after_init;
+static struct ima_rule_entry *arch_policy_entry __ro_after_init;
 
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);

