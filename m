Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0351A5F8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353679AbiEDQwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353622AbiEDQwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545774704B;
        Wed,  4 May 2022 09:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3FAF61786;
        Wed,  4 May 2022 16:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFB3C385A5;
        Wed,  4 May 2022 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682903;
        bh=MgNU/KErX9XYknk3zj2PDYvQIh2K7GS2hYAzr7pzkmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOgtY2MWMmMgijbus5AUO9zU7QSMfcG7fcFG4iQ1/hGXcxcVatp1q8XmzRFrs/176
         I3XTmAEkKAJVcBYbBCucl+5PJR42i+n3QNsY6rKi+OkMMIN4GauLjD8lPyf4V5RbVQ
         GB5Nxk6hW2njWo8KsXWyvmQ6nj7ahUjP3apdsNfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 09/84] USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader
Date:   Wed,  4 May 2022 18:43:50 +0200
Message-Id: <20220504152928.395537118@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruno Thomsen <bruno.thomsen@gmail.com>

commit 35a923a0b329c343e9e81d79518e2937eba06fcd upstream.

Wireless reading of water and heat meters using 868 MHz wM-Bus mode C1.

The two different product IDs allow detection of dongle antenna
solution:
- Internal antenna
- External antenna using SMA connector

https://www.kamstrup.com/en-en/water-solutions/water-meter-reading/usb-meter-reader

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Link: https://lore.kernel.org/r/20220414081202.5591-1-bruno.thomsen@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -195,6 +195,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
+	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */


