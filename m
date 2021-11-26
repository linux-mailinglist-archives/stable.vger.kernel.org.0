Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A4A45E502
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358241AbhKZCiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245046AbhKZCgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:36:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C002611C5;
        Fri, 26 Nov 2021 02:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893951;
        bh=3ZuQ7agRVfGGOLhnu0lAQFOlD6OrifS9UMyh1KpBFJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8NJSFmB9BbVyklppqCXJltvij5C4k/t00Q/Uv3vwist3q/HxfjMoj1wGwlLRpXXF
         o+UmliVNNBWoVZsUtK9ORXjI1vf3oPAwG590UzD4GQqHo6b3jP0BruHLwBzaqc+Dl7
         hhDpuK56PNPPHVAw2LKDDZl+piXgA6ABviB+5Ka8rdZlOSftnZfVlEu1jWpDmpkSPj
         sxo2X2+IDcyo+i5yUCsluw8eAfZU5CwUDiFi+cqe0dXLBKNBZC9DQjOvYSIK+sxT30
         aaS2K5qlTqTJHfM6T+mpMeyW8aYvZc50k+0dUF9fjc5fz8Xn9vxbZjeyWo9K+uq7+B
         2x3khZhtEhw5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jimmy Wang <jimmy221b@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/39] platform/x86: thinkpad_acpi: Add support for dual fan control
Date:   Thu, 25 Nov 2021 21:31:33 -0500
Message-Id: <20211126023156.441292-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Wang <jimmy221b@163.com>

[ Upstream commit 1f338954a5fbe21eb22b4223141e31f2a26366d5 ]

   This adds dual fan control for P1 / X1 Extreme Gen4

Signed-off-by: Jimmy Wang <jimmy221b@163.com>
Link: https://lore.kernel.org/r/20211105090528.39677-1-jimmy221b@163.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 27595aba214d9..6aa31816159cf 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8853,6 +8853,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('N', '2', 'E', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (1st gen) */
 	TPACPI_Q_LNV3('N', '2', 'O', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (2nd gen) */
 	TPACPI_Q_LNV3('N', '2', 'V', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (3nd gen) */
+	TPACPI_Q_LNV3('N', '4', '0', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (4nd gen) */
 	TPACPI_Q_LNV3('N', '3', '0', TPACPI_FAN_2CTL),	/* P15 (1st gen) / P15v (1st gen) */
 	TPACPI_Q_LNV3('N', '3', '2', TPACPI_FAN_2CTL),	/* X1 Carbon (9th gen) */
 };
-- 
2.33.0

