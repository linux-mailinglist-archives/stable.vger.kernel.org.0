Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD161EF76B
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 14:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgFEM0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 08:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgFEM0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 08:26:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCF6B208E4;
        Fri,  5 Jun 2020 12:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359965;
        bh=x7c/AxKWn05LnkjEH4TGTp18ZTJFYDtquGB/20661eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2k1I3n25vevXS3G1353EXHNPlm+JzvE1zGqShj4O8xegJaZqmpLOdyTDzX5mwpV6
         PJ1qar4IRQWOa8eW86VPHrZVvBoh/bwhy7NcIyWlwQCLlpn9xF05NR6lPhxc+A85RM
         PkUGeNUWN7EJS61v67/Q/eHHmJAD7FuNVz+ywKoA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Kadioglu <denk@eclipso.email>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/9] Input: synaptics - add a second working PNP_ID for Lenovo T470s
Date:   Fri,  5 Jun 2020 08:25:54 -0400
Message-Id: <20200605122558.2882712-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122558.2882712-1-sashal@kernel.org>
References: <20200605122558.2882712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Kadioglu <denk@eclipso.email>

[ Upstream commit 642aa86eaf8f1e6fe894f20fd7f12f0db52ee03c ]

The Lenovo Thinkpad T470s I own has a different touchpad with "LEN007a"
instead of the already included PNP ID "LEN006c". However, my touchpad
seems to work well without any problems using RMI. So this patch adds the
other PNP ID.

Signed-off-by: Dennis Kadioglu <denk@eclipso.email>
Link: https://lore.kernel.org/r/ff770543cd53ae818363c0fe86477965@mail.eclipso.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d9042d0566ab..671e018eb363 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -173,6 +173,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN005b", /* P50 */
 	"LEN005e", /* T560 */
 	"LEN006c", /* T470s */
+	"LEN007a", /* T470s */
 	"LEN0071", /* T480 */
 	"LEN0072", /* X1 Carbon Gen 5 (2017) - Elan/ALPS trackpoint */
 	"LEN0073", /* X1 Carbon G5 (Elantech) */
-- 
2.25.1

