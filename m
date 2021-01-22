Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E828300C31
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbhAVSl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbhAVOVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C78C23AC1;
        Fri, 22 Jan 2021 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324906;
        bh=Ge+tDihmPcNRoUH8T1P/bGAPMI/jWJ6KUqb5A+9xJGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjbPz9b9rWow+5EV9CU6PJwi8xoD/vMzIUEBYzX7iaSAZ7uNtIutehW7aiuU51i1g
         WzoSw1VCxlziCTIX6SuHiCe/OilQgmo3j+Ku57LkrnIjAwVLdL3Eg/WQ57xwnIDz/D
         yHwAHui61K08LRMPP6QLsknpfytmsmHqO2YA7wVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Subject: [PATCH 4.14 33/50] usb: ohci: Make distrust_firmware param default to false
Date:   Fri, 22 Jan 2021 15:12:14 +0100
Message-Id: <20210122135736.539196546@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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


