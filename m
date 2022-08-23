Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363AA59D3BD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbiHWIL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbiHWIK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E3C658D;
        Tue, 23 Aug 2022 01:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F91B611A8;
        Tue, 23 Aug 2022 08:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B63C433D6;
        Tue, 23 Aug 2022 08:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242027;
        bh=bkzWdmz2JVM+wLTXYPbUAq4Q+S3Ie5HmYb7fg2zOyJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfzBlHnZTuMBetB2+4MDNQuJFWwUsHAdBjsQBO7wEA4nfGTL4/TdDnnjgg6ErRP2L
         uWvHQRPE3xXIsC78KGmQlgpg170ZhrUL/1z5yaG2jb2ZBkKcsjGxBD71wtGLxHPudF
         ex1os4UQd07SHe7dv8o+8eV/3d2eLsVlGrSN1h7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Mingzhi <whistler@member.fsf.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Yan Xinyu <sdlyyxy@bupt.edu.cn>
Subject: [PATCH 4.9 008/101] mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.
Date:   Tue, 23 Aug 2022 10:02:41 +0200
Message-Id: <20220823080034.914913887@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -34,6 +34,7 @@ static struct usb_device_id mt7601u_devi
 	{ USB_DEVICE(0x2717, 0x4106) },
 	{ USB_DEVICE(0x2955, 0x0001) },
 	{ USB_DEVICE(0x2955, 0x1001) },
+	{ USB_DEVICE(0x2955, 0x1003) },
 	{ USB_DEVICE(0x2a5f, 0x1000) },
 	{ USB_DEVICE(0x7392, 0x7710) },
 	{ 0, }


