Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96F353CEE9
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345008AbiFCRs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345384AbiFCRsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D5E541B5;
        Fri,  3 Jun 2022 10:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03FE460A24;
        Fri,  3 Jun 2022 17:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12289C385A9;
        Fri,  3 Jun 2022 17:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278321;
        bh=+w66Ow9xeA7Z0WMgKSy5y2U7WP4p9tUaCId1oFEUwl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ob8X5VSh0Kk9LMm4OgVaNf599adh4+GHlV69H+Jfacfcx/Xs6GYZxsYd+g9+1xoDh
         lFYy950V7gJo2z1YpRbjsNg0YsV+6criF2SS+uPKogNKk8ieFrueCcaBBBzXRE33JG
         +KF9yY3bVr1HMu7NUMYWwiRaMM9Ta0NFYJMTjs+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Maslanka <mm@semihalf.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 28/34] HID: multitouch: Add support for Google Whiskers Touchpad
Date:   Fri,  3 Jun 2022 19:43:24 +0200
Message-Id: <20220603173817.000712172@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
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

From: Marek Maślanka <mm@semihalf.com>

commit 1d07cef7fd7599450b3d03e1915efc2a96e1f03f upstream.

The Google Whiskers touchpad does not work properly with the default
multitouch configuration. Instead, use the same configuration as Google
Rose.

Signed-off-by: Marek Maslanka <mm@semihalf.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2158,6 +2158,9 @@ static const struct hid_device_id mt_dev
 	{ .driver_data = MT_CLS_GOOGLE,
 		HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY, USB_VENDOR_ID_GOOGLE,
 			USB_DEVICE_ID_GOOGLE_TOUCH_ROSE) },
+	{ .driver_data = MT_CLS_GOOGLE,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8, USB_VENDOR_ID_GOOGLE,
+			USB_DEVICE_ID_GOOGLE_WHISKERS) },
 
 	/* Generic MT device */
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },


