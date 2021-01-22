Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6134F30050F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbhAVOOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbhAVONI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:13:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8301123AAC;
        Fri, 22 Jan 2021 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324654;
        bh=wSiP5Yy3ak9NSXoHC+m4cI2NMDPxDip38q1+sFbQ5dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIijDS0dmOM2MM42x3j9moF5tmaNRhKKAwhliNHHjCjpiJQp5RBecgUsGg2G4UzV/
         W0/iqWEmKECqhT2OrsSJNCMRle5lK9SmpIdXlEjiS2cSAMMOS1yEtLpv+rTPOg3jIz
         DxNPs8vnVjVt3zvYZj70yNa2YdIt5uc0VgFCRzao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/35] ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI
Date:   Fri, 22 Jan 2021 15:10:15 +0100
Message-Id: <20210122135732.865260300@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit ee61cfd955a64a58ed35cbcfc54068fcbd486945 ]

It adds a stub acpi_create_platform_device() for !CONFIG_ACPI build, so
that caller doesn't have to deal with !CONFIG_ACPI build issue.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 5670bb9788bb4..192b045cc56ec 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -734,6 +734,13 @@ static inline int acpi_device_modalias(struct device *dev,
 	return -ENODEV;
 }
 
+static inline struct platform_device *
+acpi_create_platform_device(struct acpi_device *adev,
+			    struct property_entry *properties)
+{
+	return NULL;
+}
+
 static inline bool acpi_dma_supported(struct acpi_device *adev)
 {
 	return false;
-- 
2.27.0



