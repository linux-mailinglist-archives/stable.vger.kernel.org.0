Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEAF4B4A89
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345903AbiBNKOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:14:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345907AbiBNKNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:13:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A558C6621F;
        Mon, 14 Feb 2022 01:52:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 030126130A;
        Mon, 14 Feb 2022 09:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE6FC340E9;
        Mon, 14 Feb 2022 09:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832333;
        bh=c2wwsVOne6O+20ubHYJ2YGXK3XI7T9P/J4u3/gJpya0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBMC/QkZIJEQPzBApyaH3gLAUqFM/btOXIR48RsQEFSW/GVWQ8rIAtMkrX9DBFPjD
         N0b2j+TUieOl1vPidoLi2oQ+e+BpHruTdIO8kRz5V49ApeeSoLZK+47FrhYNjF5JJ2
         Pk1cmaeORW+YOH79q/Z0BJFn/Q7vAu9+OCvhmg0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Russell <Scott.Russell2@ncr.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 153/172] USB: serial: cp210x: add CPI Bulk Coin Recycler id
Date:   Mon, 14 Feb 2022 10:26:51 +0100
Message-Id: <20220214092511.672938864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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

commit 6ca0c6283340d819bf9c7d8e76be33c9fbd903ab upstream.

Add the device id for the Crane Payment Innovation / Money Controls Bulk
Coin Recycler:

	https://www.cranepi.com/en/system/files/Support/OM_BCR_EN_V1-04_0.pdf

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
@@ -69,6 +69,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
 	{ USB_DEVICE(0x0FCF, 0x1006) }, /* Dynastream ANT development board */
 	{ USB_DEVICE(0x0FDE, 0xCA05) }, /* OWL Wireless Electricity Monitor CM-160 */
+	{ USB_DEVICE(0x106F, 0x0003) },	/* CPI / Money Controls Bulk Coin Recycler */
 	{ USB_DEVICE(0x10A6, 0xAA26) }, /* Knock-off DCU-11 cable */
 	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
 	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */


