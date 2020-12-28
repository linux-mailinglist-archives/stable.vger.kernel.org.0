Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5882E3EB2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392100AbgL1Obu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504142AbgL1ObH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85025208B6;
        Mon, 28 Dec 2020 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165826;
        bh=ZpI38a42wYjfWP93lg5YnLkfSApP0C2EHCZBK9Hrcn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMJiUW+kctxdDGXJJKnT5JV8hmm8+8J3200xpUAxaynjJYRfnpNUl5rQXgHQBVIQ3
         91OImUFT5WsqMCFDgono5I1MkXyHQdEnP5xikgRq1seiSgCPbx5SKzR3JFXAcWmc3S
         5jzLdNk0EYzKRVuQQPfLZYEYiMcviKghyh0UC3cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Liang Yang <liang.yang@amlogic.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 668/717] mtd: rawnand: meson: fix meson_nfc_dma_buffer_release() arguments
Date:   Mon, 28 Dec 2020 13:51:06 +0100
Message-Id: <20201228125052.984597876@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

commit c13d845e9a69580424d40b7b101c37d4f71bcd63 upstream.

Arguments 'infolen' and 'datalen' to meson_nfc_dma_buffer_release() were mixed up.

Fixes: 8fae856c53500 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Acked-by: Liang Yang <liang.yang@amlogic.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201028094940.11765-1-saproj@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/meson_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -510,7 +510,7 @@ static int meson_nfc_dma_buffer_setup(st
 }
 
 static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
-					 int infolen, int datalen,
+					 int datalen, int infolen,
 					 enum dma_data_direction dir)
 {
 	struct meson_nfc *nfc = nand_get_controller_data(nand);


