Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B9519B27D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389717AbgDAQo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389332AbgDAQoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7849F2071A;
        Wed,  1 Apr 2020 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759464;
        bh=/iKgduoUkNVKU9ZrPkIW5sERPFZkvrGAQfa5/ot1PG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVfi/NlC+iuameqyOInwkXf8r6f4aERlBJXlHN6uqiXMjllOH5RxoK1E26fPGwxjz
         mB7IhEzlxdNbQ8YDbrvZWuswKHYpA2MKK6pHL2w8e7gs7emhYjxttxQ3Faf3itgkXd
         x22cFEXda0JnlroJNE3FSkHExABmvdUyio55DSVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yussuf Khalil <dev@pp3345.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 089/148] Input: synaptics - enable RMI on HP Envy 13-ad105ng
Date:   Wed,  1 Apr 2020 18:18:01 +0200
Message-Id: <20200401161601.558458533@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yussuf Khalil <dev@pp3345.net>

commit 1369d0abe469fb4cdea8a5bce219d38cb857a658 upstream.

This laptop (and perhaps other variants of the same model) reports an
SMBus-capable Synaptics touchpad. Everything (including suspend and
resume) works fine when RMI is enabled via the kernel command line, so
let's add it to the whitelist.

Signed-off-by: Yussuf Khalil <dev@pp3345.net>
Link: https://lore.kernel.org/r/20200307213508.267187-1-dev@pp3345.net
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
+	"SYN3257", /* HP Envy 13-ad105ng */
 	NULL
 };
 


