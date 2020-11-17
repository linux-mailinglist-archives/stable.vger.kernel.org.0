Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87A2B63FF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733123AbgKQNnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387421AbgKQNmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A77206A5;
        Tue, 17 Nov 2020 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620542;
        bh=XONCNc+kiJcQmu1pa2kQmSO0UV5T3k2+PmC5CtMgIC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiTYtJBO3lvGiAVYfemO+3iSrffzQ6QzOpQFJOEKkgKekBHKh8Kyl98ah8HeECowR
         RO3Otpm7acCCxVLujHWv43r+0h8A8XxXGWySVt2+WwM+EVgm7xjpPoe/+Jg60nnff0
         Zj7Sb4H91hODtC43TAkbD5MyFFhuyg1jD8kY85Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 225/255] mmc: sdhci-of-esdhc: Handle pulse width detection erratum for more SoCs
Date:   Tue, 17 Nov 2020 14:06:05 +0100
Message-Id: <20201117122149.886817025@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

commit 71b053276a87ddfa40c8f236315d81543219bfb9 upstream.

Apply erratum workaround of unreliable pulse width detection to
more affected platforms (LX2160A Rev2.0 and LS1028A Rev1.0).

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Fixes: 48e304cc1970 ("mmc: sdhci-of-esdhc: workaround for unreliable pulse width detection")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201110071314.3868-1-yangbo.lu@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -1324,6 +1324,8 @@ static struct soc_device_attribute soc_f
 
 static struct soc_device_attribute soc_unreliable_pulse_detection[] = {
 	{ .family = "QorIQ LX2160A", .revision = "1.0", },
+	{ .family = "QorIQ LX2160A", .revision = "2.0", },
+	{ .family = "QorIQ LS1028A", .revision = "1.0", },
 	{ },
 };
 


