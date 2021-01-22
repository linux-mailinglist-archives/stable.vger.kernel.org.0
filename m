Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E3B300C4A
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbhAVSnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbhAVOWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B906C23B5D;
        Fri, 22 Jan 2021 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324992;
        bh=9yzrAxBVSvSDp2NTnOx6WHzKGKiiF2/vpQ+3b1iIeV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeLwoqRwyHr9LLP/Z0OpgLCMQeqON2U/jGEY3Qa9JgjYo88p7xtR11VFrw8cwt/90
         Lh2qpjIPIozxTuQqDoIwV/SWTNtwcYgzgJwCdu+zbKg1JAeBdG/oTmGeMhs/ILn5Ll
         yLGXITFrY8Efkxtfxw7i6rkCxUlC+rlUvnt7QtpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Subject: [PATCH 5.4 01/33] usb: ohci: Make distrust_firmware param default to false
Date:   Fri, 22 Jan 2021 15:12:17 +0100
Message-Id: <20210122135733.627145225@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -102,7 +102,7 @@ static void io_watchdog_func(struct time
 
 
 /* Some boards misreport power switching/overcurrent */
-static bool distrust_firmware = true;
+static bool distrust_firmware;
 module_param (distrust_firmware, bool, 0);
 MODULE_PARM_DESC (distrust_firmware,
 	"true to distrust firmware power/overcurrent setup");


