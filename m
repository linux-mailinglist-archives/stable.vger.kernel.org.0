Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D780AC158B
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfI2OBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730101AbfI2OBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F7132086A;
        Sun, 29 Sep 2019 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765711;
        bh=oSbyScY3JG+rW4fllK50xPf1ze1Tix7f6EevJu/txV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuqGKQ4nnTb2lvrIoYdZHzrevay2oKmTphSMqIgrmqZcXrAOXLIL45LG0MHdqIO1W
         8Y6cr2012ATINsv1KSwVol17qQ98aIyEaZaXcy6RhjdnWx3XFQ51HYM3jzWeVLL0U1
         /LeymJXlhdaJk4/cay5bxsH4RxvyqkyYsuUgHADc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Pshonkin <sudokamikaze@protonmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 23/45] ALSA: usb-audio: Add Hiby device family to quirks for native DSD support
Date:   Sun, 29 Sep 2019 15:55:51 +0200
Message-Id: <20190929135030.979849347@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Pshonkin <sudokamikaze@protonmail.com>

commit 029d2c0fd61eac74700fb4ffff36fc63bfff7e5e upstream.

This patch adds quirk VID ID for Hiby portable players family with
native DSD playback support.

Signed-off-by: Ilya Pshonkin <sudokamikaze@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190917074937.157802-1-ilya.pshonkin@netforce.ua
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1655,6 +1655,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case 0x152a:  /* Thesycon devices */
 	case 0x25ce:  /* Mytek devices */
 	case 0x2ab6:  /* T+A devices */
+	case 0xc502:  /* HiBy devices */
 		if (fp->dsd_raw)
 			return SNDRV_PCM_FMTBIT_DSD_U32_BE;
 		break;


