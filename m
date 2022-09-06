Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFBB5AECB9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiIFOHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239801AbiIFOFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:05:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D10844DF;
        Tue,  6 Sep 2022 06:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0169AB81633;
        Tue,  6 Sep 2022 13:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B8CC433D6;
        Tue,  6 Sep 2022 13:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471847;
        bh=uLG9Cljq5QbzkZ5LG9twJQ3INaQ4BvEigWOMbY0r4jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sn08AUO9JsEyDFePH+Cd2+4g5FaUB69R/MNC/mbyzbprFs/uk/wt2H+0ofz85C1UM
         wwAgwyoBLTpaieJ8P37gRy2hkFtkp3OhMBJKDQVuv1r6CiXqk4wp5e8G0r/F1layzd
         am7wgpvhf3gwZAzPZfk2IDQhADeFKspVa+DCS7MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        stable <stable@kernel.org>
Subject: [PATCH 5.19 059/155] staging: r8188eu: Add Rosewill USB-N150 Nano to device tables
Date:   Tue,  6 Sep 2022 15:30:07 +0200
Message-Id: <20220906132831.922251641@linuxfoundation.org>
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

From: Larry Finger <Larry.Finger@lwfinger.net>

commit e01f5c8d6af231b3b09e23c1fe8a4057cdcc4e42 upstream.

This device is reported as using the RTL8188EUS chip.

It has the improbable USB ID of 0bda:ffef, which normally would belong
to Realtek, but this ID works for the reporter.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220814175027.2689-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/r8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/r8188eu/os_dep/usb_intf.c
@@ -28,6 +28,7 @@ static struct usb_device_id rtw_usb_id_t
 	/*=== Realtek demoboard ===*/
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8179)}, /* 8188EUS */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0x0179)}, /* 8188ETV */
+	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill USB-N150 Nano */
 	/*=== Customer ID ===*/
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x07B8, 0x8179)}, /* Abocom - Abocom */


