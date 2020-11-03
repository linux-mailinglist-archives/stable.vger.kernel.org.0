Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA872A44AB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgKCL75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:59:57 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34453 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728710AbgKCL74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:59:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EECACC66;
        Tue,  3 Nov 2020 06:59:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 06:59:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=d7/9Hk
        d8Xp6z+7vt+wyTtfxbLP2wSWkCeYSPPbulklQ=; b=r8GpO96qufdTKVD9gms9N0
        6do4fdbEal39GBYrelWTNyStsTDKNnT0Al+ouLUsUqJPF+dlyFrRqtD4LKJSrr5x
        T4r8HK7XBWE2XzFxiXg9n+b2WF36Uz+fdHINNXFUPNuIha707CwoYwVHxF63dM+7
        O9aiPL9g4+n92v3xh2xTznHKm8H9l7U/UvaYbgoH+PRt1mdo1y7ca3zwwsRg6AXs
        QT7KTximNfMK+AZ9qqBek2OhN2a8Y2yiC0XAGPv4cO+GrrbfafIl2sBCD1KulTIM
        6elWPwkHX1WaUku0owonpMYLx32mnOPP5aNfdhlCJbeIqyGss5gHsZOSjdu2Ssaw
        ==
X-ME-Sender: <xms:O0ahX6WLG4TGHOBBYFCIWfgPdnvmyhTypdO8IPCKSYPdW2NN7Y_vZg>
    <xme:O0ahX2nPQhnElk6UPJXBDMt3qW-DLUZQP8bZDo2QxlFcvnFyldVb1-EVhgt1Czp3q
    tFRgJKXnvCmbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:O0ahX-b99gEnxbT5CiTgKeyA1Gap42ijjUXOKBcON1By6tQvZ1dTuQ>
    <xmx:O0ahXxUrMoerEom6tHuM-jXVSONLnU8Co9eI5rVs0EU67D8pxr6LgQ>
    <xmx:O0ahX0n6sMz9JMlAfo7PEHluEboFDNMI32KCsy_TEc-h6qc8dpV7AQ>
    <xmx:O0ahX7uxE11UfAq4EpIdVzHhiPbqEPrHv1eTxeStH6pq7PF_nTRNKB_F73A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EC793064674;
        Tue,  3 Nov 2020 06:59:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] ACPI: configfs: Add missing config_item_put() to fix refcount" failed to apply to 4.14-stable tree
To:     guohanjun@huawei.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 13:00:39 +0100
Message-ID: <160440483911641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

