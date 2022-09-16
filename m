Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2855BAAE1
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiIPKQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiIPKPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:15:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F426AD981;
        Fri, 16 Sep 2022 03:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0025562A18;
        Fri, 16 Sep 2022 10:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F64AC433D6;
        Fri, 16 Sep 2022 10:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323056;
        bh=qo7r3lFO+GmNp4rIp9+Gf79aAMEzn3aAsI/EYR7RM2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMvz/cisFhSWTSkIeHU4KQhu164sDxatHZTS2+sbB+VrwsLhuP83cEEX/fC0COBBH
         y6nlTcaP00N1uoSgYhv77p+BUNbBmHp551Z2VCh+mNboXX/p5vDehWqK24IZozwpRG
         ZLMwrLb7/x29KYs0VpDRd8fBMI0NGrgRNhDAoUaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarrah Gosbell <kernel@undef.tools>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 24/24] Input: goodix - add compatible string for GT1158
Date:   Fri, 16 Sep 2022 12:08:49 +0200
Message-Id: <20220916100446.430445471@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarrah Gosbell <kernel@undef.tools>

commit 80b9ebd3e478cd41526cbf84f80c3e0eb885d1d3 upstream.

Add compatible string for GT1158 missing from the previous patch.

Fixes: 425fe4709c76 ("Input: goodix - add support for GT1158")
Signed-off-by: Jarrah Gosbell <kernel@undef.tools>
Link: https://lore.kernel.org/r/20220813043821.9981-1-kernel@undef.tools
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1386,6 +1386,7 @@ MODULE_DEVICE_TABLE(acpi, goodix_acpi_ma
 #ifdef CONFIG_OF
 static const struct of_device_id goodix_of_match[] = {
 	{ .compatible = "goodix,gt1151" },
+	{ .compatible = "goodix,gt1158" },
 	{ .compatible = "goodix,gt5663" },
 	{ .compatible = "goodix,gt5688" },
 	{ .compatible = "goodix,gt911" },


