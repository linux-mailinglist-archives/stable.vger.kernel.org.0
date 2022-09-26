Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953735EA2B4
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbiIZLND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbiIZLLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:11:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE792606B1;
        Mon, 26 Sep 2022 03:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA24C609FB;
        Mon, 26 Sep 2022 10:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F34C433C1;
        Mon, 26 Sep 2022 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188465;
        bh=tv52t3b1albqinSUtqZaK46JAGXXbMdaRMBXhRPrD48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WcWQG5aGVA0HXdafTwr8gBdq2+hinfZXyfJYSQ4eNo1ejF/nkR1Wfg0fw+jv9KXwt
         q2qQ/6WJzab6qeDRL2oQFAN0dy9z47lQJbj8ihSdBXMbaohp0ej6A3pdM0aksgEaHB
         8J5to5JwvZW2WnY7wSx8MbuV8whQ0zUOpmBFkK08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/148] staging: r8188eu: Add Rosewill USB-N150 Nano to device tables
Date:   Mon, 26 Sep 2022 12:10:38 +0200
Message-Id: <20220926100756.232593153@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit e01f5c8d6af231b3b09e23c1fe8a4057cdcc4e42 ]

This device is reported as using the RTL8188EUS chip.

It has the improbable USB ID of 0bda:ffef, which normally would belong
to Realtek, but this ID works for the reporter.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220814175027.2689-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/r8188eu/os_dep/usb_intf.c b/drivers/staging/r8188eu/os_dep/usb_intf.c
index b6c6fa72de44..640f1ca2d985 100644
--- a/drivers/staging/r8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/r8188eu/os_dep/usb_intf.c
@@ -30,6 +30,7 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 	/*=== Realtek demoboard ===*/
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8179)}, /* 8188EUS */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x0179)}, /* 8188ETV */
+	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill USB-N150 Nano */
 	/*=== Customer ID ===*/
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x07B8, 0x8179)}, /* Abocom - Abocom */
-- 
2.35.1



