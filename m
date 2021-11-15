Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18628450CD3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhKORoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236881AbhKORly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E45632F4;
        Mon, 15 Nov 2021 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997255;
        bh=kIdQFU/9pUAtED/7qGstZ536P5/Xac8fklidjgrnPfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MM7yzhoWIz23JTJKVtQ7JvvMv/bgM9L3TjmFDOCleiKk6R8dOCXYfrWG4c1n5KAw8
         YeYJ65TtR9PCOn7PHVRBQR6k2Tui9eYa7mfEzW5ZCBBOcaAVEupO6mYBFxGFaRLArg
         B3lVKFprnaQlInxCy7fMPhoKtqkhoneZB6zoKISw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 038/575] ALSA: usb-audio: Add registration quirk for JBL Quantum 400
Date:   Mon, 15 Nov 2021 17:56:03 +0100
Message-Id: <20211115165344.946704343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

commit 763d92ed5dece7d439fc28a88b2d2728d525ffd9 upstream.

Add another device ID for JBL Quantum 400. It requires the same quirk as
other JBL Quantum devices.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211030174308.1011825-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1897,6 +1897,7 @@ static const struct registration_quirk r
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
 	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x1f47, 2),	/* JBL Quantum 800 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x1f4c, 2),	/* JBL Quantum 400 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203c, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */


