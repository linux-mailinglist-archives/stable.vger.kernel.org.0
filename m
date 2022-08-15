Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BD9594FD4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiHPEda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiHPEcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:32:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7094D168162;
        Mon, 15 Aug 2022 13:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1F4860F71;
        Mon, 15 Aug 2022 20:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEC3C433C1;
        Mon, 15 Aug 2022 20:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595007;
        bh=gy1qGSqXwJLomVUXNFZL7GA9Gval7RWJfTJsR6onuzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFvYA9xeuWXDQjHktvYCdTVPD5kpewtKtJ8+37L8HQ5sfFHIekcMhWGM1e+jpWZP3
         T5ZSCDIIoEwbhUBj5PTj9HUPrhHyQ3m8llr7To5GdU7had7FcoPaGk4Mfe/6Y9RL4H
         2SKNt+hKqxRMW9GcjAqbJmjANqJXIlOuvjhtyZX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagath Jog J <jagathjog1996@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0628/1157] iio: accel: bma400: Reordering of header files
Date:   Mon, 15 Aug 2022 19:59:44 +0200
Message-Id: <20220815180504.791580565@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 043002fe6f63..25ad1f7339bc 100644
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



