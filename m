Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AEB429177
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241711AbhJKOTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244081AbhJKOQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A127A611F2;
        Mon, 11 Oct 2021 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961163;
        bh=3hFgp+kX+/eHfQFTuImWKha9wPHDUb7GcK+93PNzg2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5b+9HmJbkNzE2iVRqsDezN7yOyCvwkgGLCbMuxDAvvlyn58vvocGKhTT3Oe2GAiN
         bNQFifi0fRUxSStagFEkOT4HpY50ZzaR6sBX+NjvyeVe+yYuxfwEdE7DQfcz6Q/I9A
         TK7oKMttUNTBMRd0XIPh6fSPinzqttSVXYkyxT4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/28] ptp_pch: Load module automatically if ID matches
Date:   Mon, 11 Oct 2021 15:47:07 +0200
Message-Id: <20211011134641.263101310@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7cd8b1542a7ba0720c5a0a85ed414a122015228b ]

The driver can't be loaded automatically because it misses
module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
call to the driver.

Fixes: 863d08ece9bf ("supports eg20t ptp clock")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_pch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 78ccf936d356..84feaa140f1b 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -695,6 +695,7 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	 },
 	{0}
 };
+MODULE_DEVICE_TABLE(pci, pch_ieee1588_pcidev_id);
 
 static struct pci_driver pch_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.33.0



