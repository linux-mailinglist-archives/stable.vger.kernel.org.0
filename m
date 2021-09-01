Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AFC3FDC84
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345372AbhIAMvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346197AbhIAMtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D5A610D0;
        Wed,  1 Sep 2021 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500073;
        bh=7s5V+XLCi58mMZ1aJ4NhjrK5fu6oh+cvwdC8oHgwZww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBq9zNjSlBhmv1vnqoLB1QtXed16MKqy73PviQ1bYbGMlZaYRmDIUIdNdDYAmWDVg
         vve//wRbkwnZRq/LRWtLKVMejdx7trUi42VpVJ+y1+cibLJXvlZxbmPw7aJxsY/jMA
         IcmsX0KOxTQMvDtfRpIC9re0h8x0vHd4akVlTSpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 091/113] platform/x86: gigabyte-wmi: add support for X570 GAMING X
Date:   Wed,  1 Sep 2021 14:28:46 +0200
Message-Id: <20210901122304.997928357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit b9570f5c9240cadf87fb5f9313e8f425aa9e788f ]

Reported as working here:
https://github.com/t-8ch/linux-gigabyte-wmi-driver/issues/1#issuecomment-900263115

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20210817154628.84992-1-linux@weissschuh.net
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index fbb224a82e34..9e8cfac403d3 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -147,6 +147,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 AORUS ELITE"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
 	{ }
-- 
2.30.2



