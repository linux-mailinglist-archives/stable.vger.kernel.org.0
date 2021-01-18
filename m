Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1D2FAA1D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437328AbhART1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:27:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390430AbhARLiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B4122CF6;
        Mon, 18 Jan 2021 11:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969845;
        bh=kH6n2pMmgkZJ0ua89HOGXyqDJ56t0QQxQPc3Ad0jmCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLph9kuLRPZ3+HdmIajxxJdMByitWAH003puiIuvPR/vLXn5iqed+FxChgYEpnYEX
         90UxAmIC8Hse8bmhNDBuEYatZDmj6aUdrZFyxRv5s+SjiqX+sXQ5wd+LTRIcxcvn4Y
         Yg2PuEvW8d2QrCvqnPgABYcbKdeM6JR9uPbyM9Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/43] ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI
Date:   Mon, 18 Jan 2021 12:34:45 +0100
Message-Id: <20210118113336.021370608@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
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
index cd412817654fa..019468f072b7d 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -812,6 +812,13 @@ static inline int acpi_device_modalias(struct device *dev,
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



