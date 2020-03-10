Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7C17FBAE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbgCJNOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731905AbgCJNOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:14:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93AE620409;
        Tue, 10 Mar 2020 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846072;
        bh=YTVwSytxeGQ6lXUbeNE2/OF+T4UUnLp0tdkd3x/uyfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pm5v1DItXTGnkCvroXU1ZYyS6hQ7MjPG6ZMF624Zl0Z+N7AsUQ1IThWrx4nUxv26H
         LcNhm2ww+J1e5y0DIaLZOpnOc+F07puzqgGwK6dqlRu+1XDVXIfG9MsxGXVQyXoXPi
         z5PEII91yXjKAUIX7Wn8mlj9IMBARaYl6JjRWh54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 77/86] ARM: dts: am437x-idk-evm: Fix incorrect OPP node names
Date:   Tue, 10 Mar 2020 13:45:41 +0100
Message-Id: <20200310124534.920468350@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

commit 31623468be0bf57617b8057dcd335693935a9491 upstream.

The commit 337c6c9a69af ("ARM: dts: am437x-idk-evm: Disable
OPP50 for MPU") adjusts couple of OPP nodes defined in the
common am4372.dtsi file, but used outdated node names. This
results in these getting treated as new OPP nodes with missing
properties.

Fix this properly by using the correct node names as updated in
commit b9cb2ba71848 ("ARM: dts: Use - instead of @ for DT OPP
entries for TI SoCs").

Reported-by: Roger Quadros <rogerq@ti.com>
Fixes: 337c6c9a69af ("ARM: dts: am437x-idk-evm: Disable OPP50 for MPU")
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am437x-idk-evm.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/am437x-idk-evm.dts
+++ b/arch/arm/boot/dts/am437x-idk-evm.dts
@@ -525,11 +525,11 @@
 	 * Supply voltage supervisor on board will not allow opp50 so
 	 * disable it and set opp100 as suspend OPP.
 	 */
-	opp50@300000000 {
+	opp50-300000000 {
 		status = "disabled";
 	};
 
-	opp100@600000000 {
+	opp100-600000000 {
 		opp-suspend;
 	};
 };


