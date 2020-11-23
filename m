Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C71B2C0A3B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbgKWNRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732572AbgKWMmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE7442065E;
        Mon, 23 Nov 2020 12:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135330;
        bh=xxacY6H/gCgXjQQHWM4FgnFn+UvbfhwuXI2a/FIcsH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ES4pyPzL3cEiVYlYoFf9ep5ow0qQQUjHVAsVHYAlbWN89JFpzrT4Uu6XToHtnOKjA
         9W4UEy3XN6I8QKEunNsnP1tYyK2EP0VnPOBPTsk/55AgFzmIKYImr8iwdhTSPj1ac4
         EjjUvgBOkRNfvhp7jRwpkz9sWi80Rdx1TEyjuhh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 030/252] net: phy: mscc: remove non-MACSec compatible phy
Date:   Mon, 23 Nov 2020 13:19:40 +0100
Message-Id: <20201123121837.044422623@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steen Hegelund <steen.hegelund@microchip.com>

[ Upstream commit aa6306a8481e0223f3783d24045daea80897238e ]

Selecting VSC8575 as a MACSec PHY was not correct

The relevant datasheet can be found here:
  - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575

History:
v1 -> v2:
   - Corrected the sha in the "Fixes:" tag

Fixes: 1bbe0ecc2a1a ("net: phy: mscc: macsec initialization")
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20201113091116.1102450-1-steen.hegelund@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mscc/mscc_macsec.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_devic
 
 	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
 	case PHY_ID_VSC856X:
-	case PHY_ID_VSC8575:
 	case PHY_ID_VSC8582:
 	case PHY_ID_VSC8584:
 		INIT_LIST_HEAD(&vsc8531->macsec_flows);


