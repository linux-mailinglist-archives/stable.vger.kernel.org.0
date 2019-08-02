Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51497F11E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404017AbfHBJgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404845AbfHBJgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32142183F;
        Fri,  2 Aug 2019 09:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738578;
        bh=ypH8/ikrrepBuxnryWfkrCGiNNhMh8PmI7wTcODDPxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4AFbmhNu+xPG3m2Y37ySXVkeuYNoWD8Y16pM7knHQxeFnVyRZTA7mP2/G8S6gmjK
         Wd0FeEb/aVCiLKYQotcCjajl1o3Y3y7wciDXlEquNNe3PITFAGwtaV2znglb3GBwOV
         EiMN71c7MGbLR6dEEGjQ0+aSGD4x22B6OqfWYjn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 144/158] ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1
Date:   Fri,  2 Aug 2019 11:29:25 +0200
Message-Id: <20190802092231.916878684@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 70256b42caaf3e13c2932c2be7903a73fbe8bb8b upstream.

Commit 7b9584fa1c0b ("staging: line6: Move altsetting to properties")
set a wrong altsetting for LINE6_PODHD500_1 during refactoring.

Set the correct altsetting number to fix the issue.

BugLink: https://bugs.launchpad.net/bugs/1790595
Fixes: 7b9584fa1c0b ("staging: line6: Move altsetting to properties")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/podhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -155,7 +155,7 @@ static const struct line6_properties pod
 		.capabilities	= LINE6_CAP_CONTROL
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
-		.altsetting = 1,
+		.altsetting = 0,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,


