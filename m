Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EE44B4651
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243749AbiBNJdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:33:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243936AbiBNJd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:33:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64962BF7C;
        Mon, 14 Feb 2022 01:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21A72B80DC9;
        Mon, 14 Feb 2022 09:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327F1C340F1;
        Mon, 14 Feb 2022 09:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831128;
        bh=RA1ihH4o+p/0O+GwVfq3zFPzcw3UMJyaeNiAp/qhKdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELVWXbqfUo+yCFB7FeTC0ew7oyBK3FQq5hy2JNnl3+9vwSXe10L0XFaEvuPp2+VQV
         fxkuC+QCpxs8Kw1INGRsk+q31cMWCo4EgUksffUiPyi1SPJxKGr/DnqKOPcMtNrkZc
         C//BNOQ1PhZMl5IkfN8/JhyZKuB50BPkByqi7KzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Russell <Scott.Russell2@ncr.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 40/44] USB: serial: cp210x: add NCR Retail IO box id
Date:   Mon, 14 Feb 2022 10:26:03 +0100
Message-Id: <20220214092449.199474522@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
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
@@ -55,6 +55,7 @@ static int cp210x_port_remove(struct usb
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x0404, 0x034C) },	/* NCR Retail IO Box */
 	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */


