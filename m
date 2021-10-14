Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FC142DC4F
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhJNO6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232279AbhJNO5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B56061151;
        Thu, 14 Oct 2021 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223342;
        bh=IGI5OlCUHU+/58fXxiR9VuN9uNRVWMjBTZSaHLlq7NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlZzwDePr2FwShkAZE1urAnIk2VhDKLeRxibi2V3JXscbyaM8FWt/xYQ3TMcwGZfE
         NSDQnFSy1j8XaZfbdf5vg3kJJzyb4by8r5KhjjDFA96YbYPLSHRASS5qkBZHbNRbKX
         nIynX1W8D9PTqR8pSm+lTREZMRKVSvk9fj78iTeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Scott Wood <oss@buserror.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/25] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Date:   Thu, 14 Oct 2021 16:53:42 +0200
Message-Id: <20211014145207.930308771@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit eed183abc0d3b8adb64fd1363b7cea7986cd58d6 ]

Property phy-connection-type contains invalid value "sgmii-2500" per scheme
defined in file ethernet-controller.yaml.

Correct phy-connection-type value should be "2500base-x".

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the board device tree(s)")
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
index 29757623e5ba..f5f8f969dd58 100644
--- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
@@ -125,7 +125,7 @@
 
 			fm1mac3: ethernet@e4000 {
 				phy-handle = <&sgmii_aqr_phy3>;
-				phy-connection-type = "sgmii-2500";
+				phy-connection-type = "2500base-x";
 				sleep = <&rcpm 0x20000000>;
 			};
 
-- 
2.33.0



