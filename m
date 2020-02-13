Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1818515C333
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387761AbgBMP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbgBMP2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:41 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3376324681;
        Thu, 13 Feb 2020 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607720;
        bh=gLEvYRahZJZvgtrz81+2AEcu4KmTQ3gESGj7mWlMQCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL7nMhpdRfEBeEybMd5pj1EIhDsZGjKmXTPCi2y/j84V6x27r4j9Y/p/Fev8n4nxp
         ZCiw/kLV8Qo+aYgoeqmVViOh7z7q4TDVe0oBFqEKZtpJsdqe7IVQHVrjMtfTklFOy3
         KLDWSYdcJlxB/el4K37yP8fqSYwwK4h22RHfPoMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.5 063/120] ARM: dts: meson8b: use the actual frequency for the GPUs 364MHz OPP
Date:   Thu, 13 Feb 2020 07:20:59 -0800
Message-Id: <20200213151922.867892486@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit c3dd3315ab58b2cfa1916df55b0d0f9fbd94266f upstream.

The clock setup on Meson8 cannot achieve a Mali frequency of exactly
182.15MHz. The vendor driver uses "FCLK_DIV7 / 1" for this frequency,
which translates to 2550MHz / 7 / 1 = 364285714Hz.
Update the GPU operating point to that specific frequency to not confuse
myself when comparing the frequency from the .dts with the actual clock
rate on the system.

Fixes: c3ea80b6138cae ("ARM: dts: meson8b: add the Mali-450 MP2 GPU")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/meson8b.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/meson8b.dtsi
+++ b/arch/arm/boot/dts/meson8b.dtsi
@@ -125,8 +125,8 @@
 			opp-hz = /bits/ 64 <255000000>;
 			opp-microvolt = <1100000>;
 		};
-		opp-364300000 {
-			opp-hz = /bits/ 64 <364300000>;
+		opp-364285714 {
+			opp-hz = /bits/ 64 <364285714>;
 			opp-microvolt = <1100000>;
 		};
 		opp-425000000 {


