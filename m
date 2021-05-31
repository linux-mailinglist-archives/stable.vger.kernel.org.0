Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4D43960DB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhEaOcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234100AbhEaOaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7286661C2E;
        Mon, 31 May 2021 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468928;
        bh=mW3JzDDoBeI87q2S+WAWUMH1ZVcEe+BKdYPGrjlANXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKjM1qWyqq464w+YG9z7TiKEHNSSQcTIhY1TmcjzaBpep2tvOs6MW2FVu62QJQWbU
         EtcnGw5Hv3LXsHHWDBrdHvIFKA5wzzBmKNRjTRXf20mkTn5oQpOQzlR7/7k+S9djCj
         DXmL4LpyQvhVBl2FeiN3oDu7U+cXxKGq6fSIx2Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/177] ALSA: usb-audio: scarlett2: snd_scarlett_gen2_controls_create() can be static
Date:   Mon, 31 May 2021 15:15:22 +0200
Message-Id: <20210531130653.623901380@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kernel test robot <lkp@intel.com>

[ Upstream commit 2b899f31f1a6db2db4608bac2ac04fe2c4ad89eb ]

sound/usb/mixer_scarlett_gen2.c:2000:5: warning: symbol 'snd_scarlett_gen2_controls_create' was not declared. Should it be static?

Fixes: 265d1a90e4fb ("ALSA: usb-audio: scarlett2: Improve driver startup messages")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20210522180900.GA83915@f59a3af2f1d9
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index a973dd4d5bbe..7a10c9e22c46 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1997,8 +1997,8 @@ static int scarlett2_mixer_status_create(struct usb_mixer_interface *mixer)
 	return usb_submit_urb(mixer->urb, GFP_KERNEL);
 }
 
-int snd_scarlett_gen2_controls_create(struct usb_mixer_interface *mixer,
-				      const struct scarlett2_device_info *info)
+static int snd_scarlett_gen2_controls_create(struct usb_mixer_interface *mixer,
+					     const struct scarlett2_device_info *info)
 {
 	int err;
 
-- 
2.30.2



