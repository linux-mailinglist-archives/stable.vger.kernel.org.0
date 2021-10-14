Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3008642DC95
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhJNPAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhJNO7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D530611CB;
        Thu, 14 Oct 2021 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223422;
        bh=1DUwpTvvYyteT9BAC5Sh80m4OUR2xkI6J4wX1OVdvs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aV3r1sMH26LaJ/RXWSsk6AzGIiKi4yu1dpoI8vCVSsySf9a+wiv53jWelCfwxR+U1
         5YDcVLgJsfpgpkw7V7fGt5zDjH4nb0rXK2+BOA8Unsapw2+R6lCJu2HikmWxQHk8fY
         OaE/W91yI3Tjd6rCgulyrUzrzPYVwDFn4/2zp5eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/33] ptp_pch: Load module automatically if ID matches
Date:   Thu, 14 Oct 2021 16:53:48 +0200
Message-Id: <20211014145209.322262973@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
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
index b3285175f20f..8461d7f92d31 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -698,6 +698,7 @@ static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	 },
 	{0}
 };
+MODULE_DEVICE_TABLE(pci, pch_ieee1588_pcidev_id);
 
 static struct pci_driver pch_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.33.0



