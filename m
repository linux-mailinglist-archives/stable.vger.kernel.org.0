Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D564B4899
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiBNJ5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343830AbiBNJz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:55:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E816E4CF;
        Mon, 14 Feb 2022 01:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C666B80DBF;
        Mon, 14 Feb 2022 09:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35326C340E9;
        Mon, 14 Feb 2022 09:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831852;
        bh=Qsnz9ccqqnSbqJScjUDjP3cDoHTZNco1Ln3r5juL2eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXKig/Yeye2lHv9FVOBV4+G/y0XflgihUe1a5bkxBaBE2Mb9nJkSMxGK9aeDzcTR2
         YGfOVfb/LscgHFvtU3XZ34unca4ka0H63SWG4kkYZaYnRWvBsDpYn+jyYKc36B3D/f
         Ib4cqH8gqdVp5gzL/fma8vonhef2IaFEFkzSkJ2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Russell <Scott.Russell2@ncr.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 105/116] USB: serial: cp210x: add NCR Retail IO box id
Date:   Mon, 14 Feb 2022 10:26:44 +0100
Message-Id: <20220214092502.411332034@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b50f8f09c622297d3cf46e332e17ba8adedec9af upstream.

Add the device id for NCR's Retail IO box (CP2105) used in NCR FastLane
SelfServ Checkout - R6C:

	https://www.ncr.com/product-catalog/ncr-fastlane-selfserv-checkout-r6c

Reported-by: Scott Russell <Scott.Russell2@ncr.com>
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -55,6 +55,7 @@ static void cp210x_enable_event_mode(str
 static void cp210x_disable_event_mode(struct usb_serial_port *port);
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x0404, 0x034C) },	/* NCR Retail IO Box */
 	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */


