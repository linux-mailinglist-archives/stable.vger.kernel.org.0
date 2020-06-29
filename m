Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7657B20DA92
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbgF2T6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387594AbgF2TkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C1312490A;
        Mon, 29 Jun 2020 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444459;
        bh=h63UWjESisQE8n3eAG6r0gEX4O1AVAstfhT8AixWNGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlTrMlvN8qtqLpc1EnLs2KULqNeQ4dnhR3x8bHXAuzzqthJtX3SZAwRcdvLAUmClh
         dJTP+GYpZI3tLQeE8kWxzWvQIQkE1+c1mJHrYprLIiL65zRtPhBKwK9I/R5i4i3Qsn
         B5Rmsbk+C6Pqkh4fSVS/VuGe8jOI1Rx/tHABlV/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Plattner <aplattner@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 139/178] ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table
Date:   Mon, 29 Jun 2020 11:24:44 -0400
Message-Id: <20200629152523.2494198-140-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Plattner <aplattner@nvidia.com>

commit adb36a8203831e40494a92095dacd566b2ad4a69 upstream.

These IDs are for upcoming NVIDIA chips with audio functions that are largely
similar to the existing ones.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200611180845.39942-1-aplattner@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index d41c91468ab33..e78c4367b6c86 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4146,6 +4146,11 @@ HDA_CODEC_ENTRY(0x10de0095, "GPU 95 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0097, "GPU 97 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0098, "GPU 98 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0099, "GPU 99 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009a, "GPU 9a HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009d, "GPU 9d HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009e, "GPU 9e HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009f, "GPU 9f HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a0, "GPU a0 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de8001, "MCP73 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x10de8067, "MCP67/68 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x11069f80, "VX900 HDMI/DP",	patch_via_hdmi),
-- 
2.25.1

