Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A991630F0
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgBRT5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgBRT5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:57:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD24024655;
        Tue, 18 Feb 2020 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055861;
        bh=alfaClgMPQx9gqsYJzeSw3F99GdWFoISOuD0fIcZiQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wh0Kj+PI/NPO72b7UZemIrKnd4jCOqa13GE2qXg2/BPHyuQXrUL6+AFRezp/vBC9Z
         sSKdcaG8zS13HHEHEyF60EE0sLgplBBSFZxh8LxUXLUspNvHii0xDEBMj/cnpgq/xS
         THB+aLjBKa+mdPnrQVPe/4y1kssU4+cc2wQ2/B8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 03/66] Input: synaptics - remove the LEN0049 dmi id from topbuttonpad list
Date:   Tue, 18 Feb 2020 20:54:30 +0100
Message-Id: <20200218190428.388256110@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 5179a9dfa9440c1781816e2c9a183d1d2512dc61 upstream.

The Yoga 11e is using LEN0049, but it doesn't have a trackstick.

Thus, there is no need to create a software top buttons row.

However, it seems that the device works under SMBus, so keep it as part
of the smbus_pnp_ids.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200115013023.9710-1-benjamin.tissoires@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -146,7 +146,6 @@ static const char * const topbuttonpad_p
 	"LEN0042", /* Yoga */
 	"LEN0045",
 	"LEN0047",
-	"LEN0049",
 	"LEN2000", /* S540 */
 	"LEN2001", /* Edge E431 */
 	"LEN2002", /* Edge E531 */
@@ -166,6 +165,7 @@ static const char * const smbus_pnp_ids[
 	/* all of the topbuttonpad_pnp_ids are valid, we just add some extras */
 	"LEN0048", /* X1 Carbon 3 */
 	"LEN0046", /* X250 */
+	"LEN0049", /* Yoga 11e */
 	"LEN004a", /* W541 */
 	"LEN005b", /* P50 */
 	"LEN005e", /* T560 */


