Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D11945BEF1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbhKXMwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345824AbhKXMux (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17375610D2;
        Wed, 24 Nov 2021 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756988;
        bh=BCswhT/GHvNHqPH9NOGZqyVJrj6JreIltr/Yqy5PEzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHAYaRQK2AHHHENsMMxQPsj1gPkwnVkQMJWGL1ULyB3+CH3RR8vVuR/xjQV1kLuqt
         xDjqSUkXBMiLQVtQkv4NLMtMGVeF1gXP+gmSg5j2i5Ra2IILvDeWIqrp/jc/dohF4h
         eZlwM4sOMoXW/dIOhkGsUTVeKmmY26xQujC3cIOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 019/323] ALSA: usb-audio: Add registration quirk for JBL Quantum 400
Date:   Wed, 24 Nov 2021 12:53:29 +0100
Message-Id: <20211124115719.500442207@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -1555,6 +1555,7 @@ static const struct registration_quirk r
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
 	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x1f47, 2),	/* JBL Quantum 800 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x1f4c, 2),	/* JBL Quantum 400 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203c, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */


