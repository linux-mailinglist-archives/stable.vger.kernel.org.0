Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186C93AF045
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhFUQru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233890AbhFUQpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3772261351;
        Mon, 21 Jun 2021 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293165;
        bh=adBEG7zv+ENyu9SHmLOWViXi62cNurLlJQCxTzrZxb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/2ces322IFoot2hsD0qf6pRRDajJADPm4w1OiH4kxQFsrKLPFh+e8LlEf+5jP20E
         NEGbyHfNQ2nvyj0jHUI14ZOHyRzdzo+7AFZmJt+77VgcsCT8SAJyX0BzUIliGwToIt
         MH+QRUn8TsauqWMoXU1s+tBpO+irQ7BPVGY4uvJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 095/178] regulator: mt6315: Fix function prototype for mt6315_map_mode
Date:   Mon, 21 Jun 2021 18:15:09 +0200
Message-Id: <20210621154925.980642040@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 89082179ec5028bcd58c87171e08ada035689542 ]

The .of_map_mode should has below function prototype:
	unsigned int (*of_map_mode)(unsigned int mode);

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210530022109.425054-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6315-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mt6315-regulator.c b/drivers/regulator/mt6315-regulator.c
index 9edc34981ee0..6b8be52c3772 100644
--- a/drivers/regulator/mt6315-regulator.c
+++ b/drivers/regulator/mt6315-regulator.c
@@ -59,7 +59,7 @@ static const struct linear_range mt_volt_range1[] = {
 	REGULATOR_LINEAR_RANGE(0, 0, 0xbf, 6250),
 };
 
-static unsigned int mt6315_map_mode(u32 mode)
+static unsigned int mt6315_map_mode(unsigned int mode)
 {
 	switch (mode) {
 	case MT6315_BUCK_MODE_AUTO:
-- 
2.30.2



