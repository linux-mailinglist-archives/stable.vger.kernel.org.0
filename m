Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D0333E10
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhCJNZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233087AbhCJNYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8558764FE0;
        Wed, 10 Mar 2021 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382693;
        bh=x/jFaJIgH5S1cJH41HYPrcs/yMdxCs5fCM20YyMtRmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rsd21vH31bQRU7M8JRsYkRkPsAXWu2fpR9IYeG8lZn4Nf5W7ByH4HaF7Sb7wahYf
         rkSXt9Q8kQt65QvQ6YP9IP402BPBTRY/a3KvXsjhx/o+Odmhqphnin7JrQyGdAjj26
         CQgVcEw1ws6dPA5sN8910//ajTIOEOx6EqTQMGfg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/49] usb: cdns3: host: add xhci_plat_priv quirk XHCI_SKIP_PHY_INIT
Date:   Wed, 10 Mar 2021 14:23:37 +0100
Message-Id: <20210310132322.774525608@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 68ed3f3d8a057bd34254e885a6306fedc0936e50 ]

cdns3 manages PHY by own DRD driver, so skip the management by
HCD core.

Reviewed-by: Jun Li <jun.li@nxp.com>
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/host.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/cdns3/host.c b/drivers/usb/cdns3/host.c
index de8da737fa25..f84739327a16 100644
--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -24,6 +24,7 @@
 #define LPM_2_STB_SWITCH_EN	BIT(25)
 
 static const struct xhci_plat_priv xhci_plat_cdns3_xhci = {
+	.quirks = XHCI_SKIP_PHY_INIT,
 	.suspend_quirk = xhci_cdns3_suspend_quirk,
 };
 
-- 
2.30.1



