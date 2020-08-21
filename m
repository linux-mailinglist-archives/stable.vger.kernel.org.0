Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1730D24DDD3
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgHUQP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgHUQPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BADA22C9F;
        Fri, 21 Aug 2020 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026518;
        bh=FS9LV1mgzKB2FrwnM+i3H+Tuad1djbcvC2VsGtvdOyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4GFlIn0r5x1xYgOq2O9Bo4du9mGyjh15e5A5T1xi8JZe1HWkLKxBZpR1pveNu1sc
         ldoCrrsdTSvjfv+imFUdFzfOFmNtCuix8Lmz+JsdYdN036w0x+FkWzLK2KFguCIS91
         GUE8Fy92xcrNZ/ICNeqBWyizuPAnyZ0Hh4Tdh7xE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kaige Li <likaige@loongson.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 42/62] ALSA: hda: Add support for Loongson 7A1000 controller
Date:   Fri, 21 Aug 2020 12:14:03 -0400
Message-Id: <20200821161423.347071-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaige Li <likaige@loongson.cn>

[ Upstream commit 61eee4a7fc406f94e441778c3cecbbed30373c89 ]

Add the new PCI ID 0x0014 0x7a07 to support Loongson 7A1000 controller.

Signed-off-by: Kaige Li <likaige@loongson.cn>
Link: https://lore.kernel.org/r/1594954292-1703-2-git-send-email-likaige@loongson.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 4c23b169ac67e..1a26940a3fd7c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2747,6 +2747,8 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_HDMI },
 	/* Zhaoxin */
 	{ PCI_DEVICE(0x1d17, 0x3288), .driver_data = AZX_DRIVER_ZHAOXIN },
+	/* Loongson */
+	{ PCI_DEVICE(0x0014, 0x7a07), .driver_data = AZX_DRIVER_GENERIC },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
-- 
2.25.1

