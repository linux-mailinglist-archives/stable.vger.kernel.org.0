Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C874756805E
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiGFHno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiGFHnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:43:32 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1984C22BE8;
        Wed,  6 Jul 2022 00:43:29 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 432385C0132;
        Wed,  6 Jul 2022 03:43:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 06 Jul 2022 03:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1657093406; x=1657179806; bh=C8Ol7HlbSs
        HcVdmPmv1NQZMoUEj7huxgWIN9xp9FzFI=; b=GuE6c1TZYemO0dX2s5RiOS5LN7
        PnmiDwZiAiciKbeCFVpo/t+2DJKEya1ObWD7eVNWZyUrdJAyx0lJODfeYnq/aVFA
        1z3RStRk32byEWjbOx+pfJc07X9szRfmwOkrTSepCqKnZeCyzdmbpX6gGXlFStuE
        wGF1GEZQDRC9a127vK1inGG4uhFKqIuYST5IYTmiRtzGgUvIzeCozcJJOfyTJWXd
        9UPv4Br41CqPEHLpcRsImOF/9FDfQwDabKmIe9uMZ7p5sxEqEnOVKTAV25H7ZKQX
        2rjgA+aLMqzU9W0VTSsuQH5p9No9WzjXHC3N7cgEXWupHETtphY5m7xJF1Vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1657093406; x=1657179806; bh=C8Ol7HlbSsHcVdmPmv1NQZMoUEj7huxgWIN
        9xp9FzFI=; b=ZxYnFyhp2fiD0/iUPCX0jYN+8BIR4lo/Kh9a2GRL/YD03m+QspM
        54bc+tXiAP0IfVHOKDVIgzK+FjMxMLjxKsTwXgWIww1Br8gDNito3q/a/nGpN1D2
        sXSXyqBatzNHWDpnp9v22GKmHm/mXUdkIsPVu5RzugpBBjS2xdTPe9GwKaOAuvwI
        85tFpjytFXnUfCttrzOZ7/d0i1qUII365AgsGfZ+YrWJEq7hIWoiHkysOj4uuwXA
        /QdTvILAwsL9wX7Ky/eefviCmJyu/v+afdI/344uCBVLuZpTXG5sDK1HbrYxEYrm
        6zdH7j0hhLFIa49XfLlhDocLrp/QRRBIvqQ==
X-ME-Sender: <xms:Hj3FYn3JC3CE4ip_UIPzODZ7Gbui5CLZZ1xuOdPU96FLp4ghCLEbyw>
    <xme:Hj3FYmE0Pbm8Gvdxh1bPY-rHnFfAZi1w9fjsMyqTs1I44gbN3jcjIayP07zj5Ecfk
    YH3koRoFFPNugQLEds>
X-ME-Received: <xmr:Hj3FYn7L6jrp8kHlZ3JtK6JkHIPOnb2mtDQU7V05ND1zhPuJuT0L5MA71KOpfqkduw3CFN9I3J_7MV7QfpJPJRY1IB7icDznZu-kLWLGxxcypnXMag0F0JL8FEDFFVI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeivddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeforghthhgv
    ficuofgtuehrihguvgcuoehmrghtthesthhrrghvvghrshgvrdgtohhmrdgruheqnecugg
    ftrfgrthhtvghrnhepgfekteegudffgfdtvedvjeejffdtgffhteefgfeuhefhleejfffg
    feeuueejleffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepmhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghu
X-ME-Proxy: <xmx:Hj3FYs1E1yllmVdoB5dHCGjPW2PMEcTRj09et3gQxety6XtqS5krhA>
    <xmx:Hj3FYqE9uKduG_5ZW3_8mqLwZ0vIFPSaLRrsgxPY7hxYsoxPO3drAg>
    <xmx:Hj3FYt9_I-Cd9lhaeTBDGc6BFtULd9wO_IjT75Z4cMhHChVlXrH19g>
    <xmx:Hj3FYmBi4tKR7zIxaqiw0OoR6LUBLGPA4o7N8RkyOELlWwVs6SnMcw>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Jul 2022 03:43:23 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org
