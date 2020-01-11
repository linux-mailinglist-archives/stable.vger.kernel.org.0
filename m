Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D68137FE0
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgAKKX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730850AbgAKKX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:57 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF6D205F4;
        Sat, 11 Jan 2020 10:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738236;
        bh=zKTBkj+dms4Z/T6nHnFDicQS7r9JXyUG8csVj+Gi90c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CezUM83UskxEAUl2+jzcnHoURjBdaVS6TYDDO6sbWlp4ps1ok2JJAluIqp3LMXsHA
         yPgYz0Izx++xOW1c66QzHVARxZ5hcIF4fIdIVbkmBOHx+VjiJ04iijxb1RyJaA0OmT
         t7ZUCBwbOJqAf0nuX//KKcFEo+mCy3UwT92SPV3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/165] ARM: dts: am335x-sancloud-bbe: fix phy mode
Date:   Sat, 11 Jan 2020 10:49:28 +0100
Message-Id: <20200111094925.508283640@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit c842b8c4ff9859f750447f3ca08f64b2ed23cebc ]

The phy mode should be rgmii-id.  For some reason, it used to work with
rgmii-txid but doesn't any more.

Signed-off-by: Mans Rullgard <mans@mansr.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-sancloud-bbe.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-sancloud-bbe.dts b/arch/arm/boot/dts/am335x-sancloud-bbe.dts
index 8678e6e35493..e5fdb7abb0d5 100644
--- a/arch/arm/boot/dts/am335x-sancloud-bbe.dts
+++ b/arch/arm/boot/dts/am335x-sancloud-bbe.dts
@@ -108,7 +108,7 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii-txid";
+	phy-mode = "rgmii-id";
 };
 
 &i2c0 {
-- 
2.20.1



