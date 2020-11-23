Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F6A2C0869
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgKWMun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:50:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbgKWMuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FEF620732;
        Mon, 23 Nov 2020 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135806;
        bh=ebrxxkYtzemwBH9VBRlJ5VfgfQn/CcE8J9Dh7Vtbfmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeIFU/eWKD78hWJ4YQXjOQA1IRP51YO0SzPZl6vv/wBfeUgt8cPjZGdXcbzMC4qLW
         sN823BW9hdLEkJ5DZGmK599Bj+R1hRVTd1M/E6dbLH5Pzuw87kLnULO+mTy+zX5U6i
         uiXnpYPzI1HASMRcDRYkiT76eMkj+AMYOIKJReOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian OKeefe <bokeefe@alum.wpi.edu>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.9 202/252] staging: rtl8723bs: Add 024c:0627 to the list of SDIO device-ids
Date:   Mon, 23 Nov 2020 13:22:32 +0100
Message-Id: <20201123121845.322193385@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian O'Keefe <bokeefe@alum.wpi.edu>

commit aee9dccc5b64e878cf1b18207436e73f66d74157 upstream.

Add 024c:0627 to the list of SDIO device-ids, based on hardware found in
the wild. This hardware exists on at least some Acer SW1-011 tablets.

Signed-off-by: Brian O'Keefe <bokeefe@alum.wpi.edu>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/b9e1523f-2ba7-fb82-646a-37f095b4440e@alum.wpi.edu
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -21,6 +21,7 @@ static const struct sdio_device_id sdio_
 	{ SDIO_DEVICE(0x024c, 0x0525), },
 	{ SDIO_DEVICE(0x024c, 0x0623), },
 	{ SDIO_DEVICE(0x024c, 0x0626), },
+	{ SDIO_DEVICE(0x024c, 0x0627), },
 	{ SDIO_DEVICE(0x024c, 0xb723), },
 	{ /* end: all zeroes */				},
 };


