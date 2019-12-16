Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1FB1216A9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfLPSLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730799AbfLPSLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48760206E0;
        Mon, 16 Dec 2019 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519893;
        bh=x02s47JwqUIvVGhQIsFWbcFxjU8RoKZGu/nJWcG/Ix0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwciFOyi4uWh9OI8dpKvUuVAQEKu61kCg6ILyBspA7FsBHM12SadXFXAZ3dqL9KVE
         3NtxSlrsHNj5Ik52s4HW2eKgvvWXPEuhN4pMm4mbOJ4TKCY8N6V+5oANbGe8LlPLqA
         C65jnlStf/puIMl9YRlZJAJR1ib97iG1H8yB5EdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Brandt <chris.brandt@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.3 111/180] pinctrl: rza2: Fix gpio name typos
Date:   Mon, 16 Dec 2019 18:49:11 +0100
Message-Id: <20191216174838.762683935@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Brandt <chris.brandt@renesas.com>

commit 930d3a4907ae6cdb476db23fc7caa86e9de1e557 upstream.

Fix apparent copy/paste errors that were overlooked in the original driver.
  "P0_4" -> "PF_4"
  "P0_3" -> "PG_3"

Fixes: b59d0e782706 ("pinctrl: Add RZ/A2 pin and gpio controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Link: https://lore.kernel.org/r/20190930145804.30497-1-chris.brandt@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-rza2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-rza2.c
+++ b/drivers/pinctrl/pinctrl-rza2.c
@@ -212,8 +212,8 @@ static const char * const rza2_gpio_name
 	"PC_0", "PC_1", "PC_2", "PC_3", "PC_4", "PC_5", "PC_6", "PC_7",
 	"PD_0", "PD_1", "PD_2", "PD_3", "PD_4", "PD_5", "PD_6", "PD_7",
 	"PE_0", "PE_1", "PE_2", "PE_3", "PE_4", "PE_5", "PE_6", "PE_7",
-	"PF_0", "PF_1", "PF_2", "PF_3", "P0_4", "PF_5", "PF_6", "PF_7",
-	"PG_0", "PG_1", "PG_2", "P0_3", "PG_4", "PG_5", "PG_6", "PG_7",
+	"PF_0", "PF_1", "PF_2", "PF_3", "PF_4", "PF_5", "PF_6", "PF_7",
+	"PG_0", "PG_1", "PG_2", "PG_3", "PG_4", "PG_5", "PG_6", "PG_7",
 	"PH_0", "PH_1", "PH_2", "PH_3", "PH_4", "PH_5", "PH_6", "PH_7",
 	/* port I does not exist */
 	"PJ_0", "PJ_1", "PJ_2", "PJ_3", "PJ_4", "PJ_5", "PJ_6", "PJ_7",


