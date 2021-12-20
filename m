Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E6047AC73
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbhLTOnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:43:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36066 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbhLTOma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:42:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C1C1611A8;
        Mon, 20 Dec 2021 14:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5807FC36AE7;
        Mon, 20 Dec 2021 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011349;
        bh=7OgrEYTMTStdfRtTvDWHabMtjvee0hiDrHqnQC+OhIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvXtp0Tg5bvSYCKs/ilYBC6a9bhaIdLSj1oM6LmuNROvvmF4XVjCbYvSBGRvtpY/W
         FStdB+0RyamVhE6GYG2+q7JsILV4q4J9EqUEG4IFeYteqmzTYheGIU8b1L5rUd6h1v
         8nEST5o/MdSr/Ka/lElT5JUWflNPJWx4XQtZm4no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Makarov <georgemakarov1@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.19 47/56] ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name
Date:   Mon, 20 Dec 2021 15:34:40 +0100
Message-Id: <20211220143025.000204785@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 737e65c7956795b3553781fb7bc82fce1c39503f upstream.

According to the i.MX6ULL Reference Manual, pad CSI_DATA07 may
have the ESAI_TX0 functionality, not ESAI_T0.

Also, NXP's i.MX Config Tools 10.0 generates dtsi with the
MX6ULL_PAD_CSI_DATA07__ESAI_TX0 naming, so fix it accordingly.

There are no devicetree users in mainline that use the old name,
so just remove the old entry.

Fixes: c201369d4aa5 ("ARM: dts: imx6ull: add imx6ull support")
Reported-by: George Makarov <georgemakarov1@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6ull-pinfunc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6ull-pinfunc.h
+++ b/arch/arm/boot/dts/imx6ull-pinfunc.h
@@ -68,6 +68,6 @@
 #define MX6ULL_PAD_CSI_DATA04__ESAI_TX_FS                         0x01F4 0x0480 0x0000 0x9 0x0
 #define MX6ULL_PAD_CSI_DATA05__ESAI_TX_CLK                        0x01F8 0x0484 0x0000 0x9 0x0
 #define MX6ULL_PAD_CSI_DATA06__ESAI_TX5_RX0                       0x01FC 0x0488 0x0000 0x9 0x0
-#define MX6ULL_PAD_CSI_DATA07__ESAI_T0                            0x0200 0x048C 0x0000 0x9 0x0
+#define MX6ULL_PAD_CSI_DATA07__ESAI_TX0                           0x0200 0x048C 0x0000 0x9 0x0
 
 #endif /* __DTS_IMX6ULL_PINFUNC_H */


