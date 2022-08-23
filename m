Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE92F59D80B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350307AbiHWJ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349783AbiHWJ1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7865C760E7;
        Tue, 23 Aug 2022 01:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A26076152E;
        Tue, 23 Aug 2022 08:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979BDC433C1;
        Tue, 23 Aug 2022 08:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243835;
        bh=4JTwL98KeRAHBUUp0B3u8WDPwf7Kzfa2VOERamwCuU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0E+/HMfdmDvobDZIMR0Y5LdtAU9Uh012AKy6JBimdWzNvT0HPq+OQorp1WX3KutsF
         94he/bVrWmzp5/PzNuGcmahtbZ8OdVrCjX+TPjsiHstNPCqOR9moAHNC7L19XPEHsC
         l/8ukHLExzA/rzpme1R0rGeAw5KaEOSobSCWisuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Mingzhi <whistler@member.fsf.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Yan Xinyu <sdlyyxy@bupt.edu.cn>
Subject: [PATCH 4.14 009/229] mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.
Date:   Tue, 23 Aug 2022 10:22:50 +0200
Message-Id: <20220823080053.679929709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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


