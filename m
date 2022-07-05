Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D376566E19
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbiGEMbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbiGEM0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834F115A25;
        Tue,  5 Jul 2022 05:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3B6B8170A;
        Tue,  5 Jul 2022 12:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D487C341C7;
        Tue,  5 Jul 2022 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023515;
        bh=do6yYSyQxfB6PbEl2YYs7ab3cyfGJYZV04POplKETk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLx9kWH1ZYMWtalyYt2T1bOQ7RPqtUeynaYkuWsvRto4Fn9x71cBqysZ54dW8+GJr
         a1JSlvEcg7UWwWJvxiJrf0+37ywStz8JnW/K7MRX7DSUk7cjdiDfEuoDWkyv1+O5p0
         Kz75M9p2ZaYrJFF9WmdWEcdNd4BECyk0+L0/qiXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/102] platform/x86: panasonic-laptop: sort includes alphabetically
Date:   Tue,  5 Jul 2022 13:58:55 +0200
Message-Id: <20220705115620.947890321@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fe4326c8d18dc8a54affdc9ab269ad92dafef659 ]

Sort includes alphabetically, small cleanup patch in preparation of
further changes.

Fixes: ed83c9171829 ("platform/x86: panasonic-laptop: Resolve hotkey double trigger bug")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220624112340.10130-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index ca6137f4000f..26e31ac09dc6 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -119,20 +119,19 @@
  *		- v0.1  start from toshiba_acpi driver written by John Belmonte
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/types.h>
+#include <linux/acpi.h>
 #include <linux/backlight.h>
 #include <linux/ctype.h>
-#include <linux/seq_file.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-#include <linux/acpi.h>
+#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
-
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
 
 MODULE_AUTHOR("Hiroshi Miura <miura@da-cha.org>");
 MODULE_AUTHOR("David Bronaugh <dbronaugh@linuxboxen.org>");
-- 
2.35.1



