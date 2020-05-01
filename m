Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC58D1C14AE
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbgEANl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730948AbgEANly (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1806208DB;
        Fri,  1 May 2020 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340514;
        bh=H9/BvLXZS1pY3l92KsMnzT6NS6j3NtYA6L+sxVYnLkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYSu0hafTGW4QIbqYnv6jgUoRGrBwe+DlBBmTrXM1ALwToomCp9SO23MTVQkIlE3R
         AS16jZfveCFRx6iBDlRJhvxypvbfIjZ8meCYqYKYICrrl182CTXmf1fs0YUpRzFN/Z
         ksgb2x+BjJiOqE4b+aHbThXxb8hyAYv+6ypA82dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.6 025/106] ARM: dts: OMAP3: disable RNG on N950/N9
Date:   Fri,  1 May 2020 15:22:58 +0200
Message-Id: <20200501131547.069242395@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit 07bdc492cff6f555538df95e9812fe72e16d154a upstream.

Like on N900, we cannot access RNG directly on N950/N9. Mark it disabled in
the DTS to allow kernel to boot.

Fixes: 308607e5545f ("ARM: dts: Configure omap3 rng")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-n950-n9.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -341,6 +341,11 @@
 	status = "disabled";
 };
 
+/* RNG not directly accessible on N950/N9. */
+&rng_target {
+	status = "disabled";
+};
+
 &usb_otg_hs {
 	interface-type = <0>;
 	usb-phy = <&usb2_phy>;


