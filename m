Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B973CF7D0C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfKKSwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbfKKSwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:52:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50CEA21783;
        Mon, 11 Nov 2019 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498353;
        bh=LJRk4EOLTUilV+RqBlau/x9nZVjaKaVoCjCUsAW1XGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zej4HF/Ig7PJOd3r4DIpAcxtu2JY/Yt8Rs2T3QaAyUo/Vbm/0sR2zgKnosiGBIp0a
         lAL4iblJiVokHCHE/dpQOf2Qx9Lc+dmZJI3co4pLK6sPGfuJz/PZlKG6Et84mxfF6P
         KDpSz+H9eBB88ZINT2mQMCVPksa9kX8ixt9A48So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.3 068/193] intel_th: pci: Add Jasper Lake PCH support
Date:   Mon, 11 Nov 2019 19:27:30 +0100
Message-Id: <20191111181506.128559336@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 9d55499d8da49e9261e95a490f3fda41d955f505 upstream.

This adds support for Intel TH on Jasper Lake PCH.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191028070651.9770-8-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -214,6 +214,11 @@ static const struct pci_device_id intel_
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa0a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Jasper Lake PCH */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4da6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 


