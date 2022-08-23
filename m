Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A27B59D574
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243359AbiHWI1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243628AbiHWIZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E426FA3E;
        Tue, 23 Aug 2022 01:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D0F56129A;
        Tue, 23 Aug 2022 08:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FCCC433D7;
        Tue, 23 Aug 2022 08:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242397;
        bh=mLBY6Fsf6WZ2u0NsCDFnW8EU6G375hSpNr7EVGFAr1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Okg3i6g0mxpnReqEbzhLb2dmMg5iG+qw9kc+AqO+u1uk71gs5ZLILKX4TCJ8/ZU2f
         /lF1jbm9r+ViLZA6vtHEuXAyC30JWn61ABWJhPL5yZ7JZRm/39MHeEM9yzZrXRj20A
         GH8/bI+jwjXhOWd8CYKl5EWE+GEip6cpNpincS9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 109/365] Input: iqs7222 - remove support for RF filter
Date:   Tue, 23 Aug 2022 10:00:10 +0200
Message-Id: <20220823080122.758836359@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

commit 381932cf61d52bde656c8596c0cb8f46bed53dc0 upstream.

The vendor has marked the RF filter enable control as reserved in
the datasheet; remove it from the driver.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-7-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index e65260d290cc..b2e8097a2e6d 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -557,13 +557,6 @@ static const struct iqs7222_prop_desc iqs7222_props[] = {
 		.reg_width = 4,
 		.label = "current reference trim",
 	},
-	{
-		.name = "azoteq,rf-filt-enable",
-		.reg_grp = IQS7222_REG_GRP_GLBL,
-		.reg_offset = 0,
-		.reg_shift = 15,
-		.reg_width = 1,
-	},
 	{
 		.name = "azoteq,max-counts",
 		.reg_grp = IQS7222_REG_GRP_GLBL,
-- 
2.37.2



