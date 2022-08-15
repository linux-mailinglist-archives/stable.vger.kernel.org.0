Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C285937FF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343638AbiHOTMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343804AbiHOTLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C685A3B949;
        Mon, 15 Aug 2022 11:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E26260FB8;
        Mon, 15 Aug 2022 18:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53329C433D7;
        Mon, 15 Aug 2022 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588606;
        bh=YqIxZSsdNXUztsVh8JPPQDHD7xEhPBvc3CkVBWgVj+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GA0oE4icEmEq0XZMN6fEhBTlHGWZ9EWgXfDq0eIImrKFQJzGTXqaWjlhRnb76rc60
         3eUn4JfuKdz0w8NRJGZhi4wnTH/9Rtonrbs7fOkKHnAEN0GlY9Y4ERwik0evCEilIl
         h6X+FIVquRq67aqq8vouvhqcbaJbIqOFdeATc2gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagath Jog J <jagathjog1996@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/779] iio: accel: bma400: Reordering of header files
Date:   Mon, 15 Aug 2022 20:01:11 +0200
Message-Id: <20220815180355.525516121@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagath Jog J <jagathjog1996@gmail.com>

[ Upstream commit 1bd2dc6ea863690aee5c45ebf09c9194c7a42c0d ]

Reordering of header files and removing the iio/sysfs.h since
custom attributes are not being used in the driver.

Signed-off-by: Jagath Jog J <jagathjog1996@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220505133021.22362-3-jagathjog1996@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma400_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index 21520e022a21..7e6598534650 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -13,14 +13,14 @@
 
 #include <linux/bitops.h>
 #include <linux/device.h>
-#include <linux/iio/iio.h>
-#include <linux/iio/sysfs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 
+#include <linux/iio/iio.h>
+
 #include "bma400.h"
 
 /*
-- 
2.35.1



