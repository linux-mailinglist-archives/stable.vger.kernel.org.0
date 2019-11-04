Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043B3EEF74
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbfKDV5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388650AbfKDV5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:48 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DC420659;
        Mon,  4 Nov 2019 21:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904667;
        bh=Wrj2WyIXcBmoMoV7uSeARcm4AvsIXTFlsWvCPMKuVqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQ4FIDGMQAocxX6FBCsqEkYYFSv5TjMRwbaLqmQRObHdEupqgoJCFAbBaZxBY8F3R
         J20rjVkewpmC95ZSGLdidpXcFvh2n5e9MkF6OSqBu1eoKGNsk8wHwbtFPKefR85QDM
         28xpcbHefIehCubWpbId+qSiUj/D8Qn4nPFpG+Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Alan Cox <alan@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Darren Hart <dvhart@infradead.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/149] platform/x86: Add the VLV ISP PCI ID to atomisp2_pm
Date:   Mon,  4 Nov 2019 22:43:40 +0100
Message-Id: <20191104212137.690358162@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 8a7d7141528ad67e465bc6afacc6a3144d1fe320 ]

If the ISP is exposed as a PCI device VLV machines need the
same treatment as CHV machines to power gate the ISP. Otherwise
s0ix will not work.

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Darren Hart <dvhart@infradead.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_atomisp2_pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_atomisp2_pm.c b/drivers/platform/x86/intel_atomisp2_pm.c
index 9371603a0ac90..4a2ec5eeb6d8a 100644
--- a/drivers/platform/x86/intel_atomisp2_pm.c
+++ b/drivers/platform/x86/intel_atomisp2_pm.c
@@ -99,6 +99,7 @@ static UNIVERSAL_DEV_PM_OPS(isp_pm_ops, isp_pci_suspend,
 			    isp_pci_resume, NULL);
 
 static const struct pci_device_id isp_id_table[] = {
+	{ PCI_VDEVICE(INTEL, 0x0f38), },
 	{ PCI_VDEVICE(INTEL, 0x22b8), },
 	{ 0, }
 };
-- 
2.20.1



