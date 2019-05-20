Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739D42349A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389376AbfETM2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbfETM2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33EE520815;
        Mon, 20 May 2019 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355330;
        bh=Oiizy4XV1wKvFexkefBV11yaUlynaoRXxjtvagQSq8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koq8X3jy5wnLrCZvk6bKdvoGyvUJEb2pGNeUCy7TDJEBg+0N/2upQIkEjZB3o7uNF
         BcYiqXTP7chvx6nHFt/A9ZrqjbR2KJMOfzNXOO+c5SFGsK60P2/PLF3NZkP3xEkgUX
         32FG3PDUpLqnxOHtdIVs2xPFG40kkEep9F8ahBUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.0 078/123] mtd: maps: Allow MTD_PHYSMAP with MTD_RAM
Date:   Mon, 20 May 2019 14:14:18 +0200
Message-Id: <20190520115250.033612570@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit d41970097f10d898cef0eb04bf53d786efd6bbbc upstream.

When the physmap_of_core.c code was merged into physmap-core.c the
ability to use MTD_PHYSMAP_OF with only MTD_RAM selected was lost.
Restore this by adding MTD_RAM to the dependencies of MTD_PHYSMAP.

Fixes: commit 642b1e8dbed7 ("mtd: maps: Merge physmap_of.c into physmap-core.c")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -10,7 +10,7 @@ config MTD_COMPLEX_MAPPINGS
 
 config MTD_PHYSMAP
 	tristate "Flash device in physical memory map"
-	depends on MTD_CFI || MTD_JEDECPROBE || MTD_ROM || MTD_LPDDR
+	depends on MTD_CFI || MTD_JEDECPROBE || MTD_ROM || MTD_RAM || MTD_LPDDR
 	help
 	  This provides a 'mapping' driver which allows the NOR Flash and
 	  ROM driver code to communicate with chips which are mapped


