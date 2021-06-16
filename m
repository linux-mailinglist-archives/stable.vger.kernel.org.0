Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B633A9FE7
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhFPPmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235287AbhFPPj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE61613EC;
        Wed, 16 Jun 2021 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857833;
        bh=rUw7BP8oocyKNmIl1hMRQzzuNIHS6uWhK3wZKD7ChF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlUn8tbrbwlcYi6RaeN/XDwE+d8D0qOmrmJSW0DrUQfT17yVTlcAofX85HqrzQlut
         CmkW0sjlzACHzsuH9f2tYAWlMfACrNXLXsIrVUqr3NFXRObBPlE6Qm27YZjVGuD32N
         0SLalaYTCuKRqFDD9ZpW/mPndfgETpNoy6GNLu1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 24/48] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Wed, 16 Jun 2021 17:33:34 +0200
Message-Id: <20210616152837.413917260@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit a4b494099ad657f1cb85436d333cf38870ee95bc ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-gt683r.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
index 898871c8c768..29ccb0accfba 100644
--- a/drivers/hid/hid-gt683r.c
+++ b/drivers/hid/hid-gt683r.c
@@ -54,6 +54,7 @@ static const struct hid_device_id gt683r_led_id[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
 	{ }
 };
+MODULE_DEVICE_TABLE(hid, gt683r_led_id);
 
 static void gt683r_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
-- 
2.30.2



