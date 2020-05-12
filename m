Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94BA1CECC1
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgELGAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 02:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725933AbgELGAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 02:00:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DB8C061A0C;
        Mon, 11 May 2020 23:00:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z72so12233637wmc.2;
        Mon, 11 May 2020 23:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xqMgmNOYwrxdY+o1DnJ61eJdUyKQzmC6mhNhV0fXE88=;
        b=D9eV/Zf54+ehFvlVaYySHF1yxDS1BGjbh6+228BirDrpdom0MfF2DPTvrOx2PKqeqn
         msk0n3K9GPL+VHGSRvIHtUus4pCZqaqd3gAF8hfWLRyTj7xsOa9HsGZHUj4gpWc9Hkrw
         zHyu8JUu/7+BNPXx37aWLX4tFqwJHBk5qqyTa6IGtdBzKqnMJPAUGFDrHD/UXue2WOVn
         DdCazsjpbK7BT0mG9l+GrVhJfMbdFhEPdf64dxv0ES+GbH5Ft1cOo04SGO0mspp70c0w
         7OpSWbgz92HLJOSQ8ByE+aZrZ4qCkvazVxoLZ1K3Ciy2wq4fjmCpm8qCXF/QuIgwrvRc
         rc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xqMgmNOYwrxdY+o1DnJ61eJdUyKQzmC6mhNhV0fXE88=;
        b=oNg9qNyZoarkWeBpQhaqMhwHpw9ghoHchM8yYfpnFzwhxdnJJRmiSeN8kK5TxCnQgs
         lgCSUABjE1Cgj9+HRiLwaQn7WyuUrAsfkUdCcQknMH/yl/Pve9SvyjuPqST2wmUAfiBs
         XfEwQOaP5iL1cIPDr2rRRG02tSE8izk2W7qwaB7rrMtX94nonC/vCgxqJvh7KiECKyJ5
         FhUcXu2RGPkiTNTMvrz0g+6PV8PzSO8GME1q5GgoAhLO7uLyEHpcGOkoiB/1CZaWufQM
         JQy5UWezasoy52drMOba5msRcX2tuPjFvAJtKobfxBwpcUyJWOYksGsZnBSsADkF+Ln3
         YDqQ==
X-Gm-Message-State: AGi0PuYzJER3ToFWHQsYjM+OHMEcu67g7VhnkrKIGeV7QQEgmIeoYA0x
        6nM7bewlFDZVovEjGxTIEQ8=
X-Google-Smtp-Source: APiQypJChnU7y6gqwA6+tQ/g42zXUMKmCWgR04qMmUVzGvHla1KX0Ibexk1/9cnyXDApm2t7GubW/A==
X-Received: by 2002:a7b:c1c4:: with SMTP id a4mr36219836wmj.86.1589263230616;
        Mon, 11 May 2020 23:00:30 -0700 (PDT)
Received: from skynet.lan (198.red-83-49-57.dynamicip.rima-tde.net. [83.49.57.198])
        by smtp.gmail.com with ESMTPSA id a13sm20539150wrv.67.2020.05.11.23.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 23:00:30 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     computersforpeace@gmail.com, kdasu.kdev@gmail.com,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sumit.semwal@linaro.org, linux-mtd@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/2] mtd: rawnand: brcmnand: fix hamming oob layout
Date:   Tue, 12 May 2020 08:00:22 +0200
Message-Id: <20200512060023.684871-2-noltari@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512060023.684871-1-noltari@gmail.com>
References: <20200504185945.2776148-1-noltari@gmail.com>
 <20200512060023.684871-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

First 2 bytes are used in large-page nand.

Fixes: ef5eeea6e911 ("mtd: nand: brcm: switch to mtd_ooblayout_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v3: invert patch order
 v2: extend original comment

 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index e4e3ceeac38f..1c1070111ebc 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1116,11 +1116,14 @@ static int brcmnand_hamming_ooblayout_free(struct mtd_info *mtd, int section,
 		if (!section) {
 			/*
 			 * Small-page NAND use byte 6 for BBI while large-page
-			 * NAND use byte 0.
+			 * NAND use bytes 0 and 1.
 			 */
-			if (cfg->page_size > 512)
-				oobregion->offset++;
-			oobregion->length--;
+			if (cfg->page_size > 512) {
+				oobregion->offset += 2;
+				oobregion->length -= 2;
+			} else {
+				oobregion->length--;
+			}
 		}
 	}
 
-- 
2.26.2

