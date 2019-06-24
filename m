Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184F95073C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfFXKFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729989AbfFXKFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:48 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AA72145D;
        Mon, 24 Jun 2019 10:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370746;
        bh=VUru6ZPh216BdAHCYLYH+RFIWY6SIvlGVpx5BvcCHi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3ZDZUG63WzkZCfoo34Mwn1pGhB3nOf8+t+UM5IOxkmVH/cqH6lwhJAploQHhPIIC
         Ky4b+p5c1zqDYAK5Jn1NwUjk2UHBbYBWwqbWHWNNdpe8AB//+gKv5xEM8BQznG7VRO
         7cIDO5BhSDq9C6dYy+f0ItoZxJ1mMCpWJIv5X+XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 75/90] ARM: dts: dra76x: Update MMC2_HS200_MANUAL1 iodelay values
Date:   Mon, 24 Jun 2019 17:57:05 +0800
Message-Id: <20190624092318.900771558@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit c3c0b70cd3f801bded7a548198ee1c9851a0ca82 upstream.

Update the MMC2_HS200_MANUAL1 iodelay values to match with the latest
dra76x data manual[1]. The new iodelay values will have better marginality
and should prevent issues in corner cases.

Also this particular pinctrl-array is using spaces instead of tabs for
spacing between the values and the comments. Fix this as well.

[1] http://www.ti.com/lit/ds/symlink/dra76p.pdf

Cc: <stable@vger.kernel.org>
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
[tony@atomide.com: updated description with a bit more info]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra76x-mmc-iodelay.dtsi |   40 +++++++++++++++---------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/arch/arm/boot/dts/dra76x-mmc-iodelay.dtsi
+++ b/arch/arm/boot/dts/dra76x-mmc-iodelay.dtsi
@@ -22,7 +22,7 @@
  *
  * Datamanual Revisions:
  *
- * DRA76x Silicon Revision 1.0: SPRS993A, Revised July 2017
+ * DRA76x Silicon Revision 1.0: SPRS993E, Revised December 2018
  *
  */
 
@@ -169,25 +169,25 @@
 	/* Corresponds to MMC2_HS200_MANUAL1 in datamanual */
 	mmc2_iodelay_hs200_conf: mmc2_iodelay_hs200_conf {
 		pinctrl-pin-array = <
-			0x190 A_DELAY_PS(384) G_DELAY_PS(0)       /* CFG_GPMC_A19_OEN */
-			0x194 A_DELAY_PS(0) G_DELAY_PS(174)       /* CFG_GPMC_A19_OUT */
-			0x1a8 A_DELAY_PS(410) G_DELAY_PS(0)       /* CFG_GPMC_A20_OEN */
-			0x1ac A_DELAY_PS(85) G_DELAY_PS(0)        /* CFG_GPMC_A20_OUT */
-			0x1b4 A_DELAY_PS(468) G_DELAY_PS(0)       /* CFG_GPMC_A21_OEN */
-			0x1b8 A_DELAY_PS(139) G_DELAY_PS(0)       /* CFG_GPMC_A21_OUT */
-			0x1c0 A_DELAY_PS(676) G_DELAY_PS(0)       /* CFG_GPMC_A22_OEN */
-			0x1c4 A_DELAY_PS(69) G_DELAY_PS(0)        /* CFG_GPMC_A22_OUT */
-			0x1d0 A_DELAY_PS(1062) G_DELAY_PS(154)	  /* CFG_GPMC_A23_OUT */
-			0x1d8 A_DELAY_PS(640) G_DELAY_PS(0)       /* CFG_GPMC_A24_OEN */
-			0x1dc A_DELAY_PS(0) G_DELAY_PS(0)         /* CFG_GPMC_A24_OUT */
-			0x1e4 A_DELAY_PS(356) G_DELAY_PS(0)       /* CFG_GPMC_A25_OEN */
-			0x1e8 A_DELAY_PS(0) G_DELAY_PS(0)         /* CFG_GPMC_A25_OUT */
-			0x1f0 A_DELAY_PS(579) G_DELAY_PS(0)       /* CFG_GPMC_A26_OEN */
-			0x1f4 A_DELAY_PS(0) G_DELAY_PS(0)         /* CFG_GPMC_A26_OUT */
-			0x1fc A_DELAY_PS(435) G_DELAY_PS(0)       /* CFG_GPMC_A27_OEN */
-			0x200 A_DELAY_PS(36) G_DELAY_PS(0)        /* CFG_GPMC_A27_OUT */
-			0x364 A_DELAY_PS(759) G_DELAY_PS(0)       /* CFG_GPMC_CS1_OEN */
-			0x368 A_DELAY_PS(72) G_DELAY_PS(0)        /* CFG_GPMC_CS1_OUT */
+			0x190 A_DELAY_PS(384) G_DELAY_PS(0)	/* CFG_GPMC_A19_OEN */
+			0x194 A_DELAY_PS(350) G_DELAY_PS(174)	/* CFG_GPMC_A19_OUT */
+			0x1a8 A_DELAY_PS(410) G_DELAY_PS(0)	/* CFG_GPMC_A20_OEN */
+			0x1ac A_DELAY_PS(335) G_DELAY_PS(0)	/* CFG_GPMC_A20_OUT */
+			0x1b4 A_DELAY_PS(468) G_DELAY_PS(0)	/* CFG_GPMC_A21_OEN */
+			0x1b8 A_DELAY_PS(339) G_DELAY_PS(0)	/* CFG_GPMC_A21_OUT */
+			0x1c0 A_DELAY_PS(676) G_DELAY_PS(0)	/* CFG_GPMC_A22_OEN */
+			0x1c4 A_DELAY_PS(219) G_DELAY_PS(0)	/* CFG_GPMC_A22_OUT */
+			0x1d0 A_DELAY_PS(1062) G_DELAY_PS(154)	/* CFG_GPMC_A23_OUT */
+			0x1d8 A_DELAY_PS(640) G_DELAY_PS(0)	/* CFG_GPMC_A24_OEN */
+			0x1dc A_DELAY_PS(150) G_DELAY_PS(0)	/* CFG_GPMC_A24_OUT */
+			0x1e4 A_DELAY_PS(356) G_DELAY_PS(0)	/* CFG_GPMC_A25_OEN */
+			0x1e8 A_DELAY_PS(150) G_DELAY_PS(0)	/* CFG_GPMC_A25_OUT */
+			0x1f0 A_DELAY_PS(579) G_DELAY_PS(0)	/* CFG_GPMC_A26_OEN */
+			0x1f4 A_DELAY_PS(200) G_DELAY_PS(0)	/* CFG_GPMC_A26_OUT */
+			0x1fc A_DELAY_PS(435) G_DELAY_PS(0)	/* CFG_GPMC_A27_OEN */
+			0x200 A_DELAY_PS(236) G_DELAY_PS(0)	/* CFG_GPMC_A27_OUT */
+			0x364 A_DELAY_PS(759) G_DELAY_PS(0)	/* CFG_GPMC_CS1_OEN */
+			0x368 A_DELAY_PS(372) G_DELAY_PS(0)	/* CFG_GPMC_CS1_OUT */
 	      >;
 	};
 


