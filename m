Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EF83C53F1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbhGLH43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351007AbhGLHvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB37C610D1;
        Mon, 12 Jul 2021 07:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076116;
        bh=5ByulEgjr3pocRzM09r7OP2K3EB5eU9FWqYMwsAqmBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYB0spxkgVjD8nOzYLP7mSOgF7eNwSf5413HPF6i+s+A0cTmWnpCPF0jMYZELUk0I
         PV87uwCCrxNq6J44tzcvOeT2GVu7rNbYarMrt7po2Bi6QO/jSbMdSp8u59EQO58E33
         fMd7sC6mqDc12XOWsPmojxYvpjPW0h/N6A9pbfK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 504/800] mt76: mt7915: fix MT_EE_CAL_GROUP_SIZE
Date:   Mon, 12 Jul 2021 08:08:47 +0200
Message-Id: <20210712061020.795051206@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit ee8ba94f9cc9afab570fd71ad421292f6360983c ]

Fix wrong offset for pre-calibration data.

Fixes: 495184ac91bb ("mt76: mt7915: add support for applying pre-calibration data")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
index 033fb592bdf0..30bf41b8ed15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -33,7 +33,7 @@ enum mt7915_eeprom_field {
 #define MT_EE_WIFI_CAL_GROUP			BIT(0)
 #define MT_EE_WIFI_CAL_DPD			GENMASK(2, 1)
 #define MT_EE_CAL_UNIT				1024
-#define MT_EE_CAL_GROUP_SIZE			(44 * MT_EE_CAL_UNIT)
+#define MT_EE_CAL_GROUP_SIZE			(49 * MT_EE_CAL_UNIT + 16)
 #define MT_EE_CAL_DPD_SIZE			(54 * MT_EE_CAL_UNIT)
 
 #define MT_EE_WIFI_CONF0_TX_PATH		GENMASK(2, 0)
-- 
2.30.2



