Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540262A54C5
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbgKCVNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389331AbgKCVNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A2620757;
        Tue,  3 Nov 2020 21:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437987;
        bh=HPmkyHj/hyhT7VazZ2qns6up9hEwm9RIZ71r8skYFXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PziUOizz3bNGMWqLnfnb/vvspHHHxlezDv1fnHB7MjR5rw0P6zt+/pMRjYSx6QpnN
         /5nn1I+Q0j44pGZl+7ztAs377IAM6aFzXpkvVhpa7Yuu8qWJbTSxephcrlap2svvPm
         9wD0GD1C7SzRDe2G20cMQI3whK0hvAimgDzQvTtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 4.14 117/125] arm: dts: mt7623: add missing pause for switchport
Date:   Tue,  3 Nov 2020 21:38:14 +0100
Message-Id: <20201103203214.418450016@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

commit 36f0a5fc5284838c544218666c63ee8cfa46a9c3 upstream.

port6 of mt7530 switch (= cpu port 0) on bananapi-r2 misses pause option
which causes rx drops on running iperf.

Fixes: f4ff257cd160 ("arm: dts: mt7623: add support for Bananapi R2 (BPI-R2) board")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200907070517.51715-1-linux@fw-web.de
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
+++ b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
@@ -183,6 +183,7 @@
 					fixed-link {
 						speed = <1000>;
 						full-duplex;
+						pause;
 					};
 				};
 			};


