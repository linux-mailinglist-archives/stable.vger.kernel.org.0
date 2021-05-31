Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A51E3962B4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhEaPAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhEaO5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E45061CC5;
        Mon, 31 May 2021 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469649;
        bh=mXgOU/XIE7N1ltNXIeFTqOVB5jPF1F4nWvQkSMcQwQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+7K52UrS6JZovkWxF4+f+DrI8XOR4Jh/7jt/gqkLrgFDKkoZ27wWYLJUoaYf668m
         q2uDX/gyl820OcShyfjI7o9G/bfn823X0qO2klXo7nDs3MhOXU6CBWYw5a7jdDsA2u
         H812LaxEu6JSukJAjGeJHCfogO81+4KKqKmbIXM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 277/296] ALSA: usb-audio: scarlett2: snd_scarlett_gen2_controls_create() can be static
Date:   Mon, 31 May 2021 15:15:32 +0200
Message-Id: <20210531130713.043838185@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
index 3ad8f61a2095..4caf379d5b99 100644
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



