Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210E3199183
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbgCaJPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbgCaJPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F5220675;
        Tue, 31 Mar 2020 09:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646116;
        bh=bDOyWPwtHpt7ua7OxR166RVFsXRO6Ja9g+epQkrZGuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHkSEBzg7RqRlbxJ5uLiuFxma20Ag0dJzsLVQwW5dM1o13StJH9q7+0pRu780Riai
         4l5Sw5g8ZPERuN4wGblMnqwiG5XXpLKafb4/W8ZxAZMqXzADJGHB48g/d+EkTueF0f
         x3OzkjfdBizr+WRZnoRA4rxFQIemFG9xciebWYlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 089/155] ARM: dts: omap5: Add bus_dma_limit for L3 bus
Date:   Tue, 31 Mar 2020 10:58:49 +0200
Message-Id: <20200331085428.309556173@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit dfa7ea303f56a3a8b1ed3b91ef35af2da67ca4ee upstream.

The L3 interconnect's memory map is from 0x0 to
0xffffffff. Out of this, System memory (SDRAM) can be
accessed from 0x80000000 to 0xffffffff (2GB)

OMAP5 does support 4GB of SDRAM but upper 2GB can only be
accessed by the MPU subsystem.

Add the dma-ranges property to reflect the physical address limit
of the L3 bus.

Cc: stable@kernel.org
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap5.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -143,6 +143,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xc0000000>;
+		dma-ranges = <0x80000000 0x0 0x80000000 0x80000000>;
 		ti,hwmods = "l3_main_1", "l3_main_2", "l3_main_3";
 		reg = <0 0x44000000 0 0x2000>,
 		      <0 0x44800000 0 0x3000>,


