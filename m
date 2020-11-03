Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AE02A44AC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgKCL76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:59:58 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56923 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbgKCL76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:59:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B01A5B5D;
        Tue,  3 Nov 2020 06:59:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 06:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E9rDgx
        q769rcKsvLPoyvqCZSZrtFzEubL9eVxbFfs+8=; b=J70lF+xb2zCPnmrSzm3JwD
        hDEoTKckIjV9Tdr3yyP5ynfwV2G4A9MSBtzmXwjRA7yCgSixSuCRbXLK0MdDK4NK
        MKgkmoshTwyeLBDHwQbUFbKClmNedNh2VSWe7/e7h1S/wtvjuF8tDQ0kOg2LhBnK
        tHOoG9HSIoCf7OJzGydBLHnrHUnL0pVjbP8XTqmcjqtpFZj2G6qr+td2rLk+v4DA
        v1LdZRoAi6wd+OtqX3mRa1so073Uky9pJbwvuPq4hr/4eoBv6cMvdgabmO9EmnQb
        XFCgw1J/byPq++N3vRrB+xohO1Jpuv/HJn2qXvyQnHNk2D5AHGMwiqPxkoQf0mSw
        ==
X-ME-Sender: <xms:PUahXwyM0qnWc_0UG4U_MnBu8tkkDFQLwkQrzqRqahlw2uOcSLksgw>
    <xme:PUahX0SFfkNr8JeHea6fPeyfOn4wJm32DVwNiRJNx_CJJAOCgBjtS3oshpveqV_KQ
    0OGaptuUUJlFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:PUahXyUuqjIL-fF59eGG9rbMv9mkYO2nPeZyHNToL6xNfPQg0dSwmg>
    <xmx:PUahX-hP6lwGDuA69Jw2hDiTtlJTBE_gFkEmGHhDSuKf-oJ8TOmTuw>
    <xmx:PUahXyA6sikDhZLxQB4JLMOITKDU3LJsKn8YwQ7_qzRS5-B6n4hlqQ>
    <xmx:PUahX9oKPwm-sgoq8IvzVfHcTCcSB1CQWdrTkheisJzwgbXBCOEYbs34-Rg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D53513280067;
        Tue,  3 Nov 2020 06:59:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] ACPI: configfs: Add missing config_item_put() to fix refcount" failed to apply to 4.19-stable tree
To:     guohanjun@huawei.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 13:00:39 +0100
Message-ID: <160440483954126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

