Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41259593640
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbiHOSmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243064AbiHOSj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852D83DBCF;
        Mon, 15 Aug 2022 11:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A5AD60693;
        Mon, 15 Aug 2022 18:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEFBC433D6;
        Mon, 15 Aug 2022 18:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587840;
        bh=IKW68nveAglgeNnym+vgT6nzaVOyqVoVUfARrjdeb+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Abq/V9/gEqDVehcVkBivKpMyA5ZcCY49bVGoK29XyjEebku34YDPl6rgovDMRUYh
         nsnbfEvDMRgHh75ln1Gh8Tpv+jmIPU51pO2yBytnFNderNUT+PvEUVCVkDkwlSW0eJ
         tkCmAiI/VEqWv1Eu+5v1TtR/2KedMXPElQEzvjPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/779] hwmon: (drivetemp) Add module alias
Date:   Mon, 15 Aug 2022 19:57:35 +0200
Message-Id: <20220815180346.291262633@linuxfoundation.org>
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
index 1eb37106a220..5bac2b0fc7bb 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -621,3 +621,4 @@ module_exit(drivetemp_exit);
 MODULE_AUTHOR("Guenter Roeck <linus@roeck-us.net>");
 MODULE_DESCRIPTION("Hard drive temperature monitor");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:drivetemp");
-- 
2.35.1



