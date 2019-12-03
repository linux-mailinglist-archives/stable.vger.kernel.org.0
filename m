Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC2111FBF
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfLCWiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfLCWiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60526207DD;
        Tue,  3 Dec 2019 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412692;
        bh=2od75twyd8JsIVh0E+fMHEG4l6sBN9ezELJsWv4ca5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoQiuuF2Pkia43sO0xZuMF7RxTmKU4tIzTyuiwWlBxB1f7spzuD7jSPXqGyRG8FwS
         zdLS85qfXXBI+OrKKBi9JZgH7j1kAr4qGH9nIvDCY0dVKg2rNFpzCAMtvwg7U7VXbZ
         vnJ8YFBfbzgtF+5acVTgcF6TppYkVqEyDt3jG1zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        youling257 <youling257@gmail.com>
Subject: [PATCH 5.4 10/46] staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids
Date:   Tue,  3 Dec 2019 23:35:30 +0100
Message-Id: <20191203212724.815744118@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 3d5f1eedbfd22ceea94b39989d6021b1958181f4 upstream.

Add 024c:0525 to the list of SDIO device-ids, based on a patch found
in the Android X86 kernels. According to that patch this device id is
used on the Alcatel Plus 10 device.

Reported-and-tested-by: youling257 <youling257@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191111113846.24940-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -18,6 +18,7 @@
 static const struct sdio_device_id sdio_ids[] =
 {
 	{ SDIO_DEVICE(0x024c, 0x0523), },
+	{ SDIO_DEVICE(0x024c, 0x0525), },
 	{ SDIO_DEVICE(0x024c, 0x0623), },
 	{ SDIO_DEVICE(0x024c, 0x0626), },
 	{ SDIO_DEVICE(0x024c, 0xb723), },


