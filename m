Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86DE14E196
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgA3Spm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgA3Spm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB933205F4;
        Thu, 30 Jan 2020 18:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409941;
        bh=g5WpGPKoyfEqCm6F7JEqL0fGq3xpDnVGuTwzVQXbujM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbKtaDbXJAcmQDkkr+t3Lq2V+uupaMNSBDNleTFmq8w3oVLmu1+Gdjk3VEk6mreFr
         jzghaZAd01V3okxw81AJLfN0XdYenCTiH9zcCty8cTxNiM8Er+LvQ1LpgnkA1BLbIN
         eR4N3xRwOVqSuH+wFfZ4IyTnS393FH/4pOjEtgc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/110] ARM: OMAP2+: SmartReflex: add omap_sr_pdata definition
Date:   Thu, 30 Jan 2020 19:39:07 +0100
Message-Id: <20200130183624.887010789@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 2079fe6ea8cbd2fb2fbadba911f1eca6c362eb9b ]

The omap_sr_pdata is not declared but is exported, so add a
define for it to fix the following warning:

arch/arm/mach-omap2/pdata-quirks.c:609:36: warning: symbol 'omap_sr_pdata' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/power/smartreflex.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index d0b37e9370372..971c9264179ee 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -293,6 +293,9 @@ struct omap_sr_data {
 	struct voltagedomain		*voltdm;
 };
 
+
+extern struct omap_sr_data omap_sr_pdata[OMAP_SR_NR];
+
 #ifdef CONFIG_POWER_AVS_OMAP
 
 /* Smartreflex module enable/disable interface */
-- 
2.20.1



