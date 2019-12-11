Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B1C11B47B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732946AbfLKPsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732708AbfLKPZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64479222C4;
        Wed, 11 Dec 2019 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077944;
        bh=DmWcfohSP5XuUcgyaV8I3EcWyxysVv3CmIaRpnEl+SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTZfNTvIr9B+m2jcSwjvnPdMru+ATIrDOnJyCU654P/Rf0qLZsLzyepRae+7xc0cr
         oDNuEcgsSn+O1fLcgDAMwYHkh1Btl3itSgr7C7wBG1xf031Yiozm+721KeUhZtzMqQ
         zXnZn5K5XeAFRRpmbPlbP82VZtejevuAF6W+heIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Brack <fb@ltec.ch>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/243] ARM: dts: am335x-pdu001: Fix polarity of card detection input
Date:   Wed, 11 Dec 2019 16:05:55 +0100
Message-Id: <20191211150352.200993376@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Brack <fb@ltec.ch>

[ Upstream commit 5760367298a37c459ef0b1364463d70fd9a1f972 ]

When a micro SD card is inserted in the PDU001 card cage, the card
detection switch is opened and the corresponding GPIO input is driven
by a pull-up. Hence change the active level of the card detection
input from low to high.

Signed-off-by: Felix Brack <fb@ltec.ch>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-pdu001.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-pdu001.dts b/arch/arm/boot/dts/am335x-pdu001.dts
index 34fb63ef420f5..f56798efddff3 100644
--- a/arch/arm/boot/dts/am335x-pdu001.dts
+++ b/arch/arm/boot/dts/am335x-pdu001.dts
@@ -577,7 +577,7 @@
 	bus-width = <4>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc2_pins>;
-	cd-gpios = <&gpio2 2 GPIO_ACTIVE_LOW>;
+	cd-gpios = <&gpio2 2 GPIO_ACTIVE_HIGH>;
 };
 
 &sham {
-- 
2.20.1



