Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20C2681065
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbjA3ODH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbjA3OCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:02:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F35769C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4989CE16B6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808A1C433D2;
        Mon, 30 Jan 2023 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087355;
        bh=fjOyhShajLp4a1JURcndRsx8j6lSHjidPur9uMLOJEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZUBiOGDQeB0zGk9KFkMtLigAvyqYs/8ykdRrO3ZXye6E04bATyjouAArlDS3C+OY
         itdjFU1ZYU1aLlsavqCCSh+2VH+NbKRvNFXkFPefGxJhmotMozraXgrChZgoLPVn5v
         21d1pdeHUg3XpFvusoipoU0cvcPpnEpg0Svlduy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/313] r8152: add vendor/device ID pair for Microsoft Devkit
Date:   Mon, 30 Jan 2023 14:50:16 +0100
Message-Id: <20230130134345.121621502@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit be53771c87f4e322a9835d3faa9cd73a4ecdec5b ]

The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
machines, Microsoft uses a custom USB device ID.

Add the respective ID values to the driver. This makes Ethernet work on
the MS Devkit device. The chip has been visually confirmed to be a
RTL8153.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20230111133228.190801-1-andre.przywara@arm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a481a1d831e2..23da1d9dafd1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9836,6 +9836,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
-- 
2.39.0



