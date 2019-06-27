Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9B576D8
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfF0Ala (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfF0Al3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:41:29 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 025A3205ED;
        Thu, 27 Jun 2019 00:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596088;
        bh=dwqc2rFbSqG/hi4drS0Ek1cR6Me27uLedH4ij06eCdU=;
        h=From:To:Cc:Subject:Date:From;
        b=XR3MhGxm4QrrOKH1PDm4o+5ZQWX7E5/Mdg540gH01hXrsDzzkOE0ihyFs9ZjwWHHx
         Z7xWNyEXVzsFiMoyOX1q/R+yPI+zY5mmx5ZIDDmh3jiUdvANOd4bmXIfdviHN7ZB9J
         1+mTmf6rrvdfVEvdB7SLi6w85zPIHTKuPj7ozGRQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Ma <aaron.ma@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/21] Input: elantech - enable middle button support on 2 ThinkPads
Date:   Wed, 26 Jun 2019 20:41:01 -0400
Message-Id: <20190627004122.21671-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit aa440de3058a3ef530851f9ef373fbb5f694dbc3 ]

Adding 2 new touchpad PNPIDs to enable middle button support.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elantech.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 38edf8f5bf8a..15be3ee6cc50 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1187,6 +1187,8 @@ static const char * const middle_button_pnp_ids[] = {
 	"LEN2132", /* ThinkPad P52 */
 	"LEN2133", /* ThinkPad P72 w/ NFC */
 	"LEN2134", /* ThinkPad P72 */
+	"LEN0407",
+	"LEN0408",
 	NULL
 };
 
-- 
2.20.1

