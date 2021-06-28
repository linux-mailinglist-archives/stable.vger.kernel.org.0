Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7096F3B62EB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhF1OuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236324AbhF1OrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88D80619AD;
        Mon, 28 Jun 2021 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890996;
        bh=iX2oTkmqyn78O4KlibLV5yCnz9KKb3Q9Wkez32DsvKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dinbheqlHj30odVm6ruDJzShTkrOemOLK5W9JS0uHStpW1MpfRZuOUWIbFkmSgsEw
         cEzhStWrP0LuKa6vHFjTjA5tYuNicwUsAK+KQoPHAa1pXCXFj9OnhwFFvs9HIZ8PUh
         ufWeqvC1Bz05Xtd/Dsxsmpb9j4fLwqzmAanHVycsfEW9fvJhRnZL38qiPcfRVprOKg
         By3kwfJdnXosBtXu8nuV3jP9lSwJ9ySh7HpnfVEIEI+9664KyJ3Ny28/liMAeXUaOQ
         Ik3cNwTWsEIEbNFfso4Gxqqfguq+N95ff3j0A+S8y1lIGCaCh9Qo8tTyyW598hgZF3
         N71aLQ/qLBL1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/88] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Jun 2021 10:35:06 -0400
Message-Id: <20210628143628.33342-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index a298fbd8db6b..8ca4c1baeda8 100644
--- a/drivers/hid/hid-gt683r.c
+++ b/drivers/hid/hid-gt683r.c
@@ -64,6 +64,7 @@ static const struct hid_device_id gt683r_led_id[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
 	{ }
 };
+MODULE_DEVICE_TABLE(hid, gt683r_led_id);
 
 static void gt683r_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
-- 
2.30.2

