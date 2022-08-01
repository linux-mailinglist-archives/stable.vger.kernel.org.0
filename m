Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1007586910
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiHAL4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiHALzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:55:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A5E474C5;
        Mon,  1 Aug 2022 04:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBF6AB81171;
        Mon,  1 Aug 2022 11:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455EFC433D7;
        Mon,  1 Aug 2022 11:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354682;
        bh=eO/ZtQD8LMvCR0OR1BCQ6/nXAd1L0wr32Z8IaAYC+4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VW5DIPg4I0dh3cLsV+7d5Ovyd4gW2YRCmQc4cxXBKvhiQR9RTmgcbXVrDHTeG7uq9
         7FXZv+MD8YnD4Tyku6Nj/vZaDZbz90p/yjdSUKXVB8ubdq4Lk3ub23ej/zH8vniv7E
         AY5uSs67a6sMaKCCil+bp/P6CRbHKbD2wO5S9UY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Mingzhi <whistler@member.fsf.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Yan Xinyu <sdlyyxy@bupt.edu.cn>
Subject: [PATCH 5.10 49/65] mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.
Date:   Mon,  1 Aug 2022 13:47:06 +0200
Message-Id: <20220801114135.766582370@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -26,6 +26,7 @@ static const struct usb_device_id mt7601
 	{ USB_DEVICE(0x2717, 0x4106) },
 	{ USB_DEVICE(0x2955, 0x0001) },
 	{ USB_DEVICE(0x2955, 0x1001) },
+	{ USB_DEVICE(0x2955, 0x1003) },
 	{ USB_DEVICE(0x2a5f, 0x1000) },
 	{ USB_DEVICE(0x7392, 0x7710) },
 	{ 0, }


