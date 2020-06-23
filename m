Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0E204B7F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgFWHrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:47:02 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37325 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731245AbgFWHrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:47:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B6434C3F;
        Tue, 23 Jun 2020 03:47:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 03:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=u9HyAP
        V0Su5MRGPmjH4Ba4EunyNMXLR0/OB7NnY8EG4=; b=OHTFIhjnoKPFFBVEDx2GAj
        qKaaWOlFy6gViM8XYn5db1pUWsF49+CyPJgmh05OQRddirqlqK655O9ymATuDcM4
        3iRxGZ+SJAkHIS2uFIbsI01BnKJ8ZZheAIHuBnccowB7JXm0F9Ehkl/WQfqFRUt5
        xPdNymevWe7rceG6sgppOn/EmZRNH8Jvs+RkJdJ6nMm93j1MPWt6gcYMdpaJQJiQ
        hLiBgC3zYN5KFlDfQ6FA7/56ayCHBM9DlVipSJ4KLLqeE6IEGdgEOJkG2Y0NsgWC
        kwzKgt/FnZFN2k9Mkv0VRh6JycO9RLebYteIQcnbA8KJrCh85l/HHxh41F+BIxWw
        ==
X-ME-Sender: <xms:dbPxXovsOGdLaY4abUElaBdcfEQ3o9rtht5mW50sHDtQbAvFG-G5pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dbPxXle12_nMsWXWLRPPG2j-fgMtO0uiXKbIGMYaqq8AQihRpLMqeA>
    <xmx:dbPxXjy4DF3Vfxdd0ATUmw6Z6O633dKvakvEOjGQ6D8GM9b6sMaMLw>
    <xmx:dbPxXrPFIzDPBQysnsWjvalBF9X-EL__FEBKnz4thRervh9kw5hCTA>
    <xmx:dbPxXhKcSlnwYFX1KxbNJHyKXtBfzgyAwPFFz12Kk2g8uGVV75FWfYMaqxo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D91873067499;
        Tue, 23 Jun 2020 03:47:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/pmu: Keep a reference to module while active" failed to apply to 5.7-stable tree
To:     chris@chris-wilson.co.uk, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 09:46:56 +0200
Message-ID: <15928984166960@kroah.com>
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

From 3b55cdeb8f1b71444da866fd2568b1a18ba7f9c3 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 30 Apr 2020 19:33:24 +0100
Subject: [PATCH] drm/i915/pmu: Keep a reference to module while active

While a perf event is open, keep a reference to the module so we don't
remove the driver internals mid-sampling.

Testcase: igt/perf_pmu/module-unload
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200430183324.23984-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 83c6a8ccd2cb..e991a707bdb7 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -442,6 +442,7 @@ static u64 count_interrupts(struct drm_i915_private *i915)
 static void i915_pmu_event_destroy(struct perf_event *event)
 {
 	WARN_ON(event->parent);
+	module_put(THIS_MODULE);
 }
 
 static int
@@ -533,8 +534,10 @@ static int i915_pmu_event_init(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (!event->parent)
+	if (!event->parent) {
+		__module_get(THIS_MODULE);
 		event->destroy = i915_pmu_event_destroy;
+	}
 
 	return 0;
 }

