Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1C0329017
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242539AbhCAUCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239412AbhCATwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B676513D;
        Mon,  1 Mar 2021 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621150;
        bh=6MZ1QLjfi3khUaDKSbwAaCQT4J9pjD/NPIHmCnWkTxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=It0Y6ScEtEl6p5MDpBHYgw0yRbd9fU0JpvugJIGXJU+FSlYsSzEojWyxa15o+0lOo
         9/QRwSsbrxJ4zrQ8ocfcPjjl+v1lSxzaiIF6nsxszJaY8Ms2lSqj5fVcG9hnYQ5SEf
         aGAiBZFExBMugbBXqwDnsHbjqVysluE17hmuEJHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 412/775] platform/x86: intel_pmt_telemetry: Add dependency on MFD_INTEL_PMT
Date:   Mon,  1 Mar 2021 17:09:40 +0100
Message-Id: <20210301161221.948851872@linuxfoundation.org>
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

[ Upstream commit f3f6da5014dea3cc005b36948abe3664b5d1f7d3 ]

All devices that expose Intel Platform Monitoring Technology (PMT)
telemetry are currently owned by the intel_pmt MFD driver. Therefore make
the telemetry driver depend on the MFD driver for build.

Fixes: 68fe8e6e2c4b ("platform/x86: Intel PMT Telemetry capability driver")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20210126205508.30907-2-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index af75c3342c061..9948c5f4928d4 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1382,6 +1382,7 @@ config INTEL_PMT_CLASS
 
 config INTEL_PMT_TELEMETRY
 	tristate "Intel Platform Monitoring Technology (PMT) Telemetry driver"
+	depends on MFD_INTEL_PMT
 	select INTEL_PMT_CLASS
 	help
 	  The Intel Platform Monitory Technology (PMT) Telemetry driver provides
-- 
2.27.0



