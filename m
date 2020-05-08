Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4771CABAB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgEHMpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbgEHMps (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FABD2145D;
        Fri,  8 May 2020 12:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941948;
        bh=6j/AYi2hXS7FtfYynCmVLISadE4ztMNbYJq4Ye/1QdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2uo0xAUff6si7vWGbwD6xglclVqGb34awLGQcIcnFGn0WR6ZhZCNnlrS2icysez4
         Ut1kDcKSDviE8bSpx0GEjMeoyeRuzKxP52d3cdEXPQ/4MiNiUpXNfNX/Msr8EoiHvb
         fnbeF80RBhLPWiMufVJPo4nR16cbsnmr4nBtNRdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        "Andrew F. Davis" <afd@ti.com>, Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4.4 229/312] power: bq27xxx: fix register numbers of bq27500
Date:   Fri,  8 May 2020 14:33:40 +0200
Message-Id: <20200508123140.550618374@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 099867a16a0fa9fd5aafc32e3b1a6f8a90f17834 upstream.

bug: according to data sheet some register numbers are wrong.

tested: no

Fixes: d74534c27775 ("power: bq27xxx_battery: Add support for additional bq27xxx family devices")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Andrew F. Davis <afd@ti.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/bq27xxx_battery.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/power/bq27xxx_battery.c
+++ b/drivers/power/bq27xxx_battery.c
@@ -198,10 +198,10 @@ static u8 bq27500_regs[] = {
 	INVALID_REG_ADDR,	/* TTECP - NA	*/
 	0x0c,	/* NAC		*/
 	0x12,	/* LMD(FCC)	*/
-	0x1e,	/* CYCT		*/
+	0x2a,	/* CYCT		*/
 	INVALID_REG_ADDR,	/* AE - NA	*/
-	0x20,	/* SOC(RSOC)	*/
-	0x2e,	/* DCAP(ILMD)	*/
+	0x2c,	/* SOC(RSOC)	*/
+	0x3c,	/* DCAP(ILMD)	*/
 	INVALID_REG_ADDR,	/* AP - NA	*/
 };
 


