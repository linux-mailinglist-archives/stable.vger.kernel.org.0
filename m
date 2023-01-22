Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30234676F28
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjAVPSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjAVPSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:18:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17119A5C6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A4360C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD55CC433EF;
        Sun, 22 Jan 2023 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400697;
        bh=fQA7eDfceYmFIOTvN/gbYSXqhpGvmXgYZyJpDkV92Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BK99/Xl1F4RjVZH6eMcp8evlmq6AUDVvEVI/Czn9fzr2COY9CfprGiJDrwvyTbWCR
         Zd6CFWku2KzTEOoobL9daiWeVkdK3iPjnnB7Rd4dSeyc9wMwcVhSN7MhEzU4ow+W+W
         YxvwdHkuc0d3+l/oeXV3wfV6Fvb1Fx+CBxMtQI7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Adler <michael.adler@siemens.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 075/117] USB: serial: cp210x: add SCALANCE LPE-9000 device id
Date:   Sun, 22 Jan 2023 16:04:25 +0100
Message-Id: <20230122150235.914790273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Adler <michael.adler@siemens.com>

commit 3f9e76e31704a325170e5aec2243c8d084d74854 upstream.

Add the USB serial console device ID for Siemens SCALANCE LPE-9000
which have a USB port for their serial console.

Signed-off-by: Michael Adler <michael.adler@siemens.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -60,6 +60,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
+	{ USB_DEVICE(0x0908, 0x0070) }, /* Siemens SCALANCE LPE-9000 USB Serial Console */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
 	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */


