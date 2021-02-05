Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D70311485
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhBEWHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232873AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D077565016;
        Fri,  5 Feb 2021 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534253;
        bh=JzE4fqFzWRvUhr3iAWBG1ID8KKIlOCPK6jHwzwzh0gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuJcjQtb8+TtzgybIuwPr46qVoKRTG2ymbhdLNPnLdc90gRaps5qyPLjxqATEeuoY
         JeeclWj2TV5GPxErjOTMTRJbLxkrPsSPnXh0zrOSU+EZXmvOCBx9/qieOLuqwczEVR
         S1Imxha8ugmFqci4M+3sPa49e5SJMUv96j4Cfmbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeannie Stevenson <jeanniestevenson@protonmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/57] platform/x86: thinkpad_acpi: Add P53/73 firmware to fan_quirk_table for dual fan control
Date:   Fri,  5 Feb 2021 15:07:10 +0100
Message-Id: <20210205140657.869909507@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeannie Stevenson <jeanniestevenson@protonmail.com>

[ Upstream commit 173aac2fef96972e42d33c0e1189e6f756a0d719 ]

This commit enables dual fan control for the new Lenovo P53 and P73
laptop models.

Signed-off-by: Jeannie Stevenson <jeanniestevenson@protonmail.com>
Link: https://lore.kernel.org/r/Pn_Xii4XYpQRFtgkf4PbNgieE89BAkHgLI1kWIq-zFudwh2A1DY5J_DJVHK06rMW_hGPHx_mPE33gd8mg9-8BxqJTaSC6hhPqAsfZlcNGH0=@protonmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index c404706379d92..69402758b99c3 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8782,6 +8782,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('N', '1', 'T', TPACPI_FAN_2CTL),	/* P71 */
 	TPACPI_Q_LNV3('N', '1', 'U', TPACPI_FAN_2CTL),	/* P51 */
 	TPACPI_Q_LNV3('N', '2', 'C', TPACPI_FAN_2CTL),	/* P52 / P72 */
+	TPACPI_Q_LNV3('N', '2', 'N', TPACPI_FAN_2CTL),	/* P53 / P73 */
 	TPACPI_Q_LNV3('N', '2', 'E', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (1st gen) */
 	TPACPI_Q_LNV3('N', '2', 'O', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (2nd gen) */
 	TPACPI_Q_LNV3('N', '2', 'V', TPACPI_FAN_2CTL),	/* P1 / X1 Extreme (3nd gen) */
-- 
2.27.0



