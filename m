Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE834796B8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404081AbfG2Tyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390345AbfG2Tyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69494217D9;
        Mon, 29 Jul 2019 19:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430088;
        bh=FuVe1aUyl4DTNAxS4rKHxiILjtEQIiyN+w8ZHcmkfZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpVKcNMgUElBzAARuR7rbJTQTUS02+z5zhkexiD1QjXRAHmFaH0gWu6nnvW7oGeFZ
         DuCg0UKBN/SH9E8WaZdGTId0VOSOa9IYoZJVPbxD/rvzM8smoRMiMBXxELG8DGtrQY
         /oNRUiVzIsH1fjE2hZIe5gZrf2c8utz7iCGVAShw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 192/215] ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1
Date:   Mon, 29 Jul 2019 21:23:08 +0200
Message-Id: <20190729190813.212196073@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
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
@@ -413,7 +413,7 @@ static const struct line6_properties pod
 		.name = "POD HD500",
 		.capabilities	= LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
-		.altsetting = 1,
+		.altsetting = 0,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,


