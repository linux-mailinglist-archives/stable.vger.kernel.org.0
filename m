Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC6C2F144C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733128AbhAKNSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733056AbhAKNSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9962226A;
        Mon, 11 Jan 2021 13:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371085;
        bh=9dfQWF5urz2nqpm61F7MOpLJeIX77TtzhnrA+m5imag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN10liie8khYwDbte5biIoVhMbuS2MLMbqbGHqhh8Ie3hebQpjtCAnqsIMKNxFnFi
         iR0Qz1pKc8XKeDaki9lTwPsraYuJoFsTnVGmWg8hVjL9opgPCf2zAkSIyG8f7cTvhO
         RP84PwwXbXPrKSsJ4kSVME1NJbo5+lKk31GFLeak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 136/145] ARM: dts: OMAP3: disable AES on N950/N9
Date:   Mon, 11 Jan 2021 14:02:40 +0100
Message-Id: <20210111130055.045525608@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit f1dc15cd7fc146107cad2a926d9c1d005f69002a upstream.

AES needs to be disabled on Nokia N950/N9 as well (HS devices), otherwise
kernel fails to boot.

Fixes: c312f066314e ("ARM: dts: omap3: Migrate AES from hwmods to sysc-omap2")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-n950-n9.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -494,3 +494,11 @@
 		clock-names = "sysclk";
 	};
 };
+
+&aes1_target {
+	status = "disabled";
+};
+
+&aes2_target {
+	status = "disabled";
+};


