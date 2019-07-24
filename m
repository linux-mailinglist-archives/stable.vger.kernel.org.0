Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4C73CD9
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388645AbfGXUMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391998AbfGXT5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1AF214AF;
        Wed, 24 Jul 2019 19:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998233;
        bh=qqWM4xerq2JWLgzBCdBVsA4X/c84rf+75c3uH+euxUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+KrdEOz/9GHKez9d2osA9QCrWfhmxqKlcHvZA77Foa4zWiv2/C44YfBZr169fcCu
         VHrHgqqKS8+V2TA5hE8w4xCIG8G8e54YnwiKYFOv0y0r5KE5ka4iYteOlRFXjkQrWM
         P1nrbls1xlTSWXi2rrVx/Fy6nt2wPScAj02E9KrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 291/371] ALSA: hda/hdmi - Remove duplicated define
Date:   Wed, 24 Jul 2019 21:20:43 +0200
Message-Id: <20190724191746.244219189@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit eb4177116bf568a413c544eca3f4446cb4064be9 upstream.

INTEL_GET_VENDOR_VERB is defined twice identically.
Let's remove a superfluous line.

Fixes: b0d8bc50b9f2 ("ALSA: hda: hdmi - add Icelake support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2431,7 +2431,6 @@ static void intel_haswell_fixup_connect_
 }
 
 #define INTEL_GET_VENDOR_VERB	0xf81
-#define INTEL_GET_VENDOR_VERB	0xf81
 #define INTEL_SET_VENDOR_VERB	0x781
 #define INTEL_EN_DP12		0x02	/* enable DP 1.2 features */
 #define INTEL_EN_ALL_PIN_CVTS	0x01	/* enable 2nd & 3rd pins and convertors */


