Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2055AEB90
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbiIFOKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241403AbiIFOJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:09:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5236E86B6D;
        Tue,  6 Sep 2022 06:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D024B818E1;
        Tue,  6 Sep 2022 13:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E635CC433C1;
        Tue,  6 Sep 2022 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472005;
        bh=U0qsK8SxRCTrLsb8Jih3HYgPeYD34y5sNOWFiYeUkks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkwE8X2oK1hCc4paIdc+Zp/VD60ubfboNANKqGIsguu4dhFcclm3JMZIgk2MrMSSV
         2F2aQUr8qDxAKqqnljbqbHf3RaBQcb5ka84IIGtBEHDXVipGbv7lgKTfTseH4Nrtlj
         82O9pGwuUyB5/G6rU91kEndaLqJ7dCKr9iIgjOXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.19 115/155] USB: serial: cp210x: add Decagon UCA device id
Date:   Tue,  6 Sep 2022 15:31:03 +0200
Message-Id: <20220906132834.313039078@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johan Hovold <johan@kernel.org>

commit ceb4038472a4803e7046ed488b03d11551991514 upstream.

Add the device id for Decagon Devices USB Cable Adapter.

Link: https://lore.kernel.org/r/trinity-819f9db2-d3e1-40e9-a669-9c245817c046-1661523546680@msvc-mesg-web108
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -130,6 +130,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8414) }, /* Decagon USB Cable Adapter */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8470) }, /* Juniper Networks BX Series System Console */


