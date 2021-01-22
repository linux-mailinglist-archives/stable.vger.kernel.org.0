Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DE4300D16
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbhAVT6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbhAVONM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:13:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08C723A84;
        Fri, 22 Jan 2021 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324598;
        bh=gip9ZyvLhgxAIdzT6+teso3BL+gh4Xupaij8iQDYj40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uKX/YJ4hp9wiU5niHuvDs6fjYEDsqIXq/SFQimWda0Lh9UiiwObZw2pcInBIBYsR
         7hnAAPpu5Nz29z8UZU/9P6XGwTIrOZXbgXftPWs1bAyurC+hGvfffxyW8JPSNK8GPl
         vV1SNjHwleNQt6jnfKlJkIDKARpL+7U+VCKH7LJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/31] ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI
Date:   Fri, 22 Jan 2021 15:08:24 +0100
Message-Id: <20210122135732.287381163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
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
index 0bd0a9ad54556..719fb8b320fdc 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -604,6 +604,13 @@ static inline int acpi_device_modalias(struct device *dev,
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



