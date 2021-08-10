Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6A3E7F09
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhHJRg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233632AbhHJRfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC3F2610CC;
        Tue, 10 Aug 2021 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616906;
        bh=A2bczzZKTvesHcKN+5UKs+PdkRxIxJHu4Mn6KoXB/OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWkLs4RaKJDM9d0TYG4eMAJYCC/O+Eki+VA1VIms2U1TC7lfo9l2Mm830I6SapSmd
         lkc7t4pEHFRmvYFGjKf5kfaUbubi3Br45PCvu5R1z0FFNv0nMiAWNJ5iKusgrDhi67
         5OmfHyVnDhvQS4NthDAPmzxqur8JlWTp1qK7Z+Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 43/85] ALSA: usb-audio: Add registration quirk for JBL Quantum 600
Date:   Tue, 10 Aug 2021 19:30:16 +0200
Message-Id: <20210810172949.690954562@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

commit 4b0556b96e1fe7723629bd40e3813a30cd632faf upstream.

Apparently JBL Quantum 600 has multiple hardware revisions. Apply
registration quirk to another device id as well.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210727093326.1153366-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1842,6 +1842,7 @@ static const struct registration_quirk r
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
 	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x203c, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */
 	{ 0 }					/* terminator */
 };


