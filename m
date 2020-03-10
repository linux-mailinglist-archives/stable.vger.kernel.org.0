Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B787017FB25
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbgCJNLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbgCJNLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE3C120409;
        Tue, 10 Mar 2020 13:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845875;
        bh=QNdpxQLf/YTwAiU0dauCMyC00+ScKCC4tI0BFeqz4C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWFca/tKT4H1haHFzsr86ma2iTBaClHos4Oj5MGcDNhyDWPoFS21B9lD4zhNmSHlR
         /u22ude7qmFDr+4bWEkhhfANA5JNjNxMbsTIFMjed8VcRHlxYIAnWSHgJuxPnzeYo8
         9FrxZTkizGxeJDIj+yyxOdMVdrkUqt7BnMAqcAo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 100/126] arm: dts: dra76x: Fix mmc3 max-frequency
Date:   Tue, 10 Mar 2020 13:42:01 +0100
Message-Id: <20200310124210.073545434@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

commit fa63c0039787b8fbacf4d6a51e3ff44288f5b90b upstream.

dra76x is not affected by i887 which requires mmc3 node to be limited to
a max frequency of 64 MHz. Fix this by overwriting the correct value in
the the dra76 specific dtsi.

Fixes: 895bd4b3e5ec ("ARM: dts: Add support for dra76-evm")
Cc: stable@vger.kernel.org
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra76x.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm/boot/dts/dra76x.dtsi
+++ b/arch/arm/boot/dts/dra76x.dtsi
@@ -17,3 +17,8 @@
 &crossbar_mpu {
 	ti,irqs-skip = <10 67 68 133 139 140>;
 };
+
+&mmc3 {
+	/* dra76x is not affected by i887 */
+	max-frequency = <96000000>;
+};


