Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B17047AE53
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhLTPAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36660 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbhLTO6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3132B80EEF;
        Mon, 20 Dec 2021 14:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4684CC36AEA;
        Mon, 20 Dec 2021 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012298;
        bh=x+YZtgjPDMCwSDRDeH0MK1mN1L1Kp6l8XeW80MzUXsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=088JupPo6mE1zJGiItmdpkQ4YJgBgdNZYrGcLjj+voXKRteiZaYWmR0nUmShXr+TZ
         cmUMguqJwdm/kPbXNt6CaqUi82N86pnkI4EyhoPg2MMiLUDi6idU6U3LnBsw93nNyV
         OBwcUc3nw8MxwSW3aV2Uq72JgFGXSQCM5IwD8pt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 152/177] can: m_can: make custom bittiming fields const
Date:   Mon, 20 Dec 2021 15:35:02 +0100
Message-Id: <20211220143045.194994765@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

commit ea22ba40debee29ee7257c42002409899e9311c1 upstream.

The assigned timing structs will be defined a const anyway, so we can
avoid a few casts by declaring the struct fields as const as well.

Link: https://lore.kernel.org/all/4508fa4e639164b2584c49a065d90c78a91fa568.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,8 +85,8 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
-	struct can_bittiming_const *bit_timing;
-	struct can_bittiming_const *data_timing;
+	const struct can_bittiming_const *bit_timing;
+	const struct can_bittiming_const *data_timing;
 
 	struct m_can_ops *ops;
 


