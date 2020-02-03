Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E503150CD3
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgBCQgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731240AbgBCQgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:54 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E24720721;
        Mon,  3 Feb 2020 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747813;
        bh=Fl2nBsgQKp5761ACa1JMB9Y6GpzmUuHxHhoViXKwlPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Apq14QVVfck0dB9K32dxNGwk2ThZ1kbW+jgSSMBmufXdmnDgjLAIciO0HdmH0JlzK
         XzJHaz/v50tN2sH1ueWFzHZQQOpl8aESJ8YyOhZoiDpaoWQ1DE13S10h+YCPzycuaZ
         oez6Z83z5+JQef2PvVCfQf72DErL4y2ekP8Rz7Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raag Jadav <raagjadav@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 81/90] ARM: dts: am43x-epos-evm: set data pin directions for spi0 and spi1
Date:   Mon,  3 Feb 2020 16:20:24 +0000
Message-Id: <20200203161927.038854624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raag Jadav <raagjadav@gmail.com>

[ Upstream commit b0b03951544534d6d9ad4aa2787eefec988fff20 ]

Set d0 and d1 pin directions for spi0 and spi1 as per their pinmux.

Signed-off-by: Raag Jadav <raagjadav@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 078cb473fa7dc..a6fbc088daa86 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -848,6 +848,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&spi0_pins_default>;
 	pinctrl-1 = <&spi0_pins_sleep>;
+	ti,pindir-d0-out-d1-in = <1>;
 };
 
 &spi1 {
@@ -855,6 +856,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&spi1_pins_default>;
 	pinctrl-1 = <&spi1_pins_sleep>;
+	ti,pindir-d0-out-d1-in = <1>;
 };
 
 &usb2_phy1 {
-- 
2.20.1



