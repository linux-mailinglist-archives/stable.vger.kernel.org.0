Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DFC74847
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388166AbfGYHhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388161AbfGYHhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:37:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6723822CBD;
        Thu, 25 Jul 2019 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564040235;
        bh=llt12HVhJMAhWKAVspypSw5Am36bWPRke5eP91slGSk=;
        h=Subject:To:From:Date:From;
        b=cpI7/uEzJEMGeWyhZnvFfYI9lRkgxgRoFP79vvwHcHSvN3P8jZNspkMEEUjAkvqdN
         O3iHBYcdZFBnDlFkNvqd6sBSDljo0mvJ3PaHzQ0/bPqmdotic80sMdAlGNH5MJ7Zct
         iKHi7W0C87PTvrob3/ow1GCrIEVn/Oc52sH4tx+M=
Subject: patch "staging: gasket: apex: fix copy-paste typo" added to staging-linus
To:     brnkv.i1@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 09:37:02 +0200
Message-ID: <1564040222125196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: gasket: apex: fix copy-paste typo

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 66665bb9979246729562a09fcdbb101c83127989 Mon Sep 17 00:00:00 2001
From: Ivan Bornyakov <brnkv.i1@gmail.com>
Date: Wed, 10 Jul 2019 23:45:18 +0300
Subject: staging: gasket: apex: fix copy-paste typo

In sysfs_show() case-branches ATTR_KERNEL_HIB_PAGE_TABLE_SIZE and
ATTR_KERNEL_HIB_SIMPLE_PAGE_TABLE_SIZE do the same. It looks like
copy-paste mistake.

Signed-off-by: Ivan Bornyakov <brnkv.i1@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190710204518.16814-1-brnkv.i1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gasket/apex_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gasket/apex_driver.c b/drivers/staging/gasket/apex_driver.c
index 2be45ee9d061..464648ee2036 100644
--- a/drivers/staging/gasket/apex_driver.c
+++ b/drivers/staging/gasket/apex_driver.c
@@ -532,7 +532,7 @@ static ssize_t sysfs_show(struct device *device, struct device_attribute *attr,
 		break;
 	case ATTR_KERNEL_HIB_SIMPLE_PAGE_TABLE_SIZE:
 		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
-				gasket_page_table_num_entries(
+				gasket_page_table_num_simple_entries(
 					gasket_dev->page_table[0]));
 		break;
 	case ATTR_KERNEL_HIB_NUM_ACTIVE_PAGES:
-- 
2.22.0


