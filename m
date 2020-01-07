Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14333133488
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgAGU6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgAGU6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66560214D8;
        Tue,  7 Jan 2020 20:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430724;
        bh=tkThJCemrhN4PT6CIjxsGWTLeuQmOKStYLnxtNXjcfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8mac5JF6t9L1qREJHknNDJ0IkQIiewDqVea94IynpZCae64Ep0Y0qKcku3n6ZZK3
         3c4DIl0efxJuE2jh1AH4WF+9ZqwrKcT9DUmucmUkd2J6FXLIXA0zIsQ4pqLEBcVMCR
         m/Q6fIzicQzV3Faw/1Ze13CScN2h4+D5Oyk3P+cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 070/191] ALSA: hda/realtek - Add headset Mic no shutup for ALC283
Date:   Tue,  7 Jan 2020 21:53:10 +0100
Message-Id: <20200107205336.734592657@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 66c5d718e5a6f80153b5e8d6ad8ba8e9c3320839 upstream.

Chrome machine had humming noise from external speaker plugin at
codec D3 state.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/2692449396954c6c968f5b75e2660358@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -501,6 +501,7 @@ static void alc_shutup_pins(struct hda_c
 	struct alc_spec *spec = codec->spec;
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
 	case 0x10ec0298:


