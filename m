Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471C551A8BC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355683AbiEDRMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356724AbiEDRJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BA017061;
        Wed,  4 May 2022 09:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FA19B82792;
        Wed,  4 May 2022 16:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13695C385AF;
        Wed,  4 May 2022 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683325;
        bh=bU9zuv/XF1iwHuINloAyTAgfvnKnw2LCdg098a6ufOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWCQu1cfcR8acu1kJQWy4eII+4WBYXGY+ivBF4Cgt60PCfPkTyN9Tw/19Y7CL+ZB/
         2on0jCarHv8hnlgHqj2vQkJZlOCnuLJwXcor0+4qjMn17Ya/DB+RszziVVJkjig1BW
         uBG9r4gsckjm+3A52i352GZ9Pyzs73QD31q9HHtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.17 004/225] USB: quirks: add STRING quirk for VCOM device
Date:   Wed,  4 May 2022 18:44:02 +0200
Message-Id: <20220504153110.605085090@linuxfoundation.org>
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

commit ec547af8a9ea6441864bad34172676b5652ceb96 upstream.

This has been reported to stall if queried

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220414123152.1700-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -510,6 +510,9 @@ static const struct usb_device_id usb_qu
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VCOM device */
+	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 


