Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7185A4F20
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiH2O0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 10:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiH2O0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 10:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8403C7EFCB;
        Mon, 29 Aug 2022 07:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F5AB810A1;
        Mon, 29 Aug 2022 14:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C11C433D6;
        Mon, 29 Aug 2022 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661783162;
        bh=9eUkVvrgSAAseCe5J1s4E5xEhEYSsVSGWWJ+TQD8XI0=;
        h=From:To:Cc:Subject:Date:From;
        b=fnbghB92BQX5Z6taA4jfSnowberbx9YEDGfWynLF2rlwKdzG02MJ7UVVH0y8Qy2Et
         G+As1QyMIDpxhPHoN9Fk4c9CdcX4U4ULcTBUH4BqAOMwsNm6ecmZsBppojc59ATuBl
         6QQ5pWBULvEHuspMe4AXD6bwlbQUX7eSoCJgtQR8l/GI6ZLjpjOZeGhemGpADOun9z
         Bj5Cp/WJJEtci+a7jRWXzDgucHkD3SWIxDf0RaTZz/SvTDF1UFtk94v1gJciaT1QnB
         H3FrqB6AXIVOuQNhZ0izi6dSff0rkeSlrp1bGaPNfz0pl5iDpQnpns04r5ZOV8bhqM
         pdKsUMn8+HnNg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oSfiM-00079t-LG; Mon, 29 Aug 2022 16:26:10 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Radisson97@web.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] USB: serial: cp210x: add Decagon UCA device id
Date:   Mon, 29 Aug 2022 16:25:50 +0200
Message-Id: <20220829142550.27505-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the device id for Decagon Devices USB Cable Adapter.

Link: https://lore.kernel.org/r/trinity-819f9db2-d3e1-40e9-a669-9c245817c046-1661523546680@msvc-mesg-web108
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index c374620a486f..a34957c4b64c 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -130,6 +130,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8414) }, /* Decagon USB Cable Adapter */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8470) }, /* Juniper Networks BX Series System Console */
-- 
2.35.1

