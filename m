Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D64E51A8B6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355907AbiEDRL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356703AbiEDRJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD85C140DC;
        Wed,  4 May 2022 09:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE9C461896;
        Wed,  4 May 2022 16:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC18C385A5;
        Wed,  4 May 2022 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683324;
        bh=0ADtk7N5G3X2CP8D5RX9L+TI3ddYO/GrfFJQis71W10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvAE/oZhW2xKbxMPskJIXKAkcCrQuTwek/P6JmTaGpxwTh3VI49O3MWUT91BguwU6
         K7x5hG4QYKw/5EAdcrXDLDClIG/6ypv4DHutHHDJSdCd+iV+dcOSwgmhU0X+4GSHHw
         MfRaR3yEDY6zHGedat6Hhx2N4a3112gci0LHQDOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.17 003/225] USB: quirks: add a Realtek card reader
Date:   Wed,  4 May 2022 18:44:01 +0200
Message-Id: <20220504153110.485302901@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 2a7ccf6bb6f147f64c025ad68f4255d8e1e0ce6d upstream.

This device is reported to stall when enummerated.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220414110209.30924-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -404,6 +404,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Realtek Semiconductor Corp. Mass Storage Device (Multicard Reader)*/
+	{ USB_DEVICE(0x0bda, 0x0151), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Realtek hub in Dell WD19 (Type-C) */
 	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
 


