Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3491474616
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391268AbfGYFow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387927AbfGYFov (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:44:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96FC521880;
        Thu, 25 Jul 2019 05:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033491;
        bh=H0O5cm5UBcai8xG9md4SjBkoFGGKexpbFnby6BmK+gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wxni29MkeSUkI8weHw9XyszuwiAWyZRiKi7aQpg7PjKhbjikamr0Tu8zoZCQjKq3c
         NniehokKAi7M7mOggxmfNK9QArOzizb1wNbnfdDubLGMRDho0f9LBXWb4kikw/lPzo
         B+2NSasdXbqoPMr1supJMsGxfOoBPpY8brXNweVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 228/271] intel_th: pci: Add Ice Lake NNPI support
Date:   Wed, 24 Jul 2019 21:21:37 +0200
Message-Id: <20190724191714.702349682@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 4aa5aed2b6f267592705a526f57518a5d715b769 upstream.

This adds Ice Lake NNPI support to the Intel(R) Trace Hub.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190621161930.60785-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -170,6 +170,11 @@ static const struct pci_device_id intel_
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x02a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Ice Lake NNPI */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x45c5),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 


