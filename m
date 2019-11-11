Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A676FF7CDD
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfKKSuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbfKKSuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3CFE204FD;
        Mon, 11 Nov 2019 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498236;
        bh=54s9gAZ/w4ffu2vVpETxtuTNjxXcA3yNC4esabz2sHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPFiShkVpUwC1oRoUFk5wZ6HJAeXzt29U43QLv9b3NEZmkTPV3/aVylBGKmnhgRFc
         gUISPLQQtrk+eq/l4d1Doh3xBDgz3L/P/9hnfou4ND6jVmIxAMIBXYDQ58M/jxLyr9
         Dp0kQ7SYIppSnzmwtFJ1dTqSZxQKWNCBRMtEMVy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.3 061/193] ARM: dts: imx6-logicpd: Re-enable SNVS power key
Date:   Mon, 11 Nov 2019 19:27:23 +0100
Message-Id: <20191111181505.507072829@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit cabe5f85e63626c00f3b879a670ec27325056a2d upstream.

The baseboard of the Logic PD i.MX6 development kit has a power
button routed which can both power down and power up the board.
It can also wake the board from sleep.  This functionality was
marked as disabled by default in imx6qdl.dtsi, so it needs to
be explicitly enabled for each board.

This patch enables the snvs power key again.

Signed-off-by: Adam Ford <aford173@gmail.com>
Fixes: 770856f0da5d ("ARM: dts: imx6qdl: Enable SNVS power key according to board design")
Cc: stable <stable@vger.kernel.org> #5.3+
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
+++ b/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
@@ -328,6 +328,10 @@
 	pinctrl-0 = <&pinctrl_pwm3>;
 };
 
+&snvs_pwrkey {
+	status = "okay";
+};
+
 &ssi2 {
 	status = "okay";
 };


