Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCA8541521
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359568AbiFGU27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376587AbiFGU1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D71B7832;
        Tue,  7 Jun 2022 11:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABCE4612EC;
        Tue,  7 Jun 2022 18:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DBCC34115;
        Tue,  7 Jun 2022 18:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626774;
        bh=eRb1IsnbktKayJ3HyDwY3GnvB4R+VD34n1nZmYxBRWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJzlMOMRyQrCdSCfVxJhJGimsK1eZPJMRjKs20Khq/bZi7I6Ra4eB+XFOfejIURYR
         ngWVFX9F4mK+71pKxHgtgk8/WtHnWwb6khxVQPVhfw3cF3chIjya+YTL9IxYy96tKU
         ojq5oID3umh8ZOsce4WP86OfLeA3RkwZ68NSMk/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 472/772] can: xilinx_can: mark bit timing constants as const
Date:   Tue,  7 Jun 2022 19:01:04 +0200
Message-Id: <20220607165002.904756885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ae38fda02996d43d9fb09f16e81e0008704dd524 ]

This patch marks the bit timing constants as const.

Fixes: c223da689324 ("can: xilinx_can: Add support for CANFD FD frames")
Link: https://lore.kernel.org/all/20220317203119.792552-1-mkl@pengutronix.de
Cc: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Cc: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 1674b561c9a2..f3b149b60465 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -239,7 +239,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd = {
 };
 
 /* AXI CANFD Data Bittiming constants as per AXI CANFD 1.0 specs */
-static struct can_bittiming_const xcan_data_bittiming_const_canfd = {
+static const struct can_bittiming_const xcan_data_bittiming_const_canfd = {
 	.name = DRIVER_NAME,
 	.tseg1_min = 1,
 	.tseg1_max = 16,
@@ -265,7 +265,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 };
 
 /* AXI CANFD 2.0 Data Bittiming constants as per AXI CANFD 2.0 spec */
-static struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
+static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.name = DRIVER_NAME,
 	.tseg1_min = 1,
 	.tseg1_max = 32,
-- 
2.35.1



