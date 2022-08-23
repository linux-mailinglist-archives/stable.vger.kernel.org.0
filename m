Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632A359DC6D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355341AbiHWKjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355158AbiHWKh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B43A6C50;
        Tue, 23 Aug 2022 02:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB881B81C4E;
        Tue, 23 Aug 2022 09:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E27FC433C1;
        Tue, 23 Aug 2022 09:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245650;
        bh=suZdBRjpDXFWDEa7jpSVWd8gmAmyH/rauzQmD1kwnvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUbkabSoxxXdeArssyE7Ch5JJeBargAo44sCH6V5lyNH1aKX5hefwzC+6ljlOPWWl
         MvtM5mUfCSWdzNtQjdX6dVA/MYU5u6h6f59f+u5O+3LkkdJBGoZrF5d+xftdTy2NL6
         bk7GrKHm7CVXOBhlUfLGa2xlKj23M4wR9E7QENWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Borisov <dedsa2002@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/287] HID: alps: Declare U1_UNICORN_LEGACY support
Date:   Tue, 23 Aug 2022 10:25:07 +0200
Message-Id: <20220823080105.120210342@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Artem Borisov <dedsa2002@gmail.com>

[ Upstream commit 1117d182c5d72abd7eb8b7d5e7b8c3373181c3ab ]

U1_UNICORN_LEGACY id was added to the driver, but was not declared
in the device id table, making it impossible to use.

Fixes: 640e403 ("HID: alps: Add AUI1657 device ID")
Signed-off-by: Artem Borisov <dedsa2002@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 3eddd8f73b57..116ece4be2c9 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -835,6 +835,8 @@ static const struct hid_device_id alps_id[] = {
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1_DUAL) },
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1) },
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
+		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY) },
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_T4_BTNLESS) },
 	{ }
-- 
2.35.1



