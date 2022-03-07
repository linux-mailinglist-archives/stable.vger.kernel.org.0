Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5404CF5CB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbiCGJb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbiCGJ3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E0C5B8BE;
        Mon,  7 Mar 2022 01:27:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B309A60C00;
        Mon,  7 Mar 2022 09:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A44C340E9;
        Mon,  7 Mar 2022 09:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645275;
        bh=f4g8xhcP711CTJtA/JNIAJ1Z6B3hMC8yWnMW76UYusA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsxCgzYh0rgCpQDMg4EIkp5559XEaHOY0osgLhOdNzFZyHq//7oKR7S+NfXSR7GhN
         x7mQoK3cbLSAaZ/vzixkddpGXK850Znjhh4Af9/pJOsIAqlxd/tqioxEahAXz5Qy7/
         oK8BhuvFiwLmZHmJQjmlDdCNdkWxSI1gcHPClIvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Alyssa Ross <hi@alyssa.is>, Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.4 41/64] firmware: arm_scmi: Remove space in MODULE_ALIAS name
Date:   Mon,  7 Mar 2022 10:19:14 +0100
Message-Id: <20220307091640.313149941@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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
@@ -983,7 +983,7 @@ static struct platform_driver scmi_drive
 
 module_platform_driver(scmi_driver);
 
-MODULE_ALIAS("platform: arm-scmi");
+MODULE_ALIAS("platform:arm-scmi");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCMI protocol driver");
 MODULE_LICENSE("GPL v2");


