Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6077132901D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbhCAUDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239573AbhCATwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8521C6518D;
        Mon,  1 Mar 2021 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621148;
        bh=/9EWwN4fsnpG9sXQdfRzP1iao39kMLN3OYxJujxeT2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7GhtN7PUuG5vdngPWZKtymkwseLoYoyLAf+ejfPQoS5lFG2ainVGzldXrFaaPKas
         X2muJTLpDp03KSOl9miNgJLL7SLTEsi9sziH7l3pid4JofunG44Xb8fV4Zjfp/LNr/
         3xrS6ggVRsW1LKzScP//uFsU9Fl5eIlyhBymWQuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 411/775] platform/x86: intel_pmt: Make INTEL_PMT_CLASS non-user-selectable
Date:   Mon,  1 Mar 2021 17:09:39 +0100
Message-Id: <20210301161221.899089398@linuxfoundation.org>
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

[ Upstream commit 35d8a973fe4d38afee944db636c3d2b1df3741a7 ]

Fix error in Kconfig that exposed INTEL_PMT_CLASS as a user selectable
option. It is already selected by INTEL_PMT_TELEMETRY and
INTEL_PMT_CRASHLOG which are user selectable.

Fixes: e2729113ce66 ("platform/x86: Intel PMT class driver")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20210126205508.30907-1-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 91e6176cdfbdf..af75c3342c061 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1369,7 +1369,7 @@ config INTEL_PMC_CORE
 		- MPHY/PLL gating status (Sunrisepoint PCH only)
 
 config INTEL_PMT_CLASS
-	tristate "Intel Platform Monitoring Technology (PMT) Class driver"
+	tristate
 	help
 	  The Intel Platform Monitoring Technology (PMT) class driver provides
 	  the basic sysfs interface and file hierarchy uses by PMT devices.
-- 
2.27.0



