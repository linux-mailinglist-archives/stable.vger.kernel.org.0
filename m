Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7631CEEA2
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 09:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgELH5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 03:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgELH5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 03:57:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71838C061A0C;
        Tue, 12 May 2020 00:57:40 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s8so14112672wrt.9;
        Tue, 12 May 2020 00:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FKnAX8odzheYGQT7jDGjNlR3gvRSpwlFpS1VXp9+OKk=;
        b=t+rtPBl8xM/oMLoZggKEKVQ1X/xWoBIs5OibyQFRcHvNObtIM6v3af/9AzrsAqUE/k
         UybciGnMaLDJqfw1XEa1zjTD42QeqBpjafibcXRUg7RSgvGqvZrB8b0SsH+Hnvk+bN10
         sowFLNzrW+7d3hmG0/3UruTr2OJl3cDNnxZmQqAcEk7qZvOBdyA+pAFsRELK96OPTTN1
         CUpncx8RhmQ5gPO7uGqPA+LwVeVNktbBR+9e/xpLLBbsoTvQ+SNMN0/31Hdj0nMg3T0k
         hhuK2QvqN5Vtzx19Z3KLNtFeMDq8YmCEd7NB36p9Q0Hkxp12GJ/7zNSB1gILQalDkZVz
         BOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FKnAX8odzheYGQT7jDGjNlR3gvRSpwlFpS1VXp9+OKk=;
        b=FW4sP4ExjXr8KIO3kRlZVTj/+kvyieamjKYk5uoZTz2f2K+5KKpc3bOo9M7dgPphuq
         +jpUfgs4Eo8UXPZ0yFPNCchu7dOssiPhsHenp0N50ruCVFr/WOZXRzts8s7pJS6l7+DG
         dKC5qgHFb4krkhPvIGAIcztwIyoE+sUv5RA96SS1OdZC1TByfQJkZYqVA5sIjcW2L5LY
         ns75foo3FBmvZ6VYofVSrbcQecfAYeFboBhnjTnjaY9SHAROdHU8rXg8nUb+1qpquped
         V6CjBvmus5VgpyzrIAacWYanwMYKBquZDanq6toHQESnxqEcJ1V0R/H8PJA9TEfR0C/a
         S33g==
X-Gm-Message-State: AGi0PuZuKFY8OA6ccYA8d3q9dOEwCiiN/lXPG9vZVdwnzIfMnGpCE7v7
        z5ucICUSVL91FsK33xcnDFs=
X-Google-Smtp-Source: APiQypKQwhXCVL/sn5E+I1b6Dwcm3VQqlLP5ifkvLOekIBhx5aYOclR8fafBTsQDDgUDuakI9hQt0w==
X-Received: by 2002:adf:afe9:: with SMTP id y41mr5657932wrd.56.1589270259075;
        Tue, 12 May 2020 00:57:39 -0700 (PDT)
Received: from skynet.lan (198.red-83-49-57.dynamicip.rima-tde.net. [83.49.57.198])
        by smtp.gmail.com with ESMTPSA id p8sm25946618wma.45.2020.05.12.00.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 00:57:38 -0700 (PDT)
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
Subject: [PATCH v4 1/2] mtd: rawnand: brcmnand: fix hamming oob layout
Date:   Tue, 12 May 2020 09:57:32 +0200
Message-Id: <20200512075733.745374-2-noltari@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512075733.745374-1-noltari@gmail.com>
References: <20200512060023.684871-1-noltari@gmail.com>
 <20200512075733.745374-1-noltari@gmail.com>
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
 v4: no changes
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

