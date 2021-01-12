Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA182F30F9
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbhALNOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404134AbhALM5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01D842333F;
        Tue, 12 Jan 2021 12:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456198;
        bh=GpGKIO4tQCy1zOqgKR1fzPxUY3aL5Ty6GVYzAwGKvzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqtGwM/VUczviEAt+a7L2BHkwW9ulW3FmqJmEQzOVDtZPEZF2X3wbmE84fcSvZVF7
         p/bSFsNp8kaatTetnGeXRMoTrqxHFGHwgoDP0UveBN+I3jkjL76nvpamehaUd6fSYM
         8Bszl87nFmX/mRaE8ZUNushAkaTj5QC+C+CUhrAn+pUP7QqSafHnC9L/ymorlZnOF6
         KOJTvcYa+QowAzflA0OaF10cTzkFE9Vs6WBTeZ0Yl4rt3F7FN+63yUSQB9gR/jpe5s
         05zQa2nPYCk/3PPB+kAJaaQlzqEj3pxPxsYVLPdcnp4doRxsbeavuZS6yFnybhJ+n2
         HGqFG7zDBkDhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        kernel test robot <lkp@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 48/51] ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI
Date:   Tue, 12 Jan 2021 07:55:30 -0500
Message-Id: <20210112125534.70280-48-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
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
index 39263c6b52e1a..5b1dc1ad4fb32 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -885,6 +885,13 @@ static inline int acpi_device_modalias(struct device *dev,
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

