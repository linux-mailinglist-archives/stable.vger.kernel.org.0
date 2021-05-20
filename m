Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB0938A596
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhETKRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235148AbhETKPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE716199B;
        Thu, 20 May 2021 09:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503952;
        bh=q23ssMtB8bBnIb8DK7RYN7kVwq1I2EE5Z01P+8uSLvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMNb+Cw12IAyR00OydZT5fATw7KdeQsG0ujVvx5/J5U8lm6FT2r8XiY3inooVotJG
         cHUXAWy/yathilepPGoeOhzet7QOzNunUqKv9vEv6uH1LG33sL2aimCQ7d6Z/FyueI
         8KnBN1YMYiGcLNspq3eqyPQvzcPB+Gl2GRsZ/yvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 028/323] intel_th: pci: Add Rocket Lake CPU support
Date:   Thu, 20 May 2021 11:18:40 +0200
Message-Id: <20210520092121.076651950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 9f7f2a5e01ab4ee56b6d9c0572536fe5fd56e376 upstream.

This adds support for the Trace Hub in Rocket Lake CPUs.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org> # v4.14+
Link: https://lore.kernel.org/r/20210414171251.14672-7-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -248,6 +248,11 @@ static const struct pci_device_id intel_
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x1bcc),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Rocket Lake CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 


