Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6611759A0AD
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350815AbiHSQCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351068AbiHSQAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:00:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FC713D16;
        Fri, 19 Aug 2022 08:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7760B8280C;
        Fri, 19 Aug 2022 15:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA6BC433D6;
        Fri, 19 Aug 2022 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924347;
        bh=2lKlvV7mdGk6XW3t9NaS89p7SXa7QHfF3L/ripmSsOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/zWuOuuU8GINlJ6F/+MeIabUgHY4JlRYs6BwuwhmlXlQR73F3vCQTn51PtVd5A7p
         c8VzBt5a7amJR9Zkik/WVTPIxG0ZEQGI2vv6Mkao0xoMeuSdDb/oNRGl3enT72gA4B
         349/fKWS8AD+Zib+kDjLHtyu28ptIYxlzVIdfAxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/545] hwmon: (drivetemp) Add module alias
Date:   Fri, 19 Aug 2022 17:38:30 +0200
Message-Id: <20220819153835.607720674@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 5918036cfa8ded7aa8094db70295011ce2275447 ]

Adding a MODULE_ALIAS() to drivetemp will make the driver easier
for modprobe to autoprobe.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220712214624.1845158-1-linus.walleij@linaro.org
Fixes: 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/drivetemp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 72c760373957..00303af82a77 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -621,3 +621,4 @@ module_exit(drivetemp_exit);
 MODULE_AUTHOR("Guenter Roeck <linus@roeck-us.net>");
 MODULE_DESCRIPTION("Hard drive temperature monitor");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:drivetemp");
-- 
2.35.1



