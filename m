Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36810300FC7
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbhAVT64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbhAVOPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:15:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E149323A79;
        Fri, 22 Jan 2021 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324717;
        bh=Ge+tDihmPcNRoUH8T1P/bGAPMI/jWJ6KUqb5A+9xJGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fn8DcaRxM2Eq9s+sLGmJLkNeutK99X8fgM4cbcaILCyM8antje636mDiwVCy6PS7
         JYuLLmhbq6tUJNfaKio5kL1KFIfWpzI0549T5mG+auCDauwVqZf09QZyC7Ul9ZFl5F
         WvzWjjW0UUZsh+jU8BMiYJ890BFoet4HvyHTnfQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Subject: [PATCH 4.9 23/35] usb: ohci: Make distrust_firmware param default to false
Date:   Fri, 22 Jan 2021 15:10:25 +0100
Message-Id: <20210122135733.250332147@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

commit c4005a8f65edc55fb1700dfc5c1c3dc58be80209 upstream.

The 'distrust_firmware' module parameter dates from 2004 and the USB
subsystem is a lot more mature and reliable now than it was then.
Alter the default to false now.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20200910212512.16670-2-hamish.martin@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ohci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -100,7 +100,7 @@ static void io_watchdog_func(unsigned lo
 
 
 /* Some boards misreport power switching/overcurrent */
-static bool distrust_firmware = true;
+static bool distrust_firmware;
 module_param (distrust_firmware, bool, 0);
 MODULE_PARM_DESC (distrust_firmware,
 	"true to distrust firmware power/overcurrent setup");


