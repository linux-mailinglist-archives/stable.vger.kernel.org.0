Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104BD491A97
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352738AbiARDAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58426 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349736AbiARCuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C58B81132;
        Tue, 18 Jan 2022 02:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8684AC36AE3;
        Tue, 18 Jan 2022 02:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474207;
        bh=hX05DE8qEpcQDsWFeRFg+CgRqppCEqZHdVOmfan5VdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqavVZqmmCfFJ5jzljXN3/2sYEMFLTy8YVyv4D0itT89sGhehthCMFS8dsfcHgtxO
         6xgYB3OdCrRpN/d9DdOsLPOmtcmFiTbwQedTA6UfTa/AG+kk3UNQLnBpe4G5aDC9Dx
         6HLC6oT6MQwBvpt6oujVKH3Npp6FrZFMparkiNTXmik/m7k/25BJ1rEhfM0PzWb+yK
         RTxOqKob8WVG2wLQ3ewPacakgrK+h8P1ZUl84JnGlU30wNrNBkOvpVDvjYxxxhYXcV
         qMEPbMZD21B2emrGo/4LytX977Bxd8BFXOWXgsDQCIK3p6euT25w7AqiOlfmcQyVPO
         gD7KQpIerUf3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 22/56] usb: uhci: add aspeed ast2600 uhci support
Date:   Mon, 17 Jan 2022 21:48:34 -0500
Message-Id: <20220118024908.1953673-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Liu <neal_liu@aspeedtech.com>

[ Upstream commit 554abfe2eadec97d12c71d4a69da1518478f69eb ]

Enable ast2600 uhci quirks.

Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Link: https://lore.kernel.org/r/20211126100021.2331024-1-neal_liu@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/uhci-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index 6cb16d4b22578..4e91f7b21a796 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -113,7 +113,8 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 				num_ports);
 		}
 		if (of_device_is_compatible(np, "aspeed,ast2400-uhci") ||
-		    of_device_is_compatible(np, "aspeed,ast2500-uhci")) {
+		    of_device_is_compatible(np, "aspeed,ast2500-uhci") ||
+		    of_device_is_compatible(np, "aspeed,ast2600-uhci")) {
 			uhci->is_aspeed = 1;
 			dev_info(&pdev->dev,
 				 "Enabled Aspeed implementation workarounds\n");
-- 
2.34.1

