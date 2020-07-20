Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBFA2271B7
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgGTVpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgGTVhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA89922CF7;
        Mon, 20 Jul 2020 21:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281058;
        bh=kOVhulJk+pdwU88duSZrqzaEiuBdYU+NRWyGSP6HyBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSI6WBQm5bu6GLlliKvJ5aBO4BgjfQc4VwOpAulO9DqE9WI2lsx91iIlSyecWi3/s
         VftoFwXi4lt6OwE0q2IHOqUY1Etj3POIWLoJurY2QdC8NHhyeV/iYjhvJwmUNgvW+p
         TSq4qqwt7KNqcj1cJv3l/2MlhBHb99/t7+flscsg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Katsnelson <me@0upti.me>, Lyude Paul <lyude@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 18/40] Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen
Date:   Mon, 20 Jul 2020 17:36:53 -0400
Message-Id: <20200720213715.406997-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
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
index 758dae8d65006..4b81b2d0fe067 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -179,6 +179,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN0093", /* T480 */
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
+	"LEN0099", /* X1 Extreme 1st */
 	"LEN009b", /* T580 */
 	"LEN200f", /* T450s */
 	"LEN2044", /* L470  */
-- 
2.25.1

