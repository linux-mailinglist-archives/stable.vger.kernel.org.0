Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8743A808
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 01:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhJYXR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 19:17:57 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:60818 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232664AbhJYXR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 19:17:57 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F0C8D40D6F;
        Mon, 25 Oct 2021 23:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1635203734; bh=EnXupqPwA5Q2pZBJt8IAoeR41osyVgghdi5Jb1sc4Mo=;
        h=Date:From:Subject:To:Cc:From;
        b=WyJKImh2Z6Q+i4F+auNP3URYwBE4DudqvSzQjS7MnQOW6zdbS9rJqeH1YJo04GqDs
         iX9jUzRZiNZHj+qjNbXt3PxA5DP+UDKSk+lIeWh0yPxpaRIxoZSuONiLgKdzsb2ZJY
         TuV1t+82o5zgb58xcgskUN5kuclX28hFsk42PcGAHXZ9EJCkZomNQB1NLbPpakfo1t
         VGMi8KayQTQL763gcFhwW+UcmL3230AEDKXp4Ted5PoP2y462d2VCGhCeWP5ZrOsQk
         ZugtAsHTbw/M1SP+zFmvlePYM1o1i/2DR4+AI96L71CnGMl60BJox7sPj1wyHCQgGY
         /L54ghgRuOrAA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 7634EA0096;
        Mon, 25 Oct 2021 23:15:32 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 25 Oct 2021 16:15:32 -0700
Date:   Mon, 25 Oct 2021 16:15:32 -0700
Message-Id: <1541737108266a97208ff827805be1f32852590c.1635202893.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: core: Revise GHWPARAMS9 offset
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During our predesign phase for DWC_usb32, the GHWPARAMS9 register offset
was 0xc680. We revised our final design, and the GHWPARAMS9 offset is
now moved to 0xc6e8 on release.

Cc: <stable@vger.kernel.org>
Fixes: 16710380d3aa ("usb: dwc3: Capture new capability register GHWPARAMS9")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 620c8d3914d7..5c491d0a19d7 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -143,7 +143,7 @@
 #define DWC3_GHWPARAMS8		0xc600
 #define DWC3_GUCTL3		0xc60c
 #define DWC3_GFLADJ		0xc630
-#define DWC3_GHWPARAMS9		0xc680
+#define DWC3_GHWPARAMS9		0xc6e0
 
 /* Device Registers */
 #define DWC3_DCFG		0xc700

base-commit: e8d6336d9d7198013a7b307107908242a7a53b23
-- 
2.28.0

