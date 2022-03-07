Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7248C4CF72F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiCGJo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbiCGJjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC9870F77;
        Mon,  7 Mar 2022 01:35:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3722360FF6;
        Mon,  7 Mar 2022 09:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F992C340F4;
        Mon,  7 Mar 2022 09:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645678;
        bh=mmQHfL/dWtz66XuI74oyMZ5+BBUM8m0i4K/ns0OOhG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqqUN4FzDphbYhXbcPfSnmjvd5kYwRMyZGyDPY7U86ND4TtFLcrOc+YafVTqAkf9j
         SciacTHpV0bydzJgz3L14lwCgerRpSoBG72yrmSrmxZrKdC8q1VlMtYXaz9Ut5zOvH
         y2Ig/NMQvkPizzjZglKgn3lZGh2NF5fOwLhJ+h2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Alyssa Ross <hi@alyssa.is>, Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.10 069/105] firmware: arm_scmi: Remove space in MODULE_ALIAS name
Date:   Mon,  7 Mar 2022 10:19:12 +0100
Message-Id: <20220307091646.118521376@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
@@ -979,7 +979,7 @@ static void __exit scmi_driver_exit(void
 }
 module_exit(scmi_driver_exit);
 
-MODULE_ALIAS("platform: arm-scmi");
+MODULE_ALIAS("platform:arm-scmi");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCMI protocol driver");
 MODULE_LICENSE("GPL v2");


