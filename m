Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635E03F548E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhHXAzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234007AbhHXAzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6120A61414;
        Tue, 24 Aug 2021 00:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766462;
        bh=7s5V+XLCi58mMZ1aJ4NhjrK5fu6oh+cvwdC8oHgwZww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXxyirE2mT9iHAGxdBVdHmxhIJNykRZObbPv5Hr3rlXcc6eJ8Kvg08UuEa3iPGmOy
         dfF9wik8qk+ntMAtkDULk7iNhcQ/+KQzOuPDGvqV8mSMPOwHc6UqH3Kro6SpLzb0s5
         mMJBJlFeXA/NrBg3OWoP/QNbjGMzFQWkqP8a3xvwXdgBewNGuzU+XCbK9gZG+eCiFR
         x4vX9mRQ3rLc8lZD9BYMchldrNz+Arc3483zGdjJztKYUOX5RdULvahwlEK2rup8da
         lxbV+9mei+OK8sOqHa7Gz08RUzFLXHyITxKMx427oXSmBeXcZyriQF0zUk2Zh5Bb4c
         p8xxZgeLPubkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 19/26] platform/x86: gigabyte-wmi: add support for X570 GAMING X
Date:   Mon, 23 Aug 2021 20:53:49 -0400
Message-Id: <20210824005356.630888-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

