Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECDE201126
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405114AbgFSPhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393751AbgFSPaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C752166E;
        Fri, 19 Jun 2020 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580645;
        bh=3InnyeHOfX2HAI/p9Sw6CicKSt7MLeeAttZJ9oB0KQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSi+w3nfriKAqeUCmGxxhVjCBQvGA4Ya1AbhttyotbzTtecFDKv5u6gp9KxMhIgO+
         IqcF52eYZgVFAOFRS+iR7sfI8gxeg4fO7oZtQQIFLTjgHROY1+ecJK6adpU3ujvZGH
         E9hKoVOnF0ae6YjnaLnhAzRhxDp95khbBKwRwWvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Monakov <amonakov@ispras.ru>,
        Borislav Petkov <bp@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.7 311/376] hwmon: (k10temp) Add AMD family 17h model 60h PCI match
Date:   Fri, 19 Jun 2020 16:33:49 +0200
Message-Id: <20200619141725.056898543@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Monakov <amonakov@ispras.ru>

commit 279f0b3a4b80660fba6faadc2ca2fa426bf3f7e9 upstream.

Add support for retrieving Tdie and Tctl on AMD Renoir (4000-series
Ryzen CPUs).

It appears SMU offsets for reading current/voltage and CCD temperature
have changed for this generation (reads from currently used offsets
yield zeros), so those features cannot be enabled so trivially.

Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.kernel.org/r/20200510204842.2603-3-amonakov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/k10temp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -632,6 +632,7 @@ static const struct pci_device_id k10tem
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M10H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M30H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M60H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_17H_M70H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}


