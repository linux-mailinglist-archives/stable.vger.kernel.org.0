Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF143C4FCF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbhGLH2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244099AbhGLH0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3141C61419;
        Mon, 12 Jul 2021 07:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074576;
        bh=yFRsu7/el9VAy3vECFtyMjZl9iQtJDhiAzWNQocLCjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvCvYY4ArHynqFCsv+WfIY1TO8pE1gB29+VhpxmoYOS3oqeP7Dq1rl/ixkisHGuTL
         LNpRQK2Vj15FxKFqbIAC1/CX5ZSJfGVpENMnn5Kj2eONsiVfNsSTryMVMRoYAu8GvQ
         DwQ+qD89cnBDQvSSosvWQDU5VLdw8eSBNkcUNkzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 583/700] mfd: mp2629: Select MFD_CORE to fix build error
Date:   Mon, 12 Jul 2021 08:11:06 +0200
Message-Id: <20210712061038.054887087@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a933272041d852a1ef1c85f0c18b93e9999a41fa ]

MFD_MP2629 should select MFD_CORE to a prevent build error:

ERROR: modpost: "devm_mfd_add_devices" [drivers/mfd/mp2629.ko] undefined!

Fixes: 06081646450e ("mfd: mp2629: Add support for mps battery charger")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b74efa469e90..8b421b21a232 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -465,6 +465,7 @@ config MFD_MP2629
 	tristate "Monolithic Power Systems MP2629 ADC and Battery charger"
 	depends on I2C
 	select REGMAP_I2C
+	select MFD_CORE
 	help
 	  Select this option to enable support for Monolithic Power Systems
 	  battery charger. This provides ADC, thermal and battery charger power
-- 
2.30.2



