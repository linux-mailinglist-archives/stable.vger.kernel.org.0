Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8993541B51
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357096AbiFGVqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381594AbiFGVoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:44:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F4823468D;
        Tue,  7 Jun 2022 12:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B2B0B823B7;
        Tue,  7 Jun 2022 19:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F6EC385A2;
        Tue,  7 Jun 2022 19:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628833;
        bh=dZo32vMLwnivpeCJQPWIqQe7S1bIJwFO/ruK0sfCIyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU4gRstkkpuPB/x7JhdB5wSpPX9wr7UswZNa5e62Ddr2wYukT44Mld1Dw7Hrfqu+w
         KiAkZtIyQWQokZcVsFhhEz42qkh6viN2BRWNP1BasI+z7q2gAmzEiT2NmDvKp5R65u
         5m5+fWP9ZGmQ6RCFW6Zvmyf/D/uoF0x39HeZb80o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Pagano <mpagano@gentoo.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 473/879] media: i2c: ov2640: Depend on V4L2_ASYNC
Date:   Tue,  7 Jun 2022 18:59:51 +0200
Message-Id: <20220607165016.609189998@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Pagano <mpagano@gentoo.org>

[ Upstream commit 8429b358975f11574f747ca8ef20d524d8247682 ]

Add V4L2_ASYNC as a dependency to match other drivers and prevent failures
when compile testing.

Fixes: ff3cc65cadb5 ("media: v4l: async, fwnode: Improve module organisation")
Signed-off-by: Mike Pagano <mpagano@gentoo.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index fae2baabb773..2b20aa6c37b1 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -372,6 +372,7 @@ config VIDEO_OV13B10
 config VIDEO_OV2640
 	tristate "OmniVision OV2640 sensor support"
 	depends on VIDEO_DEV && I2C
+	select V4L2_ASYNC
 	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV2640 camera.
-- 
2.35.1



