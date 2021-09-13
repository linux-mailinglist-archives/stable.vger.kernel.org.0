Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C44140943A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345823AbhIMO3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344442AbhIMO1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:27:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1340F61362;
        Mon, 13 Sep 2021 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540980;
        bh=2fu4AzUAN0Bxs9my6Qf+BmfW9IGGTWMtzRBKQxwm6KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hb2RnuwnYSWeS1uV1Q3YFmsoKA71Bu58cgq6YDbV5a4dE6ZEE3qfuKp8XU9J0vZLi
         b9vs2u3aV+HMryvkjP99OWkOE8XH1yW0SPlbi8dzfUZ8SuPOrLpNyTNJn5mKFm2USE
         VyXDzvH+twcQSLMc+VNb7d1YUyELLbKRljiP3jsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 114/334] net: usb: asix: ax88772: add missing stop
Date:   Mon, 13 Sep 2021 15:12:48 +0200
Message-Id: <20210913131117.224410432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9c2670951ed03f8fc6c701d66f5c765929cf1f23 ]

Add missing stop and let phylib framework suspend attached PHY.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index dc87e8caf954..53c3c680c083 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -1220,6 +1220,7 @@ static const struct driver_info ax88772b_info = {
 	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.reset = ax88772_reset,
+	.stop = ax88772_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
 	         FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
-- 
2.30.2



