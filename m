Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C802FA9B1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390636AbhARTIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390529AbhARLjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99935229CA;
        Mon, 18 Jan 2021 11:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969941;
        bh=VkNkgTi2TUVkMZ+ggYdJDBCHKp5UIzi6l98J9dZEacY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sdo5PXInQ4bRtb9JlSBV/JRad0+KfCjYTjcweQe5M7wTId5ob0CKnI+O+/tbWMQiu
         f/KDrjffyQCXOG16wz9WKJmIydTY2D+aSwRkOcrojAAggVL2Y2z2vKqp+097MfFT0H
         oI3nZBhAOvxi9iUJ0ZMnph1yn1nl07YRPGWRCijE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/76] ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI
Date:   Mon, 18 Jan 2021 12:34:46 +0100
Message-Id: <20210118113343.187387489@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
index ce29a014e591c..dd6170357ec72 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -837,6 +837,13 @@ static inline int acpi_device_modalias(struct device *dev,
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



