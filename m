Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEA44CF586
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiCGJaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237274AbiCGJ16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:27:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE966FB6;
        Mon,  7 Mar 2022 01:25:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D08E61119;
        Mon,  7 Mar 2022 09:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC654C340E9;
        Mon,  7 Mar 2022 09:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645096;
        bh=/y5DEU3VLL7/kRAEBhnVJzNpczswHDOlhMwmBMza8ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLRmBhJ+Px34AHarmSOyalMGsTzG7hImsdSiF8WZm2b4tStgX53Y2GVvt/H1E+0IM
         T0vFIqzbpL0YoWnwarsvZwGlbsQ5LlsBDfpZNgxkLjfrIJ328B262cSRr1GdWOEJYx
         n4mZO9E4sbgJCi1oZ330OU5YMg3KiuaKYn/ZaaPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Alyssa Ross <hi@alyssa.is>, Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 4.19 37/51] firmware: arm_scmi: Remove space in MODULE_ALIAS name
Date:   Mon,  7 Mar 2022 10:19:12 +0100
Message-Id: <20220307091638.047440494@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Ross <hi@alyssa.is>

commit 1ba603f56568c3b4c2542dfba07afa25f21dcff3 upstream.

modprobe can't handle spaces in aliases. Get rid of it to fix the issue.

Link: https://lore.kernel.org/r/20220211102704.128354-1-sudeep.holla@arm.com
Fixes: aa4f886f3893 ("firmware: arm_scmi: add basic driver infrastructure for SCMI")
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -873,7 +873,7 @@ static struct platform_driver scmi_drive
 
 module_platform_driver(scmi_driver);
 
-MODULE_ALIAS("platform: arm-scmi");
+MODULE_ALIAS("platform:arm-scmi");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCMI protocol driver");
 MODULE_LICENSE("GPL v2");


