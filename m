Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC712147E7A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389446AbgAXKJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:09:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389613AbgAXKJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:09:24 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79DA320709;
        Fri, 24 Jan 2020 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860563;
        bh=W+g4RWPxBysTaAJRlR6u2/CrxkupBVTisvp39ikA+e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/zkOAs33reewMQlgh8gDdrseoatwKaqOod55U7uvlfLkNt6XsvRITZDyszVNe1mw
         4f9Ci51cHrcY/Ls6/BTUyJ4h68ZtHLgWyXxIafYlKbSP/hXa5/eijf+M0/zVhqqgjQ
         PB/+2DHeBQ732TF+6PTrgx1n2oFtMVHdonL90hbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/639] ARM: dts: at91: nattis: make the SD-card slot work
Date:   Fri, 24 Jan 2020 10:23:10 +0100
Message-Id: <20200124093049.736770488@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit f52eb2067929d533babe106fbc131c88db3eff3d ]

The cd-gpios signal is assumed active-low by the driver, and the
cd-inverted property is needed if it is, in fact, active-high. Fix
this oversight.

Fixes: 0e4323899973 ("ARM: dts: at91: add devicetree for the Axentia Nattis with Natte power")
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-nattis-2-natte-2.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/at91-nattis-2-natte-2.dts b/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
index bfa5815a07214..4308a07b792ea 100644
--- a/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
+++ b/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
@@ -221,6 +221,7 @@
 		reg = <0>;
 		bus-width = <4>;
 		cd-gpios = <&pioD 5 GPIO_ACTIVE_HIGH>;
+		cd-inverted;
 	};
 };
 
-- 
2.20.1



