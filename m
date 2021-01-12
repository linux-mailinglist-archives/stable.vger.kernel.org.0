Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAD02F30A9
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbhALNJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404940AbhALM6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5822312E;
        Tue, 12 Jan 2021 12:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456241;
        bh=VkNkgTi2TUVkMZ+ggYdJDBCHKp5UIzi6l98J9dZEacY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFvZmuGNgRfeorDx+JluQAC+VZqb9QjLkIMPLP302Vn8MXTAA1ffNJNxAaijT4wln
         eHdIR+kYg+aZUGpZMu4vtZn5LiFj+VQPcYkIzy3V5RqpNwKLsA/Ze7IeEr53A0YeAF
         hRh7nQubzBddCickO3zOxiGCu06ep8WibUR8cTwrnuYWrZWcivh/dF0CQiNyntIZis
         N+hYORH7bDkIVHajHLukqsw7LQ/pg+i7ho8hgPo9M2RW0f7oMexU0DvnmHEytP9hcH
         gxI+phrqzD7yPbuucnqNSXZv96rj81O7L7Va+JtL/ctfqck4630wkgidn+8p9qeic3
         x+n99y4leWFFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        kernel test robot <lkp@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/28] ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI
Date:   Tue, 12 Jan 2021 07:56:42 -0500
Message-Id: <20210112125645.70739-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

