Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBBB20E681
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbgF2VsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgF2Sfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0D42465B;
        Mon, 29 Jun 2020 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443971;
        bh=iUhWoPb1izTE7jr4E7m4MsTP3Hs8v+Lhp4FU1e8vsps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYZDDlyLuR1QMWclJbqEd5YrlXo132wzzhcpsxs/sGpjF57vs4r2UZViRZrtblsO6
         C3yBTFrfnYjOhn4ZgDsPADrcjmfZQ+XkQz/bUQbo+xpAV619vRkYryLcsNGmO/gkQB
         6FSpRoG06xWvrdmrn+9eZQV+Wh61pcJh4jeUEPMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoffer Nielsen <cn@obviux.dk>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 075/265] ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S
Date:   Mon, 29 Jun 2020 11:15:08 -0400
Message-Id: <20200629151818.2493727-76-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoffer Nielsen <cn@obviux.dk>

commit 73094608b8e214952444fb104651704c98a37aeb upstream.

Similar to the Kingston HyperX AMP, the Kingston HyperX Cloud
Alpha S (0951:0x16ea) uses two interfaces, but only the second
interface contains the capture stream. This patch delays the
registration until the second interface appears.

Signed-off-by: Christoffer Nielsen <cn@obviux.dk>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAOtG2YHOM3zy+ed9KS-J4HkZo_QGzcUG9MigSp4e4_-13r6B=Q@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index aa964847b39b2..b5e9fe0486189 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1844,6 +1844,7 @@ struct registration_quirk {
 static const struct registration_quirk registration_quirks[] = {
 	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
 	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
+	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
 	{ 0 }					/* terminator */
 };
 
-- 
2.25.1

