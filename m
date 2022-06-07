Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C625541BDC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378028AbiFGVzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383300AbiFGVxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2905FE7;
        Tue,  7 Jun 2022 12:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8B43B82182;
        Tue,  7 Jun 2022 19:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A3EC385A2;
        Tue,  7 Jun 2022 19:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629072;
        bh=tDwZ+cRCl8rKQM727vQUjg2KyaP+QSUoDKb2AhzgPkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfhsM0NZmIBX3LN2kmi/MDdkK2zSyYTq/ZHHSd1YZdPOtKG8dOTxZtUQkyJae6khM
         j+D2fWBpeGyDEVmd7dt+QjF7tq3+YJRFtA5iyQPsWaPA6BVYIxDNo9D2KESfwzT7TO
         oA67VvMlmLk8fOaY3YzoZnM91NkVlKhlmZcsPRbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 560/879] can: xilinx_can: mark bit timing constants as const
Date:   Tue,  7 Jun 2022 19:01:18 +0200
Message-Id: <20220607165019.118305403@linuxfoundation.org>
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
index e562c5ab1149..43f0c6a064ba 100644
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



