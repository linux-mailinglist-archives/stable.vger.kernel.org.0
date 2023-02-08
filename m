Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D7468F3C8
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 17:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBHQup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 11:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjBHQuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 11:50:44 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18294DE1B;
        Wed,  8 Feb 2023 08:50:40 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D596532009B7;
        Wed,  8 Feb 2023 11:50:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 08 Feb 2023 11:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1675875039; x=1675961439; bh=ap
        //zp0VFEjpX7hb/pheanYORggpENVks5SI1lFBnOE=; b=xG8g+hKV/g30MeXiRi
        4ORF3oe/zm5Atbh5HuoluArfYLS0zY7uZsdROlI9prwMtMwJGO/Nvb9oLxoA7OvK
        Bu2yEtNv9LWVsMYlVdpneKicgr09Z+acMO8SqJoAFmih6L1Ax88uOyCATuNuqALK
        /TfEfA7h6xnb/0ziI6yNkxqRtnm4wnmSaNSo1IK16cpX0PMD4KigJy+nxYAjhoys
        EaXkc/v3umqivk48Oz/Kag0sTQzJb2bQvQA6QjSZg3E+K8O6dOjmeSoif0E6ZZAd
        Xh+gsVAqFGjLqBTsEDXZKfmDYvauCUvr9Z9vHiy0iRug3OTDWtMzC0Vo9QT5bDMd
        38iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1675875039; x=1675961439; bh=ap//zp0VFEjpX
        7hb/pheanYORggpENVks5SI1lFBnOE=; b=WVkZjRJI0pMHFCy3b/QFAn/+7qtwo
        hiXmVMom6fThhNfSRa+3AaQdFNJ/+5dZS6n/HEcwMKjqKWMg8czOyJRzLV22QZZm
        R8d1aumAXykAEFNKMb2WF0ndF89uKRKPWRC1PUO2xPBsUYr48pqDiq27mWRB2oyI
        gmKfpAlI53tzJIM1N2PWh2L3Xe5Pkxqk5ABFk+nowNbQn+PQ1MmdTAqG41CONnUN
        QVZkBDhqkCRk8wDbYSChRfHI6Btl1ylcsPr+HOhG6JXGr5YEKsb20yFuH8Bqt47V
        DpYsLu/Oso0Ok4QO5KXUyq3g0HeFmV6LbCTlyUD9szx/BvNlVN7r8z63Q==
X-ME-Sender: <xms:39LjYwHb9kNvpcMkMKvxAM24wjeAVEGScbFQs49M-EjdGu-KZXFn_A>
    <xme:39LjY5VBwMOKdyMNQOph0A-GoAQnCVjpG1U36B2sng4vxifDQ5w5B-iHdYFhyGU21
    zfRbh6xqeKcb-885oI>
X-ME-Received: <xmr:39LjY6IihLaCWoXhq0c9ANF0KQY84SVqHO7wSRZhtW4R2O7rxfBfNYDdvuXkzIGCkTjqDpbBXnylJGq3YTKjjFtCC5RiF3jdAA3IJVANV2pXwIhlPoMTWydn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goteeftdduqddtudculdduhedmnecujfgurhephffvvefufffkofgjfhgggfestdekredt
    redttdenucfhrhhomhepofgrrhhkucfrvggrrhhsohhnuceomhhpvggrrhhsohhnqdhlvg
    hnohhvohesshhquhgvsggsrdgtrgeqnecuggftrfgrthhtvghrnhepfedtvdejfeelffev
    hffgjeejheduteetieeguefgkefhhfegjeduueethefgvdffnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhhpvggrrhhsohhnqdhlvghnohhv
    ohesshhquhgvsggsrdgtrg
X-ME-Proxy: <xmx:39LjYyG3mxv32MzZ1sa4ncBz-t8H9ZtT6gXaM3e-C3YyWJmXMxJHAQ>
    <xmx:39LjY2VjhFTU6Tx6czrRscTmGgsAo76STB62Zsor1yfp9-2I9MvLrQ>
    <xmx:39LjY1OsraXyan-4A0aLok54vyEDT6puUpnnfN5AwhM2WjQ9NZAacg>
    <xmx:39LjY1QpEpR28HSw4WuyBA2IMBjOV35YF_389KBwKQLlcbbgDWUIIA>
Feedback-ID: ibe194615:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Feb 2023 11:50:38 -0500 (EST)
From:   Mark Pearson <mpearson-lenovo@squebb.ca>
To:     mpearson-lenovo@squebb.ca
Cc:     linux-usb@vger.kernel.org, Miroslav Zatko <mzatko@mirexoft.com>,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Date:   Wed,  8 Feb 2023 11:50:18 -0500
Message-Id: <20230208165018.1088701-1-mpearson-lenovo@squebb.ca>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <mpearson-lenovo@squebb.ca>
References: <mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Changes in v2: Put entry in correct position in quirks list.

 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 079e183cf3bf..9b1c56646ac5 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -535,6 +535,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.39.1

