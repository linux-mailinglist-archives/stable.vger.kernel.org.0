Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D4D6E61A5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjDRM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjDRMZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:25:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F2FB472
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C976E630FD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1126C433EF;
        Tue, 18 Apr 2023 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820744;
        bh=7cN3HYCw3m1iHVR5xnin62O9z4avQMyfpaPtkqvNJvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sn32GcM112IpCP7eY6Rpgzu6KOUqagAITVVwYF6XR+twoFZJBJE3wub9V+bu5M4nf
         Aa9vhXscOQpzXagi+Sv13PXtqCBEnG9FK2FDhFX8mx3IgnKcy5p0wkgwkqPi1ym9Fi
         rTF9dqPFIBlRCY5t3XQ2jdYrTGEYnJuaGAat6yOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kees Jan Koster <kjkoster@kjkoster.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 15/57] USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs
Date:   Tue, 18 Apr 2023 14:21:15 +0200
Message-Id: <20230418120259.253334909@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Jan Koster <kjkoster@kjkoster.org>

commit 71f8afa2b66e356f435b6141b4a9ccf953e18356 upstream.

The Silicon Labs IFS-USB-DATACABLE is used in conjunction with for example
the Quint UPSes. It is used to enable Modbus communication with the UPS to
query configuration, power and battery status.

Signed-off-by: Kees Jan Koster <kjkoster@kjkoster.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -121,6 +121,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
 	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x82AA) }, /* Silicon Labs IFS-USB-DATACABLE used with Quint UPS */
 	{ USB_DEVICE(0x10C4, 0x82EF) }, /* CESINEL FALCO 6105 AC Power Supply */
 	{ USB_DEVICE(0x10C4, 0x82F1) }, /* CESINEL MEDCAL EFD Earth Fault Detector */
 	{ USB_DEVICE(0x10C4, 0x82F2) }, /* CESINEL MEDCAL ST Network Analyzer */


