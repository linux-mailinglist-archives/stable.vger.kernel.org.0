Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1B13A4EA
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgANKDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbgANKDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41A8124672;
        Tue, 14 Jan 2020 10:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996211;
        bh=KO1LMfSNYFhXb5SrAcMNc2bgMl7s6FqsGaDUJVVkP9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v01bQkLS1IHnsXp7jevzbOkqzbzcJep5MZ31PkJuRwEj6xx58S0Y4+2VOYUwIQeqY
         6d+PXzl+Y/jja2xwBVxdut193rl/zOsHHO2eODKemqQOKhzeoXA3ehx2U2j8dQAs+w
         GMZeHmu3eDMSmNM937R7eRQMK5TMj+arNFCePX0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 07/78] ALSA: hda/realtek - Set EAPD control to default for ALC222
Date:   Tue, 14 Jan 2020 11:00:41 +0100
Message-Id: <20200114094353.565937062@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 9194a1ebbc56d7006835e2b4cacad301201fb832 upstream.

Set EAPD control to verb control.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -412,6 +412,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0672:
 		alc_update_coef_idx(codec, 0xd, 0, 1<<14); /* EAPD Ctrl */
 		break;
+	case 0x10ec0222:
 	case 0x10ec0623:
 		alc_update_coef_idx(codec, 0x19, 1<<13, 0);
 		break;