Subject: [PATCH] rtc: rx8025: fix 12/24 hour mode detection on RX-8035
Date:   Wed,  6 Jul 2022 07:42:36 +0000
Message-Id: <20220706074236.24011-1-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 12/24hr flag in the RX-8035 can be found in the hour register,
instead of the CTRL1 on the RX-8025. This was overlooked when
support for the RX-8035 was added, and was causing read errors when
the hour register 'overflowed'.

To deal with the relevant register not always being visible in
the relevant functions, determine the 12/24 mode at startup and
store it in the driver state.

Signed-off-by: Mathew McBride <matt@traverse.com.au>
Fixes: f120e2e33ac8 ("rtc: rx8025: implement RX-8035 support")
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-rx8025.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index b32117ccd74b..dde86f3e2a4b 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -55,6 +55,8 @@
 #define RX8025_BIT_CTRL2_XST	BIT(5)
 #define RX8025_BIT_CTRL2_VDET	BIT(6)
 
+#define RX8035_BIT_HOUR_1224	BIT(7)
+
 /* Clock precision adjustment */
 #define RX8025_ADJ_RESOLUTION	3050 /* in ppb */
 #define RX8025_ADJ_DATA_MAX	62
@@ -78,6 +80,7 @@ struct rx8025_data {
 	struct rtc_device *rtc;
 	enum rx_model model;
 	u8 ctrl1;
+	int is_24;
 };
 
 static s32 rx8025_read_reg(const struct i2c_client *client, u8 number)
@@ -226,7 +229,7 @@ static int rx8025_get_time(struct device *dev, struct rtc_time *dt)
 
 	dt->tm_sec = bcd2bin(date[RX8025_REG_SEC] & 0x7f);
 	dt->tm_min = bcd2bin(date[RX8025_REG_MIN] & 0x7f);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		dt->tm_hour = bcd2bin(date[RX8025_REG_HOUR] & 0x3f);
 	else
 		dt->tm_hour = bcd2bin(date[RX8025_REG_HOUR] & 0x1f) % 12
@@ -254,7 +257,7 @@ static int rx8025_set_time(struct device *dev, struct rtc_time *dt)
 	 */
 	date[RX8025_REG_SEC] = bin2bcd(dt->tm_sec);
 	date[RX8025_REG_MIN] = bin2bcd(dt->tm_min);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		date[RX8025_REG_HOUR] = bin2bcd(dt->tm_hour);
 	else
 		date[RX8025_REG_HOUR] = (dt->tm_hour >= 12 ? 0x20 : 0)
@@ -279,6 +282,7 @@ static int rx8025_init_client(struct i2c_client *client)
 	struct rx8025_data *rx8025 = i2c_get_clientdata(client);
 	u8 ctrl[2], ctrl2;
 	int need_clear = 0;
+	int hour_reg;
 	int err;
 
 	err = rx8025_read_regs(client, RX8025_REG_CTRL1, 2, ctrl);
@@ -303,6 +307,16 @@ static int rx8025_init_client(struct i2c_client *client)
 
 		err = rx8025_write_reg(client, RX8025_REG_CTRL2, ctrl2);
 	}
+
+	if (rx8025->model == model_rx_8035) {
+		/* In RX-8035, 12/24 flag is in the hour register */
+		hour_reg = rx8025_read_reg(client, RX8025_REG_HOUR);
+		if (hour_reg < 0)
+			return hour_reg;
+		rx8025->is_24 = (hour_reg & RX8035_BIT_HOUR_1224);
+	} else {
+		rx8025->is_24 = (ctrl[1] & RX8025_BIT_CTRL1_1224);
+	}
 out:
 	return err;
 }
@@ -329,7 +343,7 @@ static int rx8025_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	/* Hardware alarms precision is 1 minute! */
 	t->time.tm_sec = 0;
 	t->time.tm_min = bcd2bin(ald[0] & 0x7f);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		t->time.tm_hour = bcd2bin(ald[1] & 0x3f);
 	else
 		t->time.tm_hour = bcd2bin(ald[1] & 0x1f) % 12
@@ -350,7 +364,7 @@ static int rx8025_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	int err;
 
 	ald[0] = bin2bcd(t->time.tm_min);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
+	if (rx8025->is_24)
 		ald[1] = bin2bcd(t->time.tm_hour);
 	else
 		ald[1] = (t->time.tm_hour >= 12 ? 0x20 : 0)
-- 
2.30.1

