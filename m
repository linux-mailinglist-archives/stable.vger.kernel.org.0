Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0319431CE8
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhJRNp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232606AbhJRNoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:44:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4261961507;
        Mon, 18 Oct 2021 13:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564098;
        bh=zJAkJoWlHczIkuAjVPyHBbMLKA7zZA9sWHfvsC6rSWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsjYxSL2yUvUK6fe1tULK/7yFQ+pdVAyp76TVdC4b0wiAv/aYx1ncT9IeEMOPw1ty
         exsUWt+zoKnWNBP8OwcnNCG8GF3Y0hgnkBp8Qj+tOShxmESTErvYxjYh4eXXz3PXN/
         tz9B7ExVQa26seMM6cXtJjEQRttZsThWOtDFhFkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: [PATCH 5.10 064/103] ARM: dts: bcm2711: fix MDIO #address- and #size-cells
Date:   Mon, 18 Oct 2021 15:24:40 +0200
Message-Id: <20211018132336.902700070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit 2faff6737a8a684b077264f0aed131526c99eec4 upstream.

The values of #address-cells and #size-cells are swapped. Fix this
and avoid the following DT schema warnings for mdio@e14:

 #address-cells:0:0: 1 was expected
 #size-cells:0:0: 0 was expected

Fixes: be8af7a9e3cc ("ARM: dts: bcm2711-rpi-4: Enable GENET support")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1628334401-6577-2-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm2711.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -514,8 +514,8 @@
 				compatible = "brcm,genet-mdio-v5";
 				reg = <0xe14 0x8>;
 				reg-names = "mdio";
-				#address-cells = <0x0>;
-				#size-cells = <0x1>;
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
 			};
 		};
 	};


