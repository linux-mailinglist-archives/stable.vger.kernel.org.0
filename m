Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2551A2AB946
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgKINHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgKINHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F37420663;
        Mon,  9 Nov 2020 13:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927261;
        bh=uDShULDW3IEZqD6fakX44PMREKkI4D00SfeIEw0r8AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG8HMtnZ+Qr/83K86FwYj3JmDBaSDtqtw+KJryVLE5q5ZFWw5MJa2F3CQhQSHYFjk
         mMUYHqLMyjMeqf2+RAOy6TsZ3A3rg9hJu/6bK3zHzbkXuKtrYr/q1koNYf9TLOfQ5P
         DZOdkLZ77L79XiTQdN01CLIzpLhgspnpsJbE8cTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.14 48/48] arm64: dts: marvell: espressobin: add ethernet alias
Date:   Mon,  9 Nov 2020 13:55:57 +0100
Message-Id: <20201109125019.122260674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Maciej Nowak <tmn505@gmail.com>

commit 5253cb8c00a6f4356760efb38bca0e0393aa06de upstream.

The maker of this board and its variants, stores MAC address in U-Boot
environment. Add alias for bootloader to recognise, to which ethernet
node inject the factory MAC address.

Signed-off-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
[pali: Backported to 4.14]
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -52,6 +52,10 @@
 	model = "Globalscale Marvell ESPRESSOBin Board";
 	compatible = "globalscale,espressobin", "marvell,armada3720", "marvell,armada3710";
 
+	aliases {
+		ethernet0 = &eth0;
+	};
+
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};


