Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E780822711C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgGTVl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgGTVj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:39:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1919622BF5;
        Mon, 20 Jul 2020 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281166;
        bh=YOEldPYJZAz74gN0FsnvGPJW3gx6+vxdlBeAMEtsElw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4/qRExMdy1lGDExI7RTqNRnhq1GwTeQa+vJOJG7SiO0SZdGtUvFjuHIabB2c4VK7
         gqv0CypkD/7DXKcQ8oknwG6ZhlhcxqdzhrpnvpPM5qFK0VLTpzAQhI1sjTlKnpsLRD
         RUUmm7oFp0lbkxYMAm0vmRHrFrlypzBTtaQclHfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Katsnelson <me@0upti.me>, Lyude Paul <lyude@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/13] Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen
Date:   Mon, 20 Jul 2020 17:39:10 -0400
Message-Id: <20200720213914.407919-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213914.407919-1-sashal@kernel.org>
References: <20200720213914.407919-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Katsnelson <me@0upti.me>

[ Upstream commit dcb00fc799dc03fd320e123e4c81b3278c763ea5 ]

Tested on my own laptop, touchpad feels slightly more responsive with
this on, though it might just be placebo.

Signed-off-by: Ilya Katsnelson <me@0upti.me>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20200703143457.132373-1-me@0upti.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 85db184321f78..0714d572e49a3 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -182,6 +182,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN0093", /* T480 */
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
+	"LEN0099", /* X1 Extreme 1st */
 	"LEN009b", /* T580 */
 	"LEN200f", /* T450s */
 	"LEN2044", /* L470  */
-- 
2.25.1

