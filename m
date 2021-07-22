Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3A73D2A39
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhGVQKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233742AbhGVQIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35C5461DBA;
        Thu, 22 Jul 2021 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972513;
        bh=iTw8AkC/KFpgWuZKgaxdDF+nxTLIUgiX5Y/A4mEKECs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmDJRy/2LVzE5JphLFlQHy9QIrwikPjZSMVF1RRdmnByq5b+zxKPwyrt9pgimwaLa
         P9uFpPp18oeTlyigQ2T6CGdvT4C2/Qo7s6MTRE+RH24uuLYptKyIcDOi3shoxQa0iU
         tTeiV08Uk/6gwg+DpDIoYczVyTfD8qHXatDamhbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.13 140/156] ARM: dts: aspeed: Fix AST2600 machines line names
Date:   Thu, 22 Jul 2021 18:31:55 +0200
Message-Id: <20210722155632.876965331@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit ca46ad2214473df1a6a9496be17156d65ba89b9f upstream.

Tacoma and Rainier both have a line-names array that is too long:

 gpio gpiochip0: gpio-line-names is length 232 but should be at most length 208

This was probably copied from an AST2500 device tree that did have more
GPIOs on the controller.

Fixes: e9b24b55ca4f ("ARM: dts: aspeed: rainier: Add gpio line names")
Fixes: 2f68e4e7df67 ("ARM: dts: aspeed: tacoma: Add gpio line names")
Link: https://lore.kernel.org/r/20210624090742.56640-1-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts |    5 +----
 arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts  |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -280,10 +280,7 @@
 	/*W0-W7*/	"","","","","","","","",
 	/*X0-X7*/	"","","","","","","","",
 	/*Y0-Y7*/	"","","","","","","","",
-	/*Z0-Z7*/	"","","","","","","","",
-	/*AA0-AA7*/	"","","","","","","","",
-	/*AB0-AB7*/	"","","","","","","","",
-	/*AC0-AC7*/	"","","","","","","","";
+	/*Z0-Z7*/	"","","","","","","","";
 
 	pin_mclr_vpp {
 		gpio-hog;
--- a/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts
@@ -136,10 +136,7 @@
 	/*W0-W7*/	"","","","","","","","",
 	/*X0-X7*/	"","","","","","","","",
 	/*Y0-Y7*/	"","","","","","","","",
-	/*Z0-Z7*/	"","","","","","","","",
-	/*AA0-AA7*/	"","","","","","","","",
-	/*AB0-AB7*/	"","","","","","","","",
-	/*AC0-AC7*/	"","","","","","","","";
+	/*Z0-Z7*/	"","","","","","","","";
 };
 
 &fmc {


