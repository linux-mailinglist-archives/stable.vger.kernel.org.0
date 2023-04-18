Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322F56E627F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjDRMdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjDRMdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:33:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC73C161
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D096C6318A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E09C433EF;
        Tue, 18 Apr 2023 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821161;
        bh=45Z2sIyPYso/0Pe+ilbRjZ0rtqPtRogII/R61J9eVHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4WHrvf6xEAe1HXHj8vi0nadv37dVpYqhl7Qm1HZiw/rElT/QjkLrsjxUw0H3k9Rm
         q6SBj5KrRxmwZ4W6ohm7ShXe1Lc+F8/VOuFZ2mXA8jkFfqzLeldhLcOH6myPuxw2TG
         D7HjJ8SbNdmv3rPpsFWnIhze1S0Er0BNTWOvaXpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kees Jan Koster <kjkoster@kjkoster.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 021/124] USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs
Date:   Tue, 18 Apr 2023 14:20:40 +0200
Message-Id: <20230418120310.454222289@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -124,6 +124,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
 	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x82AA) }, /* Silicon Labs IFS-USB-DATACABLE used with Quint UPS */
 	{ USB_DEVICE(0x10C4, 0x82EF) }, /* CESINEL FALCO 6105 AC Power Supply */
 	{ USB_DEVICE(0x10C4, 0x82F1) }, /* CESINEL MEDCAL EFD Earth Fault Detector */
 	{ USB_DEVICE(0x10C4, 0x82F2) }, /* CESINEL MEDCAL ST Network Analyzer */


