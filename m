Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC471334BB
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgAGU5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgAGU5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:57:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B8C2087F;
        Tue,  7 Jan 2020 20:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430640;
        bh=EG8mgsXvyYWllOTkobaif61wALGAf0iokGmfEznAR7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXxnHqlNNuOYDOMeYDgYGes1OKykc5XfdL3RP9rhHiUo3R9PEr6wHmvH9O7lkxd9w
         6HPo7gBIx71nd3OJ/dMgFG4mQqXTN61ptPUae4zqeczWC2kmey8OEKDt43sQY9UzWe
         EMfUwSoAYi5+Twd0FdmxeXgKt12RwWmlxFA+F3MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kupfer <michael.kupfer@fau.de>,
        Kay Friedrich <kay.friedrich@fau.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/191] staging/wlan-ng: add CRC32 dependency in Kconfig
Date:   Tue,  7 Jan 2020 21:52:35 +0100
Message-Id: <20200107205334.875765584@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kay Friedrich <kay.friedrich@fau.de>

[ Upstream commit 2740bd3351cd5a4351f458aabaa1c9b77de3867b ]

wlan-ng uses the function crc32_le,
but CRC32 wasn't a dependency of wlan-ng

Co-developed-by: Michael Kupfer <michael.kupfer@fau.de>
Signed-off-by: Michael Kupfer <michael.kupfer@fau.de>
Signed-off-by: Kay Friedrich <kay.friedrich@fau.de>
Link: https://lore.kernel.org/r/20191127112457.2301-1-kay.friedrich@fau.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wlan-ng/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kconfig
index ac136663fa8e..082c16a31616 100644
--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -4,6 +4,7 @@ config PRISM2_USB
 	depends on WLAN && USB && CFG80211
 	select WIRELESS_EXT
 	select WEXT_PRIV
+	select CRC32
 	help
 	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
 	  old USB wireless devices.
-- 
2.20.1



