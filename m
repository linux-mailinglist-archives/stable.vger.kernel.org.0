Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD57C2A44AA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgKCL7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:59:47 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52683 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbgKCL7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:59:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D0C72BEF;
        Tue,  3 Nov 2020 06:59:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 06:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VS/4WR
        QTPynuuBbkDI9yX84us/g9DNUWBnw3eNgTmFM=; b=ke0WXy/Q/jpy5g0UBI1lj2
        3zt5QFyXjwGWrb4YOR8X6IbeegxVc86LMM6aF015J7Z1hKdPX/GL/TTH46qyYbjj
        FwTeVY+geSkPpSetCGeHiBWrmkzSjmXEV+FBRIC32GD0d1rqlG1CJBnPCMEK2R2n
        D3IxtAEvvxDMoMKGzuFEUmmuSeK711XRWEfH51/TkBQHOTPAmOXfA9FVjHLmJfrU
        OU6O1aDJ84JbCvr8C3+rwIyoSMjjNA6jYSdXpEgmkx3sp0p1fuyQEkaRFd0deaR0
        nCibSilLOTdyMWQg7OMX+KrEQbK6g9zK9q+SxKFpoNUopzy6fkG9jZ0vqVYmVcFQ
        ==
X-ME-Sender: <xms:MUahX_cmOfj0qdu47lBqjdP2pIwfqY87waEO4telBy_XcT1hvmzRNA>
    <xme:MUahX1OdAW_bJmwvxbycmyvWL0R0kMi_BFOKGaP8O9WHe1gvTRe3OYKGZc5j43cYv
    sYHt1y1dsWYxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MUahX4jm7LD286ggJAHbIWx7MsGMWpZwGQ6CIPVlz6jHovfmfWLhDg>
    <xmx:MUahXw_EP-Zg4gS7Ljb8MaIRGHjhBhNpYoks0K8Pm1nth8wn7MmoWQ>
    <xmx:MUahX7u4Y09W4jJ2tms_jie9y1F9Hc4vcnJJbWRKTR5t3R50RJcH3w>
    <xmx:MUahX51MreO-0lpnxcEBOrNRTv5ZEwxVRg8EI-QaMA4XHPy4hOuAr0tn_QU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA8123280060;
        Tue,  3 Nov 2020 06:59:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] ACPI: configfs: Add missing config_item_put() to fix refcount" failed to apply to 5.4-stable tree
To:     guohanjun@huawei.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 13:00:38 +0100
Message-ID: <1604404838203157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 9a2e849fb6de471b82d19989a7944d3b7671793c Mon Sep 17 00:00:00 2001
From: Hanjun Guo <guohanjun@huawei.com>
Date: Fri, 18 Sep 2020 17:13:28 +0800
Subject: [PATCH] ACPI: configfs: Add missing config_item_put() to fix refcount
 leak

config_item_put() should be called in the drop_item callback, to
decrement refcount for the config item.

Fixes: 772bf1e2878ec ("ACPI: configfs: Unload SSDT on configfs entry removal")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject edit ]
Cc: 4.13+ <stable@vger.kernel.org> # 4.13+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/acpi/acpi_configfs.c b/drivers/acpi/acpi_configfs.c
index 88c8af455ea3..cf91f49101ea 100644
--- a/drivers/acpi/acpi_configfs.c
+++ b/drivers/acpi/acpi_configfs.c
@@ -228,6 +228,7 @@ static void acpi_table_drop_item(struct config_group *group,
 
 	ACPI_INFO(("Host-directed Dynamic ACPI Table Unload"));
 	acpi_unload_table(table->index);
+	config_item_put(cfg);
 }
 
 static struct configfs_group_operations acpi_table_group_ops = {

