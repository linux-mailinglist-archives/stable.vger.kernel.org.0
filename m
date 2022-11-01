Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660BE61498F
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiKALii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiKALiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:38:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C095C1DF0C;
        Tue,  1 Nov 2022 04:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 306C4B81CCD;
        Tue,  1 Nov 2022 11:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0135C43470;
        Tue,  1 Nov 2022 11:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302313;
        bh=8JproDmIxUKonuf1KKRNqVQpO4Bk98mgN8CquEEfLPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/6GXtCGWo5zVGxDsGS7bD2rh9SumnrtG+3iQk5G4QtR09Mc2R2XgU/c1peloP8st
         B4dJK7MgTjHamLaOHDGlTNAmEBj3IYAy2HjQH6jRkAHiRzTKUu5XcYxsL9Q5dZkyaw
         QpV17EHL11rIJmttE3WDaOanpDxuhcQDHchaWJlmPsmZxRyhm/IE3Q8N2vtpxAWzXK
         aKajc3uAkjqUlrLNFCHJSfu/gxvXrqofqmPElMmbsjXyZwYdzG4uhZG7SVq4WaAMEo
         GNTLzcGOToscD8eSN2fBtIZZWqRX2e9jF00bxIdcBaatGEc3UMixoDqzLxNRZ5R7er
         ++K+5N77VCT7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/3] i2c: xiic: Add platform module alias
Date:   Tue,  1 Nov 2022 07:31:45 -0400
Message-Id: <20221101113147.801048-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113147.801048-1-sashal@kernel.org>
References: <20221101113147.801048-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Tůma <martin.tuma@digiteqautomotive.com>

[ Upstream commit b8caf0a0e04583fb71e21495bef84509182227ea ]

The missing "platform" alias is required for the mgb4 v4l2 driver to load
the i2c controller driver when probing the HW.

Signed-off-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index c65a5d0af555..4b750c99819a 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -897,6 +897,7 @@ static struct platform_driver xiic_i2c_driver = {
 
 module_platform_driver(xiic_i2c_driver);
 
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1

