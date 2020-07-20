Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4862269B8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgGTQ26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732207AbgGTP7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273152065E;
        Mon, 20 Jul 2020 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260763;
        bh=CxQlNwpzu/HtjbDgXa4Hn6fTEwibh3vRBOmu6FNrMz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm3EB6u2A/62h9wd3/dQuPS6SvoFCD6gYnGgdoAaQFs0GVF4cX46qqjGB7ij2o/XZ
         KrTrjOWqNC5gndaN8WclHpDoTkftdT+1Qdt38R6S25mqB/WBm+mzEIZjf3R9FP/fg9
         cSi58jPwisqjNFbfhm/ugsx49lxHPb61crKDsxOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Pescosta <emmanuelpescosta099@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/215] ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Alpha S
Date:   Mon, 20 Jul 2020 17:36:09 +0200
Message-Id: <20200720152824.342120264@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Pescosta <emmanuelpescosta099@gmail.com>

[ Upstream commit fd60e0683e8e9107e09cd2e4798f3e27e85d2705 ]

Similar to the Kingston HyperX AMP, the Kingston HyperX Cloud
Alpha S (0951:16d8) uses two interfaces, but only the second
interface contains the capture stream. This patch delays the
registration until the second interface appears.

Signed-off-by: Emmanuel Pescosta <emmanuelpescosta099@gmail.com>
Link: https://lore.kernel.org/r/20200404153843.9288-1-emmanuelpescosta099@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index ad557ab65e043..5341d045e6a48 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1801,6 +1801,7 @@ struct registration_quirk {
 
 static const struct registration_quirk registration_quirks[] = {
 	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
+	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
 	{ 0 }					/* terminator */
 };
 
-- 
2.25.1



