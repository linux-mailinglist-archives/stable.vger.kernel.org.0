Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB657226911
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732456AbgGTQDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732454AbgGTQDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2DC2176B;
        Mon, 20 Jul 2020 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261015;
        bh=roEMoMNz0vgPEnIen9IPPcMgNc5MvflC4Ou3IoPYch4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7Qi+DOwunM0vT7AUPFjsmOeUHEjCEDfz4ELfBABb3eKXcwwupTRLpGl0ux8uQEML
         qKgGdB/TdB0K1/mSudorDAgSkzbKIFISApRmLab20w7zk3pi0NWyk1+rgx7oWpaPYi
         Pw5o6V/CAyJSk5Ill1MKw1NffaJS4dL2NpTUg0hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wang <dave.wang@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 179/215] Input: elan_i2c - add more hardware ID for Lenovo laptops
Date:   Mon, 20 Jul 2020 17:37:41 +0200
Message-Id: <20200720152828.690157175@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wang <dave.wang@emc.com.tw>

commit a50ca29523b18baea548bdf5df9b4b923c2bb4f6 upstream.

This adds more hardware IDs for Elan touchpads found in various Lenovo
laptops.

Signed-off-by: Dave Wang <dave.wang@emc.com.tw>
Link: https://lore.kernel.org/r/000201d5a8bd$9fead3f0$dfc07bd0$@emc.com.tw
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/input/elan-i2c-ids.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/input/elan-i2c-ids.h
+++ b/include/linux/input/elan-i2c-ids.h
@@ -67,8 +67,15 @@ static const struct acpi_device_id elan_
 	{ "ELAN062B", 0 },
 	{ "ELAN062C", 0 },
 	{ "ELAN062D", 0 },
+	{ "ELAN062E", 0 }, /* Lenovo V340 Whiskey Lake U */
+	{ "ELAN062F", 0 }, /* Lenovo V340 Comet Lake U */
 	{ "ELAN0631", 0 },
 	{ "ELAN0632", 0 },
+	{ "ELAN0633", 0 }, /* Lenovo S145 */
+	{ "ELAN0634", 0 }, /* Lenovo V340 Ice lake */
+	{ "ELAN0635", 0 }, /* Lenovo V1415-IIL */
+	{ "ELAN0636", 0 }, /* Lenovo V1415-Dali */
+	{ "ELAN0637", 0 }, /* Lenovo V1415-IGLR */
 	{ "ELAN1000", 0 },
 	{ }
 };


