Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E373A6218
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhFNKzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234160AbhFNKxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3E4561481;
        Mon, 14 Jun 2021 10:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667183;
        bh=m90RFx8X7Qq5HLGB4cFqQzdChPN2N1+Kw/SUifmZI4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBYAUf/oFe3gqK46GA7B7bKwUFZkYamC248+89aFc3b1ZPXF3DGSX6sYGkx1gZb5j
         bVs+2aSHdbnElHbA7GzlCN2aMUWOvrqt7Nc1NSdjcdL+OEMpZb0wVy5dWKx3cXoLyZ
         qVPFVIBUEJfk0JTZmb6rZX27RXOM3X09UW8W40Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/84] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Mon, 14 Jun 2021 12:27:03 +0200
Message-Id: <20210614102647.211396736@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit 8c42a49738f16af0061f9ae5c2f5a955f268d9e3 ]

Also enable phy errata workaround on 9567 since has the same errata as
the 9477 according to the manufacture's documentation.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 49ab1346dc3f..0370e71ed6e0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1520,6 +1520,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.30.2



