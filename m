Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB978DB0B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHNRWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbfHNRId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48F12084D;
        Wed, 14 Aug 2019 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802513;
        bh=qgzvNf3XjFpQNtw7S/UlxKEPdF1+IPB+9t0Tvw6FNFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSyHWoVyZeGw/FwsSfv944Ay2e+iM5x+PFNPjo5d/SvCn86zgpAsQj5CDr83qN93a
         u6K+ieQoNow+CyR1pMfI1/cWjaQ1u361TGZxxw8+JDB4iTeKIRsRnN61HkCZuM9csn
         +tM8IQkPBetcclcoSwCKj0EL/17uzVrS6/j7RNn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Bornyakov <brnkv.i1@gmail.com>
Subject: [PATCH 4.19 03/91] staging: gasket: apex: fix copy-paste typo
Date:   Wed, 14 Aug 2019 19:00:26 +0200
Message-Id: <20190814165749.133660314@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Bornyakov <brnkv.i1@gmail.com>

commit 66665bb9979246729562a09fcdbb101c83127989 upstream.

In sysfs_show() case-branches ATTR_KERNEL_HIB_PAGE_TABLE_SIZE and
ATTR_KERNEL_HIB_SIMPLE_PAGE_TABLE_SIZE do the same. It looks like
copy-paste mistake.

Signed-off-by: Ivan Bornyakov <brnkv.i1@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190710204518.16814-1-brnkv.i1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/gasket/apex_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/gasket/apex_driver.c
+++ b/drivers/staging/gasket/apex_driver.c
@@ -538,7 +538,7 @@ static ssize_t sysfs_show(struct device
 		break;
 	case ATTR_KERNEL_HIB_SIMPLE_PAGE_TABLE_SIZE:
 		ret = scnprintf(buf, PAGE_SIZE, "%u\n",
-				gasket_page_table_num_entries(
+				gasket_page_table_num_simple_entries(
 					gasket_dev->page_table[0]));
 		break;
 	case ATTR_KERNEL_HIB_NUM_ACTIVE_PAGES:


