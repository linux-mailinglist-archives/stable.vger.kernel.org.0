Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD0581A3
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfF0Ld5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 07:33:57 -0400
Received: from www.linuxtv.org ([130.149.80.248]:42459 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfF0Ld5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 07:33:57 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hgSf5-0006sp-LT; Thu, 27 Jun 2019 11:33:55 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 27 Jun 2019 11:33:09 +0000
Subject: [git:media_tree/master] media: stv0297: fix frequency range limit
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hgSf5-0006sp-LT@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: stv0297: fix frequency range limit
Author:  Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:    Tue Jun 25 06:45:20 2019 -0400

There was a typo at the lower frequency limit for a DVB-C
card, causing the driver to fail while tuning channels at the
VHF range.

https://bugzilla.kernel.org/show_bug.cgi?id=202083

Fixes: f1b1eabff0eb ("media: dvb: represent min/max/step/tolerance freqs in Hz")
Reported-by: Ari Kohtamäki <ari.kohtamaki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/dvb-frontends/stv0297.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index dac396c95a59..6d5962d5697a 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -682,7 +682,7 @@ static const struct dvb_frontend_ops stv0297_ops = {
 	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		 .name = "ST STV0297 DVB-C",
-		 .frequency_min_hz = 470 * MHz,
+		 .frequency_min_hz = 47 * MHz,
 		 .frequency_max_hz = 862 * MHz,
 		 .frequency_stepsize_hz = 62500,
 		 .symbol_rate_min = 870000,
