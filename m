Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92900177F9E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbgCCRvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbgCCRvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97B6920CC7;
        Tue,  3 Mar 2020 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257915;
        bh=ZX8ylstOYNYN8SRncwF592s0hK32DUaiDh/ok8GJDC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs1AOFYEIIOlPafL/Cnk/WlA0BqMrE7+NvzEpqSOKOZMes/bWlzm42aCAT9i9RyJs
         yfKcjAshpZprbdCTOCFZmCui/tRK3nOEhvTcIttVVBWNgjz1afrTt7WZtGnrtRvWqF
         VdSyZbP3TPJCGzBHh6kXOrhOIwa0nSMibE7Cu+n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.5 166/176] bus: tegra-aconnect: Remove PM_CLK dependency
Date:   Tue,  3 Mar 2020 18:43:50 +0100
Message-Id: <20200303174323.314385414@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit 2f56acf818a08a9187ac8ec6e3d994fc13dc368d upstream.

The ACONNECT bus driver does not use pm-clk interface anymore and hence
the dependency can be removed from its Kconfig option.

Fixes: 0d7dab926130 ("bus: tegra-aconnect: use devm_clk_*() helpers")
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -139,7 +139,6 @@ config TEGRA_ACONNECT
 	tristate "Tegra ACONNECT Bus Driver"
 	depends on ARCH_TEGRA_210_SOC
 	depends on OF && PM
-	select PM_CLK
 	help
 	  Driver for the Tegra ACONNECT bus which is used to interface with
 	  the devices inside the Audio Processing Engine (APE) for Tegra210.


