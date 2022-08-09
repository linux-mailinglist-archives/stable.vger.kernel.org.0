Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5517858DDC1
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbiHISFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344603AbiHISEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:04:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C92826AFC;
        Tue,  9 Aug 2022 11:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E27AA6101C;
        Tue,  9 Aug 2022 18:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E76C433C1;
        Tue,  9 Aug 2022 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068133;
        bh=4JTwL98KeRAHBUUp0B3u8WDPwf7Kzfa2VOERamwCuU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fwvq8JA26x0VP3O59D0WiS1OK4QiyxqAHvXXix6vcEEATrt45gj3llY2io9jkho1P
         peFvceFAp9SSXqxgLe4SKMp2LV6me+C7GsV8UzsFv/Ukzs0Q/dNjhpW/4o48m7Za5j
         RHpBKuLAXDYnD24LzIqhD5LW8oRnI0Rjvo2c9Ft4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Mingzhi <whistler@member.fsf.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Yan Xinyu <sdlyyxy@bupt.edu.cn>
Subject: [PATCH 4.19 26/32] mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.
Date:   Tue,  9 Aug 2022 20:00:17 +0200
Message-Id: <20220809175513.910068873@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
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

From: Wei Mingzhi <whistler@member.fsf.org>

commit 829eea7c94e0bac804e65975639a2f2e5f147033 upstream.

USB device ID of some versions of XiaoDu WiFi Dongle is 2955:1003
instead of 2955:1001. Both are the same mt7601u hardware.

Signed-off-by: Wei Mingzhi <whistler@member.fsf.org>
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210618160840.305024-1-whistler@member.fsf.org
Cc: Yan Xinyu <sdlyyxy@bupt.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt7601u/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -34,6 +34,7 @@ static const struct usb_device_id mt7601
 	{ USB_DEVICE(0x2717, 0x4106) },
 	{ USB_DEVICE(0x2955, 0x0001) },
 	{ USB_DEVICE(0x2955, 0x1001) },
+	{ USB_DEVICE(0x2955, 0x1003) },
 	{ USB_DEVICE(0x2a5f, 0x1000) },
 	{ USB_DEVICE(0x7392, 0x7710) },
 	{ 0, }


