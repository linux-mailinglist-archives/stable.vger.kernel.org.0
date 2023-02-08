Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D868F6AC
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBHSM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBHSM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:12:27 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074C9113EF;
        Wed,  8 Feb 2023 10:12:27 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 73E875C021A;
        Wed,  8 Feb 2023 13:12:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 08 Feb 2023 13:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1675879946; x=1675966346; bh=nd
        /fepMzplEvzx04p8GRke1eQ67RxmfpHP/YrFg9v68=; b=n7nIXDuRtwQ0q+bfio
        E79WP+QcPSnkAgZ7G82WuwM2xLTDelFyVcumMgK4Qz4tf58Ug6knf9RjB5LwzTPo
        g7s+KxtUDiUeNxDzvjDlFzxxdPlhRNH46JVr87p3jrwi2PFbLWSds1To5GYEYlk0
        mrXsvVUyAMtwI5GtU5Vdqrdx+wNcUgHyshtH0TvTq5+WsjjXF/McHlRQ8+8XSl77
        zhet3r408BaWVk0cj1lHqtKR42htsi9l0rGkxQ+4l8k6k0HL7TpLSljEQtnJNLRX
        3XZOtCZeLNw1WB+5NlJ3pJNx23Mtxftk3sYO8QBaczbIRYt+C2dSJvRtX0mC+yxE
        cPXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1675879946; x=1675966346; bh=nd/fepMzplEvz
        x04p8GRke1eQ67RxmfpHP/YrFg9v68=; b=rvOf4N75NwUQl9nAkBCje/aH8axbJ
        q6jiNW5PeCvf/R4UgV3aAp/xSDQwuf7bBB6tauJlCT1mWhXZg7zVsQ2YOmlX7t4X
        tY5djD2dKib8LpPO+eDyK/RnZNJj5MVIdM7nIfHuraAP2ah1hKKqpYu8BfESXcMw
        QIU9AEIkRByfNKKR1ncaKcaQqW9tUyQgwbVaFJxjj5bBs5SFW3Si0AOGitMdn3oe
        6MmB1oii1h3he9gUSHhiVEL65yzMhct+YfpMsEgnZnTP/F7K/9ga2/MMMkzfuctd
        AJvzoJqPzyX/nIDwi83o9AqCym88nyTRddCVbD5Pv9LA4a2++YH1KgEUQ==
X-ME-Sender: <xms:CubjY127a3SpntS4ABbhpOhNI_jfGWtjvfHKw6SU5U_nG0uUTP0UdQ>
    <xme:CubjY8Fw5gM13jBIGkg76YcMug6r3gy-9L2oaNJj2u7BGmZfdjLPnyG3rKY-0j3pM
    x_0Rbl4ayc4qLe8h4k>
X-ME-Received: <xmr:CubjY17At_mYsBdiWlR0oklDXDPgY4GGyqSsPJ9SFQED1VPSOLGIiDeingvpbH6D0YCTwkDnSnHhnV3FcPPT6lgPdqhNeXjqclNUxXFC6SUz6wjPfI73KgPR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goteeftdduqddtudculdduhedmnecujfgurhephffvvefufffkofgjfhgggfestdekredt
    redttdenucfhrhhomhepofgrrhhkucfrvggrrhhsohhnuceomhhpvggrrhhsohhnqdhlvg
    hnohhvohesshhquhgvsggsrdgtrgeqnecuggftrfgrthhtvghrnhepfedtvdejfeelffev
    hffgjeejheduteetieeguefgkefhhfegjeduueethefgvdffnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhhpvggrrhhsohhnqdhlvghnohhv
    ohesshhquhgvsggsrdgtrg
X-ME-Proxy: <xmx:CubjYy3InIldK5Yh3UccDKvd-HOj2djlu5iBi-r_Y7sbYrKw-XBSuw>
    <xmx:CubjY4FtWT8b3y9SyeYjkZiZF9NFhLC2CyOFW_ssMUG359PjcokXhw>
    <xmx:CubjYz8iSKNfVBgHwUKWVdIsMKskuEAzbhFrvq3TALPT9RiSZGqs7w>
    <xmx:CubjY8DwVNOLeqSvlQbo46xGh8NsgetFdnQlfNdZKwhYs3Nzk196DQ>
Feedback-ID: ibe194615:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Feb 2023 13:12:25 -0500 (EST)
From:   Mark Pearson <mpearson-lenovo@squebb.ca>
To:     mpearson-lenovo@squebb.ca
Cc:     linux-usb@vger.kernel.org, Miroslav Zatko <mzatko@mirexoft.com>,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Date:   Wed,  8 Feb 2023 13:12:23 -0500
Message-Id: <20230208181223.1092654-1-mpearson-lenovo@squebb.ca>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <mpearson-lenovo@squebb.ca>
References: <mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
doesn't work. If LPM is enabled the reader will provide an invalid
usb config descriptor. Added quirk to disable LPM.

Verified fix on Lenovo P16 G1 and T14 G3

Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
---
Changes in v3: Send correct update that should have been in v2
Changes in v2: Put entry in correct position in quirks list.

 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 079e183cf3bf..934b3d997702 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -526,6 +526,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
-- 
2.39.1

