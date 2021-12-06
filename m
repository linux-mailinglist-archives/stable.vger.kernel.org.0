Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2FD469D4E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344008AbhLFP3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58936 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380145AbhLFPZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B34CB81132;
        Mon,  6 Dec 2021 15:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4F8C341C2;
        Mon,  6 Dec 2021 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804100;
        bh=3ZuQ7agRVfGGOLhnu0lAQFOlD6OrifS9UMyh1KpBFJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icLUUz0Yis2CC1SI9mo4I5p6TXVG1QtvByIMOvdvehBzBXoy1umvvBjpCU3qvXB+D
         GLyUoJq2gJak2fc1IQUs4GWWQ9OrM1EHOISIqVUzxD8tm47XgXGS18UWMxmxjIEsg3
         UT/3e9kI8G1Jnf2Ae4xAtvdIZeqV3LN8qiFbMb44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Wang <jimmy221b@163.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/207] platform/x86: thinkpad_acpi: Add support for dual fan control
Date:   Mon,  6 Dec 2021 15:54:40 +0100
Message-Id: <20211206145611.110329716@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



