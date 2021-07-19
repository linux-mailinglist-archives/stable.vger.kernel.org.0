Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E9D3CDFC3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbhGSPLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345805AbhGSPJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69E5E613C0;
        Mon, 19 Jul 2021 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709763;
        bh=Zgnyj7OietzwhR2T7kQGYpNELKJs2BYJDF1TZ96K5mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zfpxxLFK9GvZwHXGpzfRof8cx0CtP6lrHd7y9fFN7DOvjGOmRM1j/xvUgWy7OEFo
         1I+LzBl2ErSQTYT0g7MWH/e/a9C0N6OrY4SBbLtH567V5GF6pgcONaWmmOkwy2DKeL
         /a/XYHjH1//mjMtsa9gejIn65L44glw17sbYF2oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/149] power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:15 +0200
Message-Id: <20210719144921.976572499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 073b5d5b1f9cc94a3eea25279fbafee3f4f5f097 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/charger-manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index a21e1a2673f8..1a215b6d9447 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1470,6 +1470,7 @@ static const struct of_device_id charger_manager_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, charger_manager_match);
 
 static struct charger_desc *of_cm_parse_desc(struct device *dev)
 {
-- 
2.30.2



