Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA41419178
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfEIS5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfEISyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A7BE2177E;
        Thu,  9 May 2019 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428064;
        bh=OP280kuGSMjRSEKfqeYczZixuEf3EDUGnZF1DlEt8Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJhS9TcY/ogg/1tWQHugKxY+5IS8vXMhnJMGgmRZRibsR9ESoihX6pEFDi1LHRd+w
         pxmphEbSXfNCOlQstyVDFwpq2a2q/WHT7d/KEN/N5ODWG4lrnKiliYnjSZs/PGanir
         PoOMRRnoJwglaOBLjwgabvuk1UadNuFcdu2H8PH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 5.1 13/30] intel_th: pci: Add Comet Lake support
Date:   Thu,  9 May 2019 20:42:45 +0200
Message-Id: <20190509181253.549420902@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit e60e9a4b231a20a199d7a61caadc48693c30d695 upstream.

This adds support for Intel TH on Comet Lake.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -165,6 +165,11 @@ static const struct pci_device_id intel_
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x34a6),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
+	{
+		/* Comet Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x02a6),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
 	{ 0 },
 };
 


