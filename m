Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA74329019
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbhCAUC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239522AbhCATwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E592864F4B;
        Mon,  1 Mar 2021 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621153;
        bh=U+RqvHVvXo3/3b0B0wob1bX46wI8TdA0/7EMZwnLZAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J44lAaQmpfHRvlDrQXZMpzXFtn4FkhDA94HyMJ4wlieFyw6yytm+Ngg7UYJVTjYhw
         dKuQrevezVJ5CRM6570eR/gbsmqZFlz7MPtvzJha/bKOdpLg4lZ8Ay1Sn3zt2ecJpq
         EIhRxg9kU/T1Lw1lZZtoSDirrU8HYX0Q6JGCKtQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 413/775] platform/x86: intel_pmt_crashlog: Add dependency on MFD_INTEL_PMT
Date:   Mon,  1 Mar 2021 17:09:41 +0100
Message-Id: <20210301161221.992370809@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit fdd3feb37e36bec2ad75d76f8ac4d0273c5c0a91 ]

All devices that expose Intel Platform Monitoring Technology (PMT)
crashlog are currently owned by the intel_pmt MFD driver. Therefore make
the crashlog driver depend on the MFD driver for build.

Fixes: 5ef9998c96b0 ("platform/x86: Intel PMT Crashlog capability driver")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20210126205508.30907-3-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 9948c5f4928d4..ac4125ec06603 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1394,6 +1394,7 @@ config INTEL_PMT_TELEMETRY
 
 config INTEL_PMT_CRASHLOG
 	tristate "Intel Platform Monitoring Technology (PMT) Crashlog driver"
+	depends on MFD_INTEL_PMT
 	select INTEL_PMT_CLASS
 	help
 	  The Intel Platform Monitoring Technology (PMT) crashlog driver provides
-- 
2.27.0



