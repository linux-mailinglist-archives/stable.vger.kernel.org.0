Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5E3D5E9E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbhGZPLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236499AbhGZPJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B2560F51;
        Mon, 26 Jul 2021 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314581;
        bh=qvM0yYNL8q3J19oHR2x8OxnAyfO7cTAeFwbNUv4zl3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/sNV4DReCLjAg2P1AhV35nre7nDANEEZgz63826ztonOX0TJdWyEGKJJiMuHxPIx
         +66QaBk+LNYX0ke6PwmpCaZtg0d2v2F/ve1L0OF+B86FujPkMc2jX8RCdIdn6E+B/E
         /9qfWzTgN49utOgFg8WvaKhCchfN2/8ZUoMddIr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/120] rtc: mxc_v2: add missing MODULE_DEVICE_TABLE
Date:   Mon, 26 Jul 2021 17:37:49 +0200
Message-Id: <20210726153832.915435548@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 206e04ec7539e7bfdde9aa79a7cde656c9eb308e ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210508031509.53735-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mxc_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-mxc_v2.c b/drivers/rtc/rtc-mxc_v2.c
index 007879a5042d..45c7366b7286 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -395,6 +395,7 @@ static const struct of_device_id mxc_ids[] = {
 	{ .compatible = "fsl,imx53-rtc", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mxc_ids);
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
-- 
2.30.2



