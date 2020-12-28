Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BD12E3FD8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506273AbgL1OpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503097AbgL1OYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D0A229C4;
        Mon, 28 Dec 2020 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165435;
        bh=eWZH/hfaH+tT5EoVN3VpfUE3eDmS2frWJRm+T3vsgnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvVo4oarC+XtmQxHYFz9BNpsLTlZuKLwcHGtb35mN5CzSoSmjCXVGQF8Cm3pGgm4Z
         W1XAuOPAjiPIir1RVLMCDeQ9B8EQXU3FwIAo3JfYOZc575xmLKVtUitPsX5Y/Or+dx
         19prJCXxxKKFdbdwr163tLHKIVHzANLtSDUoTPkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 530/717] ALSA: hda/ca0132 - Change Input Source enum strings.
Date:   Mon, 28 Dec 2020 13:48:48 +0100
Message-Id: <20201228125046.357711192@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor McAdams <conmanx360@gmail.com>

commit 7079f785b50055a32b72eddcb7d9ba5688db24d0 upstream.

Change the Input Source enumerated control's strings to make it play
nice with pulseaudio.

Fixes: 7cb9d94c05de9 ("ALSA: hda/ca0132: add alt_select_in/out for R3Di + SBZ")
Cc: <stable@kernel.org>
Signed-off-by: Connor McAdams <conmanx360@gmail.com>
Link: https://lore.kernel.org/r/20201208195223.424753-2-conmanx360@gmail.com
Link: https://lore.kernel.org/r/20201210173550.2968-2-conmanx360@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -95,7 +95,7 @@ enum {
 };
 
 /* Strings for Input Source Enum Control */
-static const char *const in_src_str[3] = {"Rear Mic", "Line", "Front Mic" };
+static const char *const in_src_str[3] = { "Microphone", "Line In", "Front Microphone" };
 #define IN_SRC_NUM_OF_INPUTS 3
 enum {
 	REAR_MIC,


