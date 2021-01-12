Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C9F2F305D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404158AbhALM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404107AbhALM5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E84D2311A;
        Tue, 12 Jan 2021 12:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456196;
        bh=mvaNFAlw7j4xFI4gIfaMQt/1iJxGTU0GW3H2ruuMEEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlUDvUbegh0ThDpng4zCntO6qtDK7pHi//ddz/O4flYiMnTeXS+eAj295ID0+w4Tj
         CSp0IdagBs7JrRlF5T3MEqUSz/67D0fsZUeEaPJQbk4NBBP+srjX+Zfr9inD54ZE6i
         ok1l+DaSkK9br6g2xh3u9Qo5JMpzJfrO3WFi70BD9M4TH3jOSLY+eO+JVr73JbERZK
         RRs21FfwGo/45Ap/US/nWNFCzAPB7x+MBaE4vfqsvJDnbo38lZk4RKCv65tJE1Gc7r
         E51MhoK5BTbriR094fr6doJNCWdctasI48lUEdzPxKaGGgkK9Fmrq4W2811d+01gu8
         LBaY62sNMOIgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Ajay Gupta <ajayg@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 46/51] usb: typec: Fix copy paste error for NVIDIA alt-mode description
Date:   Tue, 12 Jan 2021 07:55:28 -0500
Message-Id: <20210112125534.70280-46-sashal@kernel.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 41952a66015466c3208aac96b14ffd92e0943589 ]

The name of the module for the NVIDIA alt-mode is incorrect as it
looks to be a copy-paste error from the entry above, update it to
the correct typec_nvidia module name.

Cc: Ajay Gupta <ajayg@nvidia.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20210106001605.167917-1-pbrobinson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/altmodes/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/altmodes/Kconfig b/drivers/usb/typec/altmodes/Kconfig
index 187690fd1a5bd..60d375e9c3c7c 100644
--- a/drivers/usb/typec/altmodes/Kconfig
+++ b/drivers/usb/typec/altmodes/Kconfig
@@ -20,6 +20,6 @@ config TYPEC_NVIDIA_ALTMODE
 	  to enable support for VirtualLink devices with NVIDIA GPUs.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called typec_displayport.
+	  module will be called typec_nvidia.
 
 endmenu
-- 
2.27.0

