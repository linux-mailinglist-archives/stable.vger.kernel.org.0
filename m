Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C25C540696
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346911AbiFGRhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347610AbiFGRf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6D2DED4;
        Tue,  7 Jun 2022 10:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2FF53CE23D0;
        Tue,  7 Jun 2022 17:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBE3C385A5;
        Tue,  7 Jun 2022 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623041;
        bh=G+VmD+Gd+6D+I0VXQN+nuqorCTGsJh90QPeQSS1lKOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/JS70GK3Ar+KTYVye2sQPWN2kd8LXbdvSu3mECJ11EoRs4HgcAKUVLF+Qm/mz7fx
         smoz6SkxJ/qtU5YQ6K/0B82eTQzz7VNO3IX6PgyLyuXJqFoR3fq1RNSr/VuV8YP8kh
         2Y2MZo/Ia4UvyMxOiaYIPilvAeDXABCBIpsWkvvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/452] can: xilinx_can: mark bit timing constants as const
Date:   Tue,  7 Jun 2022 19:02:10 +0200
Message-Id: <20220607164916.685878302@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 375998263af7..1c42417810fc 100644
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



