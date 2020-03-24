Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75ED11910AC
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCXNaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbgCXNWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:22:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F589208CA;
        Tue, 24 Mar 2020 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056165;
        bh=r2X6fsZEwcykOYrQSgZiDy/C07x8LDvGB1GD/s6K1Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxLahQkN9Igcwnz1+3SmvkhNyjwkQtnHBGagUHRlKfc1bu1Tt99oYF6bsSlMcZ3y6
         IJhdZqdD3wCYg/U/u3O7ZskTCSGJjgv/n0WYljfnYVM7PFEwPFJDni+py5WOdYorOi
         ypFL8vli9q6iz6ocWOKVetVph80toZ91bHA56bck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 007/119] phy: ti: gmii-sel: do not fail in case of gmii
Date:   Tue, 24 Mar 2020 14:09:52 +0100
Message-Id: <20200324130808.738351751@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 58aa7729310db04ffcc022c98002dd8fcb486c58 ]

The "gmii" PHY interface mode is supported on TI AM335x/437x/5xx SoCs, so
don't fail if it's selected.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-gmii-sel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index e998e9cd8d1f8..1c536fc03c83c 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -80,6 +80,7 @@ static int phy_gmii_sel_mode(struct phy *phy, enum phy_mode mode, int submode)
 		break;
 
 	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_GMII:
 		gmii_sel_mode = AM33XX_GMII_SEL_MODE_MII;
 		break;
 
-- 
2.20.1



