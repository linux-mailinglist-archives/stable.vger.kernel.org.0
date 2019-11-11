Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88996F7BF2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKSlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbfKKSla (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:41:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF11C21925;
        Mon, 11 Nov 2019 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497689;
        bh=whj7LZBqF3gxyM5GfVvToA8R3A+JBFrbIyG1RZB1At4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtztTk0+Yq9ZIXF6eJXdbQZXUa2p533vXbF8uHx+bJZRqdLdLkSZQZDZnyjjQ7A+/
         gS12DdSTx0krfCAfFP8/MMDFzWYLMpbhLiwCXJpk9tfYu0D9VM4efdNIcOrXsGXhsZ
         bnheKjArsDXgqtsMI+C4S+NwRMMlAdSbbWU5XSuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 028/125] soundwire: depend on ACPI
Date:   Mon, 11 Nov 2019 19:27:47 +0100
Message-Id: <20191111181444.620454183@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

commit 52eb063d153ac310058fbaa91577a72c0e7a7169 upstream.

The device cannot be probed on !ACPI and gives this warning:

drivers/soundwire/slave.c:16:12: warning: ‘sdw_slave_add’ defined but
not used [-Wunused-function]
 static int sdw_slave_add(struct sdw_bus *bus,
            ^~~~~~~~~~~~~

Cc: stable@vger.kernel.org
Fixes: 7c3cd189b86d ("soundwire: Add Master registration")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/bd685232ea511251eeb9554172f1524eabf9a46e.1570097621.git.msuchanek@suse.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soundwire/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soundwire/Kconfig
+++ b/drivers/soundwire/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig SOUNDWIRE
 	tristate "SoundWire support"
+	depends on ACPI
 	help
 	  SoundWire is a 2-Pin interface with data and clock line ratified
 	  by the MIPI Alliance. SoundWire is used for transporting data


