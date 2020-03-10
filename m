Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63417FA7B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgCJNFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729809AbgCJND1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:03:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EDE52468D;
        Tue, 10 Mar 2020 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845407;
        bh=Tg4+xHdoUUqG5BHcaX9AF5r82107Nq3jGYbzvAySqwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqOJffV9B0DQOIdZoTOUurASxHccPtHVUn5ciHDD3Jdd6f0nyCY4w4/Op/hqMGCSx
         Y76CdBZVJKczmTN9OfBjm15MrSkqAtYJb4/dWkZOOgNbRge+sjlyoBmUryCqvbR0Iz
         ex5dQhXB0k0ceq62g0m/quQwhCgvowSd5OACxA1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.5 172/189] ARM: dts: imx7d: fix opp-supported-hw
Date:   Tue, 10 Mar 2020 13:40:09 +0100
Message-Id: <20200310123657.226232553@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 54d6477dca3b65b7b77a903fe60a9447bc836e7f upstream.

Per i.MX7D Document Number: IMX7DCEC Rev. 6, 03/2019,
there are only consumer/industrial parts, and 1.2GHz
is only support in consumer parts.

So exclude automotive from 792/996MHz/1.2GHz and exclude
industrial from 1.2GHz.

Fixes: d7bfba7296ca ("ARM: dts: imx7d: Update cpufreq OPP table")
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx7d.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/imx7d.dtsi
+++ b/arch/arm/boot/dts/imx7d.dtsi
@@ -44,7 +44,7 @@
 			opp-hz = /bits/ 64 <792000000>;
 			opp-microvolt = <1000000>;
 			clock-latency-ns = <150000>;
-			opp-supported-hw = <0xd>, <0xf>;
+			opp-supported-hw = <0xd>, <0x7>;
 			opp-suspend;
 		};
 
@@ -52,7 +52,7 @@
 			opp-hz = /bits/ 64 <996000000>;
 			opp-microvolt = <1100000>;
 			clock-latency-ns = <150000>;
-			opp-supported-hw = <0xc>, <0xf>;
+			opp-supported-hw = <0xc>, <0x7>;
 			opp-suspend;
 		};
 
@@ -60,7 +60,7 @@
 			opp-hz = /bits/ 64 <1200000000>;
 			opp-microvolt = <1225000>;
 			clock-latency-ns = <150000>;
-			opp-supported-hw = <0x8>, <0xf>;
+			opp-supported-hw = <0x8>, <0x3>;
 			opp-suspend;
 		};
 	};


