Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEAF23461
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389286AbfETM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389273AbfETM0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8683F20645;
        Mon, 20 May 2019 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355178;
        bh=vENCxlkEC564e0tIMqMIzm3b6Nb2+zQVTcPaW5XIdUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or2BKHsNBt7F3xN3+ugEwZ1P4Sns3l2fsKlVuH/nJl3GuQRda1NIIfIY8O3W5dBsi
         vsq7kS/No4Vri5nJ5ZsHtGsXop/jckGPAP1nwgK/rw5+444t6fvw6GTMupPxnezEH8
         fSuBQ/xrA1Ss5FMboK48s1qcP/SiYdszYV88GXQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.0 009/123] ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3
Date:   Mon, 20 May 2019 14:13:09 +0200
Message-Id: <20190520115245.820307935@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit 9b23e1a3e8fde76e8cc0e366ab1ed4ffb4440feb upstream.

The name of CODEC input widget to which microphone is connected through
the "Headphone" jack is "IN12" not "IN1". This fixes microphone support
on Odroid XU3.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi
@@ -22,7 +22,7 @@
 			"Headphone Jack", "HPL",
 			"Headphone Jack", "HPR",
 			"Headphone Jack", "MICBIAS",
-			"IN1", "Headphone Jack",
+			"IN12", "Headphone Jack",
 			"Speakers", "SPKL",
 			"Speakers", "SPKR";
 


