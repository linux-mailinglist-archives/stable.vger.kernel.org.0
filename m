Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE36C5EA27C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiIZLJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237330AbiIZLHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1E6501BB;
        Mon, 26 Sep 2022 03:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E2CA60A36;
        Mon, 26 Sep 2022 10:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F4C433C1;
        Mon, 26 Sep 2022 10:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188461;
        bh=eVgz4bZHN8/KVxEkyjxtbv1XswLwXeYlsnHRAdQIHuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTELJo7hmABcpo05bRkvyeymVRvsyO39JpdpnS0zx9LMYGZMdejdzbXfxwUrXOVrv
         RZIW5/xVQMFG5vmZnrsTzAWMTmqsskjq2ty4LDH+tMuvBC5SHZuh3DVZ48DVkfgxnK
         mLcj2Sb9Iw/WoItlxfuVfc7CDjXMdC7tm6R+/9js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Candy Febriyanto <cfebriyanto@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/148] staging: r8188eu: Remove support for devices with 8188FU chipset (0bda:f179)
Date:   Mon, 26 Sep 2022 12:10:37 +0200
Message-Id: <20220926100756.195167614@linuxfoundation.org>
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

From: Candy Febriyanto <cfebriyanto@gmail.com>

[ Upstream commit 6723b283c44a3fdf9f922ae9788aab38bd909211 ]

The new r8188eu driver doesn't actually support devices with vendor ID 0bda
and product ID f179[0][1][2], remove the ID so owners of these devices
don't have to blacklist the staging driver.

[0] https://github.com/lwfinger/rtl8188eu/issues/366#issuecomment-888511731
[1] https://github.com/lwfinger/rtl8188eu/issues/385
[2] https://github.com/lwfinger/rtl8188eu/issues/385#issuecomment-973013539

Cc: Larry Finger <Larry.Finger@lwfinger.net>
CC: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Candy Febriyanto <cfebriyanto@gmail.com>
Link: https://lore.kernel.org/r/YZaBTq9vlMaJDFz2@mainframe.localdomain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e01f5c8d6af2 ("staging: r8188eu: Add Rosewill USB-N150 Nano to device tables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/os_dep/usb_intf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/r8188eu/os_dep/usb_intf.c b/drivers/staging/r8188eu/os_dep/usb_intf.c
index bb85ab77fd26..b6c6fa72de44 100644
--- a/drivers/staging/r8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/r8188eu/os_dep/usb_intf.c
@@ -30,7 +30,6 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 	/*=== Realtek demoboard ===*/
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8179)}, /* 8188EUS */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x0179)}, /* 8188ETV */
-	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xf179)}, /* 8188FU */
 	/*=== Customer ID ===*/
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x07B8, 0x8179)}, /* Abocom - Abocom */
-- 
2.35.1



