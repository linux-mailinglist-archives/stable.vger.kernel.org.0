Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B800E45C2CA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347974AbhKXNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351288AbhKXNaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:30:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2410861BB1;
        Wed, 24 Nov 2021 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758335;
        bh=U22rbgzymfHX++0ABHjijmAjDVGHM7QIFGG1734d080=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJj3ciGDqo8bpjaIvtdKXxhU//WHDyBVR9/gwMMtQKazvQveip4OBIDTL/8Eatx+k
         F7HdmIu/iiePNRWkcYwqpEMPO68I5o11/oORmSoASpJkHZs+C54gMFZrOKdeVyCOja
         9TxswdTmUJciRBbCZir4wjgaLmLWXBi27cv6mTv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Kuldeep Singh <kuldeep.singh@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/154] ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash
Date:   Wed, 24 Nov 2021 12:57:10 +0100
Message-Id: <20211124115703.464410293@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Yang <leoyang.li@nxp.com>

[ Upstream commit 05e63b48b20fa70726be505a7660d1a07bc1cffb ]

We cannot list all the possible chips used in different board revisions,
just use the generic "jedec,spi-nor" compatible instead.  This also
fixes dtbs_check error:
['jedec,spi-nor', 's25fl256s1', 's25fl512s'] is too long

Signed-off-by: Li Yang <leoyang.li@nxp.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 9d8f0c2a8aba3..aca78b5eddf20 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -251,7 +251,7 @@
 
 	flash@0 {
 		/* Rev. A uses 64MB flash, Rev. B & C use 32MB flash */
-		compatible = "jedec,spi-nor", "s25fl256s1", "s25fl512s";
+		compatible = "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
2.33.0



